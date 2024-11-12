
Pod::Spec.new do |s|
  s.name             = "UUActionSheet"
  s.version          = "2.0"
  s.summary          = "An actionSheet used on iOS."
  s.homepage         = "https://github.com/ChaneyLau/UUActionSheet"
  s.license          = 'MIT'
  s.author           = { "ChaneyLau" => "1625977078@qq.com" }
  s.source           = { :git => "https://github.com/ChaneyLau/UUActionSheet.git", :tag => s.version.to_s }
  s.platform         = :ios, '8.0'
  s.requires_arc     = true
  s.source_files     = 'UUActionSheet/**/*.{h,m}'
  s.frameworks       = 'UIKit'

end
