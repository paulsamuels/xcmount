//
//  main.m
//  xcmount
//
//  Created by Paul Samuels on 17/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

@import Foundation;

#import "PASConfiguration.h"
#import "PASDecorator.h"
#import "PASDismounter.h"
#import "PASMounter.h"
#import "PASObjectFinder.h"
#import "PASTreeBuilder.h"
#import "PASTreeSorter.h"

#import "NSArray+PASEnumeration.h"
#import "NSMutableDictionary+PBXAccessors.h"

int main(__unused int argc, __unused const char * argv[]) {
  @autoreleasepool {
    
    printf("xcmount version 0.0.1\n");
    
    NSError  *xcmountFileError = nil;
    NSString *xcmountFile      = [NSString stringWithContentsOfFile:@"xcmountfile" encoding:NSUTF8StringEncoding error:&xcmountFileError];
    
    NSError *configurationError = nil;
    
    PASConfiguration *configuration = [PASConfiguration loadFromXcmountfileString:xcmountFile
                                                                            error:&configurationError];
    
    if (!configuration) {
      printf("%s\n", configurationError.localizedDescription.UTF8String);
      return EXIT_FAILURE;
    }
    
    NSString *xcodeProjPath = [NSFileManager.defaultManager.currentDirectoryPath stringByAppendingFormat:@"/%@/project.pbxproj", configuration.projectName];
    
    NSError *plistReadError = nil;
    NSMutableDictionary *project = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfFile:xcodeProjPath]
                                                                             options:NSPropertyListMutableContainersAndLeaves
                                                                              format:NULL
                                                                               error:&plistReadError];
    
    if (!project) {
      NSLog(@"Could not open project: %@", plistReadError.localizedDescription);
      return EXIT_FAILURE;
    }
    
    NSMutableDictionary *objects = project.pbx_objects;
    
    [PASDecorator decorateObjects:objects];
    
    __block NSError *error = nil;
    
    [configuration enumerateActionsUsingBlock:^(NSString *diskPath, NSString *mountPath, NSArray *targetNames) {
      NSMutableDictionary *mountGroup = [PASObjectFinder.new findOrCreateMountingGroupWithDiskPath:diskPath mountPath:mountPath objects:objects];
      
      NSArray *targets = [PASObjectFinder.new targetObjectsInObjects:objects];
      
      [PASDismounter.new dismountGroup:mountGroup forTargets:targets objects:objects];
      
      NSError *treeBuildError = nil;
      BOOL result = [PASTreeBuilder.new buildTreeWithDiskPath:diskPath
                                                   mountGroup:mountGroup
                                                      objects:objects
                                                        error:&treeBuildError];
      
      if (!result) {
        error = treeBuildError;
        return;
      }
      
      NSArray *activeTargets = [targets pas_select:^(NSMutableDictionary *target, __unused NSUInteger _, __unused BOOL *__) {
        return [targetNames containsObject:target.pbx_name];
      }];
      
      [PASMounter.new addGroup:mountGroup toTargets:activeTargets objects:objects];
    }];
    
    [PASDecorator cleanObjects:objects];
    [PASTreeSorter sortTree:[PASObjectFinder.new mainGroupInObjects:objects] inObjects:objects];
    
    if (error) {
      printf("%s\n", error.localizedDescription.UTF8String);
      return EXIT_FAILURE;
    } else {
      [project writeToFile:xcodeProjPath atomically:YES];
    }
  }
  return EXIT_SUCCESS;
}
