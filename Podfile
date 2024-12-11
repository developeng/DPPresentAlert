# source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '13.0'

target 'DPPresentAlert' do

  use_frameworks!
  inhibit_all_warnings!
  
  pod 'SnapKit'

  end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end

