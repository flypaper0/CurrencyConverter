//
//  NetworkActivityIndicatorManager.h
//  ConverterDemo
//
//  Created by Artur Guseinov on 24/02/17.
//  Copyright © 2017 Artur Guseinov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetworkActivityIndicatorManager : NSObject

+ (void)networkOperationStarted;
+ (void)networkOperationFinished;

@end
