#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <Specta/Specta.h>

#import "PASTreeBuilder.h"

// Categories
#import "NSArray+PASEnumeration.h"
#import "NSMutableDictionary+PBXAccessors.h"

// Constants
#import "PASConstants.h"

// Helers
#import "PASSampleProjectLoader.h"

SpecBegin(PASTreeBuilder)

describe(@"PASTreeBuilder", ^{
  
  __block NSString *defaultDirectory = nil;
  
  beforeEach(^{
    
    [NSFileManager.defaultManager changeCurrentDirectoryPath:({
      [[NSBundle bundleForClass:self.class].resourcePath stringByAppendingPathComponent:@"Fixtures/xcmount-test/"];
    })];
    defaultDirectory = NSFileManager.defaultManager.currentDirectoryPath;
  });
  
  afterEach(^{
    [NSFileManager.defaultManager changeCurrentDirectoryPath:defaultDirectory];
  });
  
  describe(@"+ buildTreeWithDiskPath:mountGroup:objects:", ^{
    
    it(@"can build a tree that mirrors the disk:", ^{
      
      NSMutableDictionary *group   = @{ PBXObjectAccessors.children : NSMutableArray.array }.mutableCopy;
      NSMutableDictionary *project = PASSampleProjectFromClass(self.class);
      
      BOOL result = [PASTreeBuilder.new buildTreeWithDiskPath:@"xcmount-test/NotInTarget"
                                                   mountGroup:group
                                                      objects:project.pbx_objects
                                                        error:NULL];
      
      expect(result).to.beTruthy();
      expect(group.pbx_children.count).to.equal(6);
      
      NSArray *childObjects = [group.pbx_children pas_map:^(NSString *UUID) {
        return project.pbx_objects[UUID];
      }];
      
      expect(group.pbx_children.count).to.equal(6);
      
      void (^verifyFileReference)(NSString *) = ^(NSString *path) {
        BOOL found = NO;
        
        for (NSMutableDictionary *object in childObjects) {
          if ([path isEqualToString:object.pbx_path]) {
            expect(object.pbx_isa).to.equal(PBXObjectClass.fileReference);
            found = YES;
          }
        }
        expect(found).to.beTruthy();
      };
      
      expect([childObjects valueForKey:PBXObjectAccessors.name]).to.contain(@"SomeFolder");
      
      verifyFileReference(@"SomeImage.png");
      verifyFileReference(@"SomeSource.h");
      verifyFileReference(@"SomeSource.m");
      verifyFileReference(@"SomeSwift.swift");
      verifyFileReference(@"SomeXib.xib");
      
      BOOL found = NO;
      
      for (NSMutableDictionary *object in childObjects) {
        if ([PBXObjectClass.group isEqualToString:object.pbx_isa]) {
          expect(object.pbx_name).to.equal(@"SomeFolder");
          expect(object.pbx_path).to.equal(@"SomeFolder");
          expect(object.pbx_children.count).to.equal(3);
          
          NSMutableDictionary *child = project.pbx_objects[object.pbx_children.lastObject];
          
          expect(child.pbx_path).to.equal(@"SomeText.txt");
          found = YES;
        }
        
        expect(found).to.beTruthy();
      }
      
    });
    
    it(@"returns no with an error if there is an error in the file enumeration", ^{
      NSError *generatedError = [NSError errorWithDomain:@"com.paul-samuels" code:100 userInfo:nil];
      
      id partialMock = OCMPartialMock(NSFileManager.defaultManager);
      
      OCMStub([partialMock enumeratorAtURL:OCMArg.any
                includingPropertiesForKeys:OCMArg.any
                                   options:NSDirectoryEnumerationSkipsHiddenFiles
                              errorHandler:OCMArg.any]).andDo(^(NSInvocation *invocation) {
        
        BOOL (^errorBlock)(NSURL *url, NSError *error);
        [invocation getArgument:&errorBlock atIndex:5];
        
        errorBlock(nil, generatedError);
      });
      
      PASTreeBuilder *treeBuilder = PASTreeBuilder.new;
      treeBuilder.fileManager = partialMock;
      
      NSMutableDictionary *group   = @{ PBXObjectAccessors.children : NSMutableArray.array }.mutableCopy;
      NSMutableDictionary *project = PASSampleProjectFromClass(self.class);
      
      NSError *error = nil;
      BOOL result = [treeBuilder buildTreeWithDiskPath:@"xcmount-test/NotInTarget"
                                            mountGroup:group
                                               objects:project.pbx_objects
                                                 error:&error];
      
      expect(result).to.beFalsy();
      expect(error).to.equal(generatedError);
      
    });
    
  });
  
});

SpecEnd
