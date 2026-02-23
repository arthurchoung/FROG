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

#if 0
@implementation Definitions(jfoiwernfjejfklsdjfklsdjlkfjsdlkfjfdjskf)
+ (void)enterMacWinMode
{
    [Definitions enterMacWinMode:1];
}
+ (void)enterMacWinMode:(int)scaling
{
    if (scaling < 1) {
        scaling = 1;
    }
    [Definitions setValue:nsfmt(@"%d", scaling) forEnvironmentVariable:@"FROG_SCALING"];

    id windowManager = [Definitions windowManager];
    [windowManager setFocusDict:nil];
    [windowManager unparentAllWindows];

    [windowManager setBackgroundForCString:"b\n" palette:"b #63639c\n"];

    id rootWindowObject = [@"RootWindow" asInstance];
    [windowManager setValue:rootWindowObject forKey:@"rootWindowObject"];
    [windowManager reparentAllWindows:@"Window"];
    [[windowManager valueForKey:@"menuBar"] setValue:@"1" forKey:@"shouldCloseWindow"];
    int h = 20*scaling;
    [windowManager setValue:nsfmt(@"%d", h) forKey:@"menuBarHeight"];
    id menuBarObject = [@"MenuBar" asInstance];
    id menuBar = [windowManager openWindowForObject:menuBarObject x:0 y:0 w:[windowManager intValueForKey:@"rootWindowWidth"] h:h];
    [windowManager setValue:menuBar forKey:@"menuBar"];
    [windowManager setFocusDict:nil];
}
@end
#endif


static char *inactiveTitleBarPalette =
"b #555555\n"
". #63639C\n"
"X #DDDDDD\n"
"o #EEEEEE\n"
;
static char *inactiveTitleBarLeftPixels =
"bbbbbb\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXb\n"
;
static char *inactiveTitleBarMiddlePixels =
"b\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"b\n"
;
static char *inactiveTitleBarRightPixels =
"bbbbbbbbbbbbbbbbbb \n"
"XXXXXXXXXXXXXXXXXb \n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"bbbbbbbbbbbbbXXXXbb\n"
;
static char *inactiveWindowShadeTitleBarLeftPixels =
"bbbbbb\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bbbbbb\n"
"  bbbb\n"
;
static char *inactiveWindowShadeTitleBarMiddlePixels =
"b\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"X\n"
"b\n"
"b\n"
;
static char *inactiveWindowShadeTitleBarRightPixels =
"bbbbbbbbbbbbbbbbbb \n"
"XXXXXXXXXXXXXXXXXb \n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXbb\n"
"bbbbbbbbbbbbbbbbbbb\n"
"bbbbbbbbbbbbbbbbbbb\n"
;
static char *inactiveLeftBorderPalette =
"b #555555\n"
"X #DDDDDD\n"
"o #DDDDDD\n"
"O #DDDDDD\n"
;
static char *inactiveBottomBorderPalette =
"b #555555\n"
". #63639C\n"
"X #DDDDDD\n"
"o #EEEEEE\n"
"O #FFFFFF\n"
;
static char *inactiveBottomBorderLeftPixels =
"bXXXXb\n"
"bXXXXb\n"
"bXXXXb\n"
"bXXXXb\n"
"bXXXXb\n"
"bXXXXb\n"
"bXXXXb\n"
"bXXXXb\n"
"bXXXXb\n"
"bXXXXb\n"
"bXXXXb\n"
"bXXXXb\n"
"bXXXXb\n"
"bXXXXb\n"
"bXXXXb\n"
"bXXXXb\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bXXXXX\n"
"bbbbbb\n"
"  bbbb\n"
;
static char *inactiveBottomBorderMiddlePixels =
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
"b\n"
"X\n"
"X\n"
"X\n"
"X\n"
"b\n"
"b\n"
;
static char *inactiveBottomBorderRightPixels =
"               bXXXXbb\n"
"               bXXXXbb\n"
"               bXXXXbb\n"
"               bXXXXbb\n"
"               bXXXXbb\n"
"               bXXXXbb\n"
"               bXXXXbb\n"
"               bXXXXbb\n"
"               bXXXXbb\n"
"               bXXXXbb\n"
"               bXXXXbb\n"
"               bXXXXbb\n"
"               bXXXXbb\n"
"               bXXXXbb\n"
"               bXXXXbb\n"
"bbbbbbbbbbbbbbbbXXXXbb\n"
"XXXXXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXXXXbb\n"
"XXXXXXXXXXXXXXXXXXXXbb\n"
"bbbbbbbbbbbbbbbbbbbbbb\n"
"bbbbbbbbbbbbbbbbbbbbbb\n"
;

