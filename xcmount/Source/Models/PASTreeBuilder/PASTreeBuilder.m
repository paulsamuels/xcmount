//
//  PASTreeBuilder.m
//  xcmount
//
//  Created by Paul Samuels on 18/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

#import "PASTreeBuilder.h"

// Categories
#import "NSMutableDictionary+PBXAccessors.h"

// Models
#import "PASObjectFactory.h"
#import "PASUUIDGenerator.h"

@implementation PASTreeBuilder

- (BOOL)buildTreeWithDiskPath:(NSString *)diskPath
                   mountGroup:(NSMutableDictionary *)mountGroup
                      objects:(NSMutableDictionary *)objects
                        error:(NSError * __autoreleasing*)error;
{
  __block NSError *capturedError = nil;
  
  NSDirectoryEnumerator *enumerator = ({
    [self.fileManager enumeratorAtURL:[NSURL fileURLWithPath:[NSFileManager.defaultManager.currentDirectoryPath stringByAppendingPathComponent:diskPath]]
           includingPropertiesForKeys:@[ NSURLNameKey, NSURLIsDirectoryKey ]
                              options:NSDirectoryEnumerationSkipsHiddenFiles
                         errorHandler:^BOOL(__unused NSURL *_, NSError *error)
     {
       if (error) {
         capturedError = error;
         return NO;
       }
       
       return YES;
     }];
  });
  
  NSMutableArray *groupStack = NSMutableArray.array;
  
  NSMutableDictionary *(^currentGroup)(void) = ^{
    return groupStack.lastObject ?: mountGroup;
  };
  
  for (NSURL *fileURL in enumerator) {
    NSString *filename;
    [fileURL getResourceValue:&filename forKey:NSURLNameKey error:nil];
    
    NSNumber *isDirectory;
    [fileURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
    
    if (isDirectory.boolValue) {
      NSInteger delta = groupStack.count - enumerator.level;
      
      if (delta > 0) {
        for (int i = 0; i < delta; i++) {
          [groupStack removeLastObject];
        }
      }
      
      if (groupStack.count == enumerator.level && ![filename isEqualToString:currentGroup().pbx_name]) {
        [groupStack removeLastObject];
      }
      
      NSMutableDictionary *group = [PASObjectFactory groupWithName:filename
                                                              path:filename
                                                         inObjects:objects];
      
      [currentGroup().pbx_children addObject:group.pas_UUID];
      [groupStack addObject:group];
      
    } else {
      
      NSInteger delta = groupStack.count - (enumerator.level - 1);
      
      if (delta > 0) {
        for (int i = 0; i < delta; i++) {
          [groupStack removeLastObject];
        }
      }
      
      [currentGroup().pbx_children addObject:({
        [PASObjectFactory fileReferenceWithFilename:filename inObjects:objects].pas_UUID;
      })];
    }
    
  }
  
  if (error && capturedError) {
    *error = capturedError;
  }
  
  return !capturedError;
}

- (NSFileManager *)fileManager;
{
  return _fileManager ?: ({
    _fileManager = NSFileManager.defaultManager;
  });
}

@end
