This fork is the debugged version of TabBarKit I've come to while using it a little.

## Issues with the original source

### First debugging

You can have a look to this [article](http://www.softr.li/blog/2012/05/10/debugging-tabbarkit-a-barebones-kit-for-custom-tab-bar-on-ios/) were I explain my first issues.

### Other issues corrected in this fork

I have had to rewrite some parts of TBKTabBarController since I needed to be able to programmatically select a tab. This is normally possible by setting the `selectedIndex` or the `selectedViewController` property, but it was not working with TabBarKit.

I investigated and detected this behavior was not implemented, so I decided to complete it myself.

Along the way, I discovered there were some issues with the `containerView` being mixed up with the `TBKTabBarController`'s view, so I also corrected these bugs.