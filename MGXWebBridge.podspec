#
# Be sure to run `pod lib lint MGXWebBridge.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MGXWebBridge'
  s.version          = '0.1.0'
  s.summary          = 'UIWebView与JS交互'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  ObjC使用UIWebView与JavaScript的交互封装, 支持直接return调用结果
                       DESC

  s.homepage         = 'https://github.com/changjianfeishui/MGXWebBridge'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mangox' => '22469836@qq.com' }
  s.source           = { :git => 'https://github.com/changjianfeishui/MGXWebBridge.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'MGXWebBridge/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MGXWebBridge' => ['MGXWebBridge/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'JavaScriptCore'
  # s.dependency 'AFNetworking', '~> 2.3'
end
