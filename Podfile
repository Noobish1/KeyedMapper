platform :ios, '8.0'

target 'KeyedMapper' do
  use_frameworks!

  target 'KeyedMapperTests' do
    inherit! :search_paths

    pod 'Quick', :git => 'https://github.com/Quick/Quick.git', :branch => 'swift-3.0'
    pod 'Nimble', :git => 'https://github.com/Quick/Nimble.git', :branch => 'swift-3.0'
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
