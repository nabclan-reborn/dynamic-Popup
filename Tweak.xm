#import <UIKit/UIKit.h>
#import <SCLAlertView/SCLAlertView.h>

#define timer(sec) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^

NSData* fetchDataFromURL(NSURL* url) {
    NSData* data = [NSData dataWithContentsOfURL:url];
    return data;
}

void parseJSONData(NSData* jsonData, void(^completion)(NSArray* links, NSString* subtitle)) {
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];

    if (error) {
        NSLog(@"Error parsing JSON data: %@", error.localizedDescription);
        completion(nil, nil);
        return;
    }

    NSArray* linksArray = json[@"links"];
    NSString* subtitle = json[@"subtitle"];

    NSMutableArray *links = [[NSMutableArray alloc] init];

    for(NSDictionary *linkDic in linksArray) {
        
        NSString *linkName = [linkDic objectForKey:@"name"];
        NSString *linkUrl = [linkDic objectForKey:@"url"];
      
        [links addObject:@{@"name": linkName, @"url": linkUrl}];
    }
    completion(links, subtitle);
}

void setup() { 
  // Add functionality here 
}

void setupMenu() {
    setup();
}

static void didFinishLaunching(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef info) {
    NSURL* jsonURL = [NSURL URLWithString:@"https://cdn.nabzclan.vip/popup/links.json"]; 

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* jsonData = fetchDataFromURL(jsonURL);

        dispatch_async(dispatch_get_main_queue(), ^{
            parseJSONData(jsonData, ^(NSArray* links, NSString* subtitle) {
                if (links && subtitle) {
                    timer(1) {
                        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];

                        for (NSDictionary* linkInfo in links) {
                            [alert addButton:linkInfo[@"name"] actionBlock:^(void) {
                                NSString* urlString = linkInfo[@"url"];
                                if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
                                    timer(1) {
                                        setupMenu();
                                    });
                                }
                            }];
                        }

                        [alert addButton:@"EXIT Popup ✘" actionBlock:^(void) {
                            timer(1) {
                                setupMenu();
                            });
                        }];

                        alert.shouldDismissOnTapOutside = NO;
                        alert.customViewColor = [UIColor redColor];
                        alert.backgroundViewColor = [UIColor blackColor];
                        alert.backgroundType = SCLAlertViewBackgroundBlur;

                        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                            alert.cornerRadius = 20.0f;
                        } else {
                            alert.cornerRadius = 10.0f;
                        }

                        alert.iconTintColor = [UIColor blackColor];
                        alert.showAnimationType = SCLAlertViewShowAnimationSlideInFromCenter;

                        [alert showSuccess:nil
                                   subTitle:subtitle
                           closeButtonTitle:nil
                                   duration:99999999.0f];

                        if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
                            alert.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
                        }
                    });
                }
            });
        });
    });
}

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(), NULL, &didFinishLaunching, (CFStringRef) UIApplicationDidFinishLaunchingNotification, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
