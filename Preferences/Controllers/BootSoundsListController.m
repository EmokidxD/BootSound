#include "BootSoundsListController.h"

@implementation BootSoundsListController
- (NSArray *)specifiers {
    _specifiers = [NSMutableArray new];

	// store all file names from /var/mobile/Documents/BootSound in an array
	NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/mobile/Documents/BootSounds" error:nil];

    for (NSString* file in files) {
        PSSpecifier* fileSpecifier = [PSSpecifier preferenceSpecifierNamed:[file stringByDeletingPathExtension] target:self set:nil get:nil detail:nil cell:PSButtonCell edit:nil];
		[fileSpecifier setButtonAction:@selector(setSound:)];
		[_specifiers addObject:fileSpecifier];
    }

	return _specifiers;
}

- (void)setSound:(PSSpecifier *)specifier {
	HBPreferences* p = [[HBPreferences alloc] initWithIdentifier:@"com.emokid.bootsoundprefs"];
	[p setObject:[specifier name] forKey:@"sound"];
}
@end
