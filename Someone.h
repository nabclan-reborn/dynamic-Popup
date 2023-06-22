#include <substrate.h>
#include <mach-o/dyld.h>

#import "UIKit/UIKit.h"
#import "SCLAlertView/SCLAlertView.h"

#define timer(sec) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (const int64_t)(sec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
#define HOOK(offset, ptr, orig) MSHookFunction((void *)getRealOffset(offset), (void *)ptr, (void **)&orig)
#define HOOK_NO_ORIG(offset, ptr) MSHookFunction((void *)getRealOffset(offset), (void *)ptr, NULL)

uint64_t getRealOffset(uint64_t offset){
  return _dyld_get_image_vmaddr_slide(0) + offset;
}
