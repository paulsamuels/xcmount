//
//  NSMutableDictionary+PBXAccessors.h
//  xcmount
//
//  Created by Paul Samuels on 17/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

@import Foundation;

@interface NSMutableDictionary (PBXObjectAccessors)

@property (nonatomic, strong, setter=pbx_setChildren:) NSMutableArray *pbx_children;
@property (nonatomic, copy, setter=pbx_setIsa:)        NSString       *pbx_isa;
@property (nonatomic, copy, setter=pbx_setPath:)       NSString       *pbx_path;
@property (nonatomic, copy, setter=pbx_setName:)       NSString       *pbx_name;
@property (nonatomic, copy, setter=pas_setUUID:)       NSString       *pas_UUID;

@end

@interface NSMutableDictionary (PBXBuildFileAccessors)

@property (nonatomic, copy, setter=pbx_setFileReference:) NSString *pbx_fileReference;

@end

@interface NSMutableDictionary (PBXBuildPhaseAccessors)

@property (nonatomic, strong, setter=pbx_setFiles:) NSMutableArray *pbx_files;

@end

@interface NSMutableDictionary (PBXAccessors)

- (NSArray *)pas_childObjectsInObjects:(NSDictionary *)objects;
- (NSArray *)pas_recursiveChildUUIDsInObjects:(NSDictionary *)objects;
- (NSArray *)pas_recursiveChildObjectsInObjects:(NSDictionary *)objects;

- (void)pas_removeUUID;

@end

@interface NSMutableDictionary (PBXProjectAccessors)

@property (nonatomic, copy, setter=pbx_setMainGroup:) NSString *pbx_mainGroup;

@end

@interface NSMutableDictionary (PBXTargetAccessors)

@property (nonatomic, strong, setter=pbx_setBuildPhases:) NSMutableArray *pbx_buildPhases;

@end

@interface NSMutableDictionary (PBXWrapperAccessors)

@property (nonatomic, strong, setter=pbx_setObjects:) NSMutableDictionary *pbx_objects;

@end
