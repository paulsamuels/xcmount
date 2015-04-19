#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "PASConfiguration.h"

// Constants
#import "PASConstants.h"

@interface PASConfiguration (PASSpecHelper)

@property (nonatomic, strong) NSArray *actions;

@end

SpecBegin(PASConfiguration)

describe(@"PASConfiguration", ^{
  
  describe(@"+ loadFromXcmountfileString:error:", ^{
    
    context(@"errors", ^{
      
      it(@"errors if no string is passed", ^{
        NSError *error = nil;
        
        id result = [PASConfiguration loadFromXcmountfileString:nil error:&error];
        
        expect(result).to.beNil();
        expect(error.code).to.equal(PASConfigurationErrorNoXcmountFile);
        expect(error.domain).to.equal(PASErrorDomain);
      });
      
      it(@"errors if the Ruby fails", ^{
        NSError *error = nil;
        
        id result = [PASConfiguration loadFromXcmountfileString:@"unknown_method_call"
                                                          error:&error];
        
        expect(result).to.beNil();
        expect(error.code).to.equal(PASConfigurationErrorRubyExecutionFailed);
        expect(error.domain).to.equal(PASErrorDomain);
      });
      
      it(@"errors if the JSON parsing fails", ^{
        NSError *error = nil;
        
        /*
         * Override the to_json method on the Hash that is being built with
         * configuration options to return some junk data
         */
        id result = [PASConfiguration loadFromXcmountfileString:@"def @xcmount_configuration.to_json; \'{\';end"
                                                          error:&error];
        
        expect(result).to.beNil();
        expect(error.code).to.equal(PASConfigurationErrorJSONParseFailed);
        expect(error.domain).to.equal(PASErrorDomain);
      });
      
    });
    
    it(@"parses out the xcodeproj name", ^{
      PASConfiguration *result = ({
        [PASConfiguration loadFromXcmountfileString:@"xcodeproj 'Paul.xcodeproj'"
                                              error:NULL];
      });
      
      expect(result.projectName).to.equal(@"Paul.xcodeproj");
    });
    
    context(@"for a single target", ^{
      
      it(@"parses out an action", ^{
        
        PASConfiguration *result = ({
          [PASConfiguration loadFromXcmountfileString:@"target('Paul') { mount 'A', 'B' }"
                                                error:NULL];
        });
        
        expect(result.actions.count).to.equal(1);
        expect(result.actions.firstObject[PASConfigurationKeys.targets]).to.equal(@[ @"Paul" ]);
        expect(result.actions.firstObject[PASConfigurationKeys.dirPath]).to.equal(@"A");
        expect(result.actions.firstObject[PASConfigurationKeys.mountPath]).to.equal(@"B");
        
      });
      
      it(@"parses out an action with no explicit mount_path", ^{
        
        PASConfiguration *result = ({
          [PASConfiguration loadFromXcmountfileString:@"target('Paul') { mount 'A' }"
                                                error:NULL];
        });
        
        expect(result.actions.count).to.equal(1);
        expect(result.actions.firstObject[PASConfigurationKeys.targets]).to.equal(@[ @"Paul" ]);
        expect(result.actions.firstObject[PASConfigurationKeys.dirPath]).to.equal(@"A");
        expect(result.actions.firstObject[PASConfigurationKeys.mountPath]).to.equal(@"A");
        
      });
      
      it(@"parses out multiple actions", ^{
        
        PASConfiguration *result = ({
          [PASConfiguration loadFromXcmountfileString:@"target('Paul') { mount 'A', 'B'; mount 'C', 'D'; }"
                                                error:NULL];
        });
        
        expect(result.actions.count).to.equal(2);
        expect(result.actions.firstObject[PASConfigurationKeys.targets]).to.equal(@[ @"Paul" ]);
        expect(result.actions.firstObject[PASConfigurationKeys.dirPath]).to.equal(@"A");
        expect(result.actions.firstObject[PASConfigurationKeys.mountPath]).to.equal(@"B");
        expect(result.actions.lastObject[PASConfigurationKeys.dirPath]).to.equal(@"C");
        expect(result.actions.lastObject[PASConfigurationKeys.mountPath]).to.equal(@"D");
        
      });
      
    });
    
    context(@"for multiple targets", ^{
      
      it(@"parses out an action with more than one target", ^{
        
        PASConfiguration *result = ({
          [PASConfiguration loadFromXcmountfileString:@"target('Paul', 'Samuels') { mount 'A', 'B' }"
                                                error:NULL];
        });
        
        expect(result.actions.count).to.equal(1);
        expect(result.actions.firstObject[PASConfigurationKeys.targets]).to.equal(@[ @"Paul", @"Samuels" ]);
        expect(result.actions.firstObject[PASConfigurationKeys.dirPath]).to.equal(@"A");
        expect(result.actions.firstObject[PASConfigurationKeys.mountPath]).to.equal(@"B");
        
      });
      
    });
    
  });
  
  describe(@"- enumerateActionsUsingBlock:", ^{
    
    it(@"enumerates the actions", ^{
      PASConfiguration *result = ({
        [PASConfiguration loadFromXcmountfileString:@"target('Paul') { mount 'A', 'B'; mount 'C', 'D'; };"
         @"target('Samuels') { mount 'E', 'F' }"
                                              error:NULL];
      });
      
      NSArray *expected = ({
        @[
          @[ @"A", @"B", @[ @"Paul" ] ],
          @[ @"C", @"D", @[ @"Paul" ] ],
          @[ @"E", @"F", @[ @"Samuels" ] ],
          ];
      });
      
      __block NSInteger idx = 0;
      
      [result enumerateActionsUsingBlock:^(NSString *dirPath, NSString *mountPath, NSArray *targetNames) {
        
        expect(dirPath).to.equal(expected[idx][0]);
        expect(mountPath).to.equal(expected[idx][1]);
        expect(targetNames).to.equal(expected[idx][2]);
        
        idx += 1;
      }];
      
      expect(idx).to.equal(3);
    });
    
  });
  
});

SpecEnd
