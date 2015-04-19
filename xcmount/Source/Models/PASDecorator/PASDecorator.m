//
//  PASDecorator.m
//  xcmount
//
//  Created by Paul Samuels on 17/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

#import "PASDecorator.h"

// Categories
#import "NSMutableDictionary+PBXAccessors.h"

@implementation PASDecorator

+ (void)decorateObjects:(NSMutableDictionary *)objects;
{
  [objects enumerateKeysAndObjectsUsingBlock:^(NSString *UUID, NSMutableDictionary *object, __unused BOOL *_) {
    object.pas_UUID = UUID;
  }];
}

+ (void)cleanObjects:(NSMutableDictionary *)objects;
{
  [objects enumerateKeysAndObjectsUsingBlock:^(__unused NSString *_, NSMutableDictionary *object, __unused BOOL *__) {
    [object pas_removeUUID];
  }];
}

@end
