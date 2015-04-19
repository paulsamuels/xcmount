//
//  NSMutableDictionary+PBXAccessors.m
//  xcmount
//
//  Created by Paul Samuels on 17/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

#import "NSMutableDictionary+PBXAccessors.h"

// Categories
#import "NSArray+PASEnumeration.h"

// Constants
#import "PASConstants.h"

@implementation NSMutableDictionary (PBXObjectAccessors)

- (NSMutableArray *)pbx_children;
{
  return self[PBXObjectAccessors.children];
}

- (void)pbx_setChildren:(NSMutableArray *)pbx_children;
{
  self[PBXObjectAccessors.children] = pbx_children;
}

- (NSString *)pbx_isa;
{
  return self[PBXObjectAccessors.isa];
}

- (void)pbx_setIsa:(NSString *)pbx_isa;
{
  self[PBXObjectAccessors.isa] = pbx_isa;
}

- (NSString *)pbx_name;
{
  return self[PBXObjectAccessors.name];
}

- (void)pbx_setName:(NSString *)pbx_name;
{
  self[PBXObjectAccessors.name] = pbx_name;
}

- (NSString *)pbx_path;
{
  return self[PBXObjectAccessors.path];
}

- (void)pbx_setPath:(NSString *)pbx_path;
{
  self[PBXObjectAccessors.path] = pbx_path;
}

- (NSString *)pas_UUID;
{
  return self[PBXObjectAccessors.uuid];
}

- (void)pas_setUUID:(NSString *)pas_UUID;
{
  self[PBXObjectAccessors.uuid] = pas_UUID;
}

@end

@implementation NSMutableDictionary (PBXBuildFileAccessors)

- (NSString *)pbx_fileReference;
{
  return self[PBXBuildFileAccessors.fileReference];
}

- (void)pbx_setFileReference:(NSString *)pbx_fileReference;
{
  self[PBXBuildFileAccessors.fileReference] = pbx_fileReference;
}

@end

@implementation NSMutableDictionary (PBXBuildPhaseAccessors)

- (NSMutableArray *)pbx_files;
{
  return self[PBXBuildPhaseAccessors.files];
}

- (void)pbx_setFiles:(NSMutableArray *)pbx_files
{
  self[PBXBuildPhaseAccessors.files] = pbx_files;
}

@end

@implementation NSMutableDictionary (PBXAccessors)

- (NSArray *)pas_childObjectsInObjects:(NSDictionary *)objects;
{
  return [self.pbx_children pas_map:^(NSMutableDictionary *UUID) {
    return objects[UUID];
  }] ?: @[];
}

- (NSArray *)pas_recursiveChildUUIDsInObjects:(NSDictionary *)objects;
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
  __block id (^combine)(NSMutableArray *, NSMutableDictionary *) = ^(NSMutableArray *descendents, NSMutableDictionary *child) {
    [descendents addObject:child];
    [[child pas_childObjectsInObjects:objects] pas_reduceWithInitial:descendents combine:combine];
    
    return descendents;
  };
#pragma clang diagnostic pop
  
  return [[[self pas_childObjectsInObjects:objects] pas_reduceWithInitial:NSMutableArray.array combine:combine] pas_map:^(NSMutableDictionary *object) {
    return object.pas_UUID;
  }];
}

- (NSArray *)pas_recursiveChildObjectsInObjects:(NSDictionary *)objects;
{
  return [[self pas_recursiveChildUUIDsInObjects:objects] pas_map:^(NSString *UUID) {
    return objects[UUID];
  }];
}

- (void)pas_removeUUID;
{
  [self removeObjectForKey:PBXObjectAccessors.uuid];
}

@end

@implementation NSMutableDictionary (PBXProjectAccessors)

- (NSString *)pbx_mainGroup;
{
  return self[PBXProjectAccessors.mainGroup];
}

- (void)pbx_setMainGroup:(NSString *)pbx_mainGroup;
{
  self[PBXProjectAccessors.mainGroup] = pbx_mainGroup;
}

@end

@implementation NSMutableDictionary (PBXTargetAccessors)

- (NSMutableArray *)pbx_buildPhases;
{
  return self[PBXTargetAccessors.buildPhases];
}

- (void)pbx_setBuildPhases:(NSMutableArray *)pbx_buildPhases;
{
  self[PBXTargetAccessors.buildPhases] = pbx_buildPhases;
}

@end

@implementation NSMutableDictionary (PBXWrapperAccessors)

- (NSMutableDictionary *)pbx_objects;
{
  return self[PBXWrapperAccessors.objects];
}

- (void)pbx_setObjects:(NSMutableDictionary *)pbx_objects;
{
  self[PBXWrapperAccessors.objects] = pbx_objects;
}

@end
