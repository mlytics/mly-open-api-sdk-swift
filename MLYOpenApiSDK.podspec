Pod::Spec.new do |s|
  s.name             = 'MLYOpenApiSDK'
  s.version          = '0.1.0'
  s.summary          = 'A short description of MLYOpenApiSDK.' 
  s.description      = 'MLYOpenApiSDK'
  s.homepage         = 'https://github.com/mlytics/mly-open-api-sdk-swift' 
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'MLY' => 'rd@mlytics.com' }
  s.source           = { :git => 'https://github.com/mlytics/mly-open-api-sdk-swift.git', :tag => s.version.to_s } 
  s.swift_version    = '5.0'
  s.ios.deployment_target = '10.0'
  s.source_files     = 'MLYOpenApiSDK/Classes/**/*' 
end