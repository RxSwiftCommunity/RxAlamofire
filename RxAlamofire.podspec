Pod::Spec.new do |s|
  s.name = 'RxAlamofire'
  s.version = '0.2'
  s.license = 'MIT'
  s.summary = 'RxSwift wrapper around the elegant HTTP networking in Swift Alamofire'
  s.homepage = 'https://github.com/bontoJR/RxAlamofire'
  s.authors = { 'Junior B.' => 'info@bonto.ch' }
  s.source = { :git => 'https://github.com/bontoJR/RxAlamofire.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.source_files = 'RxAlamofire/Source/*.swift'

  s.requires_arc = true

  s.dependency "RxSwift", "~> 2.0.0-beta"
  s.dependency "Alamofire", "~> 3.0"
end