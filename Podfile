source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target 'KeyedMapper' do
  pod 'SwiftLint', '0.37.0', :configurations => ['Debug']
end


target 'KeyedMapperTests' do
    inherit! :search_paths

    pod 'Quick', '2.2.0'
    pod 'Nimble', '8.0.4'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '5.0'
        end
    end
end
