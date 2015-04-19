//
//  PASMounter.h
//  xcmount
//
//  Created by Paul Samuels on 18/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

@import Foundation;

@interface PASMounter : NSObject

- (void)addGroup:(NSMutableDictionary *)group
       toTargets:(NSArray *)targets
         objects:(NSMutableDictionary *)objects;

@end
