//
//  PASRubyErrorFormatter.h
//  xcmount
//
//  Created by Paul Samuels on 19/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

@import Foundation;

@interface PASRubyErrorFormatter : NSObject

- (NSString *)formatString:(NSString *)errorString
           withXcmountfile:(NSString *)xcmountfile
              parserString:(NSString *)parserString;

@end
