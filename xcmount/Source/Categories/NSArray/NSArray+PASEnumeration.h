//
//  NSArray+PASEnumeration.h
//  xcmount
//
//  Created by Paul Samuels on 17/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

@import Foundation;

@interface NSArray (PASEnumeration)

- (id)pas_reduceWithInitial:(id)initial combine:(id (^)(id memo, id object))combine;
- (id)pas_find:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))block;
- (NSArray *)pas_flatMap:(id (^)(id object))block;
- (NSArray *)pas_map:(id (^)(id object))block;
- (NSArray *)pas_select:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))block;

@end
