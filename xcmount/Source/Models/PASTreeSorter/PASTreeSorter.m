//
//  PASTreeSorter.m
//  xcmount
//
//  Created by Paul Samuels on 19/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

#import "PASTreeSorter.h"

// Categories
#import "NSArray+PASEnumeration.h"
#import "NSMutableDictionary+PBXAccessors.h"

// Constants
#import "PASConstants.h"

@implementation PASTreeSorter

+ (void)sortTree:(NSMutableDictionary *)tree inObjects:(NSMutableDictionary *)objects;
{
  NSString *(^key)(NSMutableDictionary *) = ^(NSMutableDictionary *object) {
    return (object.pbx_name ?: object.pbx_path) ?: @"";
  };
  
  [tree.pbx_children sortUsingComparator:^(NSString *UUID1, NSString *UUID2) {
    
    NSMutableDictionary *object1 = objects[UUID1];
    NSMutableDictionary *object2 = objects[UUID2];
    
    if ([object1.pbx_isa isEqualToString:object2.pbx_isa]) {
      return [key(object1) caseInsensitiveCompare:key(object2)];
    } else {
      return (NSComparisonResult)([PBXObjectClass.group isEqualToString:object1.pbx_isa] ? NSOrderedAscending : NSOrderedDescending);
    }
    
  }];
  
  for (NSMutableDictionary *child in tree.pbx_children) {
    [self sortTree:objects[child] inObjects:objects];
  }
}

@end
