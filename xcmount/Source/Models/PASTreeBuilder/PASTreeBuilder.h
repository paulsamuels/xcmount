//
//  PASTreeBuilder.h
//  xcmount
//
//  Created by Paul Samuels on 18/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

@import Foundation;

@interface PASTreeBuilder : NSObject

@property (nonatomic, strong) NSFileManager *fileManager;

- (BOOL)buildTreeWithDiskPath:(NSString *)diskPath
                   mountGroup:(NSMutableDictionary *)mountGroup
                      objects:(NSMutableDictionary *)objects
                        error:(NSError * __autoreleasing*)error;

@end
