//
//  PASObjectFactory.m
//  xcmount
//
//  Created by Paul Samuels on 18/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

#import "PASObjectFactory.h"

// Categories
#import "NSMutableDictionary+PBXAccessors.h"

// Constants
#import "PASConstants.h"

// Models
#import "PASUUIDGenerator.h"

@implementation PASObjectFactory

+ (NSMutableDictionary *)buildFileWithFileReferenceUUID:(NSString *)fileReferenceUUID
                                              inObjects:(NSMutableDictionary *)objects;
{
  NSMutableDictionary *buildFile = NSMutableDictionary.dictionary; {
    buildFile.pbx_fileReference = fileReferenceUUID;
    buildFile.pbx_isa           = PBXObjectClass.buildFile;
    buildFile.pas_UUID          = PASGenerateUUID();
  }
  
  objects[buildFile.pas_UUID] = buildFile;
  
  return buildFile;
}

+ (NSMutableDictionary *)fileReferenceWithFilename:(NSString *)filename
                                         inObjects:(NSMutableDictionary *)objects;
{
  NSMutableDictionary *fileReference = ({
    @{
      @"sourceTree" : @"<group>",
      }.mutableCopy;
  });
  
  fileReference.pbx_path = filename;
  fileReference.pbx_isa  = PBXObjectClass.fileReference;
  fileReference.pas_UUID = PASGenerateUUID();
  
  objects[fileReference.pas_UUID] = fileReference;
  
  return fileReference;
}

+ (NSMutableDictionary *)groupWithName:(NSString *)name
                                  path:(NSString *)path
                             inObjects:(NSMutableDictionary *)objects;
{
  NSMutableDictionary *result = ({
    @{
      @"sourceTree" : @"<group>",
      }.mutableCopy;
  });
  
  result.pbx_name     = name;
  result.pbx_children = NSMutableArray.array;
  result.pbx_isa      = PBXObjectClass.group;
  result.pas_UUID     = PASGenerateUUID();
  
  if (path) {
    result.pbx_path = path;
  }
  
  objects[result.pas_UUID] = result;
  
  return result;
}

@end
