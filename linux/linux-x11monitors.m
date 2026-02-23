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

@implementation Definitions(fjkdlsjfklsdjklfjsdf)
+ (id)x11CurrentMonitor
{
    int x = [[Definitions windowManager] intValueForKey:@"mouseX"];
    return [Definitions x11MonitorForX:x y:0];
}
+ (id)x11CurrentMonitorName
{
    int x = [[Definitions windowManager] intValueForKey:@"mouseX"];
    id result = [Definitions x11MonitorForX:x y:0];
    return [result valueForKey:@"output"];
}
+ (int)x11CurrentMonitorIndex
{
    int x = [[Definitions windowManager] intValueForKey:@"mouseX"];
    return [Definitions x11MonitorIndexForX:x y:0];
}
+ (id)x11CcurrentMonitorIndexName
{
    int x = [[Definitions windowManager] intValueForKey:@"mouseX"];
    id result = [Definitions x11MonitorIndexNameForX:x y:0];
    return result;
}
+ (void)x11SetupMonitors
{
    id cmd = nsarr();
    [cmd addObject:@"frog-x11-monitor-setupMonitors.pl"];
    [cmd runCommandInBackground];
}

+ (id)x11MonitorIndexNameForX:(int)x y:(int)y
{
    id monitors = [Definitions x11MonitorConfig];
    for (int index=0; index<[monitors count]; index++) {
        id elt = [monitors nth:index];
        int monitorX = [elt intValueForKey:@"x"];
        int monitorWidth = [elt intValueForKey:@"width"];
        if (!monitorWidth) {
            continue;
        }
        if ((x >= monitorX) && (x < (monitorX+monitorWidth))) {
            return nsfmt(@"%d/%d", index+1, [monitors count]);;
        }
    }
    return nsfmt(@"%d/%d", 1, [monitors count]);
}
+ (int)x11MonitorIndexForX:(int)x y:(int)y
{
    id monitors = [Definitions x11MonitorConfig];
    for (int index=0; index<[monitors count]; index++) {
        id elt = [monitors nth:index];
        int monitorX = [elt intValueForKey:@"x"];
        int monitorWidth = [elt intValueForKey:@"width"];
        if (!monitorWidth) {
            continue;
        }
        if ((x >= monitorX) && (x < (monitorX+monitorWidth))) {
            return index;
        }
    }
    return 0;
}
+ (id)x11MonitorForX:(int)x y:(int)y
{
    id monitors = [Definitions x11MonitorConfig];
    for (id elt in monitors) {
        int monitorX = [elt intValueForKey:@"x"];
        int monitorWidth = [elt intValueForKey:@"width"];
        if (!monitorWidth) {
            continue;
        }
        if ((x >= monitorX) && (x < (monitorX+monitorWidth))) {
            return elt;
        }
    }
    return [monitors nth:0];
}
+ (id)x11MonitorConfig
{
    static long lastTimestampPlusSize= 0;
    static id lastMonitors = nil;
    
    id path = [Definitions frogDir:@"Temp/x11ListMonitors-output.txt"];    
    if ([path fileExists]) {
        long timestampPlusSize = [path fileTimestampPlusSize];
        if (timestampPlusSize == lastTimestampPlusSize) {
            return lastMonitors;
        }
        id monitors = [path linesFromFile];
        if (monitors) {
            lastTimestampPlusSize = timestampPlusSize; 
            [lastMonitors autorelease];
            lastMonitors = monitors;
            [lastMonitors retain];
            return lastMonitors;
        }
    }
    lastTimestampPlusSize = 0;
    id arr = nsarr();
    [arr addObject:@"output:default width:1024 height:768"];
    lastMonitors = arr;
    [lastMonitors retain];
    return lastMonitors;
}
@end






