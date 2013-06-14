//
//  AMAdapterSmaato.h
//  DemoProject
//
//  Created by Gor Avakyan on 02.08.12.
//
//

#import "AMAdNetworkAdapter.h"
#import <iSoma/SOMAAdDownloader.h>
#import <iSOMA/SOMABannerView.h>
#import <iSOMA/SOMAAdListenerProtocol.h>
#import <iSOMA/SOMABannerViewDelegate.h>

@interface AMAdapterSmaato : AMAdNetworkAdapter<SOMAAdListenerProtocol, SOMABannerViewDelegate>

@end
