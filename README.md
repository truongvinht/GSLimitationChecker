GSLimitationChecker
===================

An Objective-C Limitation checker to block the app after given date is reached using UIAlertView (for iOS)


#Example

The given Example expire directly after launching the app
```Objective-C
[[GSLimitationChecker sharedInstance] expiredAt:[NSDate date]withTitle:@"Expired" withMessage:@"This is the expire text!"];
```

#License
MIT License (MIT)