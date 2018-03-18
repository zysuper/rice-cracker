#include <IOKit/pwr_mgt/IOPMLib.h>
#include <IOKit/IOMessage.h>
#include "wakeupRegister.h"

int main( int argc, char **argv )
{
    return registerWakeup();
}