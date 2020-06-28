Pod::Spec.new do |s|
  s.name             = "RxSJPageViewController"
  s.version          = "0.0.3"
  s.summary          = "RxSJPageViewController"
  s.homepage         = "https://github.com/moxcomic/RxSJPageViewController.git"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "moxcomic" => "656469762@qq.com" }
  s.source           = { :git => "https://github.com/moxcomic/RxSJPageViewController.git", :tag => "#{s.version}" }
  s.ios.deployment_target = "9.0"
  s.swift_version = "5.0"
  s.source_files = "RxSJPageViewController/Source/**/*.swift"
  s.frameworks = "Foundation"

  s.dependency "RxSwift"
  s.dependency "RxDataSources"
  s.dependency "SJPageViewController/ObjC", '~> 0.0.11'
end