Pod::Spec.new do |s|
  s.name         = "CFNotify"
  s.version      = "0.0.1"
  s.summary      = "A customizable framework to create draggable views"
  s.homepage     = "http://EXAMPLE/CFNotify"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.author             = { "Johnny" => "hallelujahbaby@gmail.com" }
  s.social_media_url   = "http://co-fire.com"
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/hallelujahbaby/CFNotify.git", :tag => "0.9.0" }
  s.source_files  = "CFNotify", "Classes/**/*.{swift,h}"
  s.resources = "CFResources/**/*.png"
  s.frameworks   = 'UIKit'
  s.requires_arc = true
end
