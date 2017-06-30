# BFRGifRefreshControl

![Demo](https://s3.amazonaws.com/f.cl.ly/items/2H053X262o351Z122O3M/Screen%20Recording%202016-04-28%20at%2012.55%20PM.gif?v=2cc44e39)

[![CocoaPods](https://img.shields.io/cocoapods/p/BFRGifRefreshControl.svg)]() [![CocoaPods](https://img.shields.io/cocoapods/v/BFRGifRefreshControl.svg)]() [![CocoaPods](https://img.shields.io/cocoapods/l/BFRGifRefreshControl.svg)]()

### Summary
The BFRGifRefreshControl is an extremely lightweight, unintrusive and configurable way to add a .gif to refreshing actions inside of your iOS app 📱! You have total control over it, and the whole package comes in at just over 100 lines 😃!

### Installation
The BFRGifRefreshControl is hosted on CocoaPods and is the recommended way to install it:
```ruby
pod 'BFRGifRefreshControl'
```

### Quickstart
To get going, pass in a .gif from your app bundle along with a trigger view and the containing scroll view. Don't worry about any retain cycles here - these are weakly reference. The trigger view is used to determine how far you the want the user to scroll down to kick off a refresh. It's calculated from the bottom of the trigger view, plus self.loadingOffset.

More than likely, the trigger view will be a navigation bar. So, if you pass in a navigation bar as the trigger view, and set the loading offset to 44, the refresh will occur when the gif has scrolled 44 points below the navigation bar.

The flow is consists of adding it your table view, setting your desired offset values for your situation and then calling:

`[refreshControl containingScrollViewDidScroll]` from the passed in scrollview's `scrollViewDidEndDragging:willDecelerate:`.
`[refreshControl containingScrollViewDidEndDragging]` from the passed in scrollview's `scrollViewDidEndDragging:willDecelerate:`.


Here is a quick example:

```
self.gifRefresh = [[BFRGifRefreshControl alloc] initWithGifFileName:@"pull-to-refresh@2x" scrollView:self.tableView triggerView:self.navigationController.navigationBar refreshAction:^ {
    [self performFakeDataRefresh];
}];
    
self.gifRefresh.loadingOffset = 44.0f; // Optional, default is 36.0f
self.gifRefresh.dataRefreshingGifYInset = 115.0f; // Where we want the gif to "hang out" while it performs the block
```

If you want some additional context, just fire up the demo project and take a peek 👌! This is the easiest way to see how to fire it up!

### Important Note
- The constraints are geared for more smaller, "logo" style .gif files (around 50 x 50). Things could certainly be changed to accomodate all sizes fairly easily, but it would require a few tweaks 😎.

### Going Forward
We regularly maintain this code, and you can also rest assured that it's been battle tested against thousands of users in production 👍. That said, we get things wrong from time to time - so feel free to open an issue for anything you spot!

We are always happy to talk shop, so feel free to give us a shout on Twitter:

+ Andy - [@ay8s](http://www.twitter.com/ay8s)
+ Jordan - [@jordanmorgan10](http://www.twitter.com/jordanmorgan10)

Or, hey - why not work on the BFRGifRefreshControl and get paid for it!? [We're hiring](http://www.buffer.com/journey)!

- - -
#### Licence
_This project uses MIT License._
