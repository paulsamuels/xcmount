//
//  PASConstants.m
//  xcmount
//
//  Created by Paul Samuels on 18/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

#import "PASConstants.h"

NSString * const PASErrorDomain = @"com.paul-samuels.xcmount";

const struct PBXObjectClass PBXObjectClass = {
  .buildFile           = @"PBXBuildFile",
  .fileReference       = @"PBXFileReference",
  .group               = @"PBXGroup",
  .nativeTarget        = @"PBXNativeTarget",
  .project             = @"PBXProject",
  .resourcesBuildPhase = @"PBXResourcesBuildPhase",
  .sourcesBuildPhase   = @"PBXSourcesBuildPhase",
};

const struct PBXObjectAccessors PBXObjectAccessors = {
  .children = @"children",
  .isa      = @"isa",
  .name     = @"name",
  .path     = @"path",
  .uuid     = @"pas_UUID",
};

const struct PBXBuildFileAccessors PBXBuildFileAccessors = {
  .fileReference = @"fileRef",
};

const struct PBXBuildPhaseAccessors PBXBuildPhaseAccessors = {
  .files = @"files",
};

const struct PBXProjectAccessors PBXProjectAccessors = {
  .mainGroup = @"mainGroup",
};

const struct PBXTargetAccessors PBXTargetAccessors = {
  .buildPhases = @"buildPhases",
};

const struct PBXWrapperAccessors PBXWrapperAccessors = {
  .objects = @"objects",
};
