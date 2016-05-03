platform:ios, "9.0"

use_frameworks!

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
end
