/*

 FROG

 Copyright (c) 2026 Arthur Choung. All rights reserved.

 Email: arthur -at- 8bitoperahouse.com

 This file is part of FROG.

 FROG is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <https://www.gnu.org/licenses/>.

 */

#import "FROG.h"

@implementation Definitions(jfkldsjklfjdsklfjlksdklfj)
+ (id)frogDir:(id)str
{
    return nsfmt(@"%@/%@", [Definitions frogDir], str);
}
+ (id)frogDir
{
    static id frogDir = nil;
    if (frogDir) {
        return frogDir;
    }
    char buf[1024];
    int result = readlink("/proc/self/exe", buf, 1023);
    if ((result > 0) && (result < 1024)) {
        frogDir = [[[NSString alloc] initWithBytes:buf length:result] autorelease];
        frogDir = [[frogDir stringByDeletingLastPathComponent] retain];
    }
    return frogDir;
}
@end

@implementation Definitions(fjkdsljfklsdjfueirwieofj)
#ifdef BUILD_FOR_ANDROID
+ (id)homeDir
{
    return @"/sdcard";
}
#else
+ (id)homeDir
{
    char *home = getenv("HOME");
    if (!home) {
        return [self frogDir];
    }
    return nsfmt(@"%s", home);
}
#endif

+ (id)homeDir:(id)path
{
    return nsfmt(@"%@/%@", [Definitions homeDir], path);
}
@end
