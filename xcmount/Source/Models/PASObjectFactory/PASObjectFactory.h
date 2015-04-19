//
//  PASObjectFactory.h
//  xcmount
//
//  Created by Paul Samuels on 18/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

@import Foundation;

@interface PASObjectFactory : NSObject

+ (NSMutableDictionary *)buildFileWithFileReferenceUUID:(NSString *)fileReferenceUUID
                                              inObjects:(NSMutableDictionary *)objects;

+ (NSMutableDictionary *)fileReferenceWithFilename:(NSString *)filename
                                         inObjects:(NSMutableDictionary *)objects;

+ (NSMutableDictionary *)groupWithName:(NSString *)name
                                  path:(NSString *)path
                             inObjects:(NSMutableDictionary *)objects;

@end
