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

@implementation Definitions(jfovcnvieiwejfklsdjfklsdjlkfjsdlkffdjskfjklsdjfkljjfkdsjf)
+ (void)enterWin30Mode
{
    [Definitions enterWin30Mode:1];
}
+ (void)enterWin30Mode:(int)scaling
{
    if (scaling < 1) {
        scaling = 1;
    }
    [Definitions setValue:nsfmt(@"%d", scaling) forEnvironmentVariable:@"FROG_SCALING"];

    id windowManager = [Definitions windowManager];
    [windowManager setFocusDict:nil];
    [windowManager unparentAllWindows];

    [windowManager setBackgroundForCString:"b\n" palette:"b #c3c7cb\n"];

    id rootWindowObject = [@"X11RootWindow" asInstance];
    [windowManager setValue:rootWindowObject forKey:@"rootWindowObject"];
    [windowManager reparentAllWindows:@"X11Window"];
    [[windowManager valueForKey:@"menuBar"] setValue:@"1" forKey:@"shouldCloseWindow"];
    int h = 20*scaling;
    [windowManager setValue:nsfmt(@"%d", h) forKey:@"menuBarHeight"];
    id menuBarObject = [@"X11MenuBar" asInstance];
    id menuBar = [windowManager openWindowForObject:menuBarObject x:0 y:0 w:[windowManager intValueForKey:@"rootWindowWidth"] h:h];
    [windowManager setValue:menuBar forKey:@"menuBar"];
    [windowManager setFocusDict:nil];

    [windowManager hackBecauseThePeopleWhoWroteJavaAreBrainDead];
}
@end

