Pod::Spec.new do |s|
  s.name = 'Kushki'
  s.version = '2.4.2'
  s.summary = 'Kushki iOS library.'
  s.description = 'iOS library to integrate with Kushki.'
  s.homepage = 'https://github.com/Kushki/kushki-ios'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'Kushki' => 'francisco.quinonez@kushkipagos.com' }
  s.source = { :git => 'https://github.com/Kushki/kushki-ios.git', :tag => "v#{s.version.to_s}" }
  s.ios.deployment_target = '14.3'
  s.source_files = 'Kushki/Classes/**/*'
  s.resources = "Kushki/Assets/**/*"
  s.dependency "Sift"
  s.ios.vendored_frameworks = 'Kushki/Frameworks/CardinalMobile.framework'
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
