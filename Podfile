platform :ios, '8.0'

target 'KeyedMapperTests' do
    use_frameworks!
    inherit! :search_paths

    pod 'Quick', '0.10.0'
    pod 'Nimble', '5.0.0'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
