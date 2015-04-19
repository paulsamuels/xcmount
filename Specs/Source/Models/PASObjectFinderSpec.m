#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "PASObjectFinder.h"

// Categories
#import "NSArray+PASEnumeration.h"
#import "NSMutableDictionary+PBXAccessors.h"

// Constants
#import "PASConstants.h"

// Helpers
#import "PASSampleProjectLoader.h"

SpecBegin(PASObjectFinder)

describe(@"PASObjectFinder", ^{
  
  __block NSMutableDictionary *project = nil;
  
  beforeEach(^{
    project = PASSampleProjectFromClass(self.class);
  });
  
  describe(@"+ targetObjectsInObjects:", ^{
    
    it(@"finds targets", ^{
      NSArray *targets = [PASObjectFinder.new targetObjectsInObjects:project.pbx_objects];
      
      expect(targets.count).to.equal(2);
      expect([targets valueForKey:PBXObjectAccessors.name]).to.contain(@"xcmount-test");
      expect([targets valueForKey:PBXObjectAccessors.name]).to.contain(@"xcmount-testTests");
    });
    
  });
  
  void (^verifyGroupWithPathAndName)(NSMutableDictionary *, NSString *, NSString *) = ^(NSMutableDictionary *group, NSString *path, NSString *name) {
    expect(group.pbx_isa).to.equal(PBXObjectClass.group);
    expect(group.pbx_path).to.equal(path);
    expect(group.pbx_name).to.equal(name);
  };
  
  describe(@"+ findOrCreateMountingGroupWithDiskPath:mountPath:objects:", ^{
    
    it(@"finds the existing 'Source' group", ^{
      NSMutableDictionary *group = [PASObjectFinder.new findOrCreateMountingGroupWithDiskPath:@"xcmount-test/Source" mountPath:@"xcmount-test/Source" objects:project.pbx_objects];
      
      verifyGroupWithPathAndName(group, @"Source", nil);
      expect([group.pbx_children count]).to.equal(3);
    });

    it(@"create a new group that does not already exist", ^{
      NSMutableDictionary *group = [PASObjectFinder.new findOrCreateMountingGroupWithDiskPath:@"NewGroup" mountPath:@"NewGroup" objects:project.pbx_objects];
      
      verifyGroupWithPathAndName(group, @"NewGroup", @"NewGroup");
      expect([group.pbx_children count]).to.equal(0);
      expect(project.pbx_objects[group.pas_UUID]).to.equal(group);
    });
    
    it(@"can create a new group at an arbitrary point", ^{
      NSMutableDictionary *group = [PASObjectFinder.new findOrCreateMountingGroupWithDiskPath:@"NewGroup" mountPath:@"A/B/C" objects:project.pbx_objects];
      
      verifyGroupWithPathAndName(group, @"NewGroup", @"C");
      expect([group.pbx_children count]).to.equal(0);
      expect(group.pbx_isa).to.equal(PBXObjectClass.group);
      expect(group.pbx_path).to.equal(@"NewGroup");
      expect(group.pbx_name).to.equal(@"C");
      
      NSMutableDictionary *B = [[project.pbx_objects allValues] pas_find:^(NSMutableDictionary *subGroup, NSUInteger idx, BOOL *stop) {
        return [subGroup.pbx_children containsObject:group.pas_UUID];
      }];
      
      expect(B).toNot.beNil();
      
      NSMutableDictionary *A = [[project.pbx_objects allValues] pas_find:^(NSMutableDictionary *subGroup, NSUInteger idx, BOOL *stop) {
        return [subGroup.pbx_children containsObject:B.pas_UUID];
      }];
      
      expect(A).toNot.beNil();
    });
    
    it(@"can create a new group with an arbitrary disk path", ^{
      NSMutableDictionary *group = [PASObjectFinder.new findOrCreateMountingGroupWithDiskPath:@"A/B/C" mountPath:@"NewGroup" objects:project.pbx_objects];
      
      verifyGroupWithPathAndName(group, @"A/B/C", @"NewGroup");
      expect([group.pbx_children count]).to.equal(0);
    });
    
    it(@"can create a new group that uses some existing groups to make the disk path", ^{
      NSMutableDictionary *group = [PASObjectFinder.new findOrCreateMountingGroupWithDiskPath:@"xcmount-test/B/C" mountPath:@"xcmount-test/NewGroup" objects:project.pbx_objects];
      
      verifyGroupWithPathAndName(group, @"B/C", @"NewGroup");
      expect([group.pbx_children count]).to.equal(0);
      
      NSMutableDictionary *xcmountTestGroup = [[project.pbx_objects allValues] pas_find:^(NSMutableDictionary *subGroup, NSUInteger idx, BOOL *stop) {
        return [subGroup.pbx_children containsObject:group.pas_UUID];
      }];
      
      expect(xcmountTestGroup).toNot.beNil();
    });

  });
  
});

SpecEnd
