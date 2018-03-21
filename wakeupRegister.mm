#include "wakeupRegister.h"
#import <Foundation/Foundation.h>
#include <IOKit/pwr_mgt/IOPMLib.h>
#include <IOKit/IOMessage.h>
#include <stdlib.h>
#import <Foundation/Foundation.h>
#import "utils.h"

io_connect_t  root_port; // a reference to the Root Power Domain IOService

//是否需要拉伸。
int needScale = 0;

void
MySleepCallBack( void * refCon, io_service_t service,
        natural_t messageType, void * messageArgument ) {

    switch ( messageType ) {
        case kIOMessageSystemWillSleep:
            NSLog(@"kIOMessageSystemWillSleep--\n");
            break;
        case kIOMessageSystemHasPoweredOn:
            NSLog(@"<<< kIOMessageSystemHasPoweredOn--\n");
            break;
        case kIOMessageSystemWillPowerOn:
            NSLog(@">>> kIOMessageSystemWillPowerOn--\n");
            if(needScale == 0) {
                resetDisplay(refCon);
                needScale = 1;
            }
            break;
        case kIOMessageCanSystemSleep:
            NSLog(@"kIOMessageCanSystemSleep--\n");
            break;
        case kIOMessageSystemWillNotSleep:
            NSLog(@"kIOMessageSystemWillNotSleep--\n");
            break;
        default:
            NSLog(@"messageType %08lx, arg %08lx\n",
                    (long unsigned int)messageType,
                    (long unsigned int)messageArgument );
    }
}

int registerWakeup(void* tables) {
    NSLog(@"register ok\n");
     // notification port allocated by IORegisterForSystemPower
    IONotificationPortRef  notifyPortRef;

    // notifier object, used to deregister later
    io_object_t            notifierObject;
    // this parameter is passed to the callback
    // void*                  refCon;

    root_port = IORegisterForSystemPower(tables, &notifyPortRef, MySleepCallBack, &notifierObject );
    if ( root_port == 0 )
    {
        printf("IORegisterForSystemPower failed\n");
        return 1;
    }

    // add the notification port to the application runloop
    CFRunLoopAddSource( CFRunLoopGetCurrent(),
            IONotificationPortGetRunLoopSource(notifyPortRef), kCFRunLoopCommonModes );

    CFRunLoopRun();
    return 0;
}