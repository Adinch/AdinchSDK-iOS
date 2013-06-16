Adinch
===========

Adinch for iOS is provided in source rather than framework form so you must build it by incorporating the Adinch sub-folder into your Xcode project.

For using each network include to project same adapter from our site

System Frameworks
----------------- 
Add the system frameworks required by the supported ad networks:

	*.	AddressBook
	*.	AudioToolbox
	*.	AVFoundation
	*.	CoreLocation
	*.	libsqlite3
	*.	libz
	*.	MapKit
    
The following additional frameworks are required by the iAd adapter:

	*.	iAd
	*.	QuartzCore
	*.	SystemConfiguration
    
Some frameworks must be weak-linked if you wish to support older iOS releases where they were unavailable.

1. Simple banner
------------------
    - (void)viewDidLoad {
        [super viewDidLoad];
        // ...
        
        AMBannerView *simpleBanner = [[AMBannerView alloc] initWithSizeType:AMBannerViewSizeType320x50];
    	simpleBanner.adsKey = MY_ADINCH_KEY;
	simpleBanner.delegate = self;
    	[simpleBanner requestNewBanner];
    
    	[self.view addSubview:simpleBanner];
    }


2. Big banner
------------------
    - (void)viewDidLoad {
        [super viewDidLoad];
        // ...
        
        AMBannerView *bigBanner = [[AMBannerView alloc] initWithSizeType:AMBannerViewSizeType300x250];
    	bigBanner.adsKey = MY_ADINCH_KEY;
	bigBanner.delegate = self;
    	[bigBanner requestNewBanner];
    
    	[self.view addSubview:bigBanner];
    }

3. Mediation. You can not use mediation with AMBannerViewSizeType300x250 size type
-------------------

    - (NSString *)AMApplicationKey {
        return MY_ADINCH_KEY;
    }
    
    - (UIViewController *)viewControllerForPresentingModalView {
        return UIWindow.rootViewController;
    }
    
    - (void)viewDidLoad {
        [super viewDidLoad];
        // ...
        
        AMView *amView = [AMView requestAMViewWithDelegate:self];
        [self.view addSubview:amView];
    }

    - (void)AMDidReceiveAd:(AMView *)amView {
        [UIView beginAnimations:@”AMDelegate.AMDidReceiveAd:” context:nil];
        
        [UIView setAnimationDuration:0.7];
        
        CGSize adSize = [amView actualAdSize];
        CGRect newFrame = amView.frame;
        newFrame.size = adSize;
        newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/ 2;
        
        amView.frame = newFrame;
        
        [UIView commitAnimations];
    }
    
4. Integrating to Adwhirl
---------------------
To integrate Adinch to Adwhirl  you’ll need:

1) In the Control Panel of Adwirl go to application settings. Push the button "Add custom event", in the appeared window fill the field. Function name – the name of the method, which will be called in your applicationи, let’s name it performAdinch.

2) Throughout the program, define the following methods:

    - (void)viewDidLoad {
        [super viewDidLoad];
        
        // Сonfiguration
        CGRect bannerFrame = CGRectZero;
        bannerFrame.size = AD_SIZE_320x50;
        _adinchBannerView = [[ADBannerView alloc] initWithFrame:bannerFrame];
        _adinchBannerView.adsKey = MY_SOME_KEY;
        _adinchBannerView.delegate = self;
    }
    
    // The method that we have written  in the application settings  Adwirl (Function name)
    - (void)performAdinch:(AdWhirlView *)sender
    {
        // Replace the current banner on  _adinchBannerView
        [sender replaceBannerViewWith:_adinchBannerView];
        
        // Request the new banner
        [_adinchBannerView requestNewBanner];
    }

Mediation meets the requirements of <a href=http://www.apache.org/licenses/LICENSE-2.0.html>Apache License, Version 2.0</a>. All copyrights respected.

The development is based on <a href=http://code.google.com/p/adwhirl/>the source codes</a> of <a href=https://www.adwhirl.com/>AdWhirl.</a>
