#!/bin/sh

if ! which xcodebuild >/dev/null; then
  echo "xcodebuild is not available. Install it from https://itunes.apple.com/us/app/xcode/id497799835"
  exit 1
fi

if ! which gem >/dev/null; then
  echo "rubygem is not available. Install it from https://rubygems.org/pages/download"
  exit 1
fi

if ! which pod >/dev/null; then
  echo "installing cocoapods..."
  gem install cocoapods --pre
fi

if ! which carthage >/dev/null; then
  echo "installing carthage..."
  brew install carthage
fi

if which carthage >/dev/null; then
  echo "installing carthage dependence..."
  carthage bootstrap --verbose --platform ios --color auto --no-use-binaries
fi

if which pod >/dev/null; then
  eche "installing cocoapods dependence..."
  pod install
fi
