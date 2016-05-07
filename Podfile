source 'https://github.com/CocoaPods/Specs.git'
platform :ios, "9.0"
use_frameworks!

def release_pods
    pod 'R.swift', '~>2.2.1'
end

def dev_pods
#    pod 'FBAllocationTracker'
#    pod 'FBRetainCycleDetector'
#    pod 'FBMemoryProfiler'
end

target 'GGQ-Release' do
    release_pods
end

target 'GGQ-Debug' do
    release_pods
end

target 'GGQ-Dev' do
    release_pods
    dev_pods
end
