#!/bin/sh

if ! which xcodebuild >/dev/null; then
  echo "xcodebuild is not available. Install it from https://itunes.apple.com/us/app/xcode/id497799835"
  exit 1
fi

if ! which carthage >/dev/null; then
  echo "installing carthage..."
  brew update
  brew install carthage
fi

if which carthage >/dev/null; then
  echo "installing carthage dependence..."
  carthage bootstrap --verbose --platform ios --color auto --no-use-binaries
fi

if which wget >/dev/null; then
  echo "installing wget..."
  brew install wget
fi

wget https://github.com/mac-cain13/R.swift/releases/download/v2.3.0/rswift-2.3.0.zip
unzip -n rswift-2.3.0.zip -d ./
