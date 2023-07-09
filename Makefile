SYSROOT = $(THEOS)/sdks/iPhoneOS11.4.sdk/
THEOS_DEVICE_IP = 192.168.1.66 -p 22
#TARGET = iphone:clang:latest:12.2

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = nabzclanpopup
nabzclanpopup_CCFLAGS = -std=c++11 -fno-rtti -fno-exceptions -DNDEBUG
CFLAGS = -fobjc-arc #-w #-Wno-deprecated -Wno-deprecated-declarations
nabzclanpopup_FILES = Tweak.xm $(wildcard SCLAlertView/*.m) 
include $(THEOS_MAKE_PATH)/tweak.mk