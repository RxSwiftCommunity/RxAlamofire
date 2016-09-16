source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

def common
    pod 'Alamofire', '~> 4.0'
    pod 'RxSwift', '~> 3.0.0-beta.1'
    pod 'RxCocoa', '~> 3.0.0-beta.1'
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
   platform :ios, '9.0'
   common

   target 'RxAlamofireTests' do
       pod 'OHHTTPStubs'
       pod 'OHHTTPStubs/Swift'
       pod 'RxBlocking', '~> 3.0.0-beta.1'
   end
end
