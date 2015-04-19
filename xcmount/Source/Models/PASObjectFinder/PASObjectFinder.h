//
//  PASObjectFinder.h
//  xcmount
//
//  Created by Paul Samuels on 17/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

@import Foundation;

@interface PASObjectFinder : NSObject

- (NSMutableDictionary *)findOrCreateMountingGroupWithDiskPath:(NSString *)diskPath
                                                     mountPath:(NSString *)mountPath
                                                       objects:(NSMutableDictionary *)objects;

- (NSArray *)targetObjectsInObjects:(NSDictionary *)objects;
- (NSMutableDictionary *)mainGroupInObjects:(NSMutableDictionary *)objects;

@end
