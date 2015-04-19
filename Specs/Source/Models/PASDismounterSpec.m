#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "PASDismounter.h"

// Categories
#import "NSMutableDictionary+PBXAccessors.h"

// Helpers
#import "PASSampleProjectLoader.h"

// Models
#import "PASDecorator.h"

SpecBegin(PASDismounter)

describe(@"PASDismounter", ^{
  
  __block NSMutableDictionary *project = nil;
  
  beforeEach(^{
    project = PASSampleProjectFromClass(self.class);
  });
  
  describe(@"+ dismountGroup:forTargets:objects:", ^{
    
    it(@"removes files and folders below the passed group", ^{
      
      NSMutableDictionary *objects = project.pbx_objects;
      
      NSMutableDictionary *sourceGroup = objects[@"DA3A386E1AE2E52900C29D16"];
      NSMutableDictionary *target      = objects[@"DA3A35551AE2DF3100C29D16"];
      NSMutableDictionary *buildPhase  = objects[@"DA3A35521AE2DF3100C29D16"];
      
      expect([objects valueForKey:@"DA3A386F1AE2E52900C29D16"]).toNot.beNil(); // AppDelegate.h
      expect([objects valueForKey:@"DA3A38701AE2E52900C29D16"]).toNot.beNil(); // AppDelegate.m
      expect([objects valueForKey:@"DA3A38711AE2E52900C29D16"]).toNot.beNil(); // ViewControllers
      expect([objects valueForKey:@"DA3A38721AE2E52900C29D16"]).toNot.beNil(); // ViewControllers/ViewController.h
      expect([objects valueForKey:@"DA3A38731AE2E52900C29D16"]).toNot.beNil(); // ViewControllers/ViewController.m
      expect([objects valueForKey:@"DA3A38751AE2E52900C29D16"]).toNot.beNil(); // ViewController.m buildFile
      expect([objects valueForKey:@"DA3A38741AE2E52900C29D16"]).toNot.beNil(); // AppDelegate.m buildFile
      
      expect(buildPhase.pbx_files).to.contain(@"DA3A38751AE2E52900C29D16"); // ViewController.m buildFile
      expect(buildPhase.pbx_files).to.contain(@"DA3A38741AE2E52900C29D16"); // AppDelegate.m buildFile
      
      [PASDismounter.new dismountGroup:sourceGroup
                            forTargets:@[ target ]
                               objects:project.pbx_objects];
      
      expect([objects valueForKey:@"DA3A386F1AE2E52900C29D16"]).to.beNil(); // AppDelegate.h
      expect([objects valueForKey:@"DA3A38701AE2E52900C29D16"]).to.beNil(); // AppDelegate.m
      expect([objects valueForKey:@"DA3A38711AE2E52900C29D16"]).to.beNil(); // ViewControllers
      expect([objects valueForKey:@"DA3A38721AE2E52900C29D16"]).to.beNil(); // ViewControllers/ViewController.h
      expect([objects valueForKey:@"DA3A38731AE2E52900C29D16"]).to.beNil(); // ViewControllers/ViewController.m
      expect([objects valueForKey:@"DA3A38751AE2E52900C29D16"]).to.beNil(); // ViewController.m buildFile
      expect([objects valueForKey:@"DA3A38741AE2E52900C29D16"]).to.beNil(); // AppDelegate.m buildFile
      
      expect(buildPhase.pbx_files).toNot.contain(@"DA3A38751AE2E52900C29D16"); // ViewController.m buildFile
      expect(buildPhase.pbx_files).toNot.contain(@"DA3A38741AE2E52900C29D16"); // AppDelegate.m buildFile
      
      expect(sourceGroup.pbx_children).to.equal(@[ ]);
      
    });
    
  });
  
});

SpecEnd
