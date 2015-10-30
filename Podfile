platform :ios, '8.2'

pod 'p2.OAuth2'
pod 'Alamofire', '~> 3.0.0-beta.3'
pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
pod 'FBSDKCoreKit', '4.1.0'
pod 'FBSDKLoginKit', '4.1.0'
pod 'FBSDKShareKit', '4.1.0'
pod 'KeychainAccess'
pod 'Dollar'
pod 'FLAnimatedImage', '~> 1.0'
pod 'Spring', :git => 'https://github.com/MengTo/Spring.git', :branch => 'swift2'
pod 'KFSwiftImageLoader', '~> 2.0'
pod 'XCGLogger'
pod 'RealmSwift'
pod 'Heap'
pod 'Parse'

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