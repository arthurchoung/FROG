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

static unsigned char *bitmapMessageIconPixels =
"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\n"
"b........bbbbbbbbbbbbbbbbbbbbbbb\n"
"b........bbbbbbbbbbbbbbbbbbbbbbb\n"
"b........bbbbbbbbbbbbbbbbbbbbbbb\n"
"b........bbbbbbbbbbbbbbbbbbbbbbb\n"
"b........bbbbbbbbb......bbbbbbbb\n"
"b...b....bbbbbbb..........bbbbbb\n"
"b...b....bbbbbb............bbbbb\n"
"b...b....bbbbb..............bbbb\n"
"b........bbbb................bbb\n"
"b........bbbb................bbb\n"
"b........bbb..................bb\n"
"b........bbb...bbb.bbb.bbb....bb\n"
"b........bbb..................bb\n"
"b........bbb..................bb\n"
"b........bbb...bbb.bbb.b.b....bb\n"
"b........bbb..................bb\n"
"b........bbb..................bb\n"
"b........bbb...bbb.b.bbb......bb\n"
"b........bbb..................bb\n"
"b....bbbbbbb..................bb\n"
"b......bbbbb...bbbb.bbb.bb....bb\n"
"b......bbbbb.................bbb\n"
"b......bbbbb.................bbb\n"
"b......bbbbb................bbbb\n"
"b......bbbb................bbbbb\n"
"b...bbbbb................bbbbbbb\n"
"b......bbbbbbbbbbbbbbbbbbbbbbbbb\n"
"b......bbbbbbbbbbbbbbbbbbbbbbbbb\n"
"b......bbbbbbbbbbbbbbbbbbbbbbbbb\n"
"b......bbbbbbbbbbbbbbbbbbbbbbbbb\n"
"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\n"
;

static unsigned char *bitmapButtonLeftPixels =
"   b\n"
" bb.\n"
" b..\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
"b...\n"
" b..\n"
" bb.\n"
"   b\n"
;
static unsigned char *bitmapButtonMiddlePixels =
"b\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
"b\n"
;
static unsigned char *bitmapButtonRightPixels =
"b   \n"
".bb \n"
"..b \n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"...b\n"
"..b \n"
".bb \n"
"b   \n"
;

static void drawButtonInBitmap_rect_palette_(id bitmap, Int4 r, unsigned char *palette)
{
    unsigned char *left = bitmapButtonLeftPixels;
    unsigned char *middle = bitmapButtonMiddlePixels;
    unsigned char *right = bitmapButtonRightPixels;

    [Definitions drawInBitmap:bitmap left:left middle:middle right:right centeredInRect:r palette:palette];
}


static unsigned char *bitmapDefaultButtonLeftPixels =
"     bbb\n"
"   bbbbb\n"
"  bbbbbb\n"
" bbbbwww\n"
" bbbwwwb\n"
"bbbwwbb.\n"
"bbbwwb..\n"
"bbbwb...\n"
"bbbwb...\n"
"bbbwb...\n"
"bbbwb...\n"
"bbbwb...\n"
"bbbwb...\n"
"bbbwb...\n"
"bbbwb...\n"
"bbbwb...\n"
"bbbwb...\n"
"bbbwb...\n"
"bbbwb...\n"
"bbbwb...\n"
"bbbwb...\n"
"bbbwb...\n"
"bbbwwb..\n"
"bbbwwbb.\n"
" bbbwwwb\n"
" bbbbwww\n"
"  bbbbbb\n"
"   bbbbb\n"
"     bbb\n"
;
static unsigned char *bitmapDefaultButtonMiddlePixels =
"b\n"
"b\n"
"b\n"
"w\n"
"b\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
".\n"
"b\n"
"w\n"
"b\n"
"b\n"
"b\n"
;
static unsigned char *bitmapDefaultButtonRightPixels =
"bbb     \n"
"bbbbb   \n"
"bbbbbb  \n"
"wwwbbbb \n"
"bwwwbbb \n"
".bbwwbbb\n"
"..bwwbbb\n"
"...bwbbb\n"
"...bwbbb\n"
"...bwbbb\n"
"...bwbbb\n"
"...bwbbb\n"
"...bwbbb\n"
"...bwbbb\n"
"...bwbbb\n"
"...bwbbb\n"
"...bwbbb\n"
"...bwbbb\n"
"...bwbbb\n"
"...bwbbb\n"
"...bwbbb\n"
"...bwbbb\n"
"..bwwbbb\n"
".bbwwbbb\n"
"bwwwbbb \n"
"wwwbbbb \n"
"bbbbbb  \n"
"bbbbb   \n"
"bbb     \n"
;
static void drawDefaultButtonInBitmap_rect_palette_(id bitmap, Int4 r, unsigned char *palette)
{
    unsigned char *left = bitmapDefaultButtonLeftPixels;
    unsigned char *middle = bitmapDefaultButtonMiddlePixels;
    unsigned char *right = bitmapDefaultButtonRightPixels;

    [Definitions drawInBitmap:bitmap left:left middle:middle right:right centeredInRect:r palette:palette];
}



static void drawAlertBorderInBitmap_rect_(id bitmap, Int4 r)
{
    [bitmap setColor:@"white"];
    [bitmap fillRect:r];
    unsigned char *pixels = [bitmap pixelBytes];
    if (!pixels) {
        return;
    }
    int bitmapWidth = [bitmap bitmapWidth];
    int bitmapHeight = [bitmap bitmapHeight];
    int bitmapStride = [bitmap bitmapStride];
    for (int i=0; i<bitmapWidth; i++) {
        unsigned char *p = pixels + i*4;
        p[0] = 0; p[1] = 0; p[2] = 0; p[3] = 0;
    }
    for (int i=3; i<bitmapWidth-3; i++) {
        unsigned char *p = pixels + bitmapStride*3 + i*4;
        p[0] = 0; p[1] = 0; p[2] = 0; p[3] = 0;
    }
    for (int i=4; i<bitmapWidth-4; i++) {
        unsigned char *p = pixels + bitmapStride*4 + i*4;
        p[0] = 0; p[1] = 0; p[2] = 0; p[3] = 0;
    }

    for (int i=0; i<bitmapWidth; i++) {
        unsigned char *p = pixels + bitmapStride*(bitmapHeight-1) + i*4;
        p[0] = 0; p[1] = 0; p[2] = 0; p[3] = 0;
    }
    for (int i=3; i<bitmapWidth-3; i++) {
        unsigned char *p = pixels + bitmapStride*(bitmapHeight-1-3) + i*4;
        p[0] = 0; p[1] = 0; p[2] = 0; p[3] = 0;
    }
    for (int i=4; i<bitmapWidth-4; i++) {
        unsigned char *p = pixels + bitmapStride*(bitmapHeight-1-4) + i*4;
        p[0] = 0; p[1] = 0; p[2] = 0; p[3] = 0;
    }

    for (int i=1; i<bitmapHeight-1; i++) {
        unsigned char *p = pixels + bitmapStride*i + 0;
        p[0] = 0; p[1] = 0; p[2] = 0; p[3] = 0;
    }
    for (int i=1; i<bitmapHeight-1; i++) {
        unsigned char *p = pixels + bitmapStride*i + (bitmapWidth-1)*4;
        p[0] = 0; p[1] = 0; p[2] = 0; p[3] = 0;
    }
    for (int i=4; i<bitmapHeight-4; i++) {
        unsigned char *p = pixels + bitmapStride*i + 3*4;
        p[0] = 0; p[1] = 0; p[2] = 0; p[3] = 0;
    }
    for (int i=4; i<bitmapHeight-4; i++) {
        unsigned char *p = pixels + bitmapStride*i + (bitmapWidth-1-3)*4;
        p[0] = 0; p[1] = 0; p[2] = 0; p[3] = 0;
    }
    for (int i=5; i<bitmapHeight-5; i++) {
        unsigned char *p = pixels + bitmapStride*i + 4*4;
        p[0] = 0; p[1] = 0; p[2] = 0; p[3] = 0;
    }
    for (int i=5; i<bitmapHeight-5; i++) {
        unsigned char *p = pixels + bitmapStride*i + (bitmapWidth-1-4)*4;
        p[0] = 0; p[1] = 0; p[2] = 0; p[3] = 0;
    }

}

@implementation NSObject(jflkdsjfoiewjflkdsjfklsdjf)
- (void)showAlert
{
    [[self description] showAlert];
}

@end

#ifdef BUILD_FOR_ANDROID
@implementation Definitions(fjkdlsjfkldsjfkldsjklfwejffjdkjfkdjlsdfjdsk)
+ (void)showAlert:(id)text
{
    NSLog(@"%@", text);
}
@end
@implementation NSString(fmeklwmfklsdmfklsdmkflmsd)
- (void)showAlert
{
    NSLog(@"%@", self);
}
@end
#else
@implementation Definitions(fjkdlsjfkldsjfkldsjklfwejffjdkjfkdjlsd)
+ (void)showAlert:(id)text
{
    id windowManager = [Definitions windowManager];
    if ([windowManager intValueForKey:@"isWindowManager"]) {
NSLog(@"showAlert:'%@'", text);
        return;
    }
    id cmd = nsarr();
    [cmd addObject:@"frog"];
    [cmd addObject:@"alert"];
    [cmd addObject:text];
    [cmd runCommandInBackground];
}
@end
@implementation NSString(yjfhjhjhmv)


- (void)showAlert
{
    id windowManager = [Definitions windowManager];
    if ([windowManager intValueForKey:@"isWindowManager"]) {
NSLog(@"showAlert:'%@'", self);
        return;
    }
    id cmd = nsarr();
    [cmd addObject:@"frog"];
    [cmd addObject:@"alert"];
    [cmd addObject:self];
    [cmd runCommandInBackground];
}

@end
#endif



@implementation Definitions(Fjewilfmlkdsmvlksdkjffjdksljfkldsjkffjdskfjk)
+ (id)testAlert
{
    id obj = [@"Alert" asInstance];
    [obj setValue:@"HJKLJDKLSFJDSKLF" forKey:@"text"];
    [obj setValue:@"ContinueContinue" forKey:@"okText"];
    [obj setValue:@"Cancel" forKey:@"cancelText"];
    return obj;
}
+ (id)testAlertFocusOut
{
    id obj = [@"Alert" asInstance];
    [obj setValue:@"HJKLJDKLSFJDSKLF" forKey:@"text"];
    [obj setValue:@"OK" forKey:@"okText"];
    [obj setValue:@"Cancel" forKey:@"cancelText"];
    [obj setValue:@"1" forKey:@"x11WaitForFocusOutThenClose"];
    return obj;
}
+ (id)Alert:(id)text
{
    id obj = [@"Alert" asInstance];
    [obj setValue:text forKey:@"text"];
    return obj;
}
@end

@interface Alert : IvarObject
{
    id _text;
    Int4 _okRect;
    Int4 _cancelRect;
    id _okText;
    id _cancelText;
    char _buttonDown;
    char _buttonHover;
    int _dialogMode;
    int _x11WaitForFocusOutThenClose;
    int _returnKey;
    int _didFocusOut;
    int _backgroundCount;
    int _scrollY;
    int _FROGNOFRAME;
    int _buttonDownX;
    int _buttonDownY;
}
@end

@implementation Alert
- (id)init
{
    self = [super init];
    if (self) {
        _FROGNOFRAME = 1;
    }
    return self;
}
- (int)preferredWidth
{
    return 480;
}
- (int)preferredHeight
{
    if (!_text) {
        return 288;
    }
    id bitmap = [Definitions bitmapWithWidth:1 height:1];

    int textWidth = 480 - 89 - 18;
    id text = [bitmap fitBitmapString:_text width:textWidth];
    int textHeight = [bitmap bitmapHeightForText:text];
    int h = 24 + textHeight + 21 + 21 + 28;
    if (h > 288) {
        return h;
    }
    return 288;
}
- (void)handleBackgroundUpdate:(id)event
{
    if (_x11WaitForFocusOutThenClose) {
        if (_didFocusOut) {
            if (_backgroundCount > 1) {
                exit(0);
            }
        }
    }
    _backgroundCount++;
}
- (void)drawInBitmap:(id)bitmap rect:(Int4)r
{
    if (_FROGNOFRAME) {
        drawAlertBorderInBitmap_rect_(bitmap, r);
    } else {
        [bitmap setColor:@"white"];
        [bitmap fillRect:r];
    }

    char *palette = "b #000000\n. #ffffff\n";
    [bitmap drawCString:bitmapMessageIconPixels palette:palette x:28 y:28];

    // text

    int textWidth = (int)r.w - 89 - 18;
    id text = [bitmap fitBitmapString:_text width:textWidth];
    [bitmap setColorIntR:0 g:0 b:0 a:255];
    [bitmap drawBitmapText:text x:89 y:24+_scrollY];

    // ok button

    if (_okText) {
        _okRect = [Definitions rectWithX:r.w-88 y:r.h-21-28 w:70 h:28];

        int okTextWidth = [bitmap bitmapWidthForText:_okText] + 16 + 8;
        if (okTextWidth > _okRect.w) {
            _okRect.x -= okTextWidth-_okRect.w;
            _okRect.w = okTextWidth;
        }

        Int4 innerRect = _okRect;
        innerRect.y += 1;
        BOOL okButtonDown = NO;        
        if ((_buttonDown == 'o') && (_buttonHover == 'o')) {
            okButtonDown = YES;
        } else if (_returnKey) {
            okButtonDown = YES;
        }
        if (okButtonDown) {
            char *palette = ". #000000\nb #000000\nw #ffffff\n";
            drawDefaultButtonInBitmap_rect_palette_(bitmap, _okRect, palette);
            [bitmap setColorIntR:255 g:255 b:255 a:255];
            [bitmap drawBitmapText:_okText centeredInRect:innerRect];
        } else {
            char *palette = ". #ffffff\nb #000000\nw #ffffff\n";
            drawDefaultButtonInBitmap_rect_palette_(bitmap, _okRect, palette);
            [bitmap setColorIntR:0 g:0 b:0 a:255];
            [bitmap drawBitmapText:_okText centeredInRect:innerRect];
        }
    } else {
        _okRect.x = 0;
        _okRect.y = 0;
        _okRect.w = 0;
        _okRect.h = 0;
    }

    // cancel button

    if (_cancelText) {
        _cancelRect = [Definitions rectWithX:_okRect.x-70-35 y:r.h-21-28 w:70 h:28];
        if ((_buttonDown == 'c') && (_buttonHover == 'c')) {
            char *palette = ". #000000\nb #000000\nw #ffffff\n";
            drawButtonInBitmap_rect_palette_(bitmap, _cancelRect, palette);
            [bitmap setColorIntR:255 g:255 b:255 a:255];
            [bitmap drawBitmapText:_cancelText centeredInRect:_cancelRect];
        } else {
            char *palette = ". #ffffff\nb #000000\nw #ffffff\n";
            drawButtonInBitmap_rect_palette_(bitmap, _cancelRect, palette);
            [bitmap setColorIntR:0 g:0 b:0 a:255];
            [bitmap drawBitmapText:_cancelText centeredInRect:_cancelRect];
        }
    } else {
        _cancelRect.x = 0;
        _cancelRect.y = 0;
        _cancelRect.w = 0;
        _cancelRect.h = 0;
    }
}
- (void)handleMouseDown:(id)event context:(id)x11dict
{
    {
        unsigned long win = [[x11dict valueForKey:@"window"] unsignedLongValue];
        id windowManager = [@"windowManager" valueForKey];
        [windowManager XRaiseWindow:win];
    }

    int mouseX = [event intValueForKey:@"mouseX"];
    int mouseY = [event intValueForKey:@"mouseY"];
    if (_okText && [Definitions isX:mouseX y:mouseY insideRect:_okRect]) {
        _buttonDown = 'o';
        _buttonHover = 'o';
    } else if (_cancelText && [Definitions isX:mouseX y:mouseY insideRect:_cancelRect]) {
        _buttonDown = 'c';
        _buttonHover = 'c';
    } else {
        _buttonDown = 'b';
        _buttonHover = 0;
        _buttonDownX = mouseX;
        _buttonDownY = mouseY;
    }
}
- (void)handleMouseMoved:(id)event context:(id)x11dict
{
    if (_buttonDown == 'b') {
        int mouseRootX = [event intValueForKey:@"mouseRootX"];
        int mouseRootY = [event intValueForKey:@"mouseRootY"];

        int newX = mouseRootX - _buttonDownX;
        int newY = mouseRootY - _buttonDownY;

        [x11dict setValue:nsfmt(@"%d", newX) forKey:@"x"];
        [x11dict setValue:nsfmt(@"%d", newY) forKey:@"y"];

        [x11dict setValue:nsfmt(@"%d %d", newX, newY) forKey:@"moveWindow"];
        return;
    }

    int mouseX = [event intValueForKey:@"mouseX"];
    int mouseY = [event intValueForKey:@"mouseY"];
    if (_okText && [Definitions isX:mouseX y:mouseY insideRect:_okRect]) {
        _buttonHover = 'o';
    } else if (_cancelText && [Definitions isX:mouseX y:mouseY insideRect:_cancelRect]) {
        _buttonHover = 'c';
    } else {
        _buttonHover = 0;
    }
}
- (void)handleMouseUp:(id)event context:(id)x11dict
{
    if (_buttonDown == _buttonHover) {
        if (_buttonDown == 'o') {
            if (_dialogMode) {
                exit(0);
            }
            NSOut(@"%@\n", _okText);
            [x11dict setValue:@"1" forKey:@"shouldCloseWindow"];
        } else if (_buttonDown == 'c') {
            if (_dialogMode) {
                exit(1);
            }
            NSOut(@"%@\n", _cancelText);
            [x11dict setValue:@"1" forKey:@"shouldCloseWindow"];
        }
    }
    _buttonDown = 0;
    _buttonHover = 0;
}
- (void)handleKeyDown:(id)event
{
    id str = [event valueForKey:@"keyString"];
    if ([str isEqual:@"return"] || [str isEqual:@"shift-return"] || [str isEqual:@"keypadenter"]) {
        _returnKey = 1;
    }
}
- (void)handleKeyUp:(id)event context:(id)x11dict
{
    id str = [event valueForKey:@"keyString"];
    if ([str isEqual:@"return"] || [str isEqual:@"shift-return"] || [str isEqual:@"keypadenter"]) {
        if (_returnKey) {
            if (_dialogMode) {
                exit(0);
            }
            NSOut(@"%@\n", _okText);
            [x11dict setValue:@"1" forKey:@"shouldCloseWindow"];
            _returnKey = 0;
        }
    }
}
- (void)handleFocusOutEvent:(id)event
{
    if (_x11WaitForFocusOutThenClose) {
        if (_backgroundCount > 1) {
            exit(0);
        }
    }
    _didFocusOut = 1;
}
- (void)handleScrollWheel:(id)event
{
    int dy = [event intValueForKey:@"scrollingDeltaY"];
    _scrollY -= dy;
}
@end

