#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "PASConstants.h"

SpecBegin(PASConstants)

describe(@"PASConstants", ^{
  
  specify(@"PASErrorDomain", ^{
    expect(PASErrorDomain).to.equal(@"com.paul-samuels.xcmount");
  });
  
  specify(@"PBXObjectClass", ^{
    
    expect(PBXObjectClass.buildFile).to.equal(@"PBXBuildFile");
    expect(PBXObjectClass.fileReference).to.equal(@"PBXFileReference");
    expect(PBXObjectClass.group).to.equal(@"PBXGroup");
    expect(PBXObjectClass.nativeTarget).to.equal(@"PBXNativeTarget");
    expect(PBXObjectClass.project).to.equal(@"PBXProject");
    expect(PBXObjectClass.resourcesBuildPhase).to.equal(@"PBXResourcesBuildPhase");
    expect(PBXObjectClass.sourcesBuildPhase).to.equal(@"PBXSourcesBuildPhase");
    
  });
  
  specify(@"PBXObjectAccessors", ^{
    
    expect(PBXObjectAccessors.children).to.equal(@"children");
    expect(PBXObjectAccessors.isa).to.equal(@"isa");
    expect(PBXObjectAccessors.name).to.equal(@"name");
    expect(PBXObjectAccessors.path).to.equal(@"path");
    expect(PBXObjectAccessors.uuid).to.equal(@"pas_UUID");
    
  });
  
  specify(@"PBXBuildFileAccessors", ^{
    expect(PBXBuildFileAccessors.fileReference).to.equal(@"fileRef");
  });
  
  specify(@"PBXBuildPhaseAccessors", ^{
    expect(PBXBuildPhaseAccessors.files).to.equal(@"files");
  });
  
  specify(@"PBXProjectAccessors", ^{
    expect(PBXProjectAccessors.mainGroup).to.equal(@"mainGroup");
  });
  
  specify(@"PBXTargetAccessors", ^{
    expect(PBXTargetAccessors.buildPhases).to.equal(@"buildPhases");
  });
  
  specify(@"PBXWrapperAccessors", ^{
    expect(PBXWrapperAccessors.objects).to.equal(@"objects");
  });
  
});

SpecEnd
