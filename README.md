#BFRGifRefreshControl#

![Demo](https://s3.amazonaws.com/f.cl.ly/items/2H053X262o351Z122O3M/Screen%20Recording%202016-04-28%20at%2012.55%20PM.gif?v=2cc44e39)

[![CocoaPods](https://img.shields.io/cocoapods/p/BFRGifRefreshControl.svg)]() [![CocoaPods](https://img.shields.io/cocoapods/v/BFRGifRefreshControl.svg)]() [![CocoaPods](https://img.shields.io/cocoapods/l/BFRGifRefreshControl.svg)]()

###Summary###
The BFRGifRefreshControl is an extremely lightweight, unintrusive and configurable way to add a .gif to refreshing actions inside of your iOS app 📱! You have total control over it, and the whole package comes in at just over 100 lines 😃!

###Installation###
The BFRGifRefreshControl is hosted on CocoaPods and is the recommended way to install it:
```ruby
pod 'BFRGifRefreshControl'
```

###Quickstart###
To get going, you can either initialize the .gif from your app bundle or via `NSData` which can be retrived from a network call or other means.
The flow is consists of adding it your table view, setting your desired offset values for your situation and then calling `[refreshControl containingScrollViewDidEndDragging]` from your tableview instance's `scrollViewDidEndDragging:willDecelerate:`.


Here is a quick example:

```
self.gifRefresh = [[BFRGifRefreshControl alloc] initWithGifFileName:@"myGif" refreshAction:^ {
    //Calls [self.gifRefresh stopAnimating] inside of performFakeDataRefresh
    [self performFakeDataRefresh];
}];
    
self.gifRefresh.dataRefreshOffsetThreshold = 100.0f; //Trigger refresh after user has scrolled this far
self.gifRefresh.dataRefreshingGifYInset = 115.0f; //Where we want the gif to "hang out" while it performs the block
self.gifRefresh.dataLoadedYInset = 64.0f; //Account for navbar
self.gifRefresh.dataLoadedYOffset = -64.0f; //Account for navbar
```

If you want some additional context, just fire up the demo project and take a peek 👌! This is the easiest way to see how to fire it up!

**_Wait - that seems like a good bit on configuration! Why?_**

- Is the view controller's `automaticallyAdjustsScrollViewInsets` set to `YES` or `NO`? 
- Is there a nav bar? 
- Is the view hierarchy complex and customized? 
- Perhaps you need an offset larger or smaller for other UI elements?
- ...etc

Those are all valid questions! The BFRGifRefreshControl was designed to be usable no matter the situation you find youself in. We could make assumptions or controll the `UIScrollView` via a category, but
every developer faces different situations and those assumptions could sometimes be wrong or lead to some tricky debugging 🐛. 

It's true that most scenarios call for direction opposite values for the Y inset and offset (i.e. 64 and -64) and that the threshold to trigger a refresh just needs to be the same as the control's height - but that's not 100% always the case. For that reason we've opted for those values to be consciouslly set by the developer 👍

###Important Note###
- The constraints are geared for more smaller, "logo" style .gif files (around 50 x 50). Things could certainly be tweaked to accomodate all sizes fairly easily, but it would require a few tweaks 😎.

###Going Forward###
We regularly maintain this code, and you can also rest assured that it's been battle tested against thousands of users in production 👍. That said, we get things wrong from time to time - so feel free to open an issue for anything you spot!

We are always happy to talk shop, so feel free to give us a shout on Twitter:

+ Andy - [@ay8s](http://www.twitter.com/ay8s)
+ Jordan - [@jordanmorgan10](http://www.twitter.com/jordanmorgan10)
+ Humber -[@goku2](http://www.twitter.com/goku2)

Or, hey - why not work on the BFRGifRefreshControl and get paid for it!? [We're hiring](http://www.buffer.com/journey)!

- - -
######Licence######
_This project uses MIT License._
