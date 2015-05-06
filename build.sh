#!/bin/bash

usage() {
cat <<EOF
Usage: sh $0 command [argument]

command:
  bootstrap: downloads product dependencies and runs `pod install` where appropriate
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

    *)
        echo "Unknown command '$COMMAND'"
        usage
        exit 1
        ;;
esac
