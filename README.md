# Opening links in Chrome for iOS (Swift Version)#
This repo is a rewritten version of Google's [OpenInChrome](https://github.com/GoogleChrome/OpenInChrome) in Swift language. The `OpenInChromeController` class is kept identical to the original one. Refer to the [original documentation](https://github.com/GoogleChrome/OpenInChrome/blob/master/README.md) for details.

## Requirements ##
* Xcode 8.1 (Swift 3.0)

## Downloading the class file ##
The OpenInChromeController class file is available [here](https://github.com/cezheng/OpenInChromeSwift/blob/master/OpenInChromeController.swift). Copy it into your Xcode installation.

## Usage ##
Use the OpenInChromeController class as follows:
```
if (openInController_.isChromeInstalled()) {
  openInController_.openInChrome(urlToOpen, callbackURL: callbackURL, createNewTab: createNewTab)
}
```

Add this to your application's Info.plist
```
  <key>LSApplicationQueriesSchemes</key>
	<array>
		<string>googlechrome</string>
		<string>googlechromes</string>
		<string>googlechrome-x-callback</string>
	</array>
 ```
 
 
