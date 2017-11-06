# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def shared_pods
  pod 'Alamofire'
  # pod 'AlamofireObjectMapper', :git => 'https://github.com/tristanhimmelman/AlamofireObjectMapper.git', :branch => 'swift-4'
  pod 'ObjectMapper', :git => 'https://github.com/Hearst-DD/ObjectMapper.git', :branch => 'swift-4'
  pod 'RealmSwift'
  pod 'SwiftyJSON'
  pod 'SwifterSwift', :git => 'https://github.com/SwifterSwift/SwifterSwift.git', :branch => 'swift-4'
  pod 'SnapKit'
  pod 'Reusable'
  pod 'SwiftyBeaver'
  pod 'KoalaTeaFlowLayout'
  pod 'UIFontComplete'
  pod 'Kingfisher'
  pod 'FittableFontLabel'
  pod 'BetterSegmentedControl', '~> 0.7'
  pod 'SideMenu'
  pod 'SwiftIcons'
  pod 'Pageboy'
  pod 'PKHUD', '~> 4.0'
  pod 'Eureka', :git => 'https://github.com/xmartlabs/Eureka.git', :branch => 'feature/Xcode9-Swift4'
  pod 'IQKeyboardManager'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'ShowTime', '2.0.0'
end

target 'Kibbl-IOS' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # # Post installation script that enables the Swift 4 compiler's
  # # legacy 3.2 mode for Swift 4-incompatible pods
  # post_install do |installer|
  #   incompatiblePods = ['Eureka']

  #   installer.pods_project.targets.each do |target|
  #       if incompatiblePods.include? target.name
  #           target.build_configurations.each do |config|
  #               config.build_settings['SWIFT_VERSION'] = '3.2'
  #           end
  #       end
  #   end
  # end
  
  # Pods for Kibbl-IOS
  shared_pods
  pod 'GooglePlaces'
  pod 'GooglePlacePicker'
  pod 'GoogleMaps'

  target 'Kibbl-IOSTests' do
    # Pods for testing
    # pod 'SwiftyBeaver'
    # pod 'Alamofire'
    # pod 'AlamofireObjectMapper', :git => 'https://github.com/tristanhimmelman/AlamofireObjectMapper.git', :branch => 'swift-4'
    # pod 'RealmSwift'
    # pod 'Quick'
    # pod 'Nimble'
    # pod 'SwiftyJSON'
  end
end