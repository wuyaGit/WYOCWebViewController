#
# Be sure to run `pod lib lint WYOCWebViewController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WYOCWebViewController'
  s.version          = '0.0.1'
  s.summary          = 'iOS 常用组件之WebViewController.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
iOS 常用组件之WebViewController.
                       DESC

  s.homepage         = 'https://github.com/wuyaGit/WYOCWebViewController'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wuya' => '407671883@qq.com' }
  s.source           = { :git => 'https://github.com/wuyaGit/WYOCWebViewController.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'WYOCWebViewController/Classes/**/*'
  
  s.resource_bundles = {
      'WYOCWebViewController' => ['WYOCWebViewController/WYOCWebViewController.bundle']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'WebKit'
  s.dependency 'dsBridge'
  s.dependency 'YYModel'
  s.dependency 'SDWebImage'
  s.dependency 'YYCategories'

end
