#import <Foundation/Foundation.h>
#import <substrate.h>
#import <AudioToolbox/AudioServices.h>
#import <Cephei/HBPreferences.h>

HBPreferences* p;
NSString* sound;

static void (* orig_SpringBoard_applicationDidFinishLaunching)(id self, SEL _cmd, BOOL finished);
static void override_SpringBoard_applicationDidFinishLaunching(id self, SEL _cmd, BOOL finished) {
    orig_SpringBoard_applicationDidFinishLaunching(self, _cmd, finished);

    if (!sound) return;

    NSString *path = [NSString stringWithFormat:@"/var/mobile/Documents/BootSounds/%@.caf", sound];
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:path];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID(url, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

__attribute__((constructor)) static void init() {
    p = [[HBPreferences alloc] initWithIdentifier:@"com.emokidxd.bootsoundprefs"];
    [p registerObject:&sound default:nil forKey:@"sound"];
    MSHookMessageEx(objc_getClass("SpringBoard"), @selector(applicationDidFinishLaunching:), (IMP)&override_SpringBoard_applicationDidFinishLaunching, (IMP *)&orig_SpringBoard_applicationDidFinishLaunching);
}
