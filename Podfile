platform :ios, '8.0'

target 'kushki-ios' do
  use_frameworks!

  target 'kushki-ios-tests' do
    inherit! :search_paths
    pod 'OHHTTPStubs'
    pod 'OHHTTPStubs/Swift'
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
