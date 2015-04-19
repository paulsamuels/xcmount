#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "NSMutableArray+PASEnumeration.h"

SpecBegin(NSMutableArray_PASEnumeration)

describe(@"NSMutableArray+PASEnumeration", ^{
  
  describe(@"- pas_deleteIf:", ^{
    
    __block NSMutableArray *testArray = nil;
    
    beforeEach(^{
      testArray = @[ @1, @2, @3 ].mutableCopy;
    });
    
    it(@"removes objects where the predicate returns YES", ^{
      
      [testArray pas_deleteIf:^BOOL(NSNumber *number, NSUInteger idx, BOOL *stop) {
        return number.integerValue > 2;
      }];
      
      expect(testArray).to.equal(@[ @1, @2, ]);
      
    });
    
    it(@"does not effect the array if the predicate never evaluates to YES", ^{

      [testArray pas_deleteIf:^BOOL(NSNumber *number, NSUInteger idx, BOOL *stop) {
        return NO;
      }];
      
      expect(testArray).to.equal(@[ @1, @2, @3, ]);
      
    });
    
  });
  
});

SpecEnd
