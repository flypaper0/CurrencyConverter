//
//  Balance.h
//  ConverterDemo
//
//  Created by Artur Guseinov on 22/02/17.
//  Copyright © 2017 Artur Guseinov. All rights reserved.
//

#import <Realm/Realm.h>


@interface Balance : RLMObject

@property int index;
@property NSString *currency;
@property double balance;

@end
