source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

def common
    pod 'Alamofire', '~> 3.4'
    pod 'RxSwift', '~> 2.4'
    pod 'RxCocoa', '~> 2.4'
    pod 'RxBlocking', '~> 2.4'
end

target 'RxAlamofireExample' do
    platform :ios, '8.0'
    common

    target 'RxAlamofireTests' do
        pod 'Quick'
        pod 'Nimble'
        pod 'OHHTTPStubs'
    end
end

target 'RxAlamofiretvOSExample' do
    platform :tvos, '9.0'
    common
end