static id paletteFormat =
@"b #000000\n"
@". %@\n"
@"X #ffff00\n"
@"o #868a8e\n"
@"O #c3c7cb\n"
@"+ #ffffff\n"
@"t %@\n"
@"T %@\n"
;
static char *activeTitleBarLeftPixels =
"bbbbbbbbbbbbbbbbbbbbbbb\n"
"b.....................b\n"
"b.....................b\n"
"b..bbbbbbbbbbbbbbbbbbbb\n"
"b..bOOOOOOOOOOOOOOOOOOb\n"
"b..bOOOOOOOOOOOOOOOOOOb\n"
"b..bOOOOOOOOOOOOOOOOOOb\n"
"b..bOOOOOOOOOOOOOOOOOOb\n"
"b..bOOOOOOOOOOOOOOOOOOb\n"
"b..bOOOOOOOOOOOOOOOOOOb\n"
"b..bOOOOOOOOOOOOOOOOOOb\n"
"b..bOObbbbbbbbbbbbbOOOb\n"
"b..bOOb+++++++++++boOOb\n"
"b..bOObbbbbbbbbbbbboOOb\n"
"b..bOOOoooooooooooooOOb\n"
"b..bOOOOOOOOOOOOOOOOOOb\n"
"b..bOOOOOOOOOOOOOOOOOOb\n"
"b..bOOOOOOOOOOOOOOOOOOb\n"
"b..bOOOOOOOOOOOOOOOOOOb\n"
"b..bOOOOOOOOOOOOOOOOOOb\n"
"b..bOOOOOOOOOOOOOOOOOOb\n"
"b..bOOOOOOOOOOOOOOOOOOb\n"
"bbbbbbbbbbbbbbbbbbbbbbb\n"
;
static char *inactiveTitleBarLeftPixels =
"bbbb\n"
"b...\n"
"b...\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"bbbb\n"
;
static char *activeTitleBarMiddlePixels =
"bb\n"
"..\n"
"..\n"
"bb\n"
"tT\n"
"Tt\n"
"tT\n"
"Tt\n"
"tT\n"
"Tt\n"
"tT\n"
"Tt\n"
"tT\n"
"Tt\n"
"tT\n"
"Tt\n"
"tT\n"
"Tt\n"
"tT\n"
"Tt\n"
"tT\n"
"Tt\n"
"bb\n"
;
static char *activeTitleBarRightPixels =
"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\n"
"...................b.....................b\n"
"...................b.....................b\n"
"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb..b\n"
"b+++++++++++++++++ob+++++++++++++++++ob..b\n"
"b+OOOOOOOOOOOOOOOoob+OOOOOOOOOOOOOOOoob..b\n"
"b+OOOOOOOOOOOOOOOoob+OOOOOOOOOOOOOOOoob..b\n"
"b+OOOOOOOOOOOOOOOoob+OOOOOOOOOOOOOOOoob..b\n"
"b+OOOOOOOOOOOOOOOoob+OOOOOOOOOOOOOOOoob..b\n"
"b+OOOOOOOOOOOOOOOoob+OOOOOOOOOOOOOOOoob..b\n"
"b+OOOOOOOOOOOOOOOoob+OOOOOOObOOOOOOOoob..b\n"
"b+OOOObbbbbbbOOOOoob+OOOOOObbbOOOOOOoob..b\n"
"b+OOOOObbbbbOOOOOoob+OOOOObbbbbOOOOOoob..b\n"
"b+OOOOOObbbOOOOOOoob+OOOObbbbbbbOOOOoob..b\n"
"b+OOOOOOObOOOOOOOoob+OOOOOOOOOOOOOOOoob..b\n"
"b+OOOOOOOOOOOOOOOoob+OOOOOOOOOOOOOOOoob..b\n"
"b+OOOOOOOOOOOOOOOoob+OOOOOOOOOOOOOOOoob..b\n"
"b+OOOOOOOOOOOOOOOoob+OOOOOOOOOOOOOOOoob..b\n"
"b+OOOOOOOOOOOOOOOoob+OOOOOOOOOOOOOOOoob..b\n"
"b+OOOOOOOOOOOOOOOoob+OOOOOOOOOOOOOOOoob..b\n"
"b+ooooooooooooooooob+ooooooooooooooooob..b\n"
"booooooooooooooooooboooooooooooooooooob..b\n"
"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\n"
;
static char *inactiveTitleBarRightPixels =
"bbbb\n"
"...b\n"
"...b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"bbbb\n"
;
static char *leftBorderMiddlePixels =
"b..b\n"
;
static char *leftBorderBottomPixels =
"bbbb\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
;
static char *bottomBorderLeftPixels =
"b..bbbbbbbbbbbbbbbbbbbb\n"
"b.....................b\n"
"b.....................b\n"
"bbbbbbbbbbbbbbbbbbbbbbb\n"
;
static char *bottomBorderMiddlePixels =
"b\n"
".\n"
".\n"
"b\n"
;
static char *bottomBorderRightPixels =
"bbbbbbbbbbbbbbbbbbbb..b\n"
"b.....................b\n"
"b.....................b\n"
"bbbbbbbbbbbbbbbbbbbbbbb\n"
;
static char *rightBorderMiddlePixels =
"b..b\n"
;
static char *rightBorderBottomPixels =
"bbbb\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
"b..b\n"
;
static char *minimizeButtonDownPixels =
"oooooooooooooooooo\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOObbbbbbbOOOOO\n"
"oOOOOOObbbbbOOOOOO\n"
"oOOOOOOObbbOOOOOOO\n"
"oOOOOOOOObOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
;
static char *maximizeButtonDownPixels =
"oooooooooooooooooo\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOObOOOOOOOO\n"
"oOOOOOOObbbOOOOOOO\n"
"oOOOOOObbbbbOOOOOO\n"
"oOOOOObbbbbbbOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
;
static char *closeButtonDownPixels =
"oooooooooooooooooo\n"
"oooooooooooooooooo\n"
"oooooooooooooooooo\n"
"oooooooooooooooooo\n"
"oooooooooooooooooo\n"
"oooooooooooooooooo\n"
"oooooooooooooooooo\n"
"oo+++++++++++++ooo\n"
"oo+bbbbbbbbbbb+Ooo\n"
"oo+++++++++++++Ooo\n"
"oooOOOOOOOOOOOOOoo\n"
"oooooooooooooooooo\n"
"oooooooooooooooooo\n"
"oooooooooooooooooo\n"
"oooooooooooooooooo\n"
"oooooooooooooooooo\n"
"oooooooooooooooooo\n"
"oooooooooooooooooo\n"
;
static char *smallCloseButtonPixels =
"OOOOOOOOOOOOOOOOOO\n"
"OOOOOOOOOOOOOOOOOO\n"
"OOOOOOOOOOOOOOOOOO\n"
"OOOOOOOOOOOOOOOOOO\n"
"OOOOOOOOOOOOOOOOOO\n"
"OOOOOOOOOOOOOOOOOO\n"
"OOOOOOOOOOOOOOOOOO\n"
"OOOOOObbbbbbbOOOOO\n"
"OOOOOOb+++++boOOOO\n"
"OOOOOObbbbbbboOOOO\n"
"OOOOOOOoooooooOOOO\n"
"OOOOOOOOOOOOOOOOOO\n"
"OOOOOOOOOOOOOOOOOO\n"
"OOOOOOOOOOOOOOOOOO\n"
"OOOOOOOOOOOOOOOOOO\n"
"OOOOOOOOOOOOOOOOOO\n"
"OOOOOOOOOOOOOOOOOO\n"
"OOOOOOOOOOOOOOOOOO\n"
;
static char *smallCloseButtonDownPixels =
"oooooooooooooooooo\n"
"oooooooooooooooooo\n"
"oooooooooooooooooo\n"
"oooooooooooooooooo\n"
"oooooooooooooooooo\n"
"oooooooooooooooooo\n"
"oooooooooooooooooo\n"
"oooooo+++++++ooooo\n"
"oooooo+bbbbb+Ooooo\n"
"oooooo+++++++Ooooo\n"
"oooooooOOOOOOOoooo\n"
"oooooooooooooooooo\n"
"oooooooooooooooooo\n"
"oooooooooooooooooo\n"
"oooooooooooooooooo\n"
"oooooooooooooooooo\n"
"oooooooooooooooooo\n"
"oooooooooooooooooo\n"
;
static char *revertButtonPixels =
"+++++++++++++++++o\n"
"+OOOOOOOOOOOOOOOoo\n"
"+OOOOOOOOOOOOOOOoo\n"
"+OOOOOOOOOOOOOOOoo\n"
"+OOOOOOObOOOOOOOoo\n"
"+OOOOOObbbOOOOOOoo\n"
"+OOOOObbbbbOOOOOoo\n"
"+OOOObbbbbbbOOOOoo\n"
"+OOOOOOOOOOOOOOOoo\n"
"+OOOOOOOOOOOOOOOoo\n"
"+OOOObbbbbbbOOOOoo\n"
"+OOOOObbbbbOOOOOoo\n"
"+OOOOOObbbOOOOOOoo\n"
"+OOOOOOObOOOOOOOoo\n"
"+OOOOOOOOOOOOOOOoo\n"
"+OOOOOOOOOOOOOOOoo\n"
"+ooooooooooooooooo\n"
"oooooooooooooooooo\n"
;
static char *revertButtonDownPixels =
"oooooooooooooooooo\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOObOOOOOOOO\n"
"oOOOOOOObbbOOOOOOO\n"
"oOOOOOObbbbbOOOOOO\n"
"oOOOOObbbbbbbOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOObbbbbbbOOOOO\n"
"oOOOOOObbbbbOOOOOO\n"
"oOOOOOOObbbOOOOOOO\n"
"oOOOOOOOObOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
"oOOOOOOOOOOOOOOOOO\n"
;

