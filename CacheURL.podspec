Pod::Spec.new do |s|

s.name             = "CacheURL"

s.version          = "1.0.0"

s.summary          = "获取网络图片"

s.description      = <<-DESC
 "获取网络图片"
DESC

s.homepage         = "https://github.com/zjjzmw1/CacheURL"
s.license          = 'MIT'
s.author           = { "张明炜" => "zjjzmw1@163.com" }

s.source           = { :git => "https://github.com/zjjzmw1/CacheURL.git", :tag => s.version.to_s }
s.platform     = :ios, '7.0'

s.requires_arc = true

s.source_files = 'MyClasses/*'

s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit'

end