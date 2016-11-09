Pod::Spec.new do |spec|
  spec.name = "CFDraggableMessage"
  spec.version = "0.1.0"
  spec.summary = "Framework to Create Draggable Messages"
  spec.homepage = "https://github.com/hallelujahbaby/CFDraggableMessage"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Johnny Choi" => 'hallelujahbaby@gmail.com' }
  spec.social_media_url = "http://co-fire.com"

  spec.platform = :ios, "9.1"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/hallelujahbaby/CFDraggableMessage.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "CFDraggableMessage/**/*.{h,swift}"
end
