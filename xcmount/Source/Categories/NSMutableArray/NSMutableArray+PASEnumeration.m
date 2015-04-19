//
//  NSMutableArray+PASEnumeration.m
//  xcmount
//
//  Created by Paul Samuels on 18/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

#import "NSMutableArray+PASEnumeration.h"

@implementation NSMutableArray (PASEnumeration)

- (void)pas_deleteIf:(BOOL(^)(id object, NSUInteger idx, BOOL *stop))block;
{
  [self removeObjectsAtIndexes:[self indexesOfObjectsPassingTest:block]];
}

@end
