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

@implementation NSArray(jfkdlsjflksdjkffjdskfjsdkf)
- (id)asWaylandMenu
{
    id menu = [@"WaylandMenu" asInstance];
    [menu setValue:self forKey:@"array"];
    return menu;
}
@end

@interface WaylandMenu : IvarObject
{
    int _closingIteration;
    int _mouseX;
    int _mouseY;
    id _array;
    id _selectedObject;
    id _contextualObject;
    int _scrollY;

    BOOL _useFixedWidthFont;

    int _unmapInsteadOfClose;
    id _title;

    unsigned long _contextualWindow;
}
@end

@implementation WaylandMenu

- (void)dealloc
{
NSLog(@"dealloc Menu %@", self);
    [super dealloc];
}

- (void)useFixedWidthFont
{
    _useFixedWidthFont = YES;
}
- (int)preferredWidth
{
    id bitmap = [Definitions bitmapWithWidth:1 height:1];
    if (_useFixedWidthFont) {
        [bitmap useAtariSTFont];
    }
    int highestWidth = 0;
    int highestRightWidth = 0;
    for (int i=0; i<[_array count]; i++) {
        id elt = [_array nth:i];
        id text = nil;
        id stringFormat = [elt valueForKey:@"stringFormat"];
        if (stringFormat) {
            if (_contextualObject) {
                text = [_contextualObject str:stringFormat];
            } else {
                text = [elt str:stringFormat];
            }
        }
        if (![text length]) {
            text = [elt valueForKey:@"displayName"];
        }
        if (![text length]) {
            text = [elt valueForKey:@"messageForClick"];
        }
        if ([text length]) {
            int w = [bitmap bitmapWidthForText:text];
            if (w > highestWidth) {
                highestWidth = w;
            }
        }
        id hotKey = [elt valueForKey:@"hotKey"];
        if (hotKey) {
            int w = [bitmap bitmapWidthForText:hotKey];
            if (w > highestRightWidth) {
                highestRightWidth = w;
            }
        }
    }
    if (highestWidth && highestRightWidth) {
        return highestWidth + 8 + highestRightWidth + 26;
    }
    if (highestWidth) {
        return highestWidth + 8;
    }
    return 1;
}
- (int)preferredHeight
{
    int h = [_array count]*20;
    if (h) {
        return h;
    }
    return 1;
}

- (BOOL)shouldAnimate
{
    if (_closingIteration > 0) {
        return YES;
    }
    return NO;
}

- (void)beginIteration:(id)event rect:(Int4)r context:(id)context
{
    if (_closingIteration < 1) {
        return;
    }
    _closingIteration--;
    if (_closingIteration == 1) {
        id message = [_selectedObject valueForKey:@"messageForClick"];
        if (message) {
            id contextualObject = _contextualObject;
            if (!contextualObject) {
                contextualObject = _selectedObject;
            }
            [contextualObject evaluateMessage:message];
        }
        [context setValue:@"1" forKey:@"shouldCloseWindow"];
    }
}

- (void)drawInBitmap:(id)bitmap rect:(Int4)outerRect context:(id)context
{
    if (_useFixedWidthFont) {
        [bitmap useAtariSTFont];
    }

    Int4 origRect = outerRect;
    outerRect.y -= _scrollY;
    Int4 r = outerRect;
    r.x += 1;
    r.y += 1;
    r.w -= 3;
    r.h -= 3;
    [bitmap setColor:@"black"];
    [bitmap fillRect:origRect];
    [bitmap setColor:@"white"];
    [bitmap fillRect:r];

    [self setValue:nil forKey:@"selectedObject"];
    id arr = _array;
    int numberOfCells = [arr count];
    if (!numberOfCells) {
        return;
    }
    int cellHeight = 20;//r.h / numberOfCells;
    for (int i=0; i<numberOfCells; i++) {
        Int4 cellRect = [Definitions rectWithX:r.x y:r.y+i*cellHeight w:r.w h:cellHeight];
        id elt = [arr nth:i];
        id text = nil;
        id stringFormat = [elt valueForKey:@"stringFormat"];
        if ([stringFormat length]) {
            if (_contextualObject) {
                text = [_contextualObject str:stringFormat];
            } else {
                text = [elt str:stringFormat];
            }
        }
        if (![text length]) {
            text = [elt valueForKey:@"displayName"];
        }
        if (![text length]) {
            text = [elt valueForKey:@"messageForClick"];
        }
        id rightText = [elt valueForKey:@"hotKey"];
        id messageForClick = [elt valueForKey:@"messageForClick"];
        if ([messageForClick length] && [Definitions isX:_mouseX y:_mouseY insideRect:origRect] && [Definitions isX:_mouseX y:_mouseY insideRect:cellRect]) {
            if ([text length]) {
                if (_closingIteration > 0) {
                    if ((_closingIteration/10) % 2 == 0) {
                        [bitmap setColor:@"blue"];
                        [bitmap fillRect:cellRect];
                        [bitmap setColorIntR:255 g:255 b:255 a:255];
                    } else {
                        [bitmap setColor:@"black"];
                    }
                } else {
                    [bitmap setColor:@"blue"];
                    [bitmap fillRect:cellRect];
                    [bitmap setColorIntR:255 g:255 b:255 a:255];
                }
                [bitmap drawBitmapText:text x:cellRect.x+4 y:cellRect.y+4];
                if ([rightText length]) {
                    int w = [bitmap bitmapWidthForText:rightText];
                    [bitmap drawBitmapText:rightText x:cellRect.x+cellRect.w-w-4 y:cellRect.y+4];
                }
            } else {
                [bitmap setColor:@"black"];
                [bitmap drawHorizontalDashedLineAtX:cellRect.x x:cellRect.x+cellRect.w y:cellRect.y+cellRect.h/2 dashLength:1];
            }
            [self setValue:elt forKey:@"selectedObject"];
        } else {
            if ([text length]) {
                if ([messageForClick length]) {
                    [bitmap setColor:@"black"];
                    [bitmap drawBitmapText:text x:cellRect.x+4 y:cellRect.y+4];
                    if ([rightText length]) {
                        int w = [bitmap bitmapWidthForText:rightText];
                        [bitmap drawBitmapText:rightText x:cellRect.x+cellRect.w-w-4 y:cellRect.y+4];
                    }
                } else {
                    [bitmap setColor:@"black"];
                    [bitmap fillRect:cellRect];
                    [bitmap setColorIntR:255 g:255 b:255 a:255];
                    [bitmap drawBitmapText:text x:cellRect.x+4 y:cellRect.y+4];
                }
            } else {
                [bitmap setColor:@"black"];
                [bitmap drawHorizontalDashedLineAtX:cellRect.x x:cellRect.x+cellRect.w y:cellRect.y+cellRect.h/2 dashLength:1];
            }
        }
    }
}
- (void)handleKeyDown:(id)event context:(id)context
{
NSLog(@"Menu handleKeyDown");
    if (_closingIteration > 0) {
        return;
    }
    id keyString = [event valueForKey:@"keyString"];
NSLog(@"keyString %@", keyString);
    if ([keyString isEqual:@"up"]) {
        _scrollY -= 20;
    } else if ([keyString isEqual:@"down"]) {
        _scrollY += 20;
    }
}
- (void)handleScrollWheel:(id)event context:(id)context
{
NSLog(@"Menu handleScrollWheel");
    if (_closingIteration > 0) {
        return;
    }
    int dy = [event intValueForKey:@"scrollingDeltaY"];
NSLog(@"dy %d", dy);
    _scrollY += dy;
}
- (void)handleMouseMoved:(id)event context:(id)context
{
//NSLog(@"Menu handleMouseMoved");
    if (_closingIteration > 0) {
        return;
    }
    _mouseX = [event intValueForKey:@"mouseX"];
    _mouseY = [event intValueForKey:@"mouseY"];

    id prevWindowObject = [context valueForKey:@"prevWindowObject"];
    if ([prevWindowObject respondsToSelector:@selector(handleMouseMoved:context:)]) {
        id nextContext = nsdict();
        [nextContext setValue:context forKey:@"prevContext"];
        [prevWindowObject handleMouseMoved:event context:nextContext];
    }
}

- (void)handleMouseUp:(id)event context:(id)context
{
NSLog(@"Menu handleMouseUp");
    if (_closingIteration > 0) {
        return;
    }
    int mouseRootY = [event intValueForKey:@"mouseRootY"];
    if (mouseRootY == -1) {
        [self setValue:nil forKey:@"selectedObject"];
    }
    if (_selectedObject) {
        _closingIteration = 120;
    } else {
        [context setValue:@"1" forKey:@"shouldCloseWindow"];
    }

    id prevWindowObject = [context valueForKey:@"prevWindowObject"];
    if ([prevWindowObject respondsToSelector:@selector(handleMouseUp:context:)]) {
        id nextContext = nsdict();
        [nextContext setValue:context forKey:@"prevContext"];
        [prevWindowObject handleMouseUp:event context:nextContext];
    }

}
- (void)handleRightMouseUp:(id)event context:(id)context
{
    [self handleMouseUp:event context:context];
}
@end

