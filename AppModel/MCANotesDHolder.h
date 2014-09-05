//
//  MCANotesDHolder.h
//  MobileCollegeAdmin
//
//  Created by aditi on 29/08/14.
//  Copyright (c) 2014 arya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCANotesDHolder : NSObject{
    
}
@property(nonatomic,strong)NSString *str_notesId;
@property(nonatomic,strong)NSString *str_notesName;
@property(nonatomic,strong)NSString *str_notesDesc;
@property(nonatomic,strong)NSString *str_notesImage;
@property(nonatomic,strong)NSString *str_notesType;
@property(nonatomic,strong)NSMutableArray *arr_notesImage;
@end
