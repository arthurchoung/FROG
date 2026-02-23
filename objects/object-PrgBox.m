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

#define BUFSIZE 16384

@implementation Definitions(fjekwlfmkldsmfkldsjflfjdskfjkdsk)
+ (id)testPrgBox:(id)cmd
{
    cmd = [cmd split];
    id process = [cmd runCommandAndReturnProcessWithError];
    id obj = [@"PrgBox" asInstance];
    [obj setValue:cmd forKey:@"command"];
    [obj setValue:process forKey:@"process"];
    [obj setValue:@"TITLE" forKey:@"text"];
    [obj setValue:@"OK" forKey:@"okText"];
    return obj;
}
@end

@interface PrgBox : IvarObject
{
    id _command;
    id _process;
    char _separator;
    id _text;
    int _returnKeyDown;
    Int4 _okRect;
    id _okText;
    char _buttonDown;
    char _buttonHover;
    int _dialogMode;
    id _exitStatus;
    int _FROGNOFRAME;
    int _buttonDownX;
    int _buttonDownY;
}
@end
@implementation PrgBox
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
    return 640;
}
- (int)preferredHeight
{
    return 400;
}
- (int *)fileDescriptors
{
    if ([_process respondsToSelector:@selector(fileDescriptors)]) {
        return [_process fileDescriptors];
    }
    return 0;
}
- (void)handleFileDescriptor:(int)fd
{
    if (_process) {
        [_process handleFileDescriptor:fd];
    }
}
- (void)handleProcessID:(int)pid wstatus:(int)wstatus
{
NSLog(@"handleProcessID:%d wstatus:%d", pid, wstatus);
    if (WIFEXITED(wstatus)) {
        int code = WEXITSTATUS(wstatus);
        id str = nsfmt(@"Exited normally (%d)", code);
        [self setValue:str forKey:@"exitStatus"];
    } else {
        id str = nsfmt(@"Did not exit normally (PID %d)", pid);
        [self setValue:str forKey:@"exitStatus"];
    }
}
- (void)endIteration:(id)x11dict
{
}
- (void)drawInBitmap:(id)bitmap rect:(Int4)r
{
    drawAlertBorderInBitmap_rect_(bitmap, r);
    char *palette = "b #000000\n. #ffffff\n";
    [bitmap drawCString:bitmapMessageIconPixels palette:palette x:28 y:28];

    // text

    [bitmap setColor:@"black"];

    int x = 89;
    int y = 24;//r.y+16;
    int textWidth = r.w - 89 - 18;

    {
        id status = nil;
        if (_exitStatus) {
            status = _exitStatus;
        } else {
            status = [_process valueForKey:@"status"];
            if (!status) {
                int pid = [_process intValueForKey:@"pid"];
                if (pid) {
                    status = nsfmt(@"Running (PID %d)", pid);
                } else {
                    status = @"Not Running";
                }
            }
        }
        id text = nsfmt(@"Status: %@\nCommand: %@", status, [_command join:@" "]);
        text = [bitmap fitBitmapString:text width:textWidth];
        [bitmap drawBitmapText:text x:x y:y];
        int textHeight = [bitmap bitmapHeightForText:text];
        y += textHeight + 16;
    }

    if (_text) {
        id text = [bitmap fitBitmapString:_text width:textWidth];
        [bitmap drawBitmapText:text x:x y:y];
        int textHeight = [bitmap bitmapHeightForText:text];
        y += textHeight + 16;
    }

    if (_process) {
        id outtext = [[_process valueForKey:@"data"] asString];
        if (!outtext) {
            outtext = @"";
        }
        id errtext = [[_process valueForKey:@"errdata"] asString];
        if (!errtext) {
            errtext = @"";
        }
        id text = nsfmt(@"%@\n%@", outtext, errtext);
        text = [bitmap fitBitmapString:text width:textWidth];
        [bitmap drawBitmapText:text x:x y:y];
        y += 32;
    }

    // ok button

    _okRect.x = 0;
    _okRect.y = 0;
    _okRect.w = 0;
    _okRect.h = 0;
    if (_okText) {
        id okText = _okText;
        if (![_process valueForKey:@"status"]) {
            okText = @"Stop";
        }

        int textWidth = [bitmap bitmapWidthForText:okText];
        int innerWidth = 50;
        if (textWidth > innerWidth) {
            innerWidth = textWidth;
        }
        _okRect.x = r.w-88;//r.x+r.w-10-(innerWidth+16);
        _okRect.y = r.h-21-28;//r.y+r.h-40;
        _okRect.w = innerWidth+20;
        _okRect.h = 28;
        Int4 innerRect = _okRect;
        innerRect.y += 1;
        if (_returnKeyDown || ((_buttonDown == 'o') && (_buttonHover == 'o'))) {
            char *palette = ". #000000\nb #000000\nw #ffffff\n";
            drawDefaultButtonInBitmap_rect_palette_(bitmap, _okRect, palette);
            [bitmap setColor:@"white"];
            [bitmap drawBitmapText:okText centeredInRect:innerRect];
        } else {
            char *palette = ". #ffffff\nb #000000\nw #ffffff\n";
            drawDefaultButtonInBitmap_rect_palette_(bitmap, _okRect, palette);
            [bitmap setColor:@"black"];
            [bitmap drawBitmapText:okText centeredInRect:innerRect];
        }
    }

}
- (void)handleMouseDown:(id)event
{
    int mouseX = [event intValueForKey:@"mouseX"];
    int mouseY = [event intValueForKey:@"mouseY"];
    if (_okText && [Definitions isX:mouseX y:mouseY insideRect:_okRect]) {
        _buttonDown = 'o';
        _buttonHover = 'o';
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
    } else {
        _buttonHover = 0;
    }
}
- (void)handleMouseUp:(id)event context:(id)x11dict
{
    if (_buttonDown == _buttonHover) {
        if (_buttonDown == 'o') {
            id status = [_process valueForKey:@"status"];
            if (!status) {
                [_process sendSignal:SIGTERM];
            } else {
                if (_dialogMode) {
                    exit(0);
                }
                [x11dict setValue:@"1" forKey:@"shouldCloseWindow"];
            }
        }
    }
    _buttonDown = 0;
    _buttonHover = 0;
}
- (void)handleKeyDown:(id)event
{
    id str = [event valueForKey:@"keyString"];
    if ([str isEqual:@"return"] || [str isEqual:@"shift-return"] || [str isEqual:@"keypadenter"]) {
        _returnKeyDown = YES;
    }
}
- (void)handleKeyUp:(id)event context:(id)x11dict
{
    id str = [event valueForKey:@"keyString"];
    if ([str isEqual:@"return"] || [str isEqual:@"shift-return"] || [str isEqual:@"keypadenter"]) {
        if (_returnKeyDown) {
            [x11dict setValue:@"1" forKey:@"shouldCloseWindow"];
            _returnKeyDown = NO;
        }
    }
}
@end

