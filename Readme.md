This fork is the debugged/improved version of TabBarKit I've come to while using it a little.

## Issues with the original source

### First debugging

You can have a look to this [article](http://www.softr.li/blog/2012/05/10/debugging-tabbarkit-a-barebones-kit-for-custom-tab-bar-on-ios/) were I explain my first issues.

### Other issues corrected in this fork

I have had to rewrite some parts of TBKTabBarController since I needed to be able to programmatically select a tab. This is normally possible by setting the `selectedIndex` or the `selectedViewController` property, but it was not working with TabBarKit.

I investigated and detected this behavior was not implemented, so I decided to complete it myself.

Along the way, I discovered there were some issues with the `containerView` being mixed up with the `TBKTabBarController`'s view, so I also corrected these bugs.

## Remarks/questions

### Is it good that TBKTabBarController is a subclass of UIViewController?

I have currently no idea of what could be the correct solution for implementing a custom tab bar, but according to some articles and StackOverflow questions I've been reading on UIViewController subclassing, TabBarKit may not be following the expected implementation.

Here are the references:

- [StackOverflow - Am I abusing UIViewController subclassing?](http://stackoverflow.com/questions/5691226/am-i-abusing-uiviewcontroller-subclassing/5691708#comment-6507338)
- [Abusing UIViewControllers](http://blog.carbonfive.com/2011/03/09/abusing-uiviewcontrollers/)

In the context of TabBarKit, I think the issues may be in the fact `TBKTabBarController` is a `UIViewController` subclass so it should only manage a view hierarchy, but in fact it will manage views of other `UIViewController`s. I understand it is not _good_ because it may induce some issues with the `didReceiveMemoryWarning` and delegate methods (such as `viewWillAppear`). However, we can consider that Apple is doing the same with its own `UITabBarController` and if we do it carefully enough, it should be OK.

As a matter of fact, the last commit I submitted is detecting if the iOS version is lower than 5 and forcing the call of the delegate methods (`viewWillAppear`, `viewDidAppear`, `viewWillDisappear`...) since that's necessary on iOS 4 but not iOS 5. This change is to correct an issue I've faced but I'm still not comfortable with it, may require more tweaking...