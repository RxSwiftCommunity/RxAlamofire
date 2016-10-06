//
//  ObserveOnSerialDispatchQueue.swift
//  RxSwift
//
//  Created by Krunoslav Zaher on 5/31/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation

#if TRACE_RESOURCES
/**
Counts number of `SerialDispatchQueueObservables`.

Purposed for unit tests.
*/
public var numberOfSerialDispatchQueueObservables: AtomicInt = 0
#endif

class ObserveOnSerialDispatchQueueSink<O: ObserverType> : ObserverBase<O.E> {
    let scheduler: SerialDispatchQueueScheduler
    let observer: O
    
    let cancel: Cancelable

    var cachedScheduleLambda: ((ObserveOnSerialDispatchQueueSink<O>, Event<E>) -> Disposable)!

    init(scheduler: SerialDispatchQueueScheduler, observer: O, cancel: Cancelable) {
        self.scheduler = scheduler
        self.observer = observer
        self.cancel = cancel
        super.init()

        cachedScheduleLambda = { sink, event in
            sink.observer.on(event)

            if event.isStopEvent {
                sink.dispose()
            }

            return Disposables.create()
        }
    }

    override func onCore(_ event: Event<E>) {
        let _ = self.scheduler.schedule((self, event), action: cachedScheduleLambda)
    }
   
    override func dispose() {
        super.dispose()

        cancel.dispose()
    }
}
    
class ObserveOnSerialDispatchQueue<E> : Producer<E> {
    let scheduler: SerialDispatchQueueScheduler
    let source: Observable<E>
    
    init(source: Observable<E>, scheduler: SerialDispatchQueueScheduler) {
        self.scheduler = scheduler
        self.source = source
        
#if TRACE_RESOURCES
        let _ = AtomicIncrement(&resourceCount)
        let _ = AtomicIncrement(&numberOfSerialDispatchQueueObservables)
#endif
    }
    
    override func run<O : ObserverType>(_ observer: O, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where O.E == E {
        let sink = ObserveOnSerialDispatchQueueSink(scheduler: scheduler, observer: observer, cancel: cancel)
        let subscription = source.subscribe(sink)
        return (sink: sink, subscription: subscription)
    }
    
#if TRACE_RESOURCES
    deinit {
        let _ = AtomicDecrement(&resourceCount)
        let _ = AtomicDecrement(&numberOfSerialDispatchQueueObservables)
    }
#endif
}
