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
    # Bootsrap
    ######################################

    "bootstrap")
        # Clear out any previous downloads
        rm -rf realm-*

        curl -o realm-objc-latest.zip -L https://static.realm.io/downloads/objc/latest
        unzip realm-objc-latest.zip
        mv realm-objc-0.* realm-objc-latest
        curl -o realm-swift-latest.zip -L https://static.realm.io/downloads/swift/latest
        unzip realm-swift-latest.zip
        mv realm-swift-0.* realm-swift-latest

        # Remove downloaded zips
        rm -rf *.zip
        exit 0
        ;;

    ######################################
    # Test
    ######################################

    "test-all")
        ./build.sh test-ios-objc-static
        exit 0
        ;;

    "test-ios-objc-static")
        xcodebuild -project ios/objc/StaticExample/StaticExample.xcodeproj -scheme StaticExample clean build test -sdk iphonesimulator
        exit 0
        ;;

    *)
        echo "Unknown command '$COMMAND'"
        usage
        exit 1
        ;;
esac
