Pod::Spec.new do |s|
  s.name = 'Kushki'
  s.version = '2.1.8'
  s.summary = 'Kushki iOS library.'
  s.description = 'iOS library to integrate with Kushki.'
  s.homepage = 'https://github.com/Kushki/kushki-ios'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'Kushki' => 'soporte@kushkipagos.com' }
  s.source = { :git => 'https://github.com/Kushki/kushki-ios.git', :tag => "v#{s.version.to_s}" }
  s.ios.deployment_target = '8.0'
  s.source_files = 'Kushki/Classes/**/*'
end
