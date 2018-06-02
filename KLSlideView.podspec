#
#  Be sure to run `pod spec lint KLSlideView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|


  s.name         = "KLSlideView"
  s.version      = "0.0.1"
  s.summary      = "KLSlideView 支持顶部Tab页点击、滑动，并支持无限分页。"

  s.homepage     = "https://github.com/kllie"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author       = { "zhaobinhua" => "zbh1019@163.com" }

  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/kllie/KLSlideView.git", :tag => s.version }

  s.requires_arc = true

  s.public_header_files = "KLSlideView/Classes/**/*.h"
  s.source_files        = "KLSlideView/Classes/**/*"

  s.subspec 'Tools' do |tools|
    tools.public_header_files   = 'KLSlideView/Classes/Tools/**/*.h'
    tools.source_files          = 'KLSlideView/Classes/Tools/**/*'
  end

end
