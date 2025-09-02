## Troubleshooting

### Issue (or similar message):

```gradle
 Failed to build module 'PaymentSdk'; this SDK is not supported by the compiler (the SDK is built with 'Apple Swift version 6.0.3 effective-5.10 (swiftlang-6.0.3.1.10 clang-1600.0.30.1)', while this compiler is 'Apple Swift version 5.10 (swiftlang-5.10.0.13 clang-1500.3.9.4)'. Please select a toolchain which matches the SDK.

```

Recommendation: To ensure proper SDK functionality, we recommend using Swift 6.x. For older versions of Xcode (e.g., 15.5 and lower), consider using updated SDK versions available through CocoaPods.

### Issue

```txt
Sandbox: rsync(92078) deny(1) file-read-data ...
...
error: Sandbox: cp(25322) deny(1) file-read-data /Users/daniel/Project/File.txt
...
1 duplicate report for Sandbox: rsync(92078) deny(1) file-read-data ...
...
Sandbox: rsync(...) deny(1) file-read-data ...
...
Sandbox: rsync(...) deny(1) file-write-create ...
```

Apple added a new build setting to Xcode last year, ENABLE_USER_SCRIPT_SANDBOXING, which controls whether any “Run Script” build phases will be run in a sandbox or not.

`ENABLE_USER_SCRIPT_SANDBOXING = NO`