@interface X11Window : IvarObject
{
    int _leftBorder;
    int _rightBorder;
    int _topBorder;
    int _bottomBorder;

    char _buttonDown;
    char _buttonHover;
    int _buttonDownX;
    int _buttonDownY;
    int _buttonDownW;
    int _buttonDownH;
    Int4 _titleBarRect;
    Int4 _titleBarTextRect;
    Int4 _leftBorderRect;
    Int4 _rightBorderRect;
    Int4 _topBorderRect;
    Int4 _bottomBorderRect;
    Int4 _closeButtonRect;
    Int4 _minimizeButtonRect;
    Int4 _maximizeButtonRect;
    Int4 _resizeButtonRect;

    id _hasFocusPalette;
    id _noFocusPalette;

    // setPixelScale:
    int _pixelScaling;
    id _scaledFont;
    id _scaledActiveTitleBarLeftPixels;
    id _scaledInactiveTitleBarLeftPixels;
    int _scaledActiveTitleBarLeftWidth;
    id _scaledActiveTitleBarMiddlePixels;
    int _scaledActiveTitleBarHeight;
    id _scaledActiveTitleBarRightPixels;
    id _scaledInactiveTitleBarRightPixels;
    int _scaledActiveTitleBarRightWidth;
    id _scaledLeftBorderMiddlePixels;
    id _scaledLeftBorderBottomPixels;
    id _scaledBottomBorderLeftPixels;
    id _scaledBottomBorderMiddlePixels;
    id _scaledBottomBorderRightPixels;
    id _scaledRightBorderMiddlePixels;
    id _scaledRightBorderBottomPixels;
    id _scaledMinimizeButtonDownPixels;
    id _scaledMaximizeButtonDownPixels;
    id _scaledCloseButtonDownPixels;

