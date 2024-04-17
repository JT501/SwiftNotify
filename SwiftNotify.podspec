Pod::Spec.new do |s|
  s.name         = "SwiftNotify"
  s.version      = ENV['GIT_TAG'] || "2.0.0"
  s.summary      = "A Swifty UI framework for notifications and alerts. "
  s.homepage     = "https://github.com/JT501/SwiftNotify"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.author            = { "Johnny" => "johnny@jt501.com" }
  s.social_media_url  = "https://github.com/JT501"
  s.swift_version     = '5.9'
  s.platform          = :ios, "13.0"
  s.source            = { :git => "https://github.com/JT501/SwiftNotify.git", :tag => s.version.to_s }
  s.source_files      = "SwiftNotify", "Sources/SwiftNotify/**/*.{swift,h}"
  s.resource_bundles  = {"SwiftNotifyResources" =>["Sources/SwiftNotify/NotifyResources/**/*.png"]}
  s.frameworks        = "UIKit"
  s.requires_arc      = true
end
