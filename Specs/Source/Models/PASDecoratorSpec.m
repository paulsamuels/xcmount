#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "PASDecorator.h"

// Categories
#import "NSMutableDictionary+PBXAccessors.h"

SpecBegin(PASDecorator)

describe(@"PASDecorator", ^{
  
  /*
   * Objects are stored in a dictionary as { UUID : Object }
   */
  
  describe(@"+ decorateObjects:", ^{
    
    it(@"adds the UUID of each object to the object", ^{
      NSMutableDictionary *objects = ({
        @{
          @"A" : @{}.mutableCopy,
          @"B" : @{}.mutableCopy,
          }.mutableCopy;
      });
      
      [PASDecorator decorateObjects:objects];
      
      [objects enumerateKeysAndObjectsUsingBlock:^(NSString *UUID, NSMutableDictionary *object, BOOL *stop) {
        expect(object.pas_UUID).to.equal(UUID);
      }];
      
    });
    
  });

  describe(@"+ cleanObjects:", ^{
    
    it(@"removes the UUID of each object to the object", ^{
      NSMutableDictionary *objects = ({
        @{
          @"A" : @{}.mutableCopy,
          @"B" : @{}.mutableCopy,
          }.mutableCopy;
      });
      
      [PASDecorator decorateObjects:objects];
      [PASDecorator cleanObjects:objects];
      
      [objects enumerateKeysAndObjectsUsingBlock:^(NSString *UUID, NSMutableDictionary *object, BOOL *stop) {
        expect(object.pas_UUID).to.beNil();
      }];
      
    });
    
  });

});

SpecEnd
