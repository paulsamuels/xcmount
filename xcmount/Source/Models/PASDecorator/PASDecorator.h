//
//  PASDecorator.h
//  xcmount
//
//  Created by Paul Samuels on 17/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

@import Foundation;

@interface PASDecorator : NSObject

+ (void)decorateObjects:(NSMutableDictionary *)objects;
+ (void)cleanObjects:(NSMutableDictionary *)objects;

@end
