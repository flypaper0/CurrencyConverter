//
//  NetworkActivityIndicatorManager.m
//  ConverterDemo
//
//  Created by Artur Guseinov on 24/02/17.
//  Copyright © 2017 Artur Guseinov. All rights reserved.
//

#import "NetworkActivityIndicatorManager.h"

@implementation NetworkActivityIndicatorManager

NSUInteger * loadingCount = 0;

+ (void)networkOperationStarted {
    if (loadingCount == 0) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    loadingCount ++;
}

+ (void)networkOperationFinished {
    if (loadingCount > 0) {
        loadingCount--;
    }
    if (loadingCount == 0) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }

}

@end
