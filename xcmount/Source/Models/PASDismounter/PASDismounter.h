//
//  PASDismounter.h
//  xcmount
//
//  Created by Paul Samuels on 17/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

@import Foundation;

@interface PASDismounter : NSObject

- (void)dismountGroup:(NSMutableDictionary *)group
           forTargets:(NSArray *)targets
              objects:(NSMutableDictionary *)objects;

@end
