//
//  NSArray+PASEnumeration.m
//  xcmount
//
//  Created by Paul Samuels on 17/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

#import "NSArray+PASEnumeration.h"

@implementation NSArray (PASEnumeration)

- (id)pas_reduceWithInitial:(id)initial combine:(id (^)(id memo, id object))combine;
{
  id result = initial;
  
  for (id obj in self) {
    result = combine(result, obj);
  }
  
  return result;
}

- (id)pas_find:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))block;
{
  NSInteger index = [self indexOfObjectPassingTest:block];
  
  return NSNotFound == index ? nil : self[index];
}

- (NSArray *)pas_flatMap:(id (^)(id object))block;
{
  NSMutableArray *result = NSMutableArray.array;
  
  for (id object in self) {
    id blockResult = block(object);
    if ([blockResult isKindOfClass:NSArray.class]) {
      [result addObjectsFromArray:blockResult];
    } else {
      [result addObject:blockResult];
    }
  }
  
  return result;
}

- (NSArray *)pas_map:(id (^)(id object))block;
{
  NSMutableArray *result = NSMutableArray.array;
  
  for (id object in self) {
    [result addObject:block(object)];
  }
  
  return result;
}

- (NSArray *)pas_select:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))block;
{
  return [self objectsAtIndexes:[self indexesOfObjectsPassingTest:block]];
}

@end
