//
//  NSMutableDictionary+PASEnumeration.h
//  xcmount
//
//  Created by Paul Samuels on 18/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

@import Foundation;

@interface NSMutableDictionary (PASEnumeration)

- (void)pas_deleteIf:(BOOL (^)(id<NSCopying> key, id object, BOOL *stop))block;

@end
