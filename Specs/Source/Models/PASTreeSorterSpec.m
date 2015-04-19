#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "PASTreeSorter.h"

// Constants
#import "PASConstants.h"

SpecBegin(PASTreeSorter)

describe(@"PASTreeSorter", ^{
  
  __block NSMutableDictionary *objects = nil;
  
  beforeEach(^{
    objects = ({
      @{
        @"childA" : @{
            PBXObjectAccessors.name : @"a",
            PBXObjectAccessors.isa : PBXObjectClass.fileReference
            }.mutableCopy,
        @"childB" : @{
            PBXObjectAccessors.name : @"b",
            PBXObjectAccessors.isa : PBXObjectClass.fileReference
            }.mutableCopy,
        @"childC" : @{
            PBXObjectAccessors.name : @"c",
            PBXObjectAccessors.isa : PBXObjectClass.fileReference
            }.mutableCopy,
        @"folderA" : @{
            PBXObjectAccessors.name : @"a",
            PBXObjectAccessors.isa : PBXObjectClass.group
            }.mutableCopy,
        @"folderB" : @{
            PBXObjectAccessors.name : @"b",
            PBXObjectAccessors.isa : PBXObjectClass.group,
            PBXObjectAccessors.children : @[
                @"childB",
                @"childA",
                @"folderA"
                ].mutableCopy,
            }.mutableCopy,
        @"folderC" : @{
            PBXObjectAccessors.path : @"c",
            PBXObjectAccessors.isa : PBXObjectClass.group
            }.mutableCopy,
        }.mutableCopy;
    });
  });
  
  it(@"sorts child objects by name", ^{
    
    NSMutableDictionary *input = ({
      @{
        PBXObjectAccessors.children : @[
            @"childB",
            @"childA",
            @"childC",
            ].mutableCopy
        }.mutableCopy;
    });
    
    [PASTreeSorter sortTree:input inObjects:objects];
    
    expect(input).to.equal(@{
                             PBXObjectAccessors.children : @[
                                 @"childA",
                                 @"childB",
                                 @"childC",
                                 ]
                             });
  });
  
  it(@"sorts folders above files", ^{
    
    NSMutableDictionary *input = ({
      @{
        PBXObjectAccessors.children : @[
            @"childA",
            @"folderA",
            ].mutableCopy
        }.mutableCopy;
    });
    
    [PASTreeSorter sortTree:input inObjects:objects];
    
    expect(input).to.equal(@{
                             PBXObjectAccessors.children : @[
                                 @"folderA",
                                 @"childA",
                                 ]
                             });
  });
  
  it(@"sorts recursively", ^{
    
    NSMutableDictionary *input = ({
      @{
        PBXObjectAccessors.children : @[
            @"folderB",
            @"childA",
            @"folderA",
            ].mutableCopy
        }.mutableCopy;
    });
    
    [PASTreeSorter sortTree:input inObjects:objects];
    
    expect(input).to.equal(@{
                             PBXObjectAccessors.children : @[
                                 @"folderA",
                                 @"folderB",
                                 @"childA",
                                 ]
                             });
    
    expect(objects[@"folderB"]).to.equal(@{
                                           PBXObjectAccessors.name : @"b",
                                           PBXObjectAccessors.isa : PBXObjectClass.group,
                                           PBXObjectAccessors.children : @[
                                               @"folderA",
                                               @"childA",
                                               @"childB",                                               
                                               ]
                                           });
  });
  
  it(@"uses 'path' if there is no name", ^{
    NSMutableDictionary *input = ({
      @{
        PBXObjectAccessors.children : @[
            @"folderC",
            @"folderA",
            @"childA",
            ].mutableCopy
        }.mutableCopy;
    });
    
    [PASTreeSorter sortTree:input inObjects:objects];
    
    expect(input).to.equal(@{
                             PBXObjectAccessors.children : @[
                                 @"folderA",
                                 @"folderC",
                                 @"childA",
                                 ]
                             });
  });
  
});

SpecEnd
