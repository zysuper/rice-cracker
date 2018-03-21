
#import <Foundation/Foundation.h>

#import <dlfcn.h>

#import "utils.h"

#include <map>

using namespace std;


void CopyAllDisplayModes(CGDirectDisplayID display, modes_D4** modes, int* cnt)
{
	int nModes;
	CGSGetNumberOfDisplayModes(display, &nModes);
	
	if(nModes)
		*cnt = nModes;
	
	if(!modes)
		return;
		
	*modes = (modes_D4*) malloc(sizeof(modes_D4)* nModes);
	for(int i=0; i<nModes; i++)
	{
		CGSGetDisplayModeDescriptionOfLength(display, i, &(*modes)[i], 0xD4);
	}
}

void SetDisplayModeNum(CGDirectDisplayID display, int modeNum)
{
	CGDisplayConfigRef config;
	CGBeginDisplayConfiguration(&config);
	CGSConfigureDisplayMode(config, display, modeNum);
	CGCompleteDisplayConfiguration(config, kCGConfigurePermanently);
}

void cacheAllDisplayModes(map<CGDirectDisplayID,modes_D4*> &displayModes) {
    uint32_t nDisplays;
        //最多抓16个显示器.
    CGDirectDisplayID displays[0x10];
    CGGetOnlineDisplayList(0x10, displays, &nDisplays);
        
    for(int i=0; i<nDisplays; i++) {
        int nModes;
        modes_D4* modes;
        CGDirectDisplayID display = displays[i];
        CopyAllDisplayModes(display, &modes, &nModes);

        displayModes.insert(pair<CGDirectDisplayID,modes_D4*>(display,modes));
    }
}

void clearDisplayModes(map<CGDirectDisplayID,modes_D4*> &displayModes) {
    map<CGDirectDisplayID,modes_D4*>::iterator pos;
    for(pos = displayModes.begin(); pos != displayModes.end(); ++pos) {
        free(pos->second);
    }
}

void printDateTime() {
	NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];  
	[formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];    
	NSString *date =  [formatter stringFromDate:[NSDate date]];  
	NSString *timeLocal = [[NSString alloc] initWithFormat:@"%@", date]; 
	NSLog(@"%@", timeLocal);
}

void resetDisplay(void *tables) {
	uint32_t nDisplays;
	CGDirectDisplayID displays[0x10];
	CGGetOnlineDisplayList(0x10, displays, &nDisplays);	

	for(int i=0; i<nDisplays; i++)
	{
		CGDirectDisplayID display = displays[i];
		int mainModeNum;

		//获取当前的显示器的显示模式。
		CGSGetCurrentDisplayMode(display, &mainModeNum);	

		//获取当前显示模式详情。
		modes_D4 currentMode;
		CGSGetDisplayModeDescriptionOfLength(display, mainModeNum, &currentMode, 0xD4);

		//打印日志。
		NSLog(@"current display id <%d> modeNum id <%d>\n",display,mainModeNum);
		NSLog(@"width:%d x height:%d freq:%d mode: %d scale: %f depth: %d\n",
                       currentMode.derived.width,
                       currentMode.derived.height,
                       currentMode.derived.freq,
                       currentMode.derived.mode,
                       currentMode.derived.density,
                       currentMode.derived.depth);

		//HiDPI
		if(currentMode.derived.density == 2.0) {

			int swapModeNum;
			if(mainModeNum == 0) {
				swapModeNum = 1;
			} else {
				swapModeNum = mainModeNum - 1;
			}	

			SetDisplayModeNum(display, swapModeNum);
			NSLog(@"reset display id <%d> modeNum id <%d>\n",display,swapModeNum);

			// sleep(1);
			//睡眠1.5s
			usleep(1000 * 1500);

			//CGSGetCurrentDisplayMode(display, &mainModeNum);	
			SetDisplayModeNum(display,mainModeNum);
			NSLog(@"reset display id <%d> modeNum id <%d>\n",display,mainModeNum);
		}

	}
}