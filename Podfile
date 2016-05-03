platform:ios, "9.0"

use_frameworks!

<<<<<<< HEAD
target 'SwiftGG' do
	pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
	pod 'Alamofire', '~> 3.0'
	pod 'Moya', '6.4.0'
        pod 'Moya/RxSwift', '6.4.0'
	pod 'Neon', '~> 0.0.1'
	pod 'UIColor_Hex_Swift', '~> 1.8'
	pod 'Kingfisher', '~> 2.2.2'
	pod 'RealmSwift', '~> 0.98.4'
	pod 'RxSwift',    '~> 2.3.1'
	pod 'RxCocoa',    '~> 2.3.1'
	pod 'RxBlocking', '~> 2.3.1'
	pod 'JGProgressHUD'
	pod 'Gloss', '~> 0.6'
	pod 'XCGLogger', '~> 3.3'
=======
def release_pods
    pod 'RxSwift', '~>2.4'
    pod 'RxCocoa', '~>2.4'
    pod 'RxDataSources'
    pod 'RxOptional'
    pod 'NSObject+Rx'
    pod 'R.swift'
    pod 'RxGesture'#, '~>0.1.6'
#    pod 'SwiftyDown'
    # pod 'RxRealm'
end

def dev_pods
#    pod 'FBAllocationTracker'
#    pod 'FBRetainCycleDetector'
#    pod 'FBMemoryProfiler'
    pod 'XCGLogger', '~> 3.3'
end

def test_pods
    pod 'RxSwift', '~>2.4'
    pod 'RxCocoa', '~>2.4'
    pod 'RxBlocking', '~>2.4'
    pod 'RxTests', '~>2.4'
end

target 'GGQ' do
    release_pods
end

target 'GGQ-Dev' do
    release_pods
    dev_pods
end

target 'GGQ-Tests' do
    test_pods
>>>>>>> 4718e4cda4da616f1e2ca18964041047ef41c6e8
end
