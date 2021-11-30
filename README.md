# push-service

Small utility command line tool you can run locally from your mac, for testing sending push notifications to actual devices.
The push service tool depends on two open source packages:
```
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.0"),
        .package(url: "https://github.com/kylebrowning/APNSwift.git", from: "3.0.0")
```


## Usage
To see the help:
```swift run push -h```


Example:
```
swift run push --alert -t "device_token" \
    -n "{\"aps\": {}}" \
    "/path/to/key/AuthKey.p8" \
    "org.yourcompany.app.name" \
    "AuthKeyId" \
    "TeamIdentifier"
```

Notification option can have custom payload added to it.
```json
{
    "aps": {
        // default aps payload data  
    },
    "custom": {
        "your_param": "your_value"
    }
}
```

Pass the `--verbose` flag to the command for debugging info.
