
Pod::Spec.new do |s|
  s.name             = "UUActionSheet"
  s.version          = "1.8"
  s.summary          = "An actionSheet used on iOS."
  s.homepage         = "https://github.com/CheeryLau/UUActionSheet"
  s.license          = 'MIT'
  s.author           = { "Cheery Lau" => "1625977078@qq.com" }
  s.source           = { :git => "https://github.com/CheeryLau/UUActionSheet.git", :tag => s.version.to_s }
  s.platform         = :ios, '7.0'
  s.requires_arc     = true
  s.source_files     = 'UUActionSheet/**/*.{h,m}'
  s.frameworks       = 'UIKit'

end
