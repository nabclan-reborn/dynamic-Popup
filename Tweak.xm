#import <UIKit/UIKit.h>
#import <SCLAlertView/SCLAlertView.h>
#import "Someone.h"

// Function to fetch JSON data from URL
NSData* fetchDataFromURL(NSURL* url) {
    NSData* data = [NSData dataWithContentsOfURL:url];
    return data;
}

// Function to parse JSON data and extract links and subtitle
void parseJSONData(NSData* jsonData, void(^completion)(NSArray* links, NSString* subtitle)) {
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    if (error) {
        NSLog(@"Error parsing JSON data: %@", error.localizedDescription);
        completion(nil, nil);
        return;
    }
    
    NSArray* links = json[@"links"];
    NSString* subtitle = json[@"subtitle"];
    
    completion(links, subtitle);
}

// Popup setup
void setup() { }

void setupMenu() {
    setup();
}

static void didFinishLaunching(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef info) {
    NSURL* jsonURL = [NSURL URLWithString:@"https://cdn.nabzclan.com/links.json"]; // Replace <JSON_URL> with your actual JSON URL
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* jsonData = fetchDataFromURL(jsonURL);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            parseJSONData(jsonData, ^(NSArray* links, NSString* subtitle) {
                if (links && subtitle) {
                    timer(1) {
                        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                        
                        for (NSString* link in links) {
                            [alert addButton:link actionBlock:^(void) {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
                                timer(9999) {
                                    setupMenu();
                                });
                            }];
                        }
                        
                        [alert addButton:@"EXIT Popup ✘" actionBlock:^(void) {
                            timer(9999) {
                                setupMenu();
                            });
                        }];
                        
                        alert.shouldDismissOnTapOutside = NO;
                        alert.customViewColor = [UIColor redColor];
                        alert.backgroundViewColor = [UIColor blackColor];
                        alert.showAnimationType = SCLAlertViewShowAnimationSlideInFromCenter;
                        [alert showSuccess:nil
                                   subTitle:subtitle
                           closeButtonTitle:nil
                                   duration:99999999.0f];
                    });
                }
            });
        });
    });
}

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(), NULL, &didFinishLaunching, (CFStringRef)UIApplicationDidFinishLaunchingNotification, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
