Pod::Spec.new do |s|
  s.name         = "WalleePaymentSdk"
  s.module_name  = "WalleePaymentSdk"
  s.version      = "1.0.1"
  s.summary      = "https://whitelabel-docs.com"
  s.license = { :type => 'Copyright', :text => <<-LICENSE
                   license
                   LICENSE
               }


  s.author       = "WalleeXXXX"
  s.homepage     = "https://github.com/WhiteLabelGithubOwnerName/ios-mobile-sdk"

  s.source       = { :git => "https://github.com/wallee-payment/ios-mobile-sdk.git", :tag => "1.0.1" }
  s.vendored_frameworks = "WalleePaymentSdk.xcframework"
  s.resource_bundles = { "WalleePayment" => "walleepaymentsdkbundle.jsbundle" }

  s.platform = :ios
  s.swift_version = "4.2"
  s.ios.deployment_target  = '12.4'
end
