Adinch
===========

Adinch for iOS is provided as a static library and header files.

Here is how to use Adinch library in your project:


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
