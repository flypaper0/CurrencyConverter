//
//  RateList.h
//  ConverterDemo
//
//  Created by Artur Guseinov on 21/02/17.
//  Copyright © 2017 Artur Guseinov. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RateList : NSObject

@property (strong, nonatomic) NSString *base;
@property (strong, nonatomic) NSDictionary *rates;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
