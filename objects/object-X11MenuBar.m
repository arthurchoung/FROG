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

@interface X11MenuBar : IvarObject
{
    id _configPath;
    time_t _configTimestamp;
    int _flashIteration;
    int _flashIndex;
    BOOL _buttonDown;
    id _selectedDict;
    id _menuDict;
    id _array;

    int _pixelScaling;
    id _scaledFont;

    BOOL _rightButtonDown;
    id _rightButtonArray;
    id _rightButtonFile;

    unsigned long _menuWindowWaitForUnmapNotify;
}
@end

@implementation X11MenuBar

- (void)flashIndex:(int)index duration:(int)duration
{
    if (index < 0) {
        _flashIndex = [_array count] + index;
    } else {
        _flashIndex = index;
    }
    _flashIteration = duration;
}

- (id)init
{
    self = [super init];
    if (self) {
        int scaling = [[Definitions valueForEnvironmentVariable:@"FROG_SCALING"] intValue];
        if (scaling < 1) {
            scaling = 1;
        }
        [self setPixelScaling:scaling];
        id configPath = [Definitions frogDir:@"Config/menuBar.csv"];
        [self setValue:configPath forKey:@"configPath"];
        id rightButtonFile = @"rightButtonMenuBar.csv";
        [self setValue:rightButtonFile forKey:@"rightButtonFile"];
    }
    return self;
}
- (void)setPixelScaling:(int)scaling
{
    _pixelScaling = scaling;
    id scaledFont = [Definitions scaleFont:scaling
                        :[Definitions arrayOfCStringsForWinSystemFont]
                        :[Definitions arrayOfWidthsForWinSystemFont]
                        :[Definitions arrayOfHeightsForWinSystemFont]
                        :[Definitions arrayOfXSpacingsForWinSystemFont]];
    [self setValue:scaledFont forKey:@"scaledFont"];

}

- (id)readMenuBarFromFile:(id)path
{
    id arr = [path parseCSVFile];
    if (!arr) {
        return nil;
    }
    for (int i=0; i<[arr count]; i++) {
        id elt = [arr nth:i];
        if ([elt intValueForKey:@"disable"]) {
            id obj = [Definitions TextMenuItem:@""];
            [elt setValue:obj forKey:@"object"];
        } else {
            id objectMessage = [elt valueForKey:@"objectMessage"];
            if ([objectMessage length]) {
                id obj = [objectMessage evaluateMessage];
                [elt setValue:obj forKey:@"object"];
            }
        }
    }
    return arr;
}
- (void)updateMenuBar
{
    id arr = [self readMenuBarFromFile:_configPath];
    if (arr) {
        [self setValue:arr forKey:@"array"];
    }
}

- (void)dealloc
{
NSLog(@"DEALLOC X11MenuBar");
    [super dealloc];
}

- (BOOL)shouldAnimate
{
    if (_flashIteration > 0) {
        return YES;
    }
    return NO;
}
- (void)beginIteration:(id)x11dict rect:(Int4)r
{
    if (_flashIteration > 0) {
        _flashIteration--;
        return;
    }
    time_t timestamp = [_configPath fileModificationTimestamp];
    if (timestamp != _configTimestamp) {
        [self setValue:nil forKey:@"array"];
        _configTimestamp = timestamp;
        [self updateMenuBar];
    }
}

- (id)fileDescriptorObjects
{
    id results = nsarr();
    for (int i=0; i<[_array count]; i++) {
        id elt = [_array nth:i];
        id obj = [elt valueForKey:@"object"];
        if ([obj respondsToSelector:@selector(fileDescriptor)]) {
            [results addObject:obj];
        }
    }
    if ([results count]) {
        return results;
    }
    return nil;
}
- (id)dictForX:(int)x
{
    return [self dictForX:x array:_array];
}
- (id)dictForX:(int)x array:(id)array
{
    id monitor = [Definitions x11MonitorForX:x y:0];
    int monitorX = [monitor intValueForKey:@"x"];
    int monitorWidth = [monitor intValueForKey:@"width"];
    if ((x < monitorX) || (x >= monitorX+monitorWidth)) {
        return nil;
    }
    for (int i=0; i<[array count]; i++) {
        id elt = [array nth:i];
        int eltX = [elt intValueForKey:@"x"];
        int x1 = (eltX < 0) ? eltX+monitorX+monitorWidth : eltX+monitorX;
        int w1 = [elt intValueForKey:@"width"];
        if ((x >= x1) && (x < x1+w1)) {
            return elt;
        }
    }
    return nil;
}
- (void)handleScrollWheel:(id)event
{
    if (!_buttonDown && !_rightButtonDown) {
        return;
    }

    if (_menuDict) {
        id windowManager = [Definitions windowManager];
        id object = [_menuDict valueForKey:@"object"];
        if ([object respondsToSelector:@selector(handleScrollWheel:)]) {
            int mouseRootX = [event intValueForKey:@"mouseRootX"];
            int mouseRootY = [event intValueForKey:@"mouseRootY"];
            int x = [_menuDict intValueForKey:@"x"];
            int y = [_menuDict intValueForKey:@"y"];
            id newEvent = [windowManager generateEventDictRootX:mouseRootX rootY:mouseRootY x:mouseRootX-x y:mouseRootY-y];
            [newEvent setValue:[event valueForKey:@"deltaX"] forKey:@"deltaX"];
            [newEvent setValue:[event valueForKey:@"deltaY"] forKey:@"deltaY"];
            [newEvent setValue:[event valueForKey:@"scrollingDeltaX"] forKey:@"scrollingDeltaX"];
            [newEvent setValue:[event valueForKey:@"scrollingDeltaY"] forKey:@"scrollingDeltaY"];
            [object handleScrollWheel:newEvent];
            [_menuDict setValue:@"1" forKey:@"needsRedraw"];
        } else if ([object respondsToSelector:@selector(handleScrollWheel:context:)]) {
            int mouseRootX = [event intValueForKey:@"mouseRootX"];
            int mouseRootY = [event intValueForKey:@"mouseRootY"];
            int x = [_menuDict intValueForKey:@"x"];
            int y = [_menuDict intValueForKey:@"y"];
            id newEvent = [windowManager generateEventDictRootX:mouseRootX rootY:mouseRootY x:mouseRootX-x y:mouseRootY-y];
            [newEvent setValue:[event valueForKey:@"deltaX"] forKey:@"deltaX"];
            [newEvent setValue:[event valueForKey:@"deltaY"] forKey:@"deltaY"];
            [newEvent setValue:[event valueForKey:@"scrollingDeltaX"] forKey:@"scrollingDeltaX"];
            [newEvent setValue:[event valueForKey:@"scrollingDeltaY"] forKey:@"scrollingDeltaY"];
            [object handleScrollWheel:newEvent context:_menuDict];
            [_menuDict setValue:@"1" forKey:@"needsRedraw"];
        }
    }
}
- (void)handleKeyDown:(id)event
{
    if (!_buttonDown && !_rightButtonDown) {
        return;
    }

    if (_menuDict) {
        id windowManager = [Definitions windowManager];
        id object = [_menuDict valueForKey:@"object"];
        if ([object respondsToSelector:@selector(handleKeyDown:)]) {
            [object handleKeyDown:event];
            [_menuDict setValue:@"1" forKey:@"needsRedraw"];
        }
    }
}

