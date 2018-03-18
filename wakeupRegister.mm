#include "wakeupRegister.h"
#import <Foundation/Foundation.h>
#include <IOKit/pwr_mgt/IOPMLib.h>
#include <IOKit/IOMessage.h>
#include <stdlib.h>
#import <Foundation/Foundation.h>
#import "utils.h"

io_connect_t  root_port; // a reference to the Root Power Domain IOService

void resetRes() {
	uint32_t nDisplays;
	CGDirectDisplayID displays[0x10];
	CGGetOnlineDisplayList(0x10, displays, &nDisplays);	

	for(int i=0; i<nDisplays; i++)
	{
		CGDirectDisplayID display = displays[i];
		int mainModeNum;
		CGSGetCurrentDisplayMode(display, &mainModeNum);	

		fprintf(stderr,"current display id <%d> modeNum id <%d>\n",display,mainModeNum);

		if(mainModeNum == 4 && display == 2034356672) {
			SetDisplayModeNum(display,11);
			sleep(1);
			CGSGetCurrentDisplayMode(display, &mainModeNum);	
			fprintf(stderr,"reset display id <%d> modeNum id <%d>\n",display,mainModeNum);
			SetDisplayModeNum(display,4);
			CGSGetCurrentDisplayMode(display, &mainModeNum);	
			fprintf(stderr,"reset display id <%d> modeNum id <%d>\n",display,mainModeNum);

			fprintf(stderr,"setting end...");
		} 

		if(mainModeNum == 3 && display == 2034356672) {
			SetDisplayModeNum(display,11);
			sleep(1);
			CGSGetCurrentDisplayMode(display, &mainModeNum);	
			fprintf(stderr,"reset display id <%d> modeNum id <%d>\n",display,mainModeNum);
			SetDisplayModeNum(display,3);
			CGSGetCurrentDisplayMode(display, &mainModeNum);	
			fprintf(stderr,"reset display id <%d> modeNum id <%d>\n",display,mainModeNum);
		}
	}
}

void
MySleepCallBack( void * refCon, io_service_t service,
        natural_t messageType, void * messageArgument ) {

    switch ( messageType ) {
        case kIOMessageSystemWillSleep:
            fprintf(stderr,"kIOMessageSystemWillSleep--\n");
            break;
        case kIOMessageSystemHasPoweredOn:
            fprintf(stderr,"kIOMessageSystemHasPoweredOn--\n");
            break;
        case kIOMessageSystemWillPowerOn:
            fprintf(stderr,"kIOMessageSystemWillPowerOn--\n");
            resetRes();
            break;
        case kIOMessageCanSystemSleep:
            fprintf(stderr,"kIOMessageCanSystemSleep--\n");
            break;
        case kIOMessageSystemWillNotSleep:
            fprintf(stderr,"kIOMessageSystemWillNotSleep--\n");
            break;
        default:
            fprintf(stderr, "messageType %08lx, arg %08lx\n",
                    (long unsigned int)messageType,
                    (long unsigned int)messageArgument );
    }
}

int registerWakeup() {
    fprintf(stderr,"register ok\n");
     // notification port allocated by IORegisterForSystemPower
    IONotificationPortRef  notifyPortRef;

    // notifier object, used to deregister later
    io_object_t            notifierObject;
    // this parameter is passed to the callback
    void*                  refCon;

    root_port = IORegisterForSystemPower(refCon, &notifyPortRef, MySleepCallBack, &notifierObject );
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