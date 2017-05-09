
Pod::Spec.new do |s|
  s.name             = "UUActionSheet"
  s.version          = "1.2"
  s.summary          = "An actionSheet used on iOS."
  s.homepage         = "https://github.com/dexianyinjiu/UUActionSheet"
  s.license          = 'MIT'
  s.author           = { "得闲饮酒" => "1625977078@qq.com" }
  s.source           = { :git => "https://github.com/dexianyinjiu/UUActionSheet.git", :tag => s.version.to_s }
  s.platform         = :ios, '7.0'
  s.requires_arc     = true
  s.source_files     = 'UUActionSheet/**/*.{h,m}'
  s.frameworks       = 'UIKit'

end
