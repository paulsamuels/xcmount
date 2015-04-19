#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "PASMounter.h"

// Categories
#import "NSArray+PASEnumeration.h"
#import "NSMutableDictionary+PBXAccessors.h"

// Helpers
#import "PASSampleProjectLoader.h"

// Models
#import "PASDecorator.h"

SpecBegin(PASMounter)

describe(@"PASMounter", ^{
  
  __block NSMutableDictionary *project = nil;
  
  beforeEach(^{
    project = PASSampleProjectFromClass(self.class);
  });
  
  describe(@"+ addGroup:toTargets:objects:", ^{
    
    it(@"adds buildFiles to source and resources buildPhases for the passed targets", ^{
      NSMutableDictionary *objects = project.pbx_objects;
      
      NSMutableDictionary *sourceGroup        = objects[@"DA3A44371AE32F7F00C29D16"];
      NSMutableDictionary *target             = objects[@"DA3A35551AE2DF3100C29D16"];
      NSMutableDictionary *sourceBuildPhase   = objects[@"DA3A35521AE2DF3100C29D16"];
      NSMutableDictionary *resourceBuildPhase = objects[@"DA3A35541AE2DF3100C29D16"];

      NSArray *knownFileReferences = [sourceBuildPhase.pbx_files pas_map:^(NSString *UUID) {
        return [objects[UUID] pbx_fileReference];
      }];
      
      NSArray *knownResourceReferences = [resourceBuildPhase.pbx_files pas_map:^(NSString *UUID) {
        return [objects[UUID] pbx_fileReference];
      }];
      
      expect(knownFileReferences).toNot.contain(@"DA3A443A1AE32F7F00C29D16");     // SomeSource.m
      expect(knownFileReferences).toNot.contain(@"DA3A443B1AE32F7F00C29D16");     // SomeSwift.m
      expect(knownResourceReferences).toNot.contain(@"DA3A443C1AE32F7F00C29D16"); // SomeXib.xib
      expect(knownResourceReferences).toNot.contain(@"DA3A44381AE32F7F00C29D16"); // SomeImage.png
            
      [PASMounter.new addGroup:sourceGroup toTargets:@[ target ] objects:objects];
      
      knownFileReferences = [sourceBuildPhase.pbx_files pas_map:^(NSString *UUID) {
        return [objects[UUID] pbx_fileReference];
      }];
      
      knownResourceReferences = [resourceBuildPhase.pbx_files pas_map:^(NSString *UUID) {
        return [objects[UUID] pbx_fileReference];
      }];
      
      expect(knownFileReferences).to.contain(@"DA3A443A1AE32F7F00C29D16");     // SomeSource.m
      expect(knownFileReferences).to.contain(@"DA3A443B1AE32F7F00C29D16");     // SomeSwift.m
      expect(knownResourceReferences).to.contain(@"DA3A443C1AE32F7F00C29D16"); // SomeXib.xib
      expect(knownResourceReferences).to.contain(@"DA3A44381AE32F7F00C29D16"); // SomeImage.png
      
      NSArray *objectsFileReference = [objects.allValues pas_map:^(NSMutableDictionary *object) {
        return object.pbx_fileReference ?: @"";
      }];
      
      expect(objectsFileReference).to.contain(@"DA3A443A1AE32F7F00C29D16"); // SomeSource.m
      expect(objectsFileReference).to.contain(@"DA3A443B1AE32F7F00C29D16"); // SomeSwift.m
      expect(objectsFileReference).to.contain(@"DA3A443C1AE32F7F00C29D16"); // SomeXib.xib
      expect(objectsFileReference).to.contain(@"DA3A44381AE32F7F00C29D16"); // SomeImage.png
    });
    
  });
  
});

SpecEnd
