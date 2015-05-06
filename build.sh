#!/bin/bash

usage() {
cat <<EOF
Usage: sh $0 command [argument]

command:
  clean:                    runs `git clean -xdf`
  bootstrap:                downloads product dependencies and runs `pod install` where appropriate
  test-all:                 tests all projects in this repo.
  test-ios-objc-static:     tests iOS Objective-C static example.
  test-ios-objc-cocoapods:  tests iOS Objective-C CocoaPods example.
  test-ios-swift-dynamic:   tests iOS Swift dynamic example.
  test-ios-swift-cocoapods: tests iOS Swift CocoaPods example.
EOF
}

COMMAND="$1"

case "$COMMAND" in
    ######################################
    # Clean
    ######################################

    "clean")
        git clean -xdf
        exit 0
        ;;

    ######################################
    # Bootsrap
    ######################################

    "bootstrap")
        ./build.sh clean

        curl -o realm-objc-latest.zip -L https://static.realm.io/downloads/objc/latest
        unzip realm-objc-latest.zip
        mv realm-objc-0.* realm-objc-latest
        curl -o realm-swift-latest.zip -L https://static.realm.io/downloads/swift/latest
        unzip realm-swift-latest.zip
        mv realm-swift-0.* realm-swift-latest

        (
            cd ios/objc/CocoaPodsExample
            pod install
        )
        (
            cd ios/swift/CocoaPodsExample
            pod install
        )

        # Remove downloaded zips
        rm -rf *.zip
        exit 0
        ;;

    ######################################
    # Test
    ######################################

    "test-all")
        ./build.sh test-ios-objc-static
        ./build.sh test-ios-objc-cocoapods
        ./build.sh test-ios-swift-dynamic
        ./build.sh test-ios-swift-cocoapods
        exit 0
        ;;

    "test-ios-objc-static")
        xcodebuild -project ios/objc/StaticExample/StaticExample.xcodeproj -scheme StaticExample clean build test -sdk iphonesimulator
        exit 0
        ;;

    "test-ios-objc-cocoapods")
        xcodebuild -workspace ios/objc/CocoaPodsExample/CocoaPodsExample.xcworkspace -scheme CocoaPodsExample clean build test -sdk iphonesimulator
        exit 0
        ;;

    "test-ios-swift-dynamic")
        xcodebuild -project ios/swift/DynamicExample/DynamicExample.xcodeproj -scheme DynamicExample clean build test -sdk iphonesimulator
        exit 0
        ;;

    "test-ios-swift-cocoapods")
        xcodebuild -workspace ios/swift/CocoaPodsExample/CocoaPodsExample.xcworkspace -scheme CocoaPodsExample clean build test -sdk iphonesimulator
        exit 0
        ;;

    *)
        echo "Unknown command '$COMMAND'"
        usage
        exit 1
        ;;
esac
