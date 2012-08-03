AdinchSDK-iOS
=============Adinch
Adinch for iOS is provided in source rather than framework form so you must build it by incorporating the Adinch sub-folder into your Xcode project.

For using each network include to project same adapter from our site

TouchJSON & JSONKit
Similarly incorporate the TouchJSON & JSONKit redistribution bundled with the Adinch SDK.

 System Frameworks
Add the system frameworks required by the supported ad networks:
	* `	AddressBook`
	* `	AudioToolbox`
	* `	AVFoundation`
	* `	CoreLocation`
	* `	libsqlite3`
	* `	libz`
	* `	MapKit`
The following additional frameworks are required by the iAd adapter:
	* `	iAd`
	* `	QuartzCore`
	* `	SystemConfiguration`
Some frameworks must be weak-linked if you wish to support older iOS releases where they were unavailable.

Setup
Finally, to display the mediated ads simply implement AMDelegate’s two requirements, request an AMView and add it to the hierarchy.
	
	- (NSString *)AMApplicationKey {
		return _MY_AD_ADINCH_APPLICATION_KEY;
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
		 [UIView beginAnimations:@”AMDelegate.AMDidReceiveAd:”
			         context:nil];
 
		 [UIView setAnimationDuration:0.7];
 
		 CGSize adSize = [amView actualAdSize];
		 CGRect newFrame = amView.frame;
 
		 newFrame.size = adSize;
		 newFrame.origin.x = (self.view.bounds.size.width - adSize.width)/ 2;
 
		 amView.frame = newFrame;
 
		 [UIView commitAnimations];
	}
