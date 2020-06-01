#
# Be sure to run `pod lib lint FxxKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FxxKit'
  s.version          = '1.0.0'
  s.summary          = '提供日常开发常用的操作及控件的封装'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/fanxiaoxin/FxxKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'fanxiaoxin' => 'fanxiaoxin_1987@126.com' }
  s.source           = { :git => 'https://github.com/fanxiaoxin/FxxKit.git', :commit => 'fad803d', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'FxxKit/Classes/**/*'
  
  s.swift_version = '5.0'
  # s.resource_bundles = {
  #   'FxxKit' => ['FxxKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
#  s.dependency 'Moya', '~> 13.0.0'
#  s.dependency 'HandyJSON', '~> 5.0.0'
#  s.dependency 'SnapKit', '~> 5.0.0'
#  s.dependency 'JRSwizzle'
#  s.dependency 'YYCategories', '~> 1.0.0'
#  s.dependency 'YYKeyboardManager', '~> 1.0.0'
#  s.dependency 'MJRefresh', '~> 3.2.0'
#  s.dependency 'SDWebImage', '~> 5.8.0'
  
  # 最基本的操作，包含页面生成快捷操作
  s.subspec 'Basic' do |b|
      b.source_files = 'FxxKit/Classes/{1.DesignPatterns,2.Basic}/**/*'
      b.dependency 'YYCategories', '~> 1.0.0'
      b.dependency 'SnapKit', '~> 5.0.0'
  end
  # 定制化的操作，比如多语言或多主题
  s.subspec 'Personalized' do |p|
      p.source_files = 'FxxKit/Classes/3.Business&Management/3.1.Personalized/**/*'
      p.dependency 'FxxKit/Basic'
  end
  # ViewController的访问控制，提供统一的加载方法，可定制加载的先决条件及跳转方式、多页面加载流程
  s.subspec 'AccessControl' do |p|
      p.source_files = 'FxxKit/Classes/3.Business&Management/3.2.AccessControl/**/*'
      p.dependency 'FxxKit/Basic'
  end
  # 将每一个API请求的相关字段都封装为一个对象，可以清晰地看到每一个API的请求地址、方式、请求结构、响应结构等操作
  s.subspec 'Api' do |a|
      a.source_files = 'FxxKit/Classes/3.Business&Management/3.3.ApiRequest/**/*'
      a.dependency 'FxxKit/Basic'
      a.dependency 'Moya', '~> 13.0.0'
      a.dependency 'HandyJSON', '~> 5.0.0'
  end
  # 提供一些控件及界面相关的工具
  s.subspec 'Controls' do |c|
      c.source_files = 'FxxKit/Classes/4.Tools&Controls&Plugs/{4.1.Tools,4.2.Controls}/**/*','FxxKit/Classes/4.Tools&Controls&Plugs/4.3.Plugs/{T,V}*/**/*'
      c.dependency 'FxxKit/AccessControl'
      c.dependency 'JRSwizzle'
      c.dependency 'YYKeyboardManager', '~> 1.0.0'
      c.dependency 'Kingfisher', '~> 5.14.0'
  end
  # 提供列表及API绑定数据的封装，新建一个TableView不需要写太多重复的代码，包含上下拉刷新
  s.subspec 'ListLoader' do |l|
      l.source_files = 'FxxKit/Classes/4.Tools&Controls&Plugs/4.3.Plugs/ApiListLoader/**/*'
      l.dependency 'FxxKit/Api'
      l.dependency 'MJRefresh', '~> 3.4.0'
  end
  
end
