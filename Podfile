source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

def common
    pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire.git', :branch => 'swift3'
    pod 'RxSwift', :git => 'https://github.com/ReactiveX/RxSwift.git', :tag => '3.0.0.alpha.1'
    pod 'RxCocoa', :git => 'https://github.com/ReactiveX/RxSwift.git', :tag => '3.0.0.alpha.1'
end

target 'RxAlamofireExample' do
    platform :ios, '9.0'
    common
end

target 'RxAlamofiretvOSExample' do
    platform :tvos, '9.0'
    common
end

target 'RxAlamofire-iOS' do
   common

   target 'RxAlamofireTests' do
       pod 'OHHTTPStubs', :git => 'https://github.com/AliSoftware/OHHTTPStubs.git', :branch => 'swift-3.0'
       pod 'OHHTTPStubs/Swift', :git => 'https://github.com/AliSoftware/OHHTTPStubs.git', :branch => 'swift-3.0'
       pod 'RxBlocking', :git => 'https://github.com/ReactiveX/RxSwift.git', :tag => '3.0.0.alpha.1'
   end
end

target 'RxAlamofire-tvOS' do
    common
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
