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

static char *checkbox_pixels =
"bbbbbbbbbbbb\n"
"b          b\n"
"b          b\n"
"b          b\n"
"b          b\n"
"b          b\n"
"b          b\n"
"b          b\n"
"b          b\n"
"b          b\n"
"b          b\n"
"bbbbbbbbbbbb\n"
;
static char *checkbox_selected_pixels =
"bbbbbbbbbbbb\n"
"bb        bb\n"
"b b      b b\n"
"b  b    b  b\n"
"b   b  b   b\n"
"b    bb    b\n"
"b    bb    b\n"
"b   b  b   b\n"
"b  b    b  b\n"
"b b      b b\n"
"bb        bb\n"
"bbbbbbbbbbbb\n"
;
static char *checkbox_down_pixels =
"bbbbbbbbbbbb\n"
"bbbbbbbbbbbb\n"
"bb        bb\n"
"bb        bb\n"
"bb        bb\n"
"bb        bb\n"
"bb        bb\n"
"bb        bb\n"
"bb        bb\n"
"bb        bb\n"
"bbbbbbbbbbbb\n"
"bbbbbbbbbbbb\n"
;

#define MAX_CHECKBOXES 20

@implementation Definitions(fjewmfnkdslnfsdjflfjdskfjksldjfkk)
+ (id)Checklist
{
    id lines = [Definitions linesFromStandardInput];
    id obj = [@"Checklist" asInstance];
    [obj setValue:@"jfkdlsjflkdsjfkljdsklf" forKey:@"text"];
    [obj setValue:lines forKey:@"array"];
    [obj setValue:@"OK" forKey:@"okText"];
    [obj setValue:@"Cancel" forKey:@"cancelText"];
    [obj setValue:@"1" forKey:@"dialogMode"];
    return obj;
}
@end

