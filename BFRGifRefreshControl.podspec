Pod::Spec.new do |s|
  s.name         = "BFRGifRefreshControl"
  s.version      = "1.0.0"
  s.summary      = "A simple and lightweigh refresh control."
  s.description  = <<-DESC
            The BFRGifRefreshControl is an extremely lightweight, unintrusive and configurable way to add a .gif to refreshing actions inside of your iOS app 📱! You have total control over it, and the whole package comes in at just over 100 lines 😃!
                   DESC
  s.homepage     = "https://github.com/bufferapp/BFRGIFRefreshControl"
  s.screenshots  = "https://camo.githubusercontent.com/462bed11b83ed04bca6f02a0fb54f4e59c651f74/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f662e636c2e6c792f6974656d732f3248303533583236326f3335315a3132324f334d2f53637265656e2532305265636f7264696e67253230323031362d30342d3238253230617425323031322e3535253230504d2e6769663f763d3263633434653339"
  s.license      = "MIT"
  s.authors      = {"Andrew Yates" => "andy@bufferapp.com",
               "Jordan Morgan" => "jordan@bufferapp.com",
                       "Humber Aquino" => "humber@bufferapp.com"}
  s.social_media_url = "https://twitter.com/bufferdevs"
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/bufferapp/BFRGIFRefreshControl.git", :tag => "1.0.0" }
  s.source_files  = 'GifRefresh/**/BFRGifRefreshControl.{h,m}'  
  s.framework  = "UIKit"
  s.requires_arc = true
  s.dependency 'FLAnimatedImage'
  s.dependency 'Masonry'
end
