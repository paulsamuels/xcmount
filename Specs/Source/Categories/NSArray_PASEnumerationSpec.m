#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "NSArray+PASEnumeration.h"

SpecBegin(NSArray_PASEnumeration)

describe(@"NSArray+PASEnumeration", ^{
  
  describe(@"- pas_reduceWithInitial:combine:", ^{
    
    it(@"yields the accumulator and the current object", ^{
      
      __block NSInteger idx = 0;
      
      NSArray *runs = @[
                        @[ @0, @1 ], // run 1
                        @[ @1, @2 ], // run 2
                        @[ @3, @3 ], // run 3
                        ];
      
      [@[ @1, @2, @3 ] pas_reduceWithInitial:@0
                                     combine:^(NSNumber *memo, NSNumber *object) {
                                       expect(memo).to.equal([runs[idx] firstObject]);
                                       expect(object).to.equal([runs[idx] lastObject]);
                                       idx += 1;
                                       
                                       return @(memo.integerValue + object.integerValue);
                                     }];
      
    });
    
    it(@"reduces an array", ^{
      
      NSNumber *result = ({
        [@[ @1, @2, @3 ] pas_reduceWithInitial:@0
                                       combine:^(NSNumber *memo, NSNumber *object) {
                                         return @(memo.integerValue + object.integerValue);
                                       }];
      });
      
      expect(result).to.equal(6);
    });
    
  });
  
  describe(@"- pas_find:", ^{
    
    it(@"returns the first match only", ^{
      id needle = [NSValue valueWithPoint:NSMakePoint(0, 0)];
      id decoy  = [NSValue valueWithPoint:NSMakePoint(0, 0)];
      
      NSArray *haystack = @[ needle, decoy, ];
      
      NSValue *result = [haystack pas_find:^BOOL(NSValue *hay, NSUInteger idx, BOOL *stop) {
        return NSEqualPoints(NSMakePoint(0, 0), hay.pointValue);
      }];
      
      expect(result).to.beIdenticalTo(needle);
      expect(result).toNot.beIdenticalTo(decoy);
    });
    
    it(@"returns nil if no matches are found", ^{
      NSArray *haystack = @[ @0, @1, @2 ];
      
      NSValue *result = [haystack pas_find:^BOOL(NSValue *hay, NSUInteger idx, BOOL *stop) {
        return NO;
      }];
      
      expect(result).to.beNil();
    });
    
  });
  
  describe(@"- pas_flatMap:", ^{
    
    it(@"maps and flattens into a single level array", ^{
      
      NSArray *result =[@[ @1, @2, @3 ] pas_flatMap:^(NSNumber *object) {
        if (1 == object.integerValue) {
          return (id)@(object.integerValue + 10);
        } else {
          return (id)@[ @(object.integerValue + 10) ];
        }
      }];
      
      expect(result).to.equal(@[ @11, @12, @13 ]);
      
    });
    
  });
  
  describe(@"- pas_map:", ^{
    
    it(@"maps from one value to another using the transformation in the yielded to block", ^{
      
      NSArray *result = [@[ @1, @2, @3 ] pas_map:^(NSNumber *object) {
        return @(object.integerValue * 10);
      }];
      
      expect(result).to.equal(@[ @10, @20, @30 ]);
    });
    
  });
  
  describe(@"- pas_select:", ^{
    
    it(@"returns only the items passing the test", ^{
      
      NSArray *result = [@[ @5, @10, @15 ] pas_select:^BOOL(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        return obj.integerValue > 5;
      }];
      
      expect(result).to.equal(@[ @10, @15 ]);
      
    });
    
    it(@"returns an empty array if no items match", ^{
      
      NSArray *result = [@[ @5, @10, @15 ] pas_select:^BOOL(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        return NO;
      }];
      
      expect(result).to.equal(@[ ]);
      
    });
    
  });
  
});

SpecEnd