static char *activeTitleBarLeftPalette =
"b #000000\n"
". #222222\n"
"X #555555\n"
"o #777777\n"
"O #63639C\n"
"+ #888888\n"
"@ #999999\n"
"# #AAAAAA\n"
"$ #BBBBBB\n"
"% #CCCCCC\n"
"& #DDDDDD\n"
"* #EEEEEE\n"
"= #FFFFFF\n"
;
static char *activeTitleBarLeftPixels =
"bbbbbbbbbbbbbbbbbbbbbb\n"
"b=====================\n"
"b=%%%%%%%%%%%%%%%%%%%%\n"
"b=%%%%%%%%%%%%%%%%%%%%\n"
"b=%%++++++++++++%%%%%=\n"
"b=%%+...........=%%%%%\n"
"b=%%+.=%%%%%%%%.=%%%%=\n"
"b=%%+.%@@##$$%+.=%%%%%\n"
"b=%%+.%@##$$%%+.=%%%%=\n"
"b=%%+.%##$$%%&+.=%%%%%\n"
"b=%%+.%#$$%%&&+.=%%%%=\n"
"b=%%+.%$$%%&&*+.=%%%%%\n"
"b=%%+.%$%%&&**+.=%%%%=\n"
"b=%%+.%%%&&**=+.=%%%%%\n"
"b=%%+.%++++++++.=%%%%=\n"
"b=%%+...........=%%%%%\n"
"b=%%%============%%%%%\n"
"b=%%%%%%%%%%%%%%%%%%%%\n"
"b=%%%%%%%%%%%%%%%%%%%%\n"
"b=%%%%%%%%%%%%%%%%%%%%\n"
"b=%%@@@@@@@@@@@@@@@@@@\n"
"b=%%@bbbbbbbbbbbbbbbbb\n"
;
static char *activeWindowShadeTitleBarLeftPixels =
"bbbbbbbbbbbbbbbbbbbbbb\n"
"b=====================\n"
"b=%%%%%%%%%%%%%%%%%%%%\n"
"b=%%%%%%%%%%%%%%%%%%%%\n"
"b=%%++++++++++++%%%%%=\n"
"b=%%+...........=%%%%%\n"
"b=%%+.=%%%%%%%%.=%%%%=\n"
"b=%%+.%@@##$$%+.=%%%%%\n"
"b=%%+.%@##$$%%+.=%%%%=\n"
"b=%%+.%##$$%%&+.=%%%%%\n"
"b=%%+.%#$$%%&&+.=%%%%=\n"
"b=%%+.%$$%%&&*+.=%%%%%\n"
"b=%%+.%$%%&&**+.=%%%%=\n"
"b=%%+.%%%&&**=+.=%%%%%\n"
"b=%%+.%++++++++.=%%%%=\n"
"b=%%+...........=%%%%%\n"
"b=%%%============%%%%%\n"
"b=%%%%%%%%%%%%%%%%%%%%\n"
"b=%%%%%%%%%%%%%%%%%%%%\n"
"b=%%%%%%%%%%%%%%%%%%%%\n"
"b@@@@@@@@@@@@@@@@@@@@@\n"
"bbbbbbbbbbbbbbbbbbbbbb\n"
"  bbbbbbbbbbbbbbbbbbbb\n"
;
static char *activeTitleBarRightPalette =
"b #000000\n"
". #222222\n"
"X #777777\n"
"o #63639C\n"
"O #888888\n"
"+ #999999\n"
"@ #AAAAAA\n"
"# #BBBBBB\n"
"$ #CCCCCC\n"
"% #DDDDDD\n"
"& #EEEEEE\n"
"* #FFFFFF\n"
;
static char *activeTitleBarMiddlePixels =
"b\n"
"*\n"
"$\n"
"$\n"
"*\n"
"X\n"
"*\n"
"X\n"
"*\n"
"X\n"
"*\n"
"X\n"
"*\n"
"X\n"
"*\n"
"X\n"
"$\n"
"$\n"
"$\n"
"$\n"
"+\n"
"b\n"
;
static char *activeWindowShadeTitleBarMiddlePixels =
"b\n"
"*\n"
"$\n"
"$\n"
"*\n"
"X\n"
"*\n"
"X\n"
"*\n"
"X\n"
"*\n"
"X\n"
"*\n"
"X\n"
"*\n"
"X\n"
"$\n"
"$\n"
"$\n"
"$\n"
"+\n"
"b\n"
"b\n"
;
static char *activeTitleBarRightPixels =
"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb \n"
"************************************$b \n"
"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$+bb\n"
"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$+bb\n"
"$$$$$OOOOOOOOOOOO$$$$OOOOOOOOOOOO$$$+bb\n"
"X$$$$O...........*$$$O...........*$$+bb\n"
"$$$$$O.*$$$$.$$$.*$$$O.*$$$$$$$$.*$$+bb\n"
"X$$$$O.$++@@.#$O.*$$$O.$++@@##$O.*$$+bb\n"
"$$$$$O.$+@@#.$$O.*$$$O.$+@@##$$O.*$$+bb\n"
"X$$$$O.$@@##.$%O.*$$$O...........*$$+bb\n"
"$$$$$O.$@##$.%%O.*$$$O.$@##$$%%O.*$$+bb\n"
"X$$$$O.......%&O.*$$$O...........*$$+bb\n"
"$$$$$O.$#$$%%&&O.*$$$O.$#$$%%&&O.*$$+bb\n"
"X$$$$O.$$$%%&&*O.*$$$O.$$$%%&&*O.*$$+bb\n"
"$$$$$O.$OOOOOOOO.*$$$O.$OOOOOOOO.*$$+bb\n"
"X$$$$O...........*$$$O...........*$$+bb\n"
"$$$$$$************$$$$************$$+bb\n"
"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$+bb\n"
"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$+bb\n"
"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$+bb\n"
"+++++++++++++++++++++++++++++++++$$$+bb\n"
"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb*$$+bb\n"
;
static char *activeWindowShadeTitleBarRightPixels =
"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb \n"
"************************************$b \n"
"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$+bb\n"
"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$+bb\n"
"$$$$$OOOOOOOOOOOO$$$$OOOOOOOOOOOO$$$+bb\n"
"X$$$$O...........*$$$O...........*$$+bb\n"
"$$$$$O.*$$$$.$$$.*$$$O.*$$$$$$$$.*$$+bb\n"
"X$$$$O.$++@@.#$O.*$$$O.$++@@##$O.*$$+bb\n"
"$$$$$O.$+@@#.$$O.*$$$O.$+@@##$$O.*$$+bb\n"
"X$$$$O.$@@##.$%O.*$$$O...........*$$+bb\n"
"$$$$$O.$@##$.%%O.*$$$O.$@##$$%%O.*$$+bb\n"
"X$$$$O.......%&O.*$$$O...........*$$+bb\n"
"$$$$$O.$#$$%%&&O.*$$$O.$#$$%%&&O.*$$+bb\n"
"X$$$$O.$$$%%&&*O.*$$$O.$$$%%&&*O.*$$+bb\n"
"$$$$$O.$OOOOOOOO.*$$$O.$OOOOOOOO.*$$+bb\n"
"X$$$$O...........*$$$O...........*$$+bb\n"
"$$$$$$************$$$$************$$+bb\n"
"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$+bb\n"
"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$+bb\n"
"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$+bb\n"
"+++++++++++++++++++++++++++++++++++++bb\n"
"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\n"
"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\n"
;
static char *activeTitleBarTextLeftPixels =
"b\n"
"*\n"
"$\n"
"$\n"
"$\n"
"X\n"
"$\n"
"X\n"
"$\n"
"X\n"
"$\n"
"X\n"
"$\n"
"X\n"
"$\n"
"X\n"
"$\n"
"$\n"
"$\n"
"$\n"
"+\n"
"b\n"
;
static char *activeTitleBarTextRightPixels =
"b\n"
"*\n"
"$\n"
"$\n"
"*\n"
"$\n"
"*\n"
"$\n"
"*\n"
"$\n"
"*\n"
"$\n"
"*\n"
"$\n"
"*\n"
"$\n"
"$\n"
"$\n"
"$\n"
"$\n"
"+\n"
"b\n"
;
static char *leftBorderPalette =
"b #000000\n"
". #63639C\n"
"X #999999\n"
"o #CCCCCC\n"
"O #FFFFFF\n"
;
static char *leftBorderMiddlePixels =
"bOooXb\n"
;

