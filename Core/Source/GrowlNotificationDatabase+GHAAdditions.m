//
//  GrowlNotificationDatabase+GHAAdditions.m
//  Growl
//
//  Created by Daniel Siemer on 10/5/10.
//  Copyright 2010 The Growl Project. All rights reserved.
//

#import "GrowlNotificationDatabase+GHAAdditions.h"
#import "GrowlTicketController.h"
#import "GrowlApplicationTicket.h"
#import "GrowlNotificationTicket.h"
#import "GrowlApplicationController.h"
#import "GrowlIdleStatusController.h"
#import "GrowlHistoryNotification.h"

@implementation GrowlNotificationDatabase (GHAAditions)

-(void)setupMaintenanceTimers
{
   //While this is only compiled with GHA, we want to be really sure we are GHA.
   if(![[[NSProcessInfo processInfo] processName] isEqualToString:@"GrowlHelperApp"])
   {
      NSLog(@"We arent GHA, we shouldn't be setting up maintenance timers");
      return;
   }
   
   if(maintenanceTimer)
   {
      NSLog(@"Timer appears to already be setup, setupMaintenanceTimers should only be called once");
      return;
   }
   NSLog(@"Setup timer, this should only happen once");

   //Setup timers, every half hour for DB maintenance, every night for Cache cleanup   
   maintenanceTimer = [[NSTimer timerWithTimeInterval:30 * 60 
                                               target:self
                                             selector:@selector(storeMaintenance:)
                                             userInfo:nil
                                              repeats:YES] retain];
   [[NSRunLoop mainRunLoop] addTimer:maintenanceTimer forMode:NSRunLoopCommonModes];

   NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
   [components setDay:[components day] - 1];
   [components setHour:23];
   [components setMinute:59];
   lastImageCheck = [[[NSCalendar currentCalendar] dateFromComponents:components] retain];
   NSLog(@"Next image check no earlier than 24 hours from %@", lastImageCheck);
   
   [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(idleStatus:)
                                                name:@"GrowlIdleStatus"
                                              object:nil];
}

-(void)idleStatus:(NSNotification*)notification
{
	if ([[notification object] isEqualToString:@"Idle"] && !notificationsWhileAway) {
      if(awayDate)
         [awayDate release];
      awayDate = [[NSDate date] retain];
   }
}

-(void)logNotificationWithDictionary:(NSDictionary*)noteDict
{
   NSError *error = nil;
   BOOL isAway = GrowlIdleStatusController_isIdle();
   if(notificationsWhileAway)
      isAway = YES;
   
   BOOL deleteUponReturn = NO;
   GrowlPreferencesController *preferences = [GrowlPreferencesController sharedController];
   GrowlApplicationTicket *ticket = [[GrowlTicketController sharedController] ticketForApplicationName:[noteDict objectForKey:GROWL_APP_NAME]];
   GrowlNotificationTicket *notificationTicket = [ticket notificationTicketForName:[noteDict objectForKey:GROWL_NOTIFICATION_NAME]];
  
   if(![self managedObjectContext])
   {
      NSLog(@"If we can't find/create the database, we can't log, return");
      return;
   }
   
   //Ignore our own notification, it would be a bit recursive, and infinite loopish...
   if([[noteDict objectForKey:GROWL_APP_NAME] isEqualToString:@"Growl"] && [[noteDict objectForKey:GROWL_NOTIFICATION_NAME] isEqualToString:NOTIFICATION_HISTORY_NOTIFICATION])
   {
      //NSLog(@"Not logging internally generated history coalesce notification");
      return;
   }
   
   /* Ignore the notification if we arent logging and arent idle
    * Note that this breaks growl menu most recent notifications
    */
   if((![preferences isGrowlHistoryLogEnabled] || ![notificationTicket logNotification]) && !isAway)
   {
      //NSLog(@"We arent logging, and we arent away, return");
      return;
   }
      
   if(![notificationTicket logNotification] && isAway && ![preferences retainAllNotesWhileAway])
   {
      //NSLog(@"We are away, but not logging or retaining, return");
      return;
   }
      
   //decide whether we will delete this message upon the user having returned/read it
   if((![preferences isGrowlHistoryLogEnabled] || ![notificationTicket logNotification]) && isAway && [preferences retainAllNotesWhileAway])
   {
      //NSLog(@"We are away, shouldnt log this message, and we are rolling up, mark for deletion upon return");
      deleteUponReturn = YES;
   }
      
   GrowlHistoryNotification *notification = [NSEntityDescription insertNewObjectForEntityForName:@"Notification" inManagedObjectContext:[[GrowlNotificationDatabase sharedInstance] managedObjectContext]];
   
   // Whatever notification we set above, set its values and save
   [notification setWithNoteDictionary:noteDict];
   [notification setDeleteUponReturn:[NSNumber numberWithBool:deleteUponReturn]];
   if (![[notification managedObjectContext] save:&error])
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      
   if(isAway)
   {
      notificationsWhileAway = YES;
      NSUInteger numberOfNotifications = [self awayHistoryCount];
      
      NSString* description;
      
      if(numberOfNotifications == 1)
         description = [NSString stringWithFormat:NSLocalizedString(@"There was %d notification while you were away", nil), numberOfNotifications];
      else
         description = [NSString stringWithFormat:NSLocalizedString(@"There were %d notifications while you were away", nil), numberOfNotifications];
      //Send out the notification, overwriting the previous one
      [GrowlApplicationBridge notifyWithTitle:NSLocalizedString(@"Notification History:", nil)
                                  description:description
                             notificationName:NOTIFICATION_HISTORY_NOTIFICATION
                                     iconData:nil
                                     priority:0
                                     isSticky:YES 
                                 clickContext:HISTORY_CLICK_CONTEXT
                                   identifier:HISTORY_IDENTIFIER];
   }
}

@end