- (void)handleMouseDown:(id)event
{
    if (_buttonDown || _rightButtonDown) {
NSLog(@"handleMouseDown ignore");
        return;
    }
NSLog(@"handleMouseDown");
    int mouseRootX = [event intValueForKey:@"mouseRootX"];
    id windowManager = [Definitions windowManager];
    int menuBarHeight = [windowManager intValueForKey:@"menuBarHeight"];
    int mouseRootY = [event intValueForKey:@"mouseRootY"];
    if (mouseRootY >= menuBarHeight) {
        return;
    }
    _buttonDown = YES;
    id dict = [self dictForX:mouseRootX];
    [self openRootMenu:dict x:mouseRootX];
}
- (void)handleRightMouseDown:(id)event
{
NSLog(@"handleRightMouseDown");
    if (_buttonDown || _rightButtonDown) {
        return;
    }
    int mouseRootX = [event intValueForKey:@"mouseRootX"];
    id windowManager = [Definitions windowManager];
    int menuBarHeight = [windowManager intValueForKey:@"menuBarHeight"];
    int mouseRootY = [event intValueForKey:@"mouseRootY"];
    if (mouseRootY >= menuBarHeight) {
        return;
    }
    _rightButtonDown = YES;
    if (_rightButtonFile) {
        id path = [Definitions frogDir:nsfmt(@"Config/%@", _rightButtonFile)];
        id arr = [self readMenuBarFromFile:path];
        [self setValue:arr forKey:@"rightButtonArray"];

        id bitmap = [Definitions bitmapWithWidth:1 height:1];
        if (_scaledFont) {
            [bitmap useFont:[[_scaledFont nth:0] bytes]
                        :[[_scaledFont nth:1] bytes]
                        :[[_scaledFont nth:2] bytes]
                        :[[_scaledFont nth:3] bytes]];
        }
        id mouseMonitor = [Definitions x11MonitorForX:mouseRootX y:0];
        int mouseMonitorWidth = [mouseMonitor intValueForKey:@"width"];
        [self layoutMenuBarArray:arr mouseMonitorWidth:mouseMonitorWidth bitmap:bitmap];
        id dict = [self dictForX:mouseRootX array:arr];
        [self openRootMenu:dict x:mouseRootX];
    }

}
- (void)handleMouseUp:(id)event
{
NSLog(@"X11MenuBar handleMouseUp event %@", event);
    if (!_buttonDown) {
        return;
    }

    id windowManager = [Definitions windowManager];

    int mouseRootX = [event intValueForKey:@"mouseRootX"];
    int mouseRootY = [event intValueForKey:@"mouseRootY"];

    if (_menuDict) {
        id object = [_menuDict valueForKey:@"object"];
        if ([object respondsToSelector:@selector(handleMouseUp:)]) {
            int x = [_menuDict intValueForKey:@"x"];
            int y = [_menuDict intValueForKey:@"y"];
            id newEvent = [windowManager generateEventDictRootX:mouseRootX rootY:mouseRootY x:mouseRootX-x y:mouseRootY-y];
            [object handleMouseUp:newEvent];
            [_menuDict setValue:@"1" forKey:@"needsRedraw"];
        } else if ([object respondsToSelector:@selector(handleMouseUp:context:)]) {
            int x = [_menuDict intValueForKey:@"x"];
            int y = [_menuDict intValueForKey:@"y"];
            id newEvent = [windowManager generateEventDictRootX:mouseRootX rootY:mouseRootY x:mouseRootX-x y:mouseRootY-y];
            [object handleMouseUp:newEvent context:_menuDict];
            [_menuDict setValue:@"1" forKey:@"needsRedraw"];
        }
        [self setValue:nil forKey:@"menuDict"];
    }
    _buttonDown = NO;
    [self setValue:nil forKey:@"selectedDict"];




}
- (void)handleRightMouseUp:(id)event
{
NSLog(@"X11MenuBar handleRightMouseUp event %@", event);
    if (!_rightButtonDown) {
        return;
    }

    if (_menuDict) {
        id windowManager = [Definitions windowManager];
        id object = [_menuDict valueForKey:@"object"];
        if ([object respondsToSelector:@selector(handleMouseUp:)]) {
            int mouseRootX = [event intValueForKey:@"mouseRootX"];
            int mouseRootY = [event intValueForKey:@"mouseRootY"];
            int x = [_menuDict intValueForKey:@"x"];
            int y = [_menuDict intValueForKey:@"y"];
            id newEvent = [windowManager generateEventDictRootX:mouseRootX rootY:mouseRootY x:mouseRootX-x y:mouseRootY-y];
            [object handleMouseUp:newEvent];
            [_menuDict setValue:@"1" forKey:@"needsRedraw"];
        } else if ([object respondsToSelector:@selector(handleMouseUp:context:)]) {
            int mouseRootX = [event intValueForKey:@"mouseRootX"];
            int mouseRootY = [event intValueForKey:@"mouseRootY"];
            int x = [_menuDict intValueForKey:@"x"];
            int y = [_menuDict intValueForKey:@"y"];
            id newEvent = [windowManager generateEventDictRootX:mouseRootX rootY:mouseRootY x:mouseRootX-x y:mouseRootY-y];
            [object handleMouseUp:newEvent context:_menuDict];
            [_menuDict setValue:@"1" forKey:@"needsRedraw"];
        }
        [self setValue:nil forKey:@"menuDict"];
    }
    _rightButtonDown = NO;
    [self setValue:nil forKey:@"selectedDict"];
    [self setValue:nil forKey:@"rightButtonArray"];
}

- (void)handleMouseMoved:(id)event
{
    id windowManager = [Definitions windowManager];
    [windowManager setX11Cursor:'5'];
    int mouseRootX = [event intValueForKey:@"mouseRootX"];
    if (!_buttonDown && !_rightButtonDown) {
        return;
    }

    int menuBarHeight = [windowManager intValueForKey:@"menuBarHeight"];
    int mouseRootY = [event intValueForKey:@"mouseRootY"];

    if (mouseRootY < menuBarHeight) {
        id dict = [self dictForX:mouseRootX array:(_buttonDown) ? _array : _rightButtonArray];
        if (dict && (dict != _selectedDict)) {
            [_menuDict setValue:@"1" forKey:@"shouldCloseWindow"];
            [self setValue:nil forKey:@"menuDict"];
            [self setValue:nil forKey:@"selectedDict"];
            [self openRootMenu:dict x:mouseRootX];
            return;
        }
    }

    if (_menuDict) {
        id object = [_menuDict valueForKey:@"object"];
        if ([object respondsToSelector:@selector(handleMouseMoved:)]) {
            int x = [_menuDict intValueForKey:@"x"];
            int y = [_menuDict intValueForKey:@"y"];
            id newEvent = [windowManager generateEventDictRootX:mouseRootX rootY:mouseRootY x:mouseRootX-x y:mouseRootY-y];
            [object handleMouseMoved:newEvent];
            [_menuDict setValue:@"1" forKey:@"needsRedraw"];
        } else if ([object respondsToSelector:@selector(handleMouseMoved:context:)]) {
            int x = [_menuDict intValueForKey:@"x"];
            int y = [_menuDict intValueForKey:@"y"];
            id newEvent = [windowManager generateEventDictRootX:mouseRootX rootY:mouseRootY x:mouseRootX-x y:mouseRootY-y];
            [object handleMouseMoved:newEvent context:_menuDict];
            [_menuDict setValue:@"1" forKey:@"needsRedraw"];
        }
    }

}
- (void)openRootMenu:(id)dict x:(int)mouseRootX
{
    id messageForClick = [dict valueForKey:@"messageForClick"];
    if (!messageForClick) {
        return;
    }
    id obj = [messageForClick evaluateAsMessage];
    if (!obj) {
        return;
    }
    id monitor = [Definitions x11MonitorForX:mouseRootX y:0];
    int monitorX = [monitor intValueForKey:@"x"];
    int monitorWidth = [monitor intValueForKey:@"width"];
    int x = [dict intValueForKey:@"x"];
    if (x < 0) {
        x += monitorX+monitorWidth;
    } else {
        x += monitorX;
    }
    int w = 200;
    if ([obj respondsToSelector:@selector(preferredWidth)]) {
        w = [obj preferredWidth];
    }
    int h = 200;
    if ([obj respondsToSelector:@selector(preferredHeight)]) {
        h = [obj preferredHeight];
    }
    id windowManager = [Definitions windowManager];
if (x+w >= monitorX+monitorWidth) {
    int dictWidth = [dict intValueForKey:@"width"];
    x = x+dictWidth-w;
    if (x < monitorX) {
        if (w > monitorWidth) {
            x = monitorX;
            w = monitorWidth;
        } else {
            x = monitorX+monitorWidth-w;
        }
    }
}



    id menuDict = [windowManager openWindowForObject:obj x:x y:18*_pixelScaling w:w h:h];
    [self setValue:menuDict forKey:@"menuDict"];
    [self setValue:dict forKey:@"selectedDict"];
[windowManager XSetInputFocus:[menuDict unsignedLongValueForKey:@"window"]];
}

