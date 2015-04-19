//
//  PASUUIDGenerator.h
//  xcmount
//
//  Created by Paul Samuels on 18/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

@import Foundation;

static inline NSString *PASGenerateUUID(void) {
  return [[[NSProcessInfo.processInfo globallyUniqueString] stringByReplacingOccurrencesOfString:@"-" withString:@""] substringToIndex:24];
}
