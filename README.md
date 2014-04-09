Adinch
===========

Adinch for iOS is provided as a static library and header files.

Here is how to use Adinch library in your project:


1. Simple banner request
------------------
    - (void)viewDidLoad
    {
        [super viewDidLoad];
        // ...
        
        self.smallBanner = [[AdinchBannerView alloc] initWithSizeType:AMBannerViewSizeType320x50];
    	smallBanner.adsKey = MY_ADINCH_KEY;
		smallBanner.delegate = self;
    	[smallBanner requestNewBanner];
    
    }


2. Big banner request
------------------
    - (void)viewDidLoad
    {
        [super viewDidLoad];
        // ...
        
        self.bigBanner = [[AdinchBannerView alloc] initWithSizeType:AMBannerViewSizeType300x250];
    	bigBanner.adsKey = MY_ADINCH_KEY;
		bigBanner.delegate = self;
    	[bigBanner requestNewBanner];
    }


3. Response when banner is ready
------------------
	- (void)bannerViewDidLoad:(AdinchBannerView *)bannerView
	{
		// banner is successfully loaded loaded and can be shown
    	[self.view addSubview:bannerView];
	}

	
4. Error handling
------------------
	- (void)bannerView:(AdinchBannerView *)bannerView didFailLoadAdWithError:(NSError *)error
	{
		[bannerView removeFromSuperview];
		if( error == nil ) {
			// there are no ads to display
			// perform [bannerView requestNewBanner] after a while or
			// request a banner from any other ad network
		} else {
			// all other errors
		}
	}