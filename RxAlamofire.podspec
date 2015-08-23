Pod::Spec.new do |s|
  s.name = 'RxAlamofire'
  s.version = '0.9'
  s.license = 'MIT'
  s.summary = 'RxSwift wrapper around the elegant HTTP networking in Swift Alamofire'
  s.homepage = 'https://github.com/bontoJR/RxAlamofire'
  s.authors = { 'Junior B.' => 'info@bonto.ch' }
  s.source = { :git => 'https://github.com/bontoJR/RxAlamofire.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.source_files = 'Source/*.swift'

  s.requires_arc = true

  s.dependency "RxSwift", :git => "git@github.com:kzaher/RxSwift.git", :branch => 'rxswift-2.0'
  s.dependency "Alamofire", :git => 'https://github.com/Alamofire/Alamofire.git', :branch => 'swift-2.0'
end