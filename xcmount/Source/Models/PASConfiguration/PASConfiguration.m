//
//  PASConfiguration.m
//  xcmount
//
//  Created by Paul Samuels on 18/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

#import "PASConfiguration.h"

// Constants
#import "PASConstants.h"
#import "PASXcmountfileParser.h"

// Models
#import "PASRubyErrorFormatter.h"

const struct PASConfigurationKeys PASConfigurationKeys = {
  .actions          = @"actions",
  .dirPath          = @"dir_path",
  .mountPath        = @"mount_path",
  .targets          = @"targets",
  .xcodeProjectName = @"xcodeproj",
};

@interface PASConfiguration ()

@property (nonatomic, strong) NSArray *actions;

@end

@implementation PASConfiguration

+ (instancetype)loadFromXcmountfileString:(NSString *)xcmountfile error:(NSError *__autoreleasing*)error;
{
  if (!xcmountfile) {
    if (error) {
      *error = ({
        [NSError errorWithDomain:PASErrorDomain
                            code:PASConfigurationErrorNoXcmountFile
                        userInfo:@{
                                   NSLocalizedDescriptionKey : @"\"xcmountfile\" could not be located in the current directory",
                                   }];
      });
    }
    
    return nil;
  }

  NSData *JSONData = [self executeXcmountfile:xcmountfile error:error];
  
  if (!JSONData) {
    return nil;
  }
  
  NSDictionary *configuration = [self parseJSONData:JSONData error:error];
  
  if (!configuration) {
    return nil;
  }
  
  PASConfiguration *instance = self.new; {
    instance->_projectName = [configuration[PASConfigurationKeys.xcodeProjectName] copy];
    instance->_actions     = configuration[PASConfigurationKeys.actions];
  }
  return instance;
}

- (void)enumerateActionsUsingBlock:(void (^)(NSString *dirPath, NSString *mountPath, NSArray *targetNames))block;
{
  [self.actions enumerateObjectsUsingBlock:^(NSDictionary *action, __unused NSUInteger _, __unused BOOL *__) {
    block(action[PASConfigurationKeys.dirPath],
          action[PASConfigurationKeys.mountPath],
          action[PASConfigurationKeys.targets]);
  }];
}

+ (NSData *)executeXcmountfile:(NSString *)xcmountfile error:(NSError *__autoreleasing*)error;
{
  NSTask *readConfig = NSTask.new;
  readConfig.launchPath = @"/usr/bin/ruby";
  
  NSString *rubyParserProgram = [NSString stringWithFormat:@"%@\n%@\nputs @xcmount_configuration.to_json",
                                 PASXcmountfileParser(),
                                 xcmountfile];
  
  readConfig.arguments  = @[ @"-e", rubyParserProgram ];
  
  NSPipe *standardOut = NSPipe.pipe;
  readConfig.standardOutput = standardOut;
  
  NSPipe *standardError = NSPipe.pipe;
  readConfig.standardError = standardError;
  
  [readConfig launch];
  [readConfig waitUntilExit];
  
  NSData *standardErrorData = [standardError.fileHandleForReading readDataToEndOfFile];
  
  if (standardErrorData.length > 0) {
    if (error) {
      
      NSString *standardErrorString = [[NSString alloc] initWithData:standardErrorData encoding:NSUTF8StringEncoding];
      NSString *errorString = [PASRubyErrorFormatter.new formatString:standardErrorString
                                                      withXcmountfile:xcmountfile
                                                         parserString:PASXcmountfileParser()];
      
      *error = [NSError errorWithDomain:PASErrorDomain
                                   code:PASConfigurationErrorRubyExecutionFailed
                               userInfo:@{
                                          NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Failed to execute ruby \"xcmountfile\".\n\n %@", errorString],
                                          }];
    }
    return nil;
  }
  
  return [standardOut.fileHandleForReading readDataToEndOfFile];
}

+ (NSDictionary *)parseJSONData:(NSData *)JSONData error:(NSError *__autoreleasing*)error;
{
  NSError *JSONParseError = nil;
  NSDictionary *configuration = [NSJSONSerialization JSONObjectWithData:JSONData
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&JSONParseError];
  
  if (!configuration) {
    if (error) {
      *error = [NSError errorWithDomain:PASErrorDomain
                                   code:PASConfigurationErrorJSONParseFailed
                               userInfo:@{
                                          NSLocalizedDescriptionKey : [NSString stringWithFormat:@"Failed to parse JSON - this is probably an error in the configuration file: underlying error = %@", JSONParseError.localizedDescription],
                                          }];
    }
    return nil;
  }
  
  return configuration;
}

@end
