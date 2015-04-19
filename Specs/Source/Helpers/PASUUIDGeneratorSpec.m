#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "PASUUIDGenerator.h"

SpecBegin(PASUUIDGenerator)

describe(@"PASUUIDGenerator", ^{
  
  /*
   * This is just going off of the size seen in existing projects
   */
  it(@"creates UUID's that are 24 chars long", ^{
    expect(PASGenerateUUID().length).to.equal(24);
  });
  
});

SpecEnd
