Pod::Spec.new do |s|
  s.name         = "CFNotify"
  s.version      = "1.0.0"
  s.summary      = "A customizable framework to create draggable views"
  s.homepage     = "https://github.com/hallelujahbaby/CFNotify"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.author             = { "Johnny" => "hallelujahbaby@gmail.com" }
  s.social_media_url   = "http://co-fire.com"
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/hallelujahbaby/CFNotify.git", :tag => s.version.to_s }
  s.source_files  = "CFNotify", "CFNotify/**/*.{swift,h}"
  s.resource_bundles = {"CFResources" =>["CFResources/**/*.png"]}
  s.frameworks   = "UIKit"
  s.requires_arc = true
end