@interface Checklist : IvarObject
{
    int _dialogMode;
    id _text;
    id _array;
    BOOL _checked[MAX_CHECKBOXES];
    Int4 _rect[MAX_CHECKBOXES];
    char _down;
    char _hover;
    Int4 _okRect;
    Int4 _cancelRect;
    id _okText;
    id _cancelText;
    int _FROGNOFRAME;
    int _buttonDownX;
    int _buttonDownY;
    int _returnKey;
}
@end
@implementation Checklist
- (id)init
{
    self = [super init];
    if (self) {
        _FROGNOFRAME = 1;
    }
    return self;
}
- (BOOL)getCheckedForIndex:(int)index
{
    if ((index >= 0) && (index < MAX_CHECKBOXES)) {
        return _checked[index];
    }
    return NO;
}
- (void)setChecked:(BOOL)checked forIndex:(int)index
{
    if ((index >= 0) && (index < MAX_CHECKBOXES)) {
        _checked[index] = checked;
    }
}
- (int)preferredWidth
{
    return 640;
}
- (int)preferredHeight
{
    id bitmap = [Definitions bitmapWithWidth:1 height:1];
    int lineHeight = [bitmap bitmapHeightForText:@"X"];
    int checkboxWidth = [Definitions widthForCString:checkbox_pixels];
    int h = 24;
    int w = 640;
    {
        id text = [bitmap fitBitmapString:_text width:w-89-18];
        h += [bitmap bitmapHeightForText:text] + lineHeight;
    }
    for (int i=0; i<[_array count]; i++) {
        id elt = [_array nth:i];
        id text = [elt valueForKey:@"text"];
        if (!text) {
            text = elt;
        }
        text = [bitmap fitBitmapString:text width:w-checkboxWidth-10-lineHeight];
        h += [bitmap bitmapHeightForText:text] + lineHeight/2;
    }
    h += 21 + 28 + 21;
    return h;
}
- (void)drawInBitmap:(id)bitmap rect:(Int4)r
{
    drawAlertBorderInBitmap_rect_(bitmap, r);
    char *palette = "b #000000\n. #ffffff\n";
    [bitmap drawCString:bitmapMessageIconPixels palette:palette x:28 y:28];

    int x = 89;
    int y = 24;

    int lineHeight = [bitmap bitmapHeightForText:@"X"];

    // text

    {
        int textWidth = r.w - x - 18;
        id text = [bitmap fitBitmapString:_text width:textWidth];
        int textHeight = [bitmap bitmapHeightForText:text];
        [bitmap setColorIntR:0 g:0 b:0 a:255];
        [bitmap drawBitmapText:text x:x y:y];
        y += textHeight + lineHeight;
    }

    // buttons

    int checkboxWidth = [Definitions widthForCString:checkbox_pixels];
    int checkboxHeight = [Definitions heightForCString:checkbox_pixels];
    for (int i=0; i<[_array count]; i++) {
        id elt = [_array nth:i];
        id text = [elt valueForKey:@"text"];
        if (!text) {
            text = elt;
        }
        _rect[i].x = x;
        _rect[i].y = y;
        text = [bitmap fitBitmapString:text width:r.w-checkboxWidth-10-(x-r.x)-20];
        int textWidth = [bitmap bitmapWidthForText:text];
        int textHeight = [bitmap bitmapHeightForText:text];
        _rect[i].w = checkboxWidth+10+textWidth;
        _rect[i].h = textHeight;
        char *str = checkbox_pixels;
        if ((_down==i+1) && (_hover==i+1)) {
            str = checkbox_down_pixels;
        }
        [bitmap drawCString:str x:x y:y c:'b' r:0 g:0 b:0 a:255];
        if ([self getCheckedForIndex:i]) {
            [bitmap drawCString:checkbox_selected_pixels x:x y:y c:'b' r:0 g:0 b:0 a:255];
        }
        [bitmap drawBitmapText:text x:x+checkboxWidth+10 y:y+1];
        y += textHeight + lineHeight/2;
    }

    // ok button

    if (_okText) {
        _okRect = [Definitions rectWithX:r.w-88 y:r.h-21-28 w:70 h:28];
        Int4 innerRect = _okRect;
        innerRect.y += 1;
        BOOL okButtonDown = NO;
        if ((_down == 'o') && (_hover == 'o')) {
            okButtonDown = YES;
        } else if (_returnKey) {
            okButtonDown = YES;
        }
        if (okButtonDown) {
            char *palette = ". #000000\nb #000000\nw #ffffff\n";
            drawDefaultButtonInBitmap_rect_palette_(bitmap, _okRect, palette);
            [bitmap setColorIntR:255 g:255 b:255 a:255];
            [bitmap drawBitmapText:@"OK" centeredInRect:innerRect];
        } else {
            char *palette = ". #ffffff\nb #000000\nw #ffffff\n";
            drawDefaultButtonInBitmap_rect_palette_(bitmap, _okRect, palette);
            [bitmap setColorIntR:0 g:0 b:0 a:255];
            [bitmap drawBitmapText:@"OK" centeredInRect:innerRect];
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
        if ((_down == 'c') && (_hover == 'c')) {
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
        _down = 'o';
        _hover = 'o';
        return;
    }
    if (_cancelText && [Definitions isX:mouseX y:mouseY insideRect:_cancelRect]) {
        _down = 'c';
        _hover = 'c';
        return;
    }
    for (int i=0; i<[_array count]; i++) {
        if ([Definitions isX:mouseX y:mouseY insideRect:_rect[i]]) {
            _down = i+1;
            _hover = i+1;
            return;
        }
    }
    _down = 'b';
    _hover = 0;
    _buttonDownX = mouseX;
    _buttonDownY = mouseY;
}
- (void)handleMouseMoved:(id)event context:(id)x11dict
{
    if (_down == 'b') {
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
        _hover = 'o';
        return;
    }
    if (_cancelText && [Definitions isX:mouseX y:mouseY insideRect:_cancelRect]) {
        _hover = 'c';
        return;
    }
    for (int i=0; i<[_array count]; i++) {
        if ([Definitions isX:mouseX y:mouseY insideRect:_rect[i]]) {
            _hover = i+1;
            return;
        }
    }
    _hover = 0;
}
- (void)handleMouseUp:(id)event
{
    int mouseX = [event intValueForKey:@"mouseX"];
    int mouseY = [event intValueForKey:@"mouseY"];

    if (_down && (_down == _hover)) {
        if (_down == 'o') {
            if (_dialogMode) {
                [self exitWithDialogMode];
            }
        } else if (_down == 'c') {
            if (_dialogMode) {
                exit(1);
            }
        } else {
            if ([self getCheckedForIndex:_down-1]) {
                [self setChecked:NO forIndex:_down-1];
            } else {
                [self setChecked:YES forIndex:_down-1];
            }
        }
    }
    _down = 0;
}
- (void)handleKeyDown:(id)event
{
    id keyString = [event valueForKey:@"keyString"];
    if ([keyString isEqual:@"return"] || [keyString isEqual:@"shift-return"] || [keyString isEqual:@"keypadenter"]) {
        _returnKey = 1;
    }
}
- (void)handleKeyUp:(id)event context:(id)x11dict
{
    id keyString = [event valueForKey:@"keyString"];
    if ([keyString isEqual:@"return"] || [keyString isEqual:@"shift-return"] || [keyString isEqual:@"keypadenter"]) {
        if (_returnKey) {
            if (_dialogMode) {
                [self exitWithDialogMode];
            }
            [x11dict setValue:@"1" forKey:@"shouldCloseWindow"];
            _returnKey = 0;
        }
    }
}
- (void)exitWithDialogMode
{
    BOOL first = YES;
    for (int i=0; i<[_array count]; i++) {
        if ([self getCheckedForIndex:i]) {
            id elt = [_array nth:i];
            id tag = [elt valueForKey:@"tag"];
            if (first) {
                first = NO;
            } else {
                if (_dialogMode == 1) {
                    NSOut(@" ");
                } else {
                    NSErr(@" ");
                }
            }
            if (_dialogMode == 1) {
                NSOut(@"%@", (tag) ? tag : elt);
            } else {
                NSErr(@"%@", (tag) ? tag : elt);
            }
        }
    }
    exit(0);
}
@end

