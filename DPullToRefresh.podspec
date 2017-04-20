#
#  Be sure to run `pod spec lint DPullToRefresh.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "DPullToRefresh"
  s.version      = "0.0.8"
  s.summary      = "DPullToRefresh to ScrollView"

  s.description  = <<-DESC
A simple drop-down refresh that supports all subclasses of ScollerView.
The default provides a style, of course, can also be customized.
                   DESC
  s.homepage     = "https://github.com/Dcell/DPullToRefresh"
  s.author             = "ding_qili"

  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/Dcell/DPullToRefresh.git", :tag => "#{s.version}" }

  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.public_header_files = "Classes/**/*.h"
end
