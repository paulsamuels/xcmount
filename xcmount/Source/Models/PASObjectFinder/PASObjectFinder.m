//
//  PASObjectFinder.m
//  xcmount
//
//  Created by Paul Samuels on 17/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

#import "PASObjectFinder.h"

// Categories
#import "NSArray+PASEnumeration.h"
#import "NSMutableDictionary+PBXAccessors.h"

// Constants
#import "PASConstants.h"

// Models
#import "PASObjectFactory.h"

@implementation PASObjectFinder

- (NSArray *)targetObjectsInObjects:(NSDictionary *)objects;
{
  return [objects.allValues pas_select:^(NSMutableDictionary *object, __unused NSUInteger _, __unused BOOL *__) {
    return [PBXObjectClass.nativeTarget isEqualToString:object.pbx_isa];
  }];
}

- (NSMutableDictionary *)findOrCreateMountingGroupWithDiskPath:(NSString *)diskPath
                                                     mountPath:(NSString *)mountPath
                                                       objects:(NSMutableDictionary *)objects;
{
  NSMutableArray *directories         = [diskPath  componentsSeparatedByString:@"/"].mutableCopy;
  NSArray        *mountPathComponents = [mountPath componentsSeparatedByString:@"/"];
  
  NSMutableDictionary *group = ({
    [mountPathComponents pas_reduceWithInitial:[self mainGroupInObjects:objects]
                                       combine:^(NSMutableDictionary *currentGroup, id pathComponent) {
                                         NSMutableDictionary *group = [[currentGroup pas_childObjectsInObjects:objects] pas_find:^BOOL(NSMutableDictionary *child, __unused NSUInteger _, __unused BOOL *__) {
                                           return [pathComponent isEqualToString:child.pbx_name] || [pathComponent isEqualToString:child.pbx_path];
                                         }];
                                         
                                         if (group) {
                                           if (directories.count > 0) {
                                             [directories removeObjectAtIndex:0];
                                           }
                                         } else {
                                           NSString *path = nil;
                                           
                                           if ([pathComponent isEqualToString:directories.firstObject]) {
                                             path = pathComponent;
                                             [directories removeObjectAtIndex:0];
                                           }
                                           
                                           group = [PASObjectFactory groupWithName:pathComponent
                                                                              path:path
                                                    inObjects:objects];
                                           
                                           [currentGroup.pbx_children addObject:group.pas_UUID];
                                           
                                         }
                                         
                                         return group;
                                       }];
  });
  
  if (directories.count > 0) {
    group.pbx_path = [directories componentsJoinedByString:@"/"];
  }
  
  return group;
}

- (NSMutableDictionary *)mainGroupInObjects:(NSMutableDictionary *)objects;
{
  return objects[[[self rootObjectInObjects:objects] pbx_mainGroup]];
}

- (NSMutableDictionary *)rootObjectInObjects:(NSMutableDictionary *)objects;
{
  return [objects.allValues pas_find:^(NSMutableDictionary *object, __unused NSUInteger _, __unused BOOL *__) {
    return [PBXObjectClass.project isEqualToString:object.pbx_isa];
  }];
}

@end