- (void)layoutMenuBarArray:(id)array mouseMonitorWidth:(int)mouseMonitorWidth bitmap:(id)bitmap
{
    int flexibleIndex = -1;
    {
        int x = 5*_pixelScaling;
        for (int i=0; i<[array count]; i++) {
            id elt = [array nth:i];
            id obj = [elt valueForKey:@"object"];
            if (!obj) {
                continue;
            }
            int flexible = [elt intValueForKey:@"flexible"];
            int leftPadding = [elt intValueForKey:@"leftPadding"];
            leftPadding *= _pixelScaling;
            int rightPadding = [elt intValueForKey:@"rightPadding"];
            rightPadding *= _pixelScaling;
            int w = 0;
            if (flexible) {
                flexibleIndex = i;
            } else {
                int highestWidth = [elt intValueForKey:@"highestWidth"];
                id text = nil;
                if ([obj respondsToSelector:@selector(text)]) {
                    text = [obj text];
                }
                if (!text) {
                    text = [obj valueForKey:@"text"];
                }
                if (text) {
                    if ([text length]) {
                        w = [bitmap bitmapWidthForText:text];
                        w += leftPadding+rightPadding;
                        if (w > highestWidth) {
                            [elt setValue:nsfmt(@"%d", w) forKey:@"highestWidth"];
                        } else {
                            w = highestWidth;
                        }
                    } else {
                        w = 0;
                        [elt setValue:nil forKey:@"highestWidth"];
                    }
                } else {
                    id pixels = [obj valueForKey:@"pixels"];
                    if (pixels) {
                        w = [Definitions widthForCString:[pixels UTF8String]];
                        w *= _pixelScaling;
                        w += leftPadding+rightPadding;
                        if (w > highestWidth) {
                            [elt setValue:nsfmt(@"%d", w) forKey:@"highestWidth"];
                        } else {
                            w = highestWidth;
                        }
                    } else {
                        w = 100;
                    }
                }
            }
            [elt setValue:nsfmt(@"%d", x) forKey:@"x"];
            [elt setValue:nsfmt(@"%d", w) forKey:@"width"];
            x += w;
        }
        int maxX = mouseMonitorWidth - 5*_pixelScaling;

        int remainingX = maxX - x;
        if (remainingX > 0) {
            if (flexibleIndex != -1) {
                {
                    id elt = [array nth:flexibleIndex];
                    int leftPadding = [elt intValueForKey:@"leftPadding"];
                    leftPadding *= _pixelScaling;
                    int rightPadding = [elt intValueForKey:@"rightPadding"];
                    rightPadding *= _pixelScaling;
                    int oldX = [elt intValueForKey:@"x"];
                    int newW = remainingX - leftPadding - rightPadding;
                    if (newW > 0) {
                        id obj = [elt valueForKey:@"object"];
                        id text = nil;
                        if ([obj respondsToSelector:@selector(text)]) {
                            text = [obj text];
                        }
                        if (!text) {
                            text = [obj valueForKey:@"text"];
                        }
                        if (text) {
                            int w = [bitmap bitmapWidthForText:text];
                            w += leftPadding+rightPadding;
                            if (w < newW) {
                                newW = w;
                            }
                        } else {
                            id pixels = [obj valueForKey:@"pixels"];
                            if (pixels) {
                                int w = [Definitions widthForCString:[pixels UTF8String]];
                                w *= _pixelScaling;
                                w += leftPadding+rightPadding;
                                if (w < newW) {
                                    newW = w;
                                }
                            }
                        }

                        [elt setValue:nsfmt(@"%d", oldX+leftPadding) forKey:@"x"];
                        [elt setValue:nsfmt(@"%d", newW) forKey:@"width"];
                    }
                }
                for (int i=flexibleIndex+1; i<[array count]; i++) {
                    id elt = [array nth:i];
                    int oldX = [elt intValueForKey:@"x"];
                    [elt setValue:nsfmt(@"%d", oldX+remainingX) forKey:@"x"];
                }
            }
        }
    }
}

