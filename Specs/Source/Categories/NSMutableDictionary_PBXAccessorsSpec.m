#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "NSMutableDictionary+PBXAccessors.h"

// Constants
#import "PASConstants.h"

SpecBegin(NSMutableDictionary_PBXAccessors)

describe(@"NSMutableDictionary+PBXAccessors", ^{
  
  describe(@"PBXObjectAccessors", ^{
    specify(@"- pbx_children", ^{
      NSMutableDictionary *object = @{ PBXObjectAccessors.children : @[ @1, @2 ] }.mutableCopy;
      
      expect(object.pbx_children).to.equal(@[ @1, @2 ]);
    });
    
    specify(@"- pbx_children", ^{
      NSMutableDictionary *object = NSMutableDictionary.dictionary;
      
      object.pbx_children = @[ @3, @4 ].mutableCopy;
      
      expect(object[PBXObjectAccessors.children]).to.equal(@[ @3, @4 ]);
    });
    
    specify(@"- pbx_isa", ^{
      NSMutableDictionary *object = @{ PBXObjectAccessors.isa : @"test" }.mutableCopy;
      
      expect(object.pbx_isa).to.equal(@"test");
    });
    
    specify(@"- pbx_setISA", ^{
      NSMutableDictionary *object = NSMutableDictionary.dictionary;
      
      object.pbx_isa = @"test";
      
      expect(object[PBXObjectAccessors.isa]).to.equal(@"test");
    });
    
    specify(@"- pbx_name", ^{
      NSMutableDictionary *object = @{ PBXObjectAccessors.name : @"test" }.mutableCopy;
      
      expect(object.pbx_name).to.equal(@"test");
    });
    
    specify(@"- pbx_setName", ^{
      NSMutableDictionary *object = NSMutableDictionary.dictionary;
      
      object.pbx_name = @"test";
      
      expect(object[PBXObjectAccessors.name]).to.equal(@"test");
    });
    
    specify(@"- pbx_path", ^{
      NSMutableDictionary *object = @{ PBXObjectAccessors.path : @"test" }.mutableCopy;
      
      expect(object.pbx_path).to.equal(@"test");
    });
    
    specify(@"- pbx_setPath", ^{
      NSMutableDictionary *object = NSMutableDictionary.dictionary;
      
      object.pbx_path = @"test";
      
      expect(object[PBXObjectAccessors.path]).to.equal(@"test");
    });
    
    specify(@"- pas_UUID", ^{
      NSMutableDictionary *object = @{ PBXObjectAccessors.uuid : @"test" }.mutableCopy;
      
      expect(object.pas_UUID).to.equal(@"test");
    });
    
    specify(@"- pas_setUUID", ^{
      NSMutableDictionary *object = NSMutableDictionary.dictionary;
      
      object.pas_UUID = @"test";
      
      expect(object[PBXObjectAccessors.uuid]).to.equal(@"test");
    });
  });
  
  describe(@"PBXBuildFileAccessors", ^{
    
    specify(@"- pbx_fileReference", ^{
      NSMutableDictionary *object = @{ PBXBuildFileAccessors.fileReference : @"test" }.mutableCopy;
      
      expect(object.pbx_fileReference).to.equal(@"test");
    });
    
    specify(@"- pbx_setFileReference:", ^{
      NSMutableDictionary *object = NSMutableDictionary.dictionary;
      
      object.pbx_fileReference = @"test";
      
      expect(object[PBXBuildFileAccessors.fileReference]).to.equal(@"test");
    });
    
  });
  
  describe(@"PBXBuildPhaseAccessors", ^{
    
    specify(@"- pbx_files", ^{
      NSMutableDictionary *object = @{ PBXBuildPhaseAccessors.files : @[ @"test" ].mutableCopy }.mutableCopy;
      
      expect(object.pbx_files).to.equal(@[ @"test" ]);
    });
    
    specify(@"- pbx_setFiles:", ^{
      NSMutableDictionary *object = NSMutableDictionary.dictionary;
      
      object.pbx_files = @[ @"test" ].mutableCopy;
      
      expect(object[PBXBuildPhaseAccessors.files]).to.equal(@[ @"test" ]);
    });
    
  });
  
  describe(@"PBXProjectAccessors", ^{
    
    specify(@"- pbx_mainGroup", ^{
      NSMutableDictionary *object =  @{ PBXProjectAccessors.mainGroup : @"test" }.mutableCopy;
      
      expect(object.pbx_mainGroup).to.equal(@"test");
    });
    
    specify(@"- pbx_setMainGroup:", ^{
      NSMutableDictionary *object = NSMutableDictionary.dictionary;
      
      object.pbx_mainGroup = @"test";
      
      expect(object[PBXProjectAccessors.mainGroup]).to.equal(@"test");
    });
    
  });
  
  describe(@"PBXTargetAccessors", ^{
    
    specify(@"- pbx_buildPhases", ^{
      NSMutableDictionary *object = @{ PBXTargetAccessors.buildPhases : @[ @"test" ].mutableCopy }.mutableCopy;
      
      expect(object.pbx_buildPhases).to.equal(@[ @"test" ]);
    });
    
    specify(@"- pbx_setBuildPhases:", ^{
      NSMutableDictionary *object = NSMutableDictionary.dictionary;
      
      object.pbx_buildPhases = @[ @"test" ].mutableCopy;
      
      expect(object[PBXTargetAccessors.buildPhases]).to.equal(@[ @"test" ]);
    });
    
  });
  
  describe(@"PBXWrapperAccessors", ^{
    
    specify(@"- pbx_objects", ^{
      NSMutableDictionary *object = @{ PBXWrapperAccessors.objects : @{ @"test" : @"test" }.mutableCopy }.mutableCopy;
      
      expect(object.pbx_objects).to.equal(@{ @"test" : @"test" });
    });
    
    specify(@"- pbx_setObjects:", ^{
      NSMutableDictionary *object = NSMutableDictionary.dictionary;
      
      object.pbx_objects = @{ @"test" : @"test" }.mutableCopy;
      
      expect(object[PBXWrapperAccessors.objects]).to.equal(@{ @"test" : @"test" });
    });
    
  });
  
});

SpecEnd
