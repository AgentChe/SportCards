platform :ios, '16.0'
inhibit_all_warnings!
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'

target 'SportCards' do
  pod 'SwiftyStoreKit'

  pod 'OtterScaleiOS', :git => "https://github.com/AgentChe/OtterScaleiOS.git"
  pod 'FBSDKCoreKit'
  pod 'Amplitude-iOS'
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
      config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
      if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
        target.build_configurations.each do |config|
            config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
        end
      end
    end
  end
end