- (void)drawInBitmap:(id)bitmap rect:(Int4)r
{
    if (_scaledFont) {
        [bitmap useFont:[[_scaledFont nth:0] bytes]
                    :[[_scaledFont nth:1] bytes]
                    :[[_scaledFont nth:2] bytes]
                    :[[_scaledFont nth:3] bytes]];
    }

    [bitmap setColor:@"white"];
    [bitmap fillRect:r];
    [bitmap setColor:@"black"];
    for (int i=0; i<_pixelScaling*2; i++) {
        [bitmap drawHorizontalLineAtX:r.x x:r.x+r.w-1 y:19*_pixelScaling+i];
    }
    id windowManager = [Definitions windowManager];
    int mouseRootX = [windowManager intValueForKey:@"mouseX"];
    id mouseMonitor = [Definitions x11MonitorForX:mouseRootX y:0];

    id monitors = [Definitions x11MonitorConfig];
    for (int monitorI=0; monitorI<[monitors count]; monitorI++) {
        id monitor = [monitors nth:monitorI];
        int monitorX = [monitor intValueForKey:@"x"];
        int monitorWidth = [monitor intValueForKey:@"width"];
        if ([monitor intValueForKey:@"x"] != [mouseMonitor intValueForKey:@"x"]) {
            int monitorIndex = 0;
            id text = nsarr();
            int textHeight = [bitmap bitmapHeightForText:@"X"];
            for (int i=0; i<[monitors count]; i++) {
                id elt = [monitors nth:i];
                if ([elt intValueForKey:@"x"] == [mouseMonitor intValueForKey:@"x"]) {
                    [text addObject:nsfmt(@"This is monitor %d (%@). Pointer is on monitor %d (%@) x:%d y:%d", monitorI+1, [monitor valueForKey:@"output"], monitorIndex+1, [elt valueForKey:@"output"], mouseRootX, [windowManager intValueForKey:@"mouseY"])];
                }
                monitorIndex++;
            }
            [bitmap setColorIntR:0x00 g:0x00 b:0x00 a:0xff];
            [bitmap drawBitmapText:[text join:@""] x:monitorX+5*2*_pixelScaling y:4*_pixelScaling];
        }
    }

    int mouseMonitorX = [mouseMonitor intValueForKey:@"x"];
    int mouseMonitorWidth = [mouseMonitor intValueForKey:@"width"];

    id array = _array;
    if (_rightButtonDown) {
        if (_rightButtonArray) {
            array = _rightButtonArray;
        }
    }

    [self layoutMenuBarArray:array mouseMonitorWidth:mouseMonitorWidth bitmap:bitmap];

    for (int i=0; i<[array count]; i++) {
        id elt = [array nth:i];
        Int4 r1 = r;
        int eltX = [elt intValueForKey:@"x"];
        r1.x = r.x+mouseMonitorX+eltX;
        r1.w = [elt intValueForKey:@"width"];

        Int4 r2 = r1;
        r2.y += 1*_pixelScaling;
        r2.h -= 1*_pixelScaling;
        id obj = [elt valueForKey:@"object"];
        int leftPadding = [elt intValueForKey:@"leftPadding"];
        leftPadding *= _pixelScaling;
        int rightPadding = [elt intValueForKey:@"rightPadding"];
        rightPadding *= _pixelScaling;

        int flexible = [elt intValueForKey:@"flexible"];
        unsigned long window = [elt unsignedLongValueForKey:@"window"];

        BOOL highlight = NO;
        if (_buttonDown) {
            highlight = YES;
        } else if (_rightButtonDown) {
            highlight = YES;
        }
        if (highlight) {
            if (_selectedDict == elt) {
            } else {
                highlight = NO;
            }
        } else if (_flashIteration > 0) {
            if (i == _flashIndex) {
                highlight = YES;
            }
        }
        
        if (highlight) {
            id text = nil;
            if ([obj respondsToSelector:@selector(text)]) {
                text = [obj text];
            }
            if (!text) {
                text = [obj valueForKey:@"text"];
            }
            if (text) {
                Int4 r3 = r2;
                r3.x += leftPadding;
                r3.w -= leftPadding+rightPadding;
                [bitmap setColor:@"black"];
                [bitmap fillRect:r2];
                [bitmap setColor:@"white"];
                if (flexible) {
                    int textWidth = [bitmap bitmapWidthForText:text];
                    if (textWidth > r3.w) {
                        text = [[[bitmap fitBitmapString:text width:r3.w] split:@"\n"] nth:0];
                    }
                }
                [bitmap drawBitmapText:text x:r3.x y:r3.y+3*_pixelScaling];

            } else {
                id palette = [obj valueForKey:@"highlightedPalette"];
                if (!palette) {
                    palette = [obj valueForKey:@"palette"];
                }
                if (palette) {
                    id pixels = [obj valueForKey:@"pixels"];
                    if (pixels) {
                        Int4 r3 = r2;
                        r3.x += leftPadding;
                        r3.y -= 1;
                        r3.w -= leftPadding+rightPadding;
                        [bitmap setColor:@"black"];
                        [bitmap fillRect:r2];
                        [bitmap setColor:@"white"];
                        pixels = [pixels asXYScaledPixels:_pixelScaling];
                        [bitmap drawCString:[pixels UTF8String] palette:[palette UTF8String] x:r3.x y:r3.y];
                    }
                }
            }
        } else {
            id text = nil;
            if ([obj respondsToSelector:@selector(text)]) {
                text = [obj text];
            }
            if (!text) {
                text = [obj valueForKey:@"text"];
            }
            if ([text length]) {
                Int4 r3 = r2;
                r3.x += leftPadding;
                r3.w -= leftPadding+rightPadding;
                [bitmap setColor:@"black"];
                if (flexible) {
                    int textWidth = [bitmap bitmapWidthForText:text];
                    if (textWidth > r3.w) {
                        text = [[[bitmap fitBitmapString:text width:r3.w] split:@"\n"] nth:0];
                    }
                }
                [bitmap drawBitmapText:text x:r3.x y:r3.y+3*_pixelScaling];

            } else {
                id palette = [obj valueForKey:@"palette"];
                if (palette) {
                    id pixels = [obj valueForKey:@"pixels"];
                    if (pixels) {
                        Int4 r3 = r2;
                        r3.x += leftPadding;
                        r3.y -= 1;
                        r3.w -= leftPadding+rightPadding;
                        [bitmap setColor:@"black"];
                        pixels = [pixels asXYScaledPixels:_pixelScaling];
                        [bitmap drawCString:[pixels UTF8String] palette:[palette UTF8String] x:r3.x y:r3.y];
                    }
                }
            }
        }
    }
    
}
@end
