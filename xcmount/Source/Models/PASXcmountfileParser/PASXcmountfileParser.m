//
//  PASXcmountfileParser.m
//  xcmount
//
//  Created by Paul Samuels on 18/04/2015.
//  Copyright (c) 2015 Paul Samuels. All rights reserved.
//

#import "PASXcmountfileParser.h"

// Models
#import "PASConfiguration.h"

NSString *PASXcmountfileParser(void) {
  return [NSString stringWithFormat:@""
          @"require 'json'\n\n"
          @"@xcmount_configuration = {\n"
          @"  '%@' => []\n"
          @"}\n"
          @"\n"
          @"def xcodeproj project_name\n"
          @"  @xcmount_configuration['%@'] = project_name\n"
          @"end\n"
          @"\n"
          @"def mount dir_path, mount_path=nil\n"
          @"  mount_path = dir_path if mount_path.nil?\n"
          @"  @xcmount_configuration['%@'] << { '%@' => @current_targets, '%@' => dir_path, '%@' => mount_path }\n"
          @"end\n"
          @"\n"
          @"def target *targets\n"
          @"  @current_targets = Array(targets)\n"
          @"  yield\n"
          @"  @current_targets = nil\n"
          @"end\n",
          PASConfigurationKeys.actions,
          PASConfigurationKeys.xcodeProjectName,
          PASConfigurationKeys.actions,
          PASConfigurationKeys.targets,
          PASConfigurationKeys.dirPath,
          PASConfigurationKeys.mountPath];
}
