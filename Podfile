platform :ios, '8.0'

pod 'p2.OAuth2'
pod 'Alamofire', '~> 3.0.0-beta.3'
pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
pod 'FBSDKCoreKit', '4.1'
pod 'FBSDKLoginKit', '4.1'
pod 'KeychainAccess'
pod 'Dollar'

def testing_pods
    pod 'Quick'
    pod 'Nimble', '2.0.0'
end

target 'GroundGameTests' do
    testing_pods
end

target 'GroundGameUITests' do
    testing_pods
end

use_frameworks!