Pod::Spec.new do |s|
  s.name = 'RxAlamofire'
  s.version = '1.1.1'
  s.license = 'MIT'
  s.summary = 'RxSwift wrapper around the elegant HTTP networking in Swift Alamofire'
  s.homepage = 'https://github.com/RxSwiftCommunity/RxAlamofire'
  s.authors = { 'Junior B.' => 'info@bonto.ch' }
  s.source = { :git => 'https://github.com/RxSwiftCommunity/RxAlamofire.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.requires_arc = true

  s.default_subspec = "Core"

  s.subspec "Core" do |ss|
    ss.source_files  = "RxAlamofire/Source/*.swift"
    ss.dependency "RxSwift", "~> 2.0"
    ss.dependency "Alamofire", "~> 3.0"
    ss.framework  = "Foundation"
  end

  s.subspec "RxCocoa" do |ss|
    ss.source_files = "RxAlamofire/Source/Cocoa/*.swift"
    ss.dependency "RxCocoa", "~> 2.0"
    ss.dependency "RxAlamofire/Core"
  end
  
end