static char *bottomBorderPalette =
"b #000000\n"
". #555555\n"
"X #777777\n"
"o #63639C\n"
"O #888888\n"
"+ #999999\n"
"@ #AAAAAA\n"
"# #CCCCCC\n"
"$ #EEEEEE\n"
"% #FFFFFF\n"
;
static char *bottomBorderLeftPixels =
"b%##+b\n"
"b%##+b\n"
"b%##+b\n"
"b%##+b\n"
"b%##+b\n"
"b%##+b\n"
"b%##+b\n"
"b%##+b\n"
"b%##+b\n"
"b%##+b\n"
"b%##+b\n"
"b%##+b\n"
"b%##+b\n"
"b%##+b\n"
"b%##+b\n"
"b%##+b\n"
"b%###%\n"
"b%####\n"
"b%####\n"
"b#++++\n"
"bbbbbb\n"
;
static char *bottomBorderMiddlePixels =
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
" \n"
"b\n"
"%\n"
"#\n"
"#\n"
"+\n"
"b\n"
;
static char *bottomBorderRightPixels =
"                                             b%##+bb\n"
"                                             b%##+bb\n"
"                                             b%##+bb\n"
"                                             b%##+bb\n"
"                                             b%##+bb\n"
"                                             b%##+bb\n"
"                                             b%##+bb\n"
"                                             b%##+bb\n"
"                                             b%##+bb\n"
"                                             b%##+bb\n"
"                                             b%##+bb\n"
"                                             b%##+bb\n"
"                                             b%##+bb\n"
"                                             b%##+bb\n"
"                                             b%##+bb\n"
"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb%##+bb\n"
"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%##+bb\n"
"#################################################+bb\n"
"#################################################+bb\n"
"++++++++++++++++++++++++++++++++++++++++++++++++++bb\n"
"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\n"
"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\n"
;


static char *rightBorderPalette =
"b #000000\n"
". #555555\n"
"X #777777\n"
"o #63639C\n"
"O #888888\n"
"+ #999999\n"
"@ #AAAAAA\n"
"# #CCCCCC\n"
"$ #DDDDDD\n"
"% #EEEEEE\n"
"& #FFFFFF\n"
;
static char *rightBorderTopPixels =
"b&##+bb\n"
;
static char *rightBorderMiddlePixels =
"b&##+bb\n"
;
static char *rightBorderBottomPixels =
"b&##+bb\n"
"b&##+bb\n"
"b&##+bb\n"
"b&##+bb\n"
"b&##+bb\n"
"b&##+bb\n"
"b&##+bb\n"
"b&##+bb\n"
"b&##+bb\n"
"b&##+bb\n"
"b&##+bb\n"
"b&##+bb\n"
"b&##+bb\n"
"b&##+bb\n"
"b&##+bb\n"
"b&##+bb\n"
"b&##+bb\n"
"b&##+bb\n"
"b&##+bb\n"
"b&##+bb\n"
"b&##+bb\n"
"b&##+bb\n"
"b&##+bb\n"
"b&##+bb\n"
"b&##+bb\n"
"b&##+bb\n"
"b&##+bb\n"
"b&##+bb\n"
"b&##+bb\n"
"b&##+bb\n"
;

static char *inactiveRightBorderPalette =
"b #555555\n"
". #63639C\n"
"X #DDDDDD\n"
"o #EEEEEE\n"
"O #FFFFFF\n"
;

static char *inactiveRightBorderTopPixels =
"bXXXXbb\n"
;
static char *inactiveRightBorderMiddlePixels =
"bXXXXbb\n"
;



static char *closeButtonDownPalette =
"b #000000\n"
". #111111\n"
"X #222222\n"
"o #333333\n"
"O #444444\n"
"+ #555555\n"
"@ #666666\n"
"# #777777\n"
"$ #888888\n"
"% #999999\n"
"& #AAAAAA\n"
"* #BBBBBB\n"
"= #CCCCCC\n"
"- #DDDDDD\n"
"; #EEEEEE\n"
": #FFFFFF\n"
;
static char *closeButtonDownPixels =
"$$$$$$$$$$$$=\n"
"$XXXXXXXXXXX:\n"
"$XOO++@@##$X:\n"
"$XO++@@##$$X:\n"
"$X++@@##$$%X:\n"
"$X+@@##$$%%X:\n"
"$X@@##$$%%%X:\n"
"$X@##$$%%&%X:\n"
"$X##$$%%&&%X:\n"
"$X#$$%%&&*%X:\n"
"$X$$%%%%%%%X:\n"
"$XXXXXXXXXXX:\n"
"=::::::::::::\n"
;

static char *shadeButtonDownPalette =
"b #000000\n"
". #111111\n"
"X #222222\n"
"o #333333\n"
"O #444444\n"
"+ #555555\n"
"@ #666666\n"
"# #777777\n"
"$ #888888\n"
"% #999999\n"
"& #AAAAAA\n"
"* #BBBBBB\n"
"= #CCCCCC\n"
"- #DDDDDD\n"
"; #EEEEEE\n"
": #FFFFFF\n"
;
static char *shadeButtonDownPixels =
"$$$$$$$$$$$$=\n"
"$XXXXXXXXXXX:\n"
"$XOO++@@##$X:\n"
"$XO++@@##$$X:\n"
"$X++@@##$$%X:\n"
"$XXXXXXXXXXX:\n"
"$X@@##$$%%%X:\n"
"$XXXXXXXXXXX:\n"
"$X##$$%%&&%X:\n"
"$X#$$%%&&*%X:\n"
"$X$$%%%%%%%X:\n"
"$XXXXXXXXXXX:\n"
"=::::::::::::\n"
;

static char *maximizeButtonDownPalette =
"b #000000\n"
". #111111\n"
"X #222222\n"
"o #333333\n"
"O #444444\n"
"+ #555555\n"
"@ #666666\n"
"# #777777\n"
"$ #888888\n"
"% #999999\n"
"& #AAAAAA\n"
"* #BBBBBB\n"
"= #CCCCCC\n"
"- #DDDDDD\n"
"; #EEEEEE\n"
": #FFFFFF\n"
;
static char *maximizeButtonDownPixels =
"$$$$$$$$$$$$=\n"
"$XXXXXXXXXXX:\n"
"$XOO++@X##$X:\n"
"$XO++@@X#$$X:\n"
"$X++@@#X$$%X:\n"
"$X+@@##X$%%X:\n"
"$X@@##$X%%%X:\n"
"$XXXXXXX%&%X:\n"
"$X##$$%%&&%X:\n"
"$X#$$%%&&*%X:\n"
"$X$$%%%%%%%X:\n"
"$XXXXXXXXXXX:\n"
"=::::::::::::\n"
;
static char *moveSelectionTopLeftPixels =
"bw\n"
"ww\n"
;
static char *moveSelectionTopPixels =
"bw\n"
"bw\n"
;
static char *moveSelectionLeftPixels =
"bb\n"
"ww\n"
;
static char *moveSelectionRightPixels =
"bw\n"
"wb\n"
;
static char *moveSelectionBottomPixels =
"bw\n"
"wb\n"
;
static char *resizeSelectionHorizontalPixels =
"bw\n"
;
static char *resizeSelectionVerticalPixels =
"b\n"
"w\n"
;

@interface WaylandWindow : IvarObject
{
    int _leftBorder;
    int _rightBorder;
    int _topBorder;
    int _bottomBorder;
    id _x11HasChildMask;

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
    Int4 _bottomBorderRect;
    Int4 _closeButtonRect;
    Int4 _shadeButtonRect;
    Int4 _maximizeButtonRect;
    Int4 _resizeButtonRect;

    // setPixelScale:
    int _pixelScaling;
    id _scaledFont;

    id _scaledInactiveTitleBarLeftPixels;
    id _scaledInactiveWindowShadeTitleBarLeftPixels;
    id _scaledInactiveTitleBarMiddlePixels;
    id _scaledInactiveWindowShadeTitleBarMiddlePixels;
    id _scaledInactiveTitleBarRightPixels;
    id _scaledInactiveWindowShadeTitleBarRightPixels;
    id _scaledInactiveBottomBorderLeftPixels;
    id _scaledInactiveBottomBorderMiddlePixels;
    id _scaledInactiveBottomBorderRightPixels;
    id _scaledActiveTitleBarLeftPixels;
    id _scaledActiveWindowShadeTitleBarLeftPixels;
    int _scaledActiveTitleBarLeftWidth;
    id _scaledActiveTitleBarMiddlePixels;
    id _scaledActiveWindowShadeTitleBarMiddlePixels;
    int _scaledActiveTitleBarHeight;
    id _scaledActiveTitleBarRightPixels;
    id _scaledActiveWindowShadeTitleBarRightPixels;
    int _scaledActiveTitleBarRightWidth;
    id _scaledActiveTitleBarTextLeftPixels;
    id _scaledActiveTitleBarTextRightPixels;
    id _scaledLeftBorderMiddlePixels;
    id _scaledBottomBorderLeftPixels;
    id _scaledBottomBorderMiddlePixels;
    id _scaledBottomBorderRightPixels;
    id _scaledRightBorderTopPixels;
    id _scaledRightBorderMiddlePixels;
    id _scaledRightBorderBottomPixels;
    id _scaledInactiveRightBorderTopPixels;
    id _scaledInactiveRightBorderMiddlePixels;
    id _scaledCloseButtonDownPixels;
    id _scaledShadeButtonDownPixels;
    id _scaledMaximizeButtonDownPixels;

    id _mouseDownTimestamp;
}
@end
@implementation WaylandWindow
- (id)init
{
    self = [super init];
    if (self) {
        int scaling = [[Definitions valueForEnvironmentVariable:@"FROG_SCALING"] intValue];
        if (scaling < 1) {
            scaling = 1;
        }
        [self setPixelScaling:scaling];

    }
    return self;
}
- (int *)x11WindowMaskPointsForWidth:(int)w height:(int)h
{
    static int points[9];
    points[0] = 9; // length of array including this number

    points[1] = 0; // lower left corner
    points[2] = h-1;
    points[3] = 1;
    points[4] = h-1;

    points[5] = w-1; // upper right corner
    points[6] = 0;
    points[7] = w-1;
    points[8] = 1;
    return points;
}
- (void)setPixelScaling:(int)scaling
{
    _pixelScaling = scaling;

    _leftBorder = 6*_pixelScaling;
    _rightBorder = (6+1)*_pixelScaling;
    _topBorder = 22*_pixelScaling;
    _bottomBorder = (6+1)*_pixelScaling;
//    [self setValue:nsfmt(@"bottomRightCorner w:%d h:%d", 15*scaling, 15*scaling) forKey:@"x11HasChildMask"];

    id obj;
    obj = [Definitions scaleFont:scaling
                    :[Definitions arrayOfCStringsForChicagoFont]
                    :[Definitions arrayOfWidthsForChicagoFont]
                    :[Definitions arrayOfHeightsForChicagoFont]
                    :[Definitions arrayOfXSpacingsForChicagoFont]];
    [self setValue:obj forKey:@"scaledFont"];

    obj = [nsfmt(@"%s", inactiveTitleBarLeftPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledInactiveTitleBarLeftPixels"];

    obj = [nsfmt(@"%s", inactiveWindowShadeTitleBarLeftPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledInactiveWindowShadeTitleBarLeftPixels"];

    obj = [nsfmt(@"%s", inactiveTitleBarMiddlePixels) asYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledInactiveTitleBarMiddlePixels"];

    obj = [nsfmt(@"%s", inactiveWindowShadeTitleBarMiddlePixels) asYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledInactiveWindowShadeTitleBarMiddlePixels"];

    obj = [nsfmt(@"%s", inactiveTitleBarRightPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledInactiveTitleBarRightPixels"];

    obj = [nsfmt(@"%s", inactiveWindowShadeTitleBarRightPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledInactiveWindowShadeTitleBarRightPixels"];

    obj = [nsfmt(@"%s", inactiveBottomBorderLeftPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledInactiveBottomBorderLeftPixels"];

    obj = [nsfmt(@"%s", inactiveBottomBorderMiddlePixels) asYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledInactiveBottomBorderMiddlePixels"];

    obj = [nsfmt(@"%s", inactiveBottomBorderRightPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledInactiveBottomBorderRightPixels"];

    obj = [nsfmt(@"%s", activeTitleBarLeftPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledActiveTitleBarLeftPixels"];
    _scaledActiveTitleBarLeftWidth = [Definitions widthForCString:[obj UTF8String]];

    obj = [nsfmt(@"%s", activeWindowShadeTitleBarLeftPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledActiveWindowShadeTitleBarLeftPixels"];

    obj = [nsfmt(@"%s", activeTitleBarMiddlePixels) asYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledActiveTitleBarMiddlePixels"];
    _scaledActiveTitleBarHeight = [Definitions heightForCString:[obj UTF8String]];
    obj = [nsfmt(@"%s", activeWindowShadeTitleBarMiddlePixels) asYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledActiveWindowShadeTitleBarMiddlePixels"];

    obj = [nsfmt(@"%s", activeTitleBarRightPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledActiveTitleBarRightPixels"];
    _scaledActiveTitleBarRightWidth = [Definitions widthForCString:[obj UTF8String]];

    obj = [nsfmt(@"%s", activeWindowShadeTitleBarRightPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledActiveWindowShadeTitleBarRightPixels"];

    obj = [nsfmt(@"%s", activeTitleBarTextLeftPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledActiveTitleBarTextLeftPixels"];

    obj = [nsfmt(@"%s", activeTitleBarTextRightPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledActiveTitleBarTextRightPixels"];

    obj = [nsfmt(@"%s", leftBorderMiddlePixels) asXScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledLeftBorderMiddlePixels"];

    obj = [nsfmt(@"%s", bottomBorderLeftPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledBottomBorderLeftPixels"];

    obj = [nsfmt(@"%s", bottomBorderMiddlePixels) asYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledBottomBorderMiddlePixels"];

    obj = [nsfmt(@"%s", bottomBorderRightPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledBottomBorderRightPixels"];

    obj = [nsfmt(@"%s", rightBorderTopPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledRightBorderTopPixels"];

    obj = [nsfmt(@"%s", rightBorderMiddlePixels) asXScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledRightBorderMiddlePixels"];

    obj = [nsfmt(@"%s", rightBorderBottomPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledRightBorderBottomPixels"];

    obj = [nsfmt(@"%s", inactiveRightBorderTopPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledInactiveRightBorderTopPixels"];

    obj = [nsfmt(@"%s", inactiveRightBorderMiddlePixels) asXScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledInactiveRightBorderMiddlePixels"];

    obj = [nsfmt(@"%s", closeButtonDownPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledCloseButtonDownPixels"];

    obj = [nsfmt(@"%s", shadeButtonDownPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledShadeButtonDownPixels"];

    obj = [nsfmt(@"%s", maximizeButtonDownPixels) asXYScaledPixels:scaling];
    [self setValue:obj forKey:@"scaledMaximizeButtonDownPixels"];
}

- (void)calculateRects:(Int4)r
{
    _titleBarRect = [Definitions rectWithX:r.x y:r.y w:r.w h:_scaledActiveTitleBarHeight];
    _titleBarTextRect = _titleBarRect;
    _titleBarTextRect.x = _scaledActiveTitleBarLeftWidth+4*_pixelScaling;
    _titleBarTextRect.w -= _scaledActiveTitleBarLeftWidth+_scaledActiveTitleBarRightWidth+(4+4)*_pixelScaling;

    _leftBorderRect = r;
    _leftBorderRect.y += _scaledActiveTitleBarHeight;
    _leftBorderRect.h -= _scaledActiveTitleBarHeight;
    _leftBorderRect.h -= _bottomBorder;
    _leftBorderRect.w = _leftBorder;

//FIXME pixelScaling
    _rightBorderRect = r;
    _rightBorderRect.x += r.w-_rightBorder;
    _rightBorderRect.y += _scaledActiveTitleBarHeight;
    _rightBorderRect.h -= _scaledActiveTitleBarHeight;
    _rightBorderRect.h -= _bottomBorder;
    _rightBorderRect.w = _rightBorder;

    _bottomBorderRect = _titleBarRect;
    _bottomBorderRect.y += r.h-_bottomBorder;
    _bottomBorderRect.h = _bottomBorder;

    _closeButtonRect = _titleBarRect;
    _closeButtonRect.x += 4*_pixelScaling;
    _closeButtonRect.y += 4*_pixelScaling;
    _closeButtonRect.w = 13*_pixelScaling;
    _closeButtonRect.h = 13*_pixelScaling;

    _shadeButtonRect = _titleBarRect;
    _shadeButtonRect.x = _shadeButtonRect.x+_shadeButtonRect.w-18*_pixelScaling;
    _shadeButtonRect.y += 4*_pixelScaling;
    _shadeButtonRect.w = 13*_pixelScaling;
    _shadeButtonRect.h = 13*_pixelScaling;

    _maximizeButtonRect = _titleBarRect;
    _maximizeButtonRect.x = _maximizeButtonRect.x+_maximizeButtonRect.w-(18+3+13)*_pixelScaling;
    _maximizeButtonRect.y += 4*_pixelScaling;
    _maximizeButtonRect.w = 13*_pixelScaling;
    _maximizeButtonRect.h = 13*_pixelScaling;
}
- (void)drawInBitmap:(id)bitmap rect:(Int4)r
{
    [self drawInBitmap:bitmap rect:r context:nil];
}
- (void)drawInBitmap:(id)bitmap rect:(Int4)r context:(id)context
{
    BOOL windowShade = NO;
    if (r.h == 23*_pixelScaling) {
        windowShade = YES;
    }

    if (_scaledFont) {
        [bitmap useFont:[[_scaledFont nth:0] bytes]
                    :[[_scaledFont nth:1] bytes]
                    :[[_scaledFont nth:2] bytes]
                    :[[_scaledFont nth:3] bytes]];
    }

    int hasFocus = [context intValueForKey:@"hasFocus"];

    [self calculateRects:r];
    if (windowShade) {
        if (hasFocus) {
            char *leftPalette = activeTitleBarLeftPalette;
            char *rightPalette = activeTitleBarRightPalette;
            char *left = [_scaledActiveWindowShadeTitleBarLeftPixels UTF8String];
            char *middle = [_scaledActiveWindowShadeTitleBarMiddlePixels UTF8String];
            char *right = [_scaledActiveWindowShadeTitleBarRightPixels UTF8String];
            [Definitions drawInBitmap:bitmap left:left palette:leftPalette middle:middle palette:rightPalette right:right palette:rightPalette x:_titleBarRect.x y:_titleBarRect.y w:_titleBarRect.w];
        } else {
            char *palette = inactiveTitleBarPalette;
            char *left = [_scaledInactiveWindowShadeTitleBarLeftPixels UTF8String];
            char *middle = [_scaledInactiveWindowShadeTitleBarMiddlePixels UTF8String];
            char *right = [_scaledInactiveWindowShadeTitleBarRightPixels UTF8String];
            [Definitions drawInBitmap:bitmap left:left palette:palette middle:middle palette:palette right:right palette:palette x:_titleBarRect.x y:_titleBarRect.y w:_titleBarRect.w];
        }
    } else {
        if (hasFocus) {
            char *leftPalette = activeTitleBarLeftPalette;
            char *rightPalette = activeTitleBarRightPalette;
            char *left = [_scaledActiveTitleBarLeftPixels UTF8String];
            char *middle = [_scaledActiveTitleBarMiddlePixels UTF8String];
            char *right = [_scaledActiveTitleBarRightPixels UTF8String];
            [Definitions drawInBitmap:bitmap left:left palette:leftPalette middle:middle palette:rightPalette right:right palette:rightPalette x:_titleBarRect.x y:_titleBarRect.y w:_titleBarRect.w];
        } else {
            char *palette = inactiveTitleBarPalette;
            char *left = [_scaledInactiveTitleBarLeftPixels UTF8String];
            char *middle = [_scaledInactiveTitleBarMiddlePixels UTF8String];
            char *right = [_scaledInactiveTitleBarRightPixels UTF8String];
            [Definitions drawInBitmap:bitmap left:left palette:palette middle:middle palette:palette right:right palette:palette x:_titleBarRect.x y:_titleBarRect.y w:_titleBarRect.w];
        }
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
                char *palette = activeTitleBarRightPalette;
                char *titleTextLeft = [_scaledActiveTitleBarTextLeftPixels UTF8String];
                char *titleTextRight = [_scaledActiveTitleBarTextRightPixels UTF8String];
                [bitmap setColor:@"#ccccccff"];
                [bitmap fillRect:[Definitions rectWithX:backX y:_titleBarTextRect.y+2*_pixelScaling w:backWidth h:16*_pixelScaling]];
                [bitmap drawCString:titleTextLeft palette:palette x:backX y:_titleBarTextRect.y];
                [bitmap drawCString:titleTextRight palette:palette x:backX+backWidth-1*_pixelScaling y:_titleBarTextRect.y];
                [bitmap setColorIntR:0 g:0 b:0 a:255];
                [bitmap drawBitmapText:text x:textX y:_titleBarTextRect.y+4*_pixelScaling];
            } else {
                [bitmap setColorIntR:0x77 g:0x77 b:0x77 a:255];
                [bitmap drawBitmapText:text x:textX y:_titleBarTextRect.y+4*_pixelScaling];
            }
        }
    }

if (!windowShade) {
    {
        char *palette = (hasFocus) ? leftBorderPalette : inactiveLeftBorderPalette;
        char *middle = [_scaledLeftBorderMiddlePixels UTF8String];
        [Definitions drawInBitmap:bitmap top:middle palette:palette middle:middle palette:palette bottom:middle palette:palette x:_leftBorderRect.x y:_leftBorderRect.y h:_leftBorderRect.h];
    }
    if (hasFocus) {
        char *palette = rightBorderPalette;
        char *top = [_scaledRightBorderTopPixels UTF8String];
        char *middle = [_scaledRightBorderMiddlePixels UTF8String];
        char *bottom = [_scaledRightBorderBottomPixels UTF8String];
        [Definitions drawInBitmap:bitmap top:middle palette:palette middle:middle palette:palette bottom:bottom palette:palette x:_rightBorderRect.x y:_rightBorderRect.y h:_rightBorderRect.h];
    } else {
        char *palette = inactiveRightBorderPalette;
        char *top = [_scaledInactiveRightBorderTopPixels UTF8String];
        char *middle = [_scaledInactiveRightBorderMiddlePixels UTF8String];
        char *bottom = [_scaledInactiveRightBorderMiddlePixels UTF8String];
        [Definitions drawInBitmap:bitmap top:middle palette:palette middle:middle palette:palette bottom:bottom palette:palette x:_rightBorderRect.x y:_rightBorderRect.y h:_rightBorderRect.h];
    }

    if (hasFocus) {
        Int4 r = _bottomBorderRect;
        char *palette = bottomBorderPalette;
        char *left = [_scaledBottomBorderLeftPixels UTF8String];
        char *middle = [_scaledBottomBorderMiddlePixels UTF8String];
        char *right = [_scaledBottomBorderRightPixels UTF8String];
        [Definitions drawInBitmap:bitmap left:left middle:middle right:right x:r.x y:r.y-15*_pixelScaling w:r.w palette:palette];
    } else {
        Int4 r = _bottomBorderRect;
        char *palette = inactiveBottomBorderPalette;
        char *left = [_scaledInactiveBottomBorderLeftPixels UTF8String];
        char *middle = [_scaledInactiveBottomBorderMiddlePixels UTF8String];
        char *right = [_scaledInactiveBottomBorderRightPixels UTF8String];
        [Definitions drawInBitmap:bitmap left:left middle:middle right:right x:r.x y:r.y-15*_pixelScaling w:r.w palette:palette];
    }
}

    if (hasFocus) {
        if ((_buttonDown == 'c') && (_buttonHover == 'c')) {
            char *palette = closeButtonDownPalette;
            char *closeButtonDown = [_scaledCloseButtonDownPixels UTF8String];
            [bitmap drawCString:closeButtonDown palette:palette x:_closeButtonRect.x y:_closeButtonRect.y];
        }
        if ((_buttonDown == 'm') && (_buttonHover == 'm')) {
            char *palette = maximizeButtonDownPalette;
            char *maximizeButtonDown = [_scaledMaximizeButtonDownPixels UTF8String];
            [bitmap drawCString:maximizeButtonDown palette:palette x:_maximizeButtonRect.x y:_maximizeButtonRect.y];
        }
        if ((_buttonDown == 's') && (_buttonHover == 's')) {
            char *palette = shadeButtonDownPalette;
            char *shadeButtonDown = [_scaledShadeButtonDownPixels UTF8String];
            [bitmap drawCString:shadeButtonDown palette:palette x:_shadeButtonRect.x y:_shadeButtonRect.y];
        }
        if (_buttonDown == 't') {
//FIXME pixelScaling
            char *palette = "b #000000\nw #ffffff\n";
            char *topLeft = moveSelectionTopLeftPixels;
            char *top = moveSelectionTopPixels;
            char *left = moveSelectionLeftPixels;
            char *right = moveSelectionRightPixels;
            char *bottom = moveSelectionBottomPixels;
            [Definitions drawInBitmap:bitmap left:topLeft middle:top right:right x:r.x y:r.y w:r.w palette:palette];
            [Definitions drawInBitmap:bitmap top:left palette:palette middle:left palette:palette bottom:bottom palette:palette x:r.x y:r.y+2 h:r.h-4];
            [Definitions drawInBitmap:bitmap top:right palette:palette middle:right palette:palette bottom:right palette:palette x:r.x+r.w-2 y:r.y+2 h:r.h-4];
            [Definitions drawInBitmap:bitmap left:bottom middle:bottom right:bottom x:r.x y:r.y+r.h-2 w:r.w palette:palette];
        }
        if (_buttonDown == 'r') {
//FIXME pixelScaling
            char *palette = "b #000000\nw #ffffff\n";
            char *h = resizeSelectionHorizontalPixels;
            char *v = resizeSelectionVerticalPixels;
            [Definitions drawInBitmap:bitmap left:h middle:h right:h x:r.x y:r.y w:r.w palette:palette];
            [Definitions drawInBitmap:bitmap top:v palette:palette middle:v palette:palette bottom:v palette:palette x:r.x y:r.y+1 h:r.h-2];
            [Definitions drawInBitmap:bitmap top:v palette:palette middle:v palette:palette bottom:v palette:palette x:r.x+r.w-1 y:r.y+1 h:r.h-2];
            [Definitions drawInBitmap:bitmap left:h middle:h right:h x:r.x y:r.y+r.h-1 w:r.w palette:palette];

            [Definitions drawInBitmap:bitmap left:h middle:h right:h x:r.x+_leftBorder-1 y:r.y+_topBorder-1 w:r.w-(_leftBorder-1)-(_leftBorder-1) palette:palette];
            [Definitions drawInBitmap:bitmap top:v palette:palette middle:v palette:palette bottom:v palette:palette x:r.x+_leftBorder-1 y:r.y+_topBorder-1 h:r.h-(_topBorder-1)-5];
            [Definitions drawInBitmap:bitmap top:v palette:palette middle:v palette:palette bottom:v palette:palette x:r.x+r.w-7 y:r.y+_topBorder-1 h:r.h-(_topBorder-1)-(_bottomBorder-1)];
            [Definitions drawInBitmap:bitmap left:h middle:h right:h x:r.x+_leftBorder-1 y:r.y+r.h-7 w:r.w-(_leftBorder-1)-(_rightBorder-1) palette:palette];

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
    } else if ((y >= h-7*_pixelScaling) && (y < h)) {
        if ((x >= 0) && (x < 23*_pixelScaling)) {
            return '1';
        } else if ((x >= w-23*_pixelScaling) && (x < w)) {
            return '3';
        } else {
            return '2';
        }
    } else if ((x >= 0) && (x < 6*_pixelScaling)) {
        if ((y >= 0) && (y < 23*_pixelScaling)) {
            return '7';
        } else if ((y >= h-23*_pixelScaling) && (y < h)) {
            return '1';
        } else {
            return '4';
        }
    } else if ((x >= w-7*_pixelScaling) && (x < w)) {
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

    BOOL windowShade = NO;
    if (x11H == 23*_pixelScaling) {
        windowShade = YES;
    }

    if ([Definitions isX:mouseX y:mouseY insideRect:_closeButtonRect]) {
        _buttonDown = 'c';
        _buttonHover = 'c';
        _buttonDownX = mouseX;
        _buttonDownY = mouseY;
        _buttonDownW = x11W;
        _buttonDownH = x11H;
        return;
    }
    if ([Definitions isX:mouseX y:mouseY insideRect:_maximizeButtonRect]) {
        _buttonDown = 'm';
        _buttonHover = 'm';
        _buttonDownX = mouseX;
        _buttonDownY = mouseY;
        _buttonDownW = x11W;
        _buttonDownH = x11H;
        return;
    }
    if ([Definitions isX:mouseX y:mouseY insideRect:_shadeButtonRect]) {
        _buttonDown = 's';
        _buttonHover = 's';
        _buttonDownX = mouseX;
        _buttonDownY = mouseY;
        _buttonDownW = x11W;
        _buttonDownH = x11H;
        return;
    }
    if (!windowShade) {
        int border = [self borderForX:mouseX y:mouseY w:x11W h:x11H];
        if (border) {
            _buttonDown = border;
            _buttonDownX = mouseX;
            _buttonDownY = mouseY;
            _buttonDownW = x11W;
            _buttonDownH = x11H;
            return;
        }
    }
    if ([Definitions isX:mouseX y:mouseY insideRect:_titleBarRect]) {
        id timestamp = [Definitions gettimeofday];
        if (_mouseDownTimestamp) {
            if ([timestamp doubleValue]-[_mouseDownTimestamp doubleValue] <= 0.3) {
                [self x11ToggleWindowShade:x11dict];
                [self setValue:nil forKey:@"mouseDownTimestamp"];
                return;
            }
        }
        [self setValue:timestamp forKey:@"mouseDownTimestamp"];
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
        if ([Definitions isX:mouseX y:mouseY insideRect:_maximizeButtonRect]) {
            _buttonHover = 'm';
        } else {
            _buttonHover = 0;
        }
        return;
    }
    if (_buttonDown == 's') {
        int mouseX = [event intValueForKey:@"mouseX"];
        int mouseY = [event intValueForKey:@"mouseY"];
        if ([Definitions isX:mouseX y:mouseY insideRect:_shadeButtonRect]) {
            _buttonHover = 's';
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

/*
        if (newX < 0) {
            newX = 0;
        }
        if (newY < menuBarHeight) {
            newY = menuBarHeight;
        }
*/

        [x11dict setValue:nsfmt(@"%d %d", newX, newY) forKey:@"moveWindow"];

        return;
    }

    int x11H = [x11dict intValueForKey:@"h"];

    BOOL windowShade = NO;
    if (x11H == 23*_pixelScaling) {
        windowShade = YES;
    }
    if (windowShade) {
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
    if ((_buttonDown == 's') && (_buttonHover == 's')) {
        [self x11ToggleWindowShade:x11dict];
    }
    if (_buttonDown == 't') {
        int h = [x11dict intValueForKey:@"h"];
        if (h != 23) {
            /* this was added for Wine */
            [x11dict x11MoveChildWindowBackAndForthForWine];
        }
    }

    _buttonDown = 0;
}
- (void)x11ToggleWindowShade:(id)dict
{
    unsigned long win = [dict unsignedLongValueForKey:@"window"];
    int h = [dict intValueForKey:@"h"];
    id revert = [dict valueForKey:@"revertWindowShade"];
    if ((h == 23) && revert) {
        int w = [dict intValueForKey:@"w"];
        int newH = [revert intValue];
        [dict setValue:nsfmt(@"%d %d", w, newH) forKey:@"resizeWindow"];
        [dict setValue:nil forKey:@"revertWindowShade"];
        [dict setValue:nil forKey:@"revertMaximize"];
    } else {
        int x = [dict intValueForKey:@"x"];
        int y = [dict intValueForKey:@"y"];
        int w = [dict intValueForKey:@"w"];
        [dict setValue:nsfmt(@"%d", h) forKey:@"revertWindowShade"];
        [dict setValue:nsfmt(@"%d %d", w, 23*_pixelScaling) forKey:@"resizeWindow"];
        [dict setValue:nsfmt(@"%d %d %d %d", x, y, w, h) forKey:@"revertMaximize"];
        [dict setValue:nsfmt(@"%d %d", _leftBorder*_pixelScaling, 23*_pixelScaling) forKey:@"moveChildWindow"];
    }
}
@end

