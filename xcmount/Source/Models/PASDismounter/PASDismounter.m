//
//  PASDismounter.m
//  xcmount
//
//  Created by Paul Samuels on 17/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

#import "PASDismounter.h"

// Categories
#import "NSArray+PASEnumeration.h"
#import "NSMutableArray+PASEnumeration.h"
#import "NSMutableDictionary+PBXAccessors.h"
#import "NSMutableDictionary+PASEnumeration.h"

// Constants
#import "PASConstants.h"

@implementation PASDismounter

- (void)dismountGroup:(NSMutableDictionary *)group
           forTargets:(NSArray *)targets
              objects:(NSMutableDictionary *)objects;
{
  NSSet *fileAndGroupsToRemove = [NSSet setWithArray:[group pas_recursiveChildUUIDsInObjects:objects]];
  
  [[targets pas_flatMap:^(NSMutableDictionary *target) {
    
    return [target.pbx_buildPhases pas_map:^(NSString *UUID) {
      return objects[UUID];
    }];
    
  }] enumerateObjectsUsingBlock:^(NSMutableDictionary *buildPhase, __unused NSUInteger _, __unused BOOL *__) {
    
    [buildPhase.pbx_files pas_deleteIf:^(NSString *UUID, __unused NSUInteger _, __unused BOOL *__) {
      return [fileAndGroupsToRemove containsObject:[objects[UUID] pbx_fileReference]];
    }];
    
    group.pbx_children = NSMutableArray.array;
    
  }];
  
  [objects pas_deleteIf:^BOOL(NSString *UUID, NSMutableDictionary *object, __unused BOOL *_) {
    return [fileAndGroupsToRemove containsObject:UUID] || ([PBXObjectClass.buildFile isEqualToString:object.pbx_isa] && [fileAndGroupsToRemove containsObject:object.pbx_fileReference]);
  }];
}

@end
