//
//  MCADBIntraction.h
//  MobileCollegeAdmin
//
//  Created by aditi on 09/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCADBIntraction : NSObject
@property (nonatomic,retain) NSString *databaseName;
+ (id)databaseInteractionManager;

-(void)insertTaskList:(NSMutableArray*)arr_taskList;
-(void)updateTaskList:(NSMutableArray*)arr_taskList;
-(void)deleteTaskList:(id)sender;
-(void)deleteTask:(NSMutableArray*)arr_task;
-(NSMutableArray*)retrieveTaskList:(id)sender;
@end
