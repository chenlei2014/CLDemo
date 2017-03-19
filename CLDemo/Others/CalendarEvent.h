//
//  CalendarEvent.h
//  CalendarEventDemo
//
//  Created by JmoVxia on 2017/3/18.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CalendarEvent;

typedef enum : NSUInteger {
    
    /**
     *  Have not permission to save the event to system.
     */
    kCalendarEventAccessDenied = 1000,
    
    /**
     *  Saved the event success.
     */
    kCalendarEventAccessSavedSucess,
    
    /**
     *  Saved the event failed.
     */
    kCalendarEventAccessSavedFailed,
    
    /**
     *  Removed the event success.
     */
    kCalendarEventAccessRemovedSucess,
    
    /**
     *  Removed the event failed.
     */
    kCalendarEventAccessRemovedFailed,
    
} ECalendarEventStatus;

@protocol CalendarEventDelegate <NSObject>

@optional

/**
 *  The CalendarEvent saved status.
 *
 *  @param event  CalendarEvent's object.
 *  @param status Saved status.
 *  @param error  Error infomation.
 */
- (void)calendarEvent:(CalendarEvent *)event savedStatus:(ECalendarEventStatus)status error:(NSError *)error;

/**
 *  The CalendarEvent removed status.
 *
 *  @param event  CalendarEvent's object.
 *  @param status Removed status.
 *  @param error  Error infomation.
 */
- (void)calendarEvent:(CalendarEvent *)event removedStatus:(ECalendarEventStatus)status error:(NSError *)error;

@end

@interface CalendarEvent : NSObject

/**
 *  CalendarEvent's delegate.
 */
@property (nonatomic, weak)   id <CalendarEventDelegate>  delegate;

/**
 *  Event title.
 */
@property (nonatomic, strong) NSString *eventTitle;

/**
 *  Alarm date.
 */
@property (nonatomic, strong) NSDate   *alarmDate;

/**
 *  Event start date.
 */
@property (nonatomic, strong) NSDate   *startDate;

/**
 *  Event end date.
 */
@property (nonatomic, strong) NSDate   *endDate;

/**
 *  Event location.
 */
@property (nonatomic, strong) NSString *eventLocation;

/**
 *  Save the event to system.
 */
- (void)save;

/**
 *  Remove the event.
 */
- (void)remove;

/**
 *  To indicate the event have saved or not.
 */
- (BOOL)haveSaved;

#pragma mark - Constructor method.

+ (instancetype)calendarEventWithEventTitle:(NSString *)title startDate:(NSDate *)startDate endDate:(NSDate *)endDate alarmDate:(NSDate *)alarmDate;

@end
