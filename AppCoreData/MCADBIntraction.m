//
//  MCADBIntraction.m
//  MobileCollegeAdmin
//
//  Created by aditi on 09/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import "MCADBIntraction.h"

MCADBIntraction *databaseManager = nil;
@implementation MCADBIntraction
@synthesize databaseName;
+ (id)databaseInteractionManager
{
    @synchronized(self)
    {
        if (databaseManager == nil)
        {
            databaseManager = [[self alloc] init];
        }
    }
    return databaseManager;
}
- (id)init
{
    if (self = [super init])
    {
        dBCollgeAdmin  = [[FMDatabase alloc] initWithPath:[self getDatabasePathFromName:@"MobileCollegeAdmin"]];
    }
    return self;
}
- (NSString *) getDatabasePathFromName:(NSString *)dbName
{
	return [self getDatabaseFolderPath:dbName];
}

-(NSString *) getDatabaseFolderPath : (NSString *)dbName
{
	databaseName = [dbName stringByAppendingString:@".sqlite"];
	NSString *databasePath = [[self getDocumentsDirectoryPath] stringByAppendingPathComponent:databaseName];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:databasePath]) return databasePath;
	else
    {
		NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
	}
	return databasePath;
}

- (NSString *) getDocumentsDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}
-(void)insertTaskList:(NSMutableArray *)arr_taskList
{
    for (int i=0; i<arr_taskList.count;i++)
    {        
        MCATaskDetailDHolder *taskDHoler=[arr_taskList objectAtIndex:i];
        
        NSString *query=[NSString stringWithFormat:@"insert into tbl_tasklist(taskId,userId,taskName,taskDetail,taskPriority,taskStartDate,taskStatus,createdAt,createdBy,updatedAt,grade,status,network,nowDate) values(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",taskDHoler.str_taskId,taskDHoler.str_userId,taskDHoler.str_taskName,taskDHoler.str_taskDetail,taskDHoler.str_taskPriority,taskDHoler.str_taskStartDate,taskDHoler.str_taskStatus,taskDHoler.str_createdAt,taskDHoler.str_createdBy,taskDHoler.str_updatedAt,taskDHoler.str_grade,taskDHoler.str_status,taskDHoler.str_network,taskDHoler.str_nowDate];
        
        @try
        {
            [dBCollgeAdmin open];
            if ([dBCollgeAdmin executeUpdate:query])
            {
                NSLog(@"successfully inserted");
            }
        }
        @catch (NSException *e)
        {
            NSLog(@"%@",e);
        }
        @finally
        {
            [dBCollgeAdmin close];
        }
    }
}

-(NSMutableArray*)retrieveTaskList:(id)sender{
    
    NSMutableArray *arr_dbTaskList=[[NSMutableArray alloc]init];
    
    NSString *query=@"Select * from tbl_tasklist";
    @try
    {
        [dBCollgeAdmin open];
        FMResultSet *resultSet=[dBCollgeAdmin executeQuery:query];
        while ([resultSet next])
        {
            MCATaskDetailDHolder *taskDHolder=[MCATaskDetailDHolder new];
            taskDHolder.str_taskId = [resultSet stringForColumn:@"taskId"];
            taskDHolder.str_userId = [resultSet stringForColumn:@"userId"];
            taskDHolder.str_taskName = [resultSet stringForColumn:@"taskName"];
            taskDHolder.str_taskDetail = [resultSet stringForColumn:@"taskDetail"];
            taskDHolder.str_taskPriority = [resultSet stringForColumn:@"taskPriority"];
            taskDHolder.str_taskStartDate = [resultSet stringForColumn:@"taskStartDate"];
            taskDHolder.str_taskStatus = [resultSet stringForColumn:@"taskStatus"];
            taskDHolder.str_createdAt = [resultSet stringForColumn:@"createdAt"];
            taskDHolder.str_createdBy = [resultSet stringForColumn:@"createdBy"];
            taskDHolder.str_updatedAt = [resultSet stringForColumn:@"updatedAt"];
            taskDHolder.str_grade = [resultSet stringForColumn:@"grade"];
            taskDHolder.str_status = [resultSet stringForColumn:@"status"];
            taskDHolder.str_nowDate = [resultSet stringForColumn:@"nowDate"];
            
            [arr_dbTaskList addObject:taskDHolder];
        }
        [resultSet close];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    @finally
    {
        [dBCollgeAdmin close];
    }
    return arr_dbTaskList;
}
-(void)updateTaskList:(NSMutableArray *)arr_taskList{
 
    for (int i=0; i<arr_taskList.count;i++)
    {
        MCATaskDetailDHolder *taskDHoler=[arr_taskList objectAtIndex:i];
        
        NSString *query=[NSString stringWithFormat:@"UPDATE tbl_tasklist SET taskId=\'%@\',userId =\'%@\',taskName=\'%@\',taskDetail=\'%@\',taskPriority=\'%@\',taskStartDate=\'%@\',taskStatus=\'%@\',createdAt=\'%@\',createdBy=\'%@\',updatedAt=\'%@\',grade=\'%@\',status=\'%@\',network=\'%@\',nowDate=\'%@\' where userId=\'%@\' and taskId=\'%@\'",taskDHoler.str_taskId,taskDHoler.str_userId,taskDHoler.str_taskName,taskDHoler.str_taskDetail,taskDHoler.str_taskPriority,taskDHoler.str_taskStartDate,taskDHoler.str_taskStatus,taskDHoler.str_createdAt,taskDHoler.str_createdBy,taskDHoler.str_updatedAt,taskDHoler.str_grade,taskDHoler.str_status,taskDHoler.str_network,taskDHoler.str_nowDate,taskDHoler.str_userId,taskDHoler.str_taskId];
        
        @try
        {
            [dBCollgeAdmin open];
            if ([dBCollgeAdmin executeUpdate:query])
            {
                NSLog(@"successfully updated");
            }
        }
        @catch (NSException *e)
        {
            NSLog(@"%@",e);
        }
        @finally
        {
            [dBCollgeAdmin close];
        }
    }
}
-(void)deleteTaskList:(id)sender{

    NSString *query=[NSString stringWithFormat:@"delete from tbl_tasklist"];
    
    @try
    {
        [dBCollgeAdmin open];
        if ([dBCollgeAdmin executeUpdate:query])
        {
            NSLog(@"succesfully deleted");
            
        }else
        {
            NSLog(@"error in deletion");
        }
        [dBCollgeAdmin close];
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
    }
}
-(void)deleteTask:(NSMutableArray*)arr_task{
   
   for (int i=0; i<arr_task.count;i++)
   {
        MCATaskDetailDHolder *taskDHoler=[arr_task objectAtIndex:i];
    
    NSString *query=[NSString stringWithFormat:@"delete from tbl_tasklist where userId=\'%@\' and taskId=\'%@\'",taskDHoler.str_userId,taskDHoler.str_taskId];
    
    @try
    {
        [dBCollgeAdmin open];
        if ([dBCollgeAdmin executeUpdate:query])
        {
            NSLog(@"succesfully deleted");
            
        }else
        {
            NSLog(@"error in deletion");
        }
        [dBCollgeAdmin close];
    }
    @catch (NSException *e)
    {
        NSLog(@"%@",e);
    }
  }
}

@end
