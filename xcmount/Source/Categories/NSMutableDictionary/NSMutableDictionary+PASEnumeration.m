//
//  NSMutableDictionary+PASEnumeration.m
//  xcmount
//
//  Created by Paul Samuels on 18/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

#import "NSMutableDictionary+PASEnumeration.h"

@implementation NSMutableDictionary (PASEnumeration)

- (void)pas_deleteIf:(BOOL (^)(id<NSCopying> key, id object, BOOL *stop))block;
{
  [self removeObjectsForKeys:[self keysOfEntriesPassingTest:block].allObjects];
}

@end
