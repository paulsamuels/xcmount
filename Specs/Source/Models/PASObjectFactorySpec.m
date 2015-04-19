#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "PASObjectFactory.h"

// Categories
#import "NSMutableDictionary+PBXAccessors.h"

// Constants
#import "PASConstants.h"

SpecBegin(PASObjectFactory)

describe(@"PASObjectFactory", ^{
  
  describe(@"+ buildFileWithFileReferenceUUID:inObjects", ^{
    
    it(@"creates a configured buildFile", ^{
      NSMutableDictionary *objects = NSMutableDictionary.dictionary;
      
      NSMutableDictionary *buildFile = [PASObjectFactory buildFileWithFileReferenceUUID:@"UUID" inObjects:objects];
      
      expect(buildFile.pbx_fileReference).to.equal(@"UUID");
      expect(buildFile.pbx_isa).to.equal(PBXObjectClass.buildFile);
      expect(buildFile.pas_UUID).toNot.beNil();
      
      expect(objects[buildFile.pas_UUID]).to.equal(buildFile);
    });
    
  });
  
  describe(@"+ fileReferenceWithFilename:inObjects:", ^{
    
    it(@"create a configured fileReference", ^{
      NSMutableDictionary *objects = NSMutableDictionary.dictionary;
      
      NSMutableDictionary *fileReference = [PASObjectFactory fileReferenceWithFilename:@"SomeFile" inObjects:objects];
      
      expect(fileReference.pbx_path).to.equal(@"SomeFile");
      expect(fileReference.pbx_isa).to.equal(PBXObjectClass.fileReference);
      expect(fileReference.pas_UUID).toNot.beNil();
      
      expect(objects[fileReference.pas_UUID]).to.equal(fileReference);
    });

  });
  
  describe(@"+ groupWithName:path:inObjects:", ^{
    
    it(@"creates a configured group", ^{
      NSMutableDictionary *objects = NSMutableDictionary.dictionary;
      
      NSMutableDictionary *group = [PASObjectFactory groupWithName:@"Test" path:@"some/path" inObjects:objects];
      
      expect(group.pbx_name).to.equal(@"Test");
      expect(group.pbx_path).to.equal(@"some/path");
      expect(group.pbx_isa).to.equal(PBXObjectClass.group);
      expect(group.pbx_children).to.equal(@[]);
      expect(group[@"sourceTree"]).to.equal(@"<group>");
      expect(group.pas_UUID).toNot.beNil();
      
      expect(objects[group.pas_UUID]).to.equal(group);
    });
    
  });
  
});

SpecEnd
