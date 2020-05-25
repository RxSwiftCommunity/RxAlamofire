Pod::Spec.new do |s|
  s.name = "RxAlamofire"
  # Version to always follow latest tag, with fallback to major
  s.version = ENV['RELEASE_VERSION'] || "5.0.0"
  s.license = "MIT"
  s.summary = "RxSwift wrapper around the elegant HTTP networking in Swift Alamofire"
  s.homepage = "https://github.com/RxSwiftCommunity/RxAlamofire"
  s.authors = { "RxSwift Community" => "community@rxswift.org" }
  s.source = { :git => "https://github.com/RxSwiftCommunity/RxAlamofire.git", :tag => s.version }
  s.swift_version = "5.1"

  s.ios.deployment_target = "10.0"
  s.osx.deployment_target = "10.12"
  s.tvos.deployment_target = "10.0"
  s.watchos.deployment_target = "3.0"

  s.requires_arc = true

  s.default_subspec = "Core"

  s.subspec "Core" do |ss|
    ss.source_files = "Sources/RxAlamofire/*.swift"
    ss.dependency "RxSwift", "~> 5.1"
    ss.dependency "Alamofire", "~> 5.1"
    ss.framework = "Foundation"
  end

  s.subspec "RxCocoa" do |ss|
    ss.source_files = "Sources/RxAlamofire/Cocoa/*.swift"
    ss.dependency "RxCocoa", "~> 5.1"
    ss.dependency "RxAlamofire/Core"
  end
end
