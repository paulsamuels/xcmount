//
//  PASSampleProjectLoader.h
//  xcmount
//
//  Created by Paul Samuels on 19/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

@import Foundation;

#import "PASDecorator.h"

static NSMutableDictionary *PASSampleProjectFromClass(Class klass) {
  NSString *projectPath = [[NSBundle bundleForClass:klass].resourcePath stringByAppendingPathComponent:@"Fixtures/xcmount-test/xcmount-test.xcodeproj/project.pbxproj"];
  
  NSMutableDictionary *project = ({
    [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfFile:projectPath]
                                              options:NSPropertyListMutableContainersAndLeaves
                                               format:NULL
                                                error:NULL];
  });
  
  [PASDecorator decorateObjects:project.pbx_objects];
  
  return project;
};
