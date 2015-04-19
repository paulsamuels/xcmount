//
//  NSMutableArray+PASEnumeration.h
//  xcmount
//
//  Created by Paul Samuels on 18/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

@import Foundation;

@interface NSMutableArray (PASEnumeration)

- (void)pas_deleteIf:(BOOL(^)(id object, NSUInteger idx, BOOL *stop))block;

@end
