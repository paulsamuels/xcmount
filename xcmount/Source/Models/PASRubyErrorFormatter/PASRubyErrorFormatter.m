//
//  PASRubyErrorFormatter.m
//  xcmount
//
//  Created by Paul Samuels on 19/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

#import "PASRubyErrorFormatter.h"

// Categories
#import "NSArray+PASEnumeration.h"

@implementation PASRubyErrorFormatter

- (NSString *)formatString:(NSString *)errorString
           withXcmountfile:(NSString *)xcmountfile
              parserString:(NSString *)parserString;
{
  NSRegularExpression *regularExpression = ({
    [NSRegularExpression regularExpressionWithPattern:@"^-e:(\\d+):\\w* (.*)"
                                              options:NSRegularExpressionCaseInsensitive
                                                error:NULL];
  });

  NSTextCheckingResult *result = ({
    [regularExpression firstMatchInString:errorString
                                  options:NSMatchingAnchored
                                    range:NSMakeRange(0, errorString.length)];
  });

  NSInteger  errorLine    = [[errorString substringWithRange:[result rangeAtIndex:1]] integerValue];
  NSString  *errorMessage = [errorString substringWithRange:[result rangeAtIndex:2]];

  if (errorLine > 0 && errorMessage.length > 0) {
    NSInteger adjustedOffset = errorLine - [[parserString componentsSeparatedByString:@"\n"] count];
    
    __block NSInteger index = 0;
    
    NSString *augmentedXcmountfile = [[[xcmountfile componentsSeparatedByString:@"\n"] pas_map:^(NSString *line) {
      index += 1;
      
      NSString *prefix = index == adjustedOffset ? @"-> " : @"   ";
      return [prefix stringByAppendingString:line];
    }] componentsJoinedByString:@"\n"];
    
    errorString = [errorMessage stringByAppendingFormat:@"\n\n%@", augmentedXcmountfile];
  }
  
  return errorString;
}

@end
