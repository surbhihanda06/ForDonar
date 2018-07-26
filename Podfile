# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ForDonors' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ForDonors

pod 'ReachabilitySwift', '~> 3'
pod 'Alamofire', '~> 4.4'
#pod 'ObjectMapper', '~> 2.2'
pod 'ObjectMapper'
pod 'AlamofireObjectMapper', '~> 4.0'
pod 'SDWebImage', '~>3.8'
pod 'AlamofireImage'
pod 'IQKeyboardManagerSwift', :git => 'https://github.com/hackiftekhar/IQKeyboardManager'
#pod 'IQKeyboardManagerSwift'
#pod 'IQKeyboardManager'
pod 'Firebase/Core'
pod 'Firebase/Crash'
pod 'SVProgressHUD'
pod 'FloatRatingView', '~> 2.0.0'
pod 'FacebookCore'
pod 'FacebookLogin'
pod 'FacebookShare'
pod 'GoogleSignIn'
pod 'LinkedinSwift'
pod 'TwitterKit'
pod 'SwiftInstagram'
pod 'Fabric'
pod 'Crashlytics'
#pod 'YouTubePlayer'
pod 'youtube-ios-player-helper'
pod 'NKVPhonePicker'
pod 'Planet'
pod "CCValidator"
pod 'Stripe'
pod 'Firebase/Storage'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'JSQMessagesViewController'
pod 'AWSLambda'



end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |configuration|
            # these libs work now only with Swift3.2 in Xcode9
            if ['ObjectMapper'].include? target.name
                configuration.build_settings['SWIFT_VERSION'] = "3.2"
            end
        end
    end
end
