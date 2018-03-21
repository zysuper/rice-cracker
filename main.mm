#import <Foundation/Foundation.h>
#include <IOKit/pwr_mgt/IOPMLib.h>
#include <IOKit/IOMessage.h>
#import <dlfcn.h>
#import "utils.h"
#include "wakeupRegister.h"


using namespace std;

int main( int argc, char **argv )
{
    // cacheAllDisplayModes(displayModes);
    registerWakeup(nullptr);
    // clearDisplayModes(displayModes);
    return 0;
}