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

static char *frogMenuIconPalette =
"a #480000\n"
"b #282028\n"
"c #f8f8f8\n"
"d #78f010\n"
"e #50b000\n"
"f #f8b830\n"
"g #5880e0\n"
"h #d04078\n"
"i #986000\n"
"j #788020\n"
"k #485028\n"
"l #283020\n"
"m #402038\n"
"n #f800f8\n"
"o #f800f8\n"
"p #f800f8\n"
;

static char *frogMenuIconPixels =
"                \n"
"     bm  mb     \n"
"    bdebbedb    \n"
"   mcldjjdlcm   \n"
"   blleeeellb   \n"
"   bfleddelfb   \n"
"  meleeddeelem  \n"
"  bddeillieddb  \n"
"  beliccccileb  \n"
"   bfccffccfm   \n"
"  mklifccfiljm  \n"
"  bjjjllllkjjb  \n"
"  kkjjjjjjjllkm \n"
" mlcllkjjkljclb \n"
" bfflcliiclllfb \n"
" bgglifffillfcgm\n"
"bgckifcccfilkggb\n"
"bggklikfkilkgcgb\n"
" bbjlcccccglgglb\n"
;
/*
"  bklgcllcclllkb\n"
"   bfffillilfkb \n"
"    bkklllffibb \n"
"   bcggbbbkkkb  \n"
"  bgggbbbkgggb  \n"
"   mbbbbbkcggb  \n"
;
*/
@implementation Definitions(fnmjkdfsjkfsdjkeklwfmklsdmfksdkfmfjdskfjksdfjdks)
+ (id)FrogMenuItem
{
    id pixels = nscstr(frogMenuIconPixels);
    id palette = nscstr(frogMenuIconPalette);
    id highlightedPalette = palette;

    id obj = [@"BitmapMenuItem" asInstance];
    [obj setValue:pixels forKey:@"pixels"];
    [obj setValue:palette forKey:@"palette"];
    [obj setValue:highlightedPalette forKey:@"highlightedPalette"];
    return obj;
}
@end



@interface BitmapMenuItem : IvarObject
{
    id _pixels;
    id _palette;
    id _highlightedPalette;
}
@end

@implementation BitmapMenuItem
@end

