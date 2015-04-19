//
//  PASMounter.m
//  xcmount
//
//  Created by Paul Samuels on 18/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

#import "PASMounter.h"

// Categories
#import "NSArray+PASEnumeration.h"
#import "NSMutableDictionary+PBXAccessors.h"

// Models
#import "PASConstants.h"
#import "PASObjectFactory.h"
#import "PASUUIDGenerator.h"

@implementation PASMounter

- (void)addGroup:(NSMutableDictionary *)group
       toTargets:(NSArray *)targets
         objects:(NSMutableDictionary *)objects;
{
  NSMutableArray *implementationFilesUUIDs = NSMutableArray.array;
  NSMutableArray *resourceFilesUUIDs       = NSMutableArray.array;
  
  [[[group pas_recursiveChildObjectsInObjects:objects] pas_select:^(NSMutableDictionary *object, __unused NSUInteger _, __unused BOOL *__) {
    
    return [PBXObjectClass.fileReference isEqualToString:object.pbx_isa];
    
  }] enumerateObjectsUsingBlock:^(NSMutableDictionary *fileReference, __unused NSUInteger _, __unused BOOL *__) {
    
    NSString *fileName = fileReference.pbx_path;
    
    if ([fileName hasSuffix:@".h"]) {
      return;
    }
    
    NSMutableDictionary *buildFile = [PASObjectFactory buildFileWithFileReferenceUUID:fileReference.pas_UUID
                                                                            inObjects:objects];
    
    static NSArray *sourceExtensions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      sourceExtensions = @[ @"swift", @"c", @"m", @"mm", @"cc", @"cpp" ];
    });
    
    if ([sourceExtensions containsObject:fileName.pathExtension.lowercaseString]) {
      [implementationFilesUUIDs addObject:buildFile.pas_UUID];
    } else {
      [resourceFilesUUIDs addObject:buildFile.pas_UUID];
    }
  }];
  
  [targets enumerateObjectsUsingBlock:^(NSMutableDictionary *target, __unused NSUInteger _, __unused BOOL *__) {
    
    [[target.pbx_buildPhases pas_map:^(NSMutableDictionary *buildPhase) {
      
      return objects[buildPhase];
      
    }] enumerateObjectsUsingBlock:^(NSMutableDictionary *buildPhase, __unused NSUInteger _, __unused BOOL *__) {
      
      if ([PBXObjectClass.sourcesBuildPhase isEqualToString:buildPhase.pbx_isa]) {
        [buildPhase.pbx_files addObjectsFromArray:implementationFilesUUIDs];
      } else if ([PBXObjectClass.resourcesBuildPhase isEqualToString:buildPhase.pbx_isa]) {
        [buildPhase.pbx_files addObjectsFromArray:resourceFilesUUIDs];
      }
      
    }];
    
  }];
}

@end
