//
//  MCACalendarView.h
//  Vurig
//
//  Created by in 't Veen Tjeerd on 5/8/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UIColor+expanded.h"

#define kMCACalendarViewTopBarHeight 62
#define kMCACalendarViewWidth 320

#define kMCACalendarViewDayWidth 44
#define kMCACalendarViewDayHeight 36

@protocol MCACalendarViewDelegate;
@interface MCACalendarView : UIView {
    id <MCACalendarViewDelegate> delegate;
    
    NSDate *currentMonth;
    UILabel *labelCurrentMonth;
    
    BOOL isAnimating;
    BOOL prepAnimationPreviousMonth;
    BOOL prepAnimationNextMonth;
    
    UIImageView *animationView_A;
    UIImageView *animationView_B;
    
    NSArray *markedDates;
    NSMutableArray *arrPriority;
    NSArray *markedColors;
}

@property (nonatomic, retain) id <MCACalendarViewDelegate> delegate;
@property (nonatomic, retain) NSDate *currentMonth;
@property (nonatomic, retain) UILabel *labelCurrentMonth;
@property (nonatomic, retain) UIImageView *animationView_A;
@property (nonatomic, retain) UIImageView *animationView_B;
@property (nonatomic, retain) NSArray *markedDates;
@property (nonatomic, retain) NSArray *markedColors;
@property (nonatomic, retain) NSMutableArray *arrPriority;
@property (nonatomic, getter = calendarHeight) float calendarHeight;
@property (nonatomic, retain, getter = selectedDate) NSDate *selectedDate;

-(void)selectDate:(int)date;
-(void)reset;

-(void)markDates:(NSArray *)dates priorityQueue:(NSMutableArray*)priority;
-(void)markDates:(NSArray *)dates withColors:(NSArray *)colors;

-(void)showNextMonth;
-(void)showPreviousMonth;

-(int)numRows;
-(void)updateSize;
-(UIImage *)drawCurrentState;

@end

@protocol MCACalendarViewDelegate <NSObject>
-(void)calendarView:(MCACalendarView *)calendarView switchedToMonth:(int)month switchedToYear:(int)year targetHeight:(float)targetHeight animated:(BOOL)animated;
-(void)calendarView:(MCACalendarView *)calendarView dateSelected:(NSDate *)date;
@end