    id _inactiveTitleBarTextColor;

}
@end
@implementation X11Window
- (id)init
{
    self = [super init];
    if (self) {
        int scaling = [[Definitions valueForEnvironmentVariable:@"FROG_SCALING"] intValue];
        if (scaling < 1) {
            scaling = 1;
        }
        [self setPixelScaling:scaling];
        id color1 = @"#868a8e";
        id color2 = @"#0000aa";
        id color3 = @"#c3c7cb";
        id color4 = @"#ffffff";
        [self setValue:@"#000000" forKey:@"inactiveTitleBarTextColor"];
        
        [self setValue:nsfmt(paletteFormat, color1, @"#55aaaa", @"#5555aa") forKey:@"hasFocusPalette"];
        [self setValue:nsfmt(paletteFormat, color3, color4, color4) forKey:@"noFocusPalette"];
    }
    return self;
}
- (void)setPixelScaling:(int)scaling
{
    _pixelScaling = scaling;

    _leftBorder = 4*scaling;
    _rightBorder = 4*scaling;
    _topBorder = 23*scaling;
    _bottomBorder = 4*scaling;

    id obj;
    obj = [Definitions scaleFont:scaling
                    :[Definitions arrayOfCStringsForWinSystemFont]
                    :[Definitions arrayOfWidthsForWinSystemFont]
                    :[Definitions arrayOfHeightsForWinSystemFont]
                    :[Definitions arrayOfXSpacingsForWinSystemFont]];
    [self setValue:obj forKey:@"scaledFont"];

    obj = [nsfmt(@"%s", activeTitleBarLeftPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledActiveTitleBarLeftPixels"];
    _scaledActiveTitleBarLeftWidth = [Definitions widthForCString:[obj UTF8String]];

    obj = [nsfmt(@"%s", inactiveTitleBarLeftPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledInactiveTitleBarLeftPixels"];

    obj = [nsfmt(@"%s", activeTitleBarMiddlePixels) asYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledActiveTitleBarMiddlePixels"];
    _scaledActiveTitleBarHeight = [Definitions heightForCString:[obj UTF8String]];

    obj = [nsfmt(@"%s", activeTitleBarRightPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledActiveTitleBarRightPixels"];
    _scaledActiveTitleBarRightWidth = [Definitions widthForCString:[obj UTF8String]];

    obj = [nsfmt(@"%s", inactiveTitleBarRightPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledInactiveTitleBarRightPixels"];

    obj = [nsfmt(@"%s", leftBorderMiddlePixels) asXScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledLeftBorderMiddlePixels"];

    obj = [nsfmt(@"%s", leftBorderBottomPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledLeftBorderBottomPixels"];

    obj = [nsfmt(@"%s", bottomBorderLeftPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledBottomBorderLeftPixels"];

    obj = [nsfmt(@"%s", bottomBorderMiddlePixels) asYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledBottomBorderMiddlePixels"];

    obj = [nsfmt(@"%s", bottomBorderRightPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledBottomBorderRightPixels"];

    obj = [nsfmt(@"%s", rightBorderMiddlePixels) asXScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledRightBorderMiddlePixels"];

    obj = [nsfmt(@"%s", rightBorderBottomPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledRightBorderBottomPixels"];

    obj = [nsfmt(@"%s", minimizeButtonDownPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledMinimizeButtonDownPixels"];

    obj = [nsfmt(@"%s", maximizeButtonDownPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledMaximizeButtonDownPixels"];

    obj = [nsfmt(@"%s", closeButtonDownPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledCloseButtonDownPixels"];
}

- (void)calculateRects:(Int4)r
{
    _titleBarRect = [Definitions rectWithX:r.x y:r.y w:r.w h:_scaledActiveTitleBarHeight];
    _titleBarTextRect = _titleBarRect;
    _titleBarTextRect.x = _scaledActiveTitleBarLeftWidth+4*_pixelScaling;
    _titleBarTextRect.w -= _scaledActiveTitleBarLeftWidth+4*_pixelScaling;
    _titleBarTextRect.w -= _scaledActiveTitleBarRightWidth+4*_pixelScaling;

    _leftBorderRect = r;
    _leftBorderRect.y += _scaledActiveTitleBarHeight;
    _leftBorderRect.h -= _scaledActiveTitleBarHeight;
    _leftBorderRect.h -= _bottomBorder;
    _leftBorderRect.w = _leftBorder;

    _rightBorderRect = r;
    _rightBorderRect.x += r.w-_rightBorder;
    _rightBorderRect.y += _scaledActiveTitleBarHeight;
    _rightBorderRect.h -= _scaledActiveTitleBarHeight;
    _rightBorderRect.h -= _bottomBorder;
    _rightBorderRect.w = _rightBorder;

    _topBorderRect = _titleBarRect;
    _topBorderRect.h = 4*_pixelScaling;

    _bottomBorderRect = _titleBarRect;
    _bottomBorderRect.y += r.h-_bottomBorder;
    _bottomBorderRect.h = _bottomBorder;

    _closeButtonRect = _titleBarRect;
    _closeButtonRect.x += 4*_pixelScaling;
    _closeButtonRect.y += 4*_pixelScaling;
    _closeButtonRect.w = 18*_pixelScaling;
    _closeButtonRect.h = 18*_pixelScaling;

    _minimizeButtonRect = _titleBarRect;
    _minimizeButtonRect.x = _minimizeButtonRect.x+_minimizeButtonRect.w-(4+18+1+18)*_pixelScaling;
    _minimizeButtonRect.y += 4*_pixelScaling;
    _minimizeButtonRect.w = 18*_pixelScaling;
    _minimizeButtonRect.h = 18*_pixelScaling;

    _maximizeButtonRect = _titleBarRect;
    _maximizeButtonRect.x = _maximizeButtonRect.x+_maximizeButtonRect.w-(4+18)*_pixelScaling;
    _maximizeButtonRect.y += 4*_pixelScaling;
    _maximizeButtonRect.w = 18*_pixelScaling;
    _maximizeButtonRect.h = 18*_pixelScaling;
}
- (void)drawInBitmap:(id)bitmap rect:(Int4)r
{
    [self drawInBitmap:bitmap rect:r context:nil];
}
- (void)drawInBitmap:(id)bitmap rect:(Int4)r context:(id)context
{

    if (_scaledFont) {
        [bitmap useFont:[[_scaledFont nth:0] bytes]
                    :[[_scaledFont nth:1] bytes]
                    :[[_scaledFont nth:2] bytes]
                    :[[_scaledFont nth:3] bytes]];
    }

    char *palette = [_hasFocusPalette UTF8String];
    int hasFocus = [context intValueForKey:@"hasFocus"];
    if (!hasFocus) {
        palette = [_noFocusPalette UTF8String];
    }

    [self calculateRects:r];
    [bitmap setColor:@"white"];
    [bitmap fillRect:r];
    [bitmap setColor:@"black"];
    [bitmap drawHorizontalLineAtX:r.x x:r.x+r.w-1 y:r.y+r.h-1];
    [bitmap drawVerticalLineAtX:r.x+r.w-1 y:r.y y:r.y+r.h-1];
    {
        char *left;
        if (hasFocus) {
            left = [_scaledActiveTitleBarLeftPixels UTF8String];
        } else {
            left = [_scaledInactiveTitleBarLeftPixels UTF8String];
        }
        char *middle = [_scaledActiveTitleBarMiddlePixels UTF8String];
        char *right;
        if (hasFocus) {
            right = [_scaledActiveTitleBarRightPixels UTF8String];
        } else {
            right = [_scaledInactiveTitleBarRightPixels UTF8String];
        }
        [Definitions drawInBitmap:bitmap left:left palette:palette middle:middle palette:palette right:right palette:palette x:_titleBarRect.x y:_titleBarRect.y w:_titleBarRect.w];
    }
    if (_titleBarTextRect.w > 0) {
        id text = [context valueForKey:@"name"];
        if (!text) {
            text = @"(no title)";
        }

        text = [[[bitmap fitBitmapString:text width:_titleBarTextRect.w-14*_pixelScaling] split:@"\n"] nth:0];
        if (text) {
            int textWidth = [bitmap bitmapWidthForText:text];
            int backWidth = textWidth + 14*_pixelScaling;
            int backX = _titleBarTextRect.x + ((_titleBarTextRect.w - backWidth) / 2);
            int textX = backX + 7*_pixelScaling;
            if (hasFocus) {
                [bitmap setColor:@"white"];
                [bitmap drawBitmapText:text x:textX y:_titleBarTextRect.y+7*_pixelScaling];
            } else {
                if (_inactiveTitleBarTextColor) {
                    [bitmap setColor:_inactiveTitleBarTextColor];
                } else {
                    [bitmap setColor:@"white"];
                }
                [bitmap drawBitmapText:text x:textX y:_titleBarTextRect.y+7*_pixelScaling];
            }
        }
    }

    {
        char *middle = [_scaledLeftBorderMiddlePixels UTF8String];
        char *bottom = [_scaledLeftBorderBottomPixels UTF8String];
        [Definitions drawInBitmap:bitmap top:middle palette:palette middle:middle palette:palette bottom:bottom palette:palette x:_leftBorderRect.x y:_leftBorderRect.y h:_leftBorderRect.h];
    }
    {
        char *top = [_scaledRightBorderMiddlePixels UTF8String];
        char *middle = top;
        char *bottom = [_scaledRightBorderBottomPixels UTF8String];
        [Definitions drawInBitmap:bitmap top:top palette:palette middle:middle palette:palette bottom:bottom palette:palette x:_rightBorderRect.x y:_rightBorderRect.y h:_rightBorderRect.h];
    }

    {
        Int4 r = _bottomBorderRect;
        char *left = [_scaledBottomBorderLeftPixels UTF8String];
        char *middle = [_scaledBottomBorderMiddlePixels UTF8String];
        char *right = [_scaledBottomBorderRightPixels UTF8String];
        [Definitions drawInBitmap:bitmap left:left middle:middle right:right x:r.x y:r.y w:r.w palette:palette];
    }

    if (hasFocus) {
        if ((_buttonDown == 'c') && (_buttonHover == 'c')) {
            char *closeButtonDown = [_scaledCloseButtonDownPixels UTF8String];
            [bitmap drawCString:closeButtonDown palette:palette x:_closeButtonRect.x y:_closeButtonRect.y];
        }
        if ((_buttonDown == 'm') && (_buttonHover == 'm')) {
            char *minimizeButtonDown = [_scaledMinimizeButtonDownPixels UTF8String];
            [bitmap drawCString:minimizeButtonDown palette:palette x:_minimizeButtonRect.x y:_minimizeButtonRect.y];
        }
        if ((_buttonDown == 'M') && (_buttonHover == 'M')) {
            char *maximizeButtonDown = [_scaledMaximizeButtonDownPixels UTF8String];
            [bitmap drawCString:maximizeButtonDown palette:palette x:_maximizeButtonRect.x y:_maximizeButtonRect.y];
        }
        if (_buttonDown == 't') {
// FIXME: pixel scaling
            char *black = "b #000000\n";
            char *white = "b #ffffff\n";
            char *gray  = "b #55aaaa\n";
            for (int i=0; i<r.w; i++) {
                int j = 0;
                int x = r.x+i;
                int y = r.y+j;
                if ((i+j) % 2 == 0) {
                    [bitmap drawCString:"b\n" palette:black x:x y:y];
                } else {
                    [bitmap drawCString:"b\n" palette:white x:x y:y];
                }
            }
            for (int i=0; i<r.w; i++) {
                int j = r.h-1;
                int x = r.x+i;
                int y = r.y+j;
                if ((i+j) % 2 == 0) {
                    [bitmap drawCString:"b\n" palette:black x:x y:y];
                } else {
                    [bitmap drawCString:"b\n" palette:white x:x y:y];
                }
            }
            for (int j=0; j<r.h; j++) {
                int i = 0;
                int x = r.x+i;
                int y = r.y+j;
                if ((i+j) % 2 == 0) {
                    [bitmap drawCString:"b\n" palette:black x:x y:y];
                } else {
                    [bitmap drawCString:"b\n" palette:white x:x y:y];
                }
            }
            for (int j=0; j<r.h; j++) {
                int i = r.w-1;
                int x = r.x+i;
                int y = r.y+j;
                if ((i+j) % 2 == 0) {
                    [bitmap drawCString:"b\n" palette:black x:x y:y];
                } else {
                    [bitmap drawCString:"b\n" palette:white x:x y:y];
                }
            }
            //
            for (int i=1; i<r.w-1; i++) {
                for (int j=1; j<=2; j++) {
                    int x = r.x+i;
                    int y = r.y+j;
                    if ((i+j) % 2 == 1) {
                        [bitmap drawCString:"b\n" palette:gray x:x y:y];
                    }
                }
                for (int j=r.h-3; j<=r.h-2; j++) {
                    int x = r.x+i;
                    int y = r.y+j;
                    if ((i+j) % 2 == 1) {
                        [bitmap drawCString:"b\n" palette:gray x:x y:y];
                    }
                }
            }
            for (int j=3; j<r.h-3; j++) {
                for (int i=1; i<=2; i++) {
                    int x = r.x+i;
                    int y = r.y+j;
                    if ((i+j) % 2 == 1) {
                        [bitmap drawCString:"b\n" palette:gray x:x y:y];
                    }
                }
                for (int i=r.w-3; i<=r.w-2; i++) {
                    int x = r.x+i;
                    int y = r.y+j;
                    if ((i+j) % 2 == 1) {
                        [bitmap drawCString:"b\n" palette:gray x:x y:y];
                    }
                }
            }
            //
            {
                int i = 22;
                for (int j=1; j<=2; j++) {
                    int x = r.x+i;
                    int y = r.y+j;
                    if ((i+j) % 2 == 0) {
                        [bitmap drawCString:"b\n" palette:black x:x y:y];
                    } else {
                        [bitmap drawCString:"b\n" palette:white x:x y:y];
                    }
                }
                for (int j=r.h-3; j<=r.h-2; j++) {
                    int x = r.x+i;
                    int y = r.y+j;
                    if ((i+j) % 2 == 0) {
                        [bitmap drawCString:"b\n" palette:black x:x y:y];
                    } else {
                        [bitmap drawCString:"b\n" palette:white x:x y:y];
                    }
                }
            }
            {
                int i = r.w-23;
                for (int j=1; j<=2; j++) {
                    int x = r.x+i;
                    int y = r.y+j;
                    if ((i+j) % 2 == 0) {
                        [bitmap drawCString:"b\n" palette:black x:x y:y];
                    } else {
                        [bitmap drawCString:"b\n" palette:white x:x y:y];
                    }
                }
                for (int j=r.h-3; j<=r.h-2; j++) {
                    int x = r.x+i;
                    int y = r.y+j;
                    if ((i+j) % 2 == 0) {
                        [bitmap drawCString:"b\n" palette:black x:x y:y];
                    } else {
                        [bitmap drawCString:"b\n" palette:white x:x y:y];
                    }
                }
            }
            {
                int j = 22;
                for (int i=1; i<=2; i++) {
                    int x = r.x+i;
                    int y = r.y+j;
                    if ((i+j) % 2 == 0) {
                        [bitmap drawCString:"b\n" palette:black x:x y:y];
                    } else {
                        [bitmap drawCString:"b\n" palette:white x:x y:y];
                    }
                }
                for (int i=r.w-3; i<=r.w-2; i++) {
                    int x = r.x+i;
                    int y = r.y+j;
                    if ((i+j) % 2 == 0) {
                        [bitmap drawCString:"b\n" palette:black x:x y:y];
                    } else {
                        [bitmap drawCString:"b\n" palette:white x:x y:y];
                    }
                }
            }
            {
                int j = r.h-23;
                for (int i=1; i<=2; i++) {
                    int x = r.x+i;
                    int y = r.y+j;
                    if ((i+j) % 2 == 0) {
                        [bitmap drawCString:"b\n" palette:black x:x y:y];
                    } else {
                        [bitmap drawCString:"b\n" palette:white x:x y:y];
                    }
                }
                for (int i=r.w-3; i<=r.w-2; i++) {
                    int x = r.x+i;
                    int y = r.y+j;
                    if ((i+j) % 2 == 0) {
                        [bitmap drawCString:"b\n" palette:black x:x y:y];
                    } else {
                        [bitmap drawCString:"b\n" palette:white x:x y:y];
                    }
                }
            }
        }
        if (_buttonDown == 'r') {
// FIXME: pixel scaling
            char *palette = "b #000000\nw #ffffff\n";
            char *h = [Definitions cStringForMacWindowSelectionHorizontal];
            char *v = [Definitions cStringForMacWindowSelectionVertical];
            [Definitions drawInBitmap:bitmap left:h middle:h right:h x:r.x y:r.y w:r.w palette:palette];
            [Definitions drawInBitmap:bitmap left:h middle:h right:h x:r.x y:r.y+18 w:r.w palette:palette];
            [Definitions drawInBitmap:bitmap top:v palette:palette middle:v palette:palette bottom:v palette:palette x:r.x y:r.y+1 h:r.h-2];
            [Definitions drawInBitmap:bitmap top:v palette:palette middle:v palette:palette bottom:v palette:palette x:r.x+r.w-2 y:r.y+1 h:r.h-2];
            [Definitions drawInBitmap:bitmap top:v palette:palette middle:v palette:palette bottom:v palette:palette x:r.x+r.w-2-15 y:r.y+1+18 h:r.h-2-18];
            [Definitions drawInBitmap:bitmap left:h middle:h right:h x:r.x y:r.y+r.h-2 w:r.w palette:palette];
            [Definitions drawInBitmap:bitmap left:h middle:h right:h x:r.x y:r.y+r.h-2-15 w:r.w palette:palette];
        }
    }

}
- (char)borderForX:(int)x y:(int)y w:(int)w h:(int)h
{
    if ((y >= 0) && (y < 4*_pixelScaling)) {
        if ((x >= 0) && (x < 23*_pixelScaling)) {
            return '7';
        } else if ((x >= w-23*_pixelScaling) && (x < w)) {
            return '9';
        } else {
            return '8';
        }
    } else if ((y >= h-4*_pixelScaling) && (y < h)) {
        if ((x >= 0) && (x < 23*_pixelScaling)) {
            return '1';
        } else if ((x >= w-23*_pixelScaling) && (x < w)) {
            return '3';
        } else {
            return '2';
        }
    } else if ((x >= 0) && (x < 4*_pixelScaling)) {
        if ((y >= 0) && (y < 23*_pixelScaling)) {
            return '7';
        } else if ((y >= h-23*_pixelScaling) && (y < h)) {
            return '1';
        } else {
            return '4';
        }
    } else if ((x >= w-4*_pixelScaling) && (x < w)) {
        if ((y >= 0) && (y < 23*_pixelScaling)) {
            return '9';
        } else if ((y >= h-23*_pixelScaling) && (y < h)) {
            return '3';
        } else {
            return '6';
        }
    }
    return 0;
}
- (void)handleMouseDown:(id)event context:(id)x11dict
{
    id windowManager = [Definitions windowManager];
    [windowManager setFocusDict:x11dict];
    int mouseX = [event intValueForKey:@"mouseX"];
    int mouseY = [event intValueForKey:@"mouseY"];

    int x11W = [x11dict intValueForKey:@"w"];
    int x11H = [x11dict intValueForKey:@"h"];
    if ([Definitions isX:mouseX y:mouseY insideRect:_closeButtonRect]) {
        _buttonDown = 'c';
        _buttonHover = 'c';
        _buttonDownX = mouseX;
        _buttonDownY = mouseY;
        _buttonDownW = x11W;
        _buttonDownH = x11H;
        return;
    }
    if ([Definitions isX:mouseX y:mouseY insideRect:_minimizeButtonRect]) {
        _buttonDown = 'm';
        _buttonHover = 'm';
        _buttonDownX = mouseX;
        _buttonDownY = mouseY;
        _buttonDownW = x11W;
        _buttonDownH = x11H;
        return;
    }
    if ([Definitions isX:mouseX y:mouseY insideRect:_maximizeButtonRect]) {
        _buttonDown = 'M';
        _buttonHover = 'M';
        _buttonDownX = mouseX;
        _buttonDownY = mouseY;
        _buttonDownW = x11W;
        _buttonDownH = x11H;
        return;
    }
    int border = [self borderForX:mouseX y:mouseY w:x11W h:x11H];
    if (border) {
        _buttonDown = border;
        _buttonDownX = mouseX;
        _buttonDownY = mouseY;
        _buttonDownW = x11W;
        _buttonDownH = x11H;
        return;
    }
    if ([Definitions isX:mouseX y:mouseY insideRect:_titleBarRect]) {
        _buttonDown = 't';
        _buttonDownX = mouseX;
        _buttonDownY = mouseY;
        _buttonDownW = x11W;
        _buttonDownH = x11H;
        return;
    }
}
- (void)handleMouseMoved:(id)event context:(id)x11dict
{
    if (_buttonDown == 'c') {
        int mouseX = [event intValueForKey:@"mouseX"];
        int mouseY = [event intValueForKey:@"mouseY"];
        if ([Definitions isX:mouseX y:mouseY insideRect:_closeButtonRect]) {
            _buttonHover = 'c';
        } else {
            _buttonHover = 0;
        }
        return;
    }
    if (_buttonDown == 'm') {
        int mouseX = [event intValueForKey:@"mouseX"];
        int mouseY = [event intValueForKey:@"mouseY"];
        if ([Definitions isX:mouseX y:mouseY insideRect:_minimizeButtonRect]) {
            _buttonHover = 'm';
        } else {
            _buttonHover = 0;
        }
        return;
    }
    if (_buttonDown == 'M') {
        int mouseX = [event intValueForKey:@"mouseX"];
        int mouseY = [event intValueForKey:@"mouseY"];
        if ([Definitions isX:mouseX y:mouseY insideRect:_maximizeButtonRect]) {
            _buttonHover = 'M';
        } else {
            _buttonHover = 0;
        }
        return;
    }

    if (_buttonDown == 't') {
        id windowManager = [Definitions windowManager];
        int menuBarHeight = [windowManager intValueForKey:@"menuBarHeight"];
        int mouseRootX = [event intValueForKey:@"mouseRootX"];
        int mouseRootY = [event intValueForKey:@"mouseRootY"];

        int newX = mouseRootX - _buttonDownX;
        int newY = mouseRootY - _buttonDownY;

        if (newX < 0) {
            newX = 0;
        }
        if (newY < menuBarHeight) {
            newY = menuBarHeight;
        }

        [x11dict setValue:nsfmt(@"%d %d", newX, newY) forKey:@"moveWindow"];

        return;
    }

    int mouseX = [event intValueForKey:@"mouseX"];
    int mouseY = [event intValueForKey:@"mouseY"];
    int mouseRootX = [event intValueForKey:@"mouseRootX"];
    int mouseRootY = [event intValueForKey:@"mouseRootY"];
    int x = [x11dict intValueForKey:@"x"];
    int y = [x11dict intValueForKey:@"y"];
    int w = [x11dict intValueForKey:@"w"];
    int h = [x11dict intValueForKey:@"h"];
    id windowManager = [Definitions windowManager];
    if (!_buttonDown) {
        int border = [self borderForX:mouseX y:mouseY w:w h:h];
        if (border) {
            [windowManager setX11Cursor:border];
        } else {
            [windowManager setX11Cursor:'5'];
        }
        return;
    }

    if (_buttonDown == '4') {
        if (mouseY < 0) {
            _buttonDown = '7';
            [windowManager setX11Cursor:_buttonDown];
        } else if (mouseY > h) {
            _buttonDown = '1';
            [windowManager setX11Cursor:_buttonDown];
        } else {
            int newX = mouseRootX;
            int newWidth = x+w - mouseRootX;
            if (newWidth < _leftBorder+_rightBorder) {
                newWidth = _leftBorder+_rightBorder;
            }
            [x11dict setValue:nsfmt(@"%d %d", newX, y) forKey:@"moveWindow"];
            [x11dict setValue:nsfmt(@"%d %d", newWidth, h) forKey:@"resizeWindow"];
            return;
        }
    }
    if (_buttonDown == '6') {
        if (mouseY < 0) {
            _buttonDown = '9';
            [windowManager setX11Cursor:_buttonDown];
        } else if (mouseY > h) {
            _buttonDown = '3';
            [windowManager setX11Cursor:_buttonDown];
        } else {
            int newWidth = mouseX;
            if (newWidth < _leftBorder+_rightBorder) {
                newWidth = _leftBorder+_rightBorder;
            }
            [x11dict setValue:nsfmt(@"%d %d", newWidth, h) forKey:@"resizeWindow"];
            return;
        }
    }
    if (_buttonDown == '2') {
        if (mouseX < 0) {
            _buttonDown = '1';
            [windowManager setX11Cursor:_buttonDown];
        } else if (mouseX > w) {
            _buttonDown = '3';
            [windowManager setX11Cursor:_buttonDown];
        } else {
            int newHeight = mouseY;
            if (newHeight < _topBorder+_bottomBorder) {
                newHeight = _topBorder+_bottomBorder;
            }
            [x11dict setValue:nsfmt(@"%d %d", w, newHeight) forKey:@"resizeWindow"];
            return;
        }
    }
    if (_buttonDown == '8') {
        if (mouseX < 0) {
            _buttonDown = '7';
            [windowManager setX11Cursor:_buttonDown];
        } else if (mouseX > w) {
            _buttonDown = '9';
            [windowManager setX11Cursor:_buttonDown];
        } else {
            int newY = mouseRootY;
            int newHeight = y+h - mouseRootY;
            if (newHeight < _topBorder+_bottomBorder) {
                newHeight = _topBorder+_bottomBorder;
            }
            [x11dict setValue:nsfmt(@"%d %d", x, newY) forKey:@"moveWindow"];
            [x11dict setValue:nsfmt(@"%d %d", w, newHeight) forKey:@"resizeWindow"];
            return;
        }
    }
    if (_buttonDown == '1') {
        int newX = mouseRootX;
        int newWidth = x+w - mouseRootX;
        int newHeight = mouseY;
        if (newWidth < _leftBorder+_rightBorder) {
            newWidth = _leftBorder+_rightBorder;
        }
        if (newHeight < _topBorder+_bottomBorder) {
            newHeight = _topBorder+_bottomBorder;
        }
        [x11dict setValue:nsfmt(@"%d %d", newX, y) forKey:@"moveWindow"];
        [x11dict setValue:nsfmt(@"%d %d", newWidth, newHeight) forKey:@"resizeWindow"];
        return;
    }
    if (_buttonDown == '3') {
        int newWidth = mouseX;
        int newHeight = mouseY;
        if (newWidth < _leftBorder+_rightBorder) {
            newWidth = _leftBorder+_rightBorder;
        }
        if (newHeight < _topBorder+_bottomBorder) {
            newHeight = _topBorder+_bottomBorder;
        }
        [x11dict setValue:nsfmt(@"%d %d", newWidth, newHeight) forKey:@"resizeWindow"];
        return;
    }
    if (_buttonDown == '7') {
        int newX = mouseRootX;
        int newY = mouseRootY;
        int newWidth = x+w - mouseRootX;
        int newHeight = y+h - mouseRootY;
        if (newWidth < _leftBorder+_rightBorder) {
            newWidth = _leftBorder+_rightBorder;
        }
        if (newHeight < _topBorder+_bottomBorder) {
            newHeight = _topBorder+_bottomBorder;
        }
        [x11dict setValue:nsfmt(@"%d %d", newX, newY) forKey:@"moveWindow"];
        [x11dict setValue:nsfmt(@"%d %d", newWidth, newHeight) forKey:@"resizeWindow"];
        return;
    }
    if (_buttonDown == '9') {
        int newY = mouseRootY;
        int newWidth = mouseX;
        int newHeight = y+h - mouseRootY;
        if (newWidth < _leftBorder+_rightBorder) {
            newWidth = _leftBorder+_rightBorder;
        }
        if (newHeight < _topBorder+_bottomBorder) {
            newHeight = _topBorder+_bottomBorder;
        }
        [x11dict setValue:nsfmt(@"%d %d", x, newY) forKey:@"moveWindow"];
        [x11dict setValue:nsfmt(@"%d %d", newWidth, newHeight) forKey:@"resizeWindow"];
        return;
    }
}
- (void)handleMouseUp:(id)event context:(id)x11dict
{
    if ((_buttonDown == 'c') && (_buttonHover == 'c')) {
        [x11dict x11CloseWindow];
    }
    if ((_buttonDown == 'm') && (_buttonHover == 'm')) {
        [x11dict x11ToggleMaximizeWindow];
    }
    if ((_buttonDown == 'M') && (_buttonHover == 'M')) {
        [x11dict x11ToggleMaximizeWindow];
    }
    if (_buttonDown == 't') {
        /* this was added for Wine */
        [x11dict x11MoveChildWindowBackAndForthForWine];
    }

    _buttonDown = 0;
}
@end

