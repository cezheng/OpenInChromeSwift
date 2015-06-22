// Copyright (c) 2015 Ce Zheng
//
// Copyright 2012, Google Inc.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
//     * Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above
// copyright notice, this list of conditions and the following disclaimer
// in the documentation and/or other materials provided with the
// distribution.
//     * Neither the name of Google Inc. nor the names of its
// contributors may be used to endorse or promote products derived from
// this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import UIKit

private let googleChromeHTTPScheme: String = "googlechrome:"
private let googleChromeHTTPSScheme: String = "googlechromes:"
private let googleChromeCallbackScheme: String = "googlechrome-x-callback:"

private func encodeByAddingPercentEscapes(input: String?) -> String {
    return CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, input, nil, "!*'();:@&=+$,/?%#[]", CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)) as String;
}

public class OpenInChromeController {
    public static let sharedInstance = OpenInChromeController()
    
    public func isChromeInstalled() -> Bool {
        let simpleURL = NSURL(string: googleChromeHTTPScheme)!
        let callbackURL = NSURL(string: googleChromeCallbackScheme)!
        return UIApplication.sharedApplication().canOpenURL(simpleURL) || UIApplication.sharedApplication().canOpenURL(callbackURL);
    }
    
    public func openInChrome(url: NSURL, callbackURL: NSURL? = nil, createNewTab: Bool = false) -> Bool {
        let chromeSimpleURL = NSURL(string: googleChromeHTTPScheme)!
        let chromeCallbackURL = NSURL(string: googleChromeCallbackScheme)!
        if UIApplication.sharedApplication().canOpenURL(chromeCallbackURL) {
            var appName = NSBundle.mainBundle().infoDictionary?["CFBundleDisplayName"] as? String
            // CFBundleDisplayName is an optional key, so we will use CFBundleName if it does not exist
            if appName == nil {
                appName = NSBundle.mainBundle().infoDictionary?["CFBundleName"] as? String
            }
            let scheme = url.scheme.lowercaseString
            if scheme == "http" || scheme == "https" {
                var chromeURLString = String(format: "%@//x-callback-url/open/?x-source=%@&url=%@", googleChromeCallbackScheme, encodeByAddingPercentEscapes(appName), encodeByAddingPercentEscapes(url.absoluteString))
                if callbackURL != nil {
                    chromeURLString += String(format: "&x-success=%@", encodeByAddingPercentEscapes(callbackURL!.absoluteString))
                }
                if createNewTab {
                    chromeURLString += "&create-new-tab"
                }
                return UIApplication.sharedApplication().openURL(NSURL(string: chromeURLString)!)
            }
        } else if UIApplication.sharedApplication().canOpenURL(chromeSimpleURL) {
            let scheme = url.scheme.lowercaseString
            var chromeScheme: String? = nil
            if scheme == "http" {
                chromeScheme = googleChromeHTTPScheme
            } else if scheme == "https" {
                chromeScheme = googleChromeHTTPSScheme
            }
            if let chromeScheme = chromeScheme {
                let absoluteURLString = url.absoluteString
                let chromeURLString = chromeScheme + absoluteURLString.substringFromIndex(absoluteURLString.rangeOfString(":")!.startIndex)
                return UIApplication.sharedApplication().openURL(NSURL(string: chromeURLString)!)
            }
        }
        return false;
    }
}