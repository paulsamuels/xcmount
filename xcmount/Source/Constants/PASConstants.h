//
//  PASConstants.h
//  xcmount
//
//  Created by Paul Samuels on 18/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

@import Foundation;

extern NSString * const PASErrorDomain;

extern const struct PBXObjectClass {
  __unsafe_unretained NSString *buildFile;
  __unsafe_unretained NSString *fileReference;
  __unsafe_unretained NSString *group;
  __unsafe_unretained NSString *nativeTarget;
  __unsafe_unretained NSString *project;
  __unsafe_unretained NSString *resourcesBuildPhase;
  __unsafe_unretained NSString *sourcesBuildPhase;
} PBXObjectClass;

extern const struct PBXObjectAccessors {
  __unsafe_unretained NSString *children;
  __unsafe_unretained NSString *isa;
  __unsafe_unretained NSString *name;
  __unsafe_unretained NSString *path;
  __unsafe_unretained NSString *uuid;
} PBXObjectAccessors;

extern const struct PBXBuildFileAccessors {
  __unsafe_unretained NSString *fileReference;
} PBXBuildFileAccessors;

extern const struct PBXBuildPhaseAccessors {
  __unsafe_unretained NSString *files;
} PBXBuildPhaseAccessors;

extern const struct PBXProjectAccessors {
  __unsafe_unretained NSString *mainGroup;
} PBXProjectAccessors;

extern const struct PBXTargetAccessors {
  __unsafe_unretained NSString *buildPhases;
} PBXTargetAccessors;

extern const struct PBXWrapperAccessors {
  __unsafe_unretained NSString *objects;
} PBXWrapperAccessors;
