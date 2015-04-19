//
//  PASConfiguration.h
//  xcmount
//
//  Created by Paul Samuels on 18/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

@import Foundation;

extern const struct PASConfigurationKeys {
  __unsafe_unretained NSString *actions;
  __unsafe_unretained NSString *dirPath;
  __unsafe_unretained NSString *mountPath;
  __unsafe_unretained NSString *targets;
  __unsafe_unretained NSString *xcodeProjectName;
} PASConfigurationKeys;

typedef NS_ENUM(NSInteger, PASConfigurationError) {
  PASConfigurationErrorNoXcmountFile        = 100,
  PASConfigurationErrorJSONParseFailed,
  PASConfigurationErrorRubyExecutionFailed,
};

@interface PASConfiguration : NSObject

@property (nonatomic, copy, readonly) NSString *projectName;

+ (instancetype)loadFromXcmountfileString:(NSString *)xcmountfile error:(NSError *__autoreleasing*)error;

- (void)enumerateActionsUsingBlock:(void (^)(NSString *dirPath, NSString *mountPath, NSArray *targetNames))block;

@end
