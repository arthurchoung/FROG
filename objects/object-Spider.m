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

@implementation Definitions(emjfkwlmfkldlskfm)
+ (id)Spider
{
    id obj = [@"Spider" asInstance];
    [obj setup];
    return obj;
}
@end

#define NUMBER_OF_PILES 10
#define NUMBER_OF_CARDS 104

static char *card_icon_palette_normal = 
"b #000000\n"
"o #808080\n"
"O #c0c0c0\n"
"X #2020a0\n"
". #ffffff\n"
"* #000000\n"
;
static char *card_icon_palette_outline = 
"b #ffffff\n"
;
static char *card_icon =
"     bbbbbbbbbbb        \n"
"    bOOOOOOOOOOObb      \n"
"    bOOOOOOOOOOOOOb     \n"
"     bbbbbbbbbbbbbbb    \n"
"      bOOOOOOOOOOOObo   \n"
"    bbbbbbbbbbbbOOOboo  \n"
"   b............bOOboo  \n"
"   b..*......*..bOOboo  \n"
"   b.***....***.bOOboo  \n"
"   b.***....***.bObboo  \n"
"   b..*......*..bbOObo  \n"
"  bbbbbb..bbbbbbbOOOOb  \n"
" bbOOOOb..bOOOOObbOOboo \n"
"bObObbbObbObbbbObObboooo\n"
"bObObXXXXXXXXXbObOObooo \n"
" bbObXXXXXXXXXbObOOboo  \n"
"  bObXXXXXXXXXbObOOboo  \n"
"  bObXXXXXXXXXbObOOboo  \n"
"  bObXXXXXXXXXbObOOboo  \n"
"  bObXXXXXXXXXbObOOboo  \n"
"  bObXXXXXXXXXbObOOboo  \n"
"  bObXXXXXXXXXbObOOboo  \n"
"  bObXXXXXXXXXbObOOboo  \n"
"  bObXXXXXXXXXbObOOboo  \n"
"  bObXXXXXXXXXbObOOboo  \n"
"  bObXXXXXXXXXbObOOboo  \n"
"  bObXXXXXXXXXbObOOboo  \n"
"  bObbbbbbbbbbbObObooo  \n"
"  bOOOOOOOOOOOOObbooo   \n"
"  bbbbbbbbbbbbbbbooo    \n"
;
//"    ooooooooooooooo     \n"
//"    oooooooooooooo      \n"
//;

@implementation Definitions(fjkdlsjflksdjklfjfksdjf)
+ (id)writeAllCardsToFiles
{
    char *cardRanks = "A23456789TJQK";
    char *cardSuits = "cdhs";
    for (int i=0; i<52; i++) {
        int rank = i % 13;
        int suit = i / 13;
        id path = [Definitions homeDir:nsfmt(@"cards/card_%c%c.txt", cardRanks[rank], cardSuits[suit])];
        char *pixels = [Definitions pixelsForCard:i];
        char *palette = [Definitions paletteForCard:i];
        [nsfmt(@"palette\n%s\npixels\n%s\n", palette, pixels) writeToFile:path];
    }
    return @"OK";
}
@end

@implementation Definitions(jfkdlsjfkldskfj)
#ifdef BUILD_FOR_IOS
#else
//FIXME
+ (BOOL)isiPad
{
    return YES;
}
#endif

+ (id)generateAppCardIconBitmap
{
    id bitmap = [[[@"Bitmap" alloc] initWithWidth:32 height:32] autorelease];
    [bitmap setColorIntR:0 g:170 b:85 a:255];
    [bitmap fillRect:[Definitions rectWithX:0 y:0 w:32 h:32]];
    [bitmap drawCString:card_icon palette:card_icon_palette_normal x:4 y:30];
    return bitmap;
}
+ (id)generateiPadProCardIconBitmap
{
    id bitmap = [[[@"Bitmap" alloc] initWithWidth:42 height:42] autorelease];
    [bitmap setColorIntR:0 g:170 b:85 a:255];
    [bitmap fillRect:[Definitions rectWithX:0 y:0 w:42 h:42]];
    [bitmap drawCString:card_icon palette:card_icon_palette_normal x:9 y:35];
    return bitmap;
}
+ (id)generateiPadCardIconBitmap
{
    id bitmap = [[[@"Bitmap" alloc] initWithWidth:38 height:38] autorelease];
    [bitmap setColorIntR:0 g:170 b:85 a:255];
    [bitmap fillRect:[Definitions rectWithX:0 y:0 w:38 h:38]];
    [bitmap drawCString:card_icon palette:card_icon_palette_normal x:7 y:33];
    return bitmap;
}
+ (id)generateiPhoneCardIconBitmap
{
    id bitmap = [[[@"Bitmap" alloc] initWithWidth:30 height:30] autorelease];
    [bitmap setColorIntR:0 g:170 b:85 a:255];
    [bitmap fillRect:[Definitions rectWithX:0 y:0 w:30 h:30]];
    [bitmap drawCString:card_icon palette:card_icon_palette_normal x:3 y:29];
    return bitmap;
}
+ (id)generateCardIconImage
{
    id bitmap = [[[@"Bitmap" alloc] initWithWidth:30 height:30] autorelease];
    [bitmap drawCString:card_icon palette:card_icon_palette_outline x:3 y:29];
    return [Definitions convertBitmapToUIImage:bitmap];
}
+ (id)deckOfCards:(int)numberOfCards
{
    id arr = nsarr();
    for (int i=0; i<numberOfCards; i++) {
        [arr addObject:nsfmt(@"%d", i%52)];
    }
    return arr;
}
+ (id)shuffledDeckOfCards:(int)numberOfCards
{
    id arr = nsarr();
    for (int i=0; i<numberOfCards; i++) {
        [arr addObject:nsfmt(@"%d", i%52)];
    }
    for (int i=0; i<13; i++) {
        arr = [arr asShuffledArray];
    }
    return arr;
}
+ (id)textForCard:(int)index
{
    if (index < 0) {
        return nil;
    }
    index = index%52;
    char *cardRanks = "A23456789TJQK";
    char *cardSuits = "cdhs";
    int rank = index % 13;
    int suit = index / 13;
    return nsfmt(@"%c%c", cardRanks[rank], cardSuits[suit]);
}
@end

@interface Spider : IvarObject
{
    int _deckX;
    int _deckY;
    int _pileX[NUMBER_OF_PILES];
    int _pileY[NUMBER_OF_PILES];
    int _cardID[NUMBER_OF_CARDS];
    int _cardX[NUMBER_OF_CARDS];
    int _cardY[NUMBER_OF_CARDS];
    int _cardWidth[NUMBER_OF_CARDS];
    int _cardHeight[NUMBER_OF_CARDS];
    int _buttonDown;
    int _buttonDownX;
    int _buttonDownY;
    int _buttonDownOffsetX;
    int _buttonDownOffsetY;
    int _animateIndex;
    int _animateMaxIndex;
    int _animateIteration;
    int _animateMaxIteration;
    int _animateCard[NUMBER_OF_CARDS];
    int _animateFromX[NUMBER_OF_CARDS];
    int _animateFromY[NUMBER_OF_CARDS];
    int _animateToX[NUMBER_OF_CARDS];
    int _animateToY[NUMBER_OF_CARDS];
    int _completeX;
    int _completeY;
    BOOL _showOverlayText;
    id _bitmap;
}
@end
@implementation Spider
- (id)contextualMenu
{
    id arr = nsarr();
    id dict;
    dict = nsdict();
    [dict setValue:@"toggleOverlayText" forKey:@"displayName"];
    [dict setValue:@"toggleBoolKey:'showOverlayText'" forKey:@"messageForClick"];
    [dict setValue:@"z" forKey:@"keyDown"];
    [arr addObject:dict];
    dict = nsdict();
    [dict setValue:@"writeState" forKey:@"displayName"];
    [dict setValue:@"writeStateToFile:(homeDir:'testspider.dat')" forKey:@"messageForClick"];
    [arr addObject:dict];
    dict = nsdict();
    [dict setValue:@"readState" forKey:@"displayName"];
    [dict setValue:@"readStateFromFile:(homeDir:'testspider.dat')" forKey:@"messageForClick"];
    [arr addObject:dict];
    dict = nsdict();
    [dict setValue:@"fixmeMoveComplete" forKey:@"displayName"];
    [dict setValue:@"fixmeMoveComplete" forKey:@"messageForClick"];
    [arr addObject:dict];
    dict = nsdict();
    [dict setValue:@"fixmeMoveDeck" forKey:@"displayName"];
    [dict setValue:@"fixmeMoveDeck" forKey:@"messageForClick"];
    [arr addObject:dict];
#ifdef BUILD_FOR_IOS
    id mapArr = nsarr();
    for (id elt in arr) {
        [mapArr addObject:[[elt mutableCopy] autorelease]];
    }
    arr = mapArr;
#endif
    return arr;
}
- (id)textForCardsOnTopOfCards
{
    char *cardRanks = "A23456789TJQK";
    int ranks[13];
    int wrongCardOnTop[13];
    int onTopOfWrongCard[13];
    int outOfPlace[13];
    int available[13];

    for (int i=0; i<13; i++) {
        ranks[i] = 0;
        wrongCardOnTop[i] = 0;
        onTopOfWrongCard[i] = 0;
        outOfPlace[i] = 0;
        available[i] = 0;
    }
    for (int i=0; i<NUMBER_OF_CARDS; i++) {
        if (_cardID[i] < 0) {
            continue;
        }
        int rank = _cardID[i] % 13;
        ranks[rank]++;
        int cardOnTopOfCard = [self cardOnTopOfCard:i];
        if (cardOnTopOfCard == i) {
            available[rank]++;
        } else if (_cardID[cardOnTopOfCard] % 13 != rank-1) {
            wrongCardOnTop[rank]++;
        }
        int cardUnderneathCard = [self cardUnderneathCard:i];
        if (cardUnderneathCard == i) {
            outOfPlace[rank]++;
        } else {
            if (_cardID[cardUnderneathCard] < 0) {
                outOfPlace[rank]++;
            } else if (_cardID[cardUnderneathCard] % 13 == rank+1) {
            } else {
                outOfPlace[rank]++;
                onTopOfWrongCard[rank]++;
            }
        }
    }
    id arr = nsarr();
    for (int i=0; i<13; i++) {
        [arr addObject:nsfmt(@"%c: %@ %@ %@ %@", cardRanks[i],
            (ranks[i]) ? nsfmt(@"%d faceup", ranks[i]) : @"-",
            (outOfPlace[i]) ? nsfmt(@"%d out of place", outOfPlace[i]) : @"-",
            (wrongCardOnTop[i]) ? nsfmt(@"%d buried", wrongCardOnTop[i]) : @"-",
            (available[i]) ? nsfmt(@"%d available", available[i]) : @"-"
        )];
    }
    return [arr join:@"\n"];
}
- (void)fixmeMoveComplete
{
    int newCompleteX = _completeX + 200;
    for (int i=0; i<NUMBER_OF_CARDS; i++) {
        if (_cardX[i] == _completeX) {
            _cardX[i] = newCompleteX;
        }
    }
    _completeX = newCompleteX;
}
- (void)fixmeMoveDeck
{
    _deckX += 50;
    for (int i=0; i<NUMBER_OF_CARDS; i++) {
        if (_cardY[i] == _deckY) {
            if (_cardID[i] < 0) {
                _cardX[i] += 50;
            }
        }
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setValue:[Definitions bitmapWithWidth:[self bitmapWidth] height:[self bitmapHeight]] forKey:@"bitmap"];
        _buttonDown = -1;
    }
    return self;
}
- (int)topmostCardForPile:(int)pile
{
    if (pile < 0) {
        return 0;
    }
    if (pile >= NUMBER_OF_PILES) {
        return 0;
    }
    int card = [self cardAtX:_pileX[pile] y:_pileY[pile]];
    return card;
}
- (id)probabilitiesForValidFacedownCard
{
    id topmostCards = [self ranksOfTopmostCards];
    id facedownCards = [self ranksOfFacedownCards];
    id results = nsarr();
    for (int i=0; i<[facedownCards count]; i++) {
        id obj = [facedownCards nth:i];
        int facedownCard = [obj intValue];
        if (facedownCard < 0) {
            [results addObject:@"0"];
            continue;
        }
        for (int j=0; j<[topmostCards count]; j++) {
            id elt = [topmostCards nth:j];
            int topmostCard = [elt intValue];
            if (topmostCard < 0) {
                continue;
            }
            if (topmostCard-1 == facedownCard) {
                [results addObject:@"1"];
                goto endloop;
            }
        }
        [results addObject:@"0"];
endloop:
        ;
    }
    return results;
}
    
- (id)ranksOfTopmostCards
{
    char *cardRanks = "A23456789TJQK";
    id results = nsarr();
    for (int i=0; i<NUMBER_OF_PILES; i++) {
        int topmostCard = [self topmostCardForPile:i];
        if (topmostCard >= 0) {
            topmostCard = [self topmostCardOnTopOfCard:topmostCard];
        }
        id str = (topmostCard >= 0) ? nsfmt(@"%d", _cardID[topmostCard]%13) : @"-1";
        [results addObject:str];
    }
    return results;
}
- (id)textForTopmostCards
{
    char *cardRanks = "A23456789TJQK";
    id results = nsarr();
    id ranksOfTopmostCards = [self ranksOfTopmostCards];
    for (int i=0; i<[ranksOfTopmostCards count]; i++) {
        id elt = [ranksOfTopmostCards nth:i];
        int rank = [elt intValue];
        if (rank == -1) {
            [results addObject:@"-"];
            continue;
        }
        [results addObject:nsfmt(@"%c", cardRanks[rank])];
    }
    return [results join:@" "];
}
- (id)ranksOfFacedownCards
{
    int ranks[13];
    for (int i=0; i<13; i++) {
        ranks[i] = 8;
    }
    for (int i=0; i<NUMBER_OF_CARDS; i++) {
        if (_cardID[i] < 0) {
            continue;
        }
        ranks[_cardID[i]%13]--;
    }
    id arr = nsarr();
    for (int i=0; i<13; i++) {
        for (int j=0; j<ranks[i]; j++) {
            [arr addObject:nsfmt(@"%d", i)];
        }
    }
    return arr;
}
- (id)textForFacedownCards
{
    char *cardRanks = "A23456789TJQK";
    id arr = nsarr();
    id ranksOfFacedownCards = [self ranksOfFacedownCards];
    for (int i=0; i<[ranksOfFacedownCards count]; i++) {
        id elt = [ranksOfFacedownCards nth:i];
        [arr addObject:nsfmt(@"%c", cardRanks[[elt intValue]])];
    }
    return [arr asProbabilityDistributionText];
}
- (id)textForFaceupCards
{
    char *cardRanks = "A23456789TJQK";
    char *cardSuits = "cdhs";
    int cards[52];
    for (int i=0; i<52; i++) {
        cards[i] = 0;
    }
    for (int i=0; i<NUMBER_OF_CARDS; i++) {
        if (_cardID[i] < 0) {
            continue;
        }
        if (_cardY[i] == _completeY) {
            continue;
        }
        cards[_cardID[i]%52]++;
    }
    id lines = nsarr();
    for (int suit=0; suit<4; suit++) {
        int count = 0;
        id cols = nsarr();
        for (int rank=0; rank<13; rank++) {
            if (cards[suit*13+rank]) {
                [cols addObject:nsfmt(@"%c", cardRanks[rank])];
                count++;
            } else {
                [cols addObject:@"-"];
            }
        }
        [cols addObject:nsfmt(@"%c", cardSuits[suit])];
        [lines addObject:nsfmt(@"%@ (%d)", [cols join:@""], count)];
    }
    return [lines join:@"\n"];
}
- (id)tabBarImage
{
    return [Definitions generateCardIconImage];
}

- (BOOL)isAnimating
{
    if (_animateIndex < _animateMaxIndex) {
        return YES;
    }
    return NO;
}
- (BOOL)shouldAnimate
{
    if (_animateIndex >= _animateMaxIndex) {
        return NO;
    }
    return YES;
}
- (void)beginIteration:(id)event rect:(Int4)r
{
    [self updateState];
    [self updateBitmap];
}
- (void)updateState
{
    if (_animateIndex >= _animateMaxIndex) {
        return;
    }
    int i = _animateIndex;
    _animateIteration++;
    int card = _animateCard[i];
    if (_animateIteration < _animateMaxIteration) {
        if (_animateIteration == 1) {
            [self raiseCard:card];
            card = NUMBER_OF_CARDS-1;
            _animateCard[i] = card;
            if (_cardID[card] < 0) {
                _cardID[card] += 52;
            }
            if (_animateFromX[i] == _animateToX[i]) {
                if (_animateFromY[i] == _animateToY[i]) {
                    _animateIteration = 0;
                    _animateIndex++;
                }
            }
            return;
        }
        int deltaX = _animateToX[i] - _animateFromX[i];
        int deltaY = _animateToY[i] - _animateFromY[i];
        int stepX = ((double)deltaX / (double)(_animateMaxIteration-1)) * (double)(_animateIteration-1);
        int stepY = ((double)deltaY / (double)(_animateMaxIteration-1)) * (double)(_animateIteration-1);
        _cardX[card] = _animateFromX[i]+stepX;
        _cardY[card] = _animateFromY[i]+stepY;
    } else {
        _cardX[card] = _animateToX[i];
        _cardY[card] = _animateToY[i];
        _animateIteration = 0;
        _animateIndex++;
    }
}
- (int)bitmapWidth
{
    static int bitmapWidth = 0;
    if (!bitmapWidth) {
        if ([Definitions isiPad]) {
            bitmapWidth = 768;
        } else {
            bitmapWidth = 720;
        }
    }
    return bitmapWidth;
}
- (int)bitmapHeight
{
    static int bitmapHeight = 0;
    if (!bitmapHeight) {
        if ([Definitions isiPad]) {
            bitmapHeight = 1024;
        } else {
            bitmapHeight = 960;
        }
    }
    return bitmapHeight;
}
- (unsigned char *)pixelBytesRGBA8888
{
    return [_bitmap pixelBytes];
}
- (void)updateBitmap
{
    int bitmapWidth = [self bitmapWidth];
    int bitmapHeight = [self bitmapHeight];
    id bitmap = _bitmap;
    [bitmap setColorIntR:0 g:170 b:85 a:255];
    [bitmap fillRect:[Definitions rectWithX:0 y:0 w:bitmapWidth h:bitmapHeight]];
    for (int i=0; i<NUMBER_OF_PILES; i++) {
        char *pixels = [Definitions pixelsForEmptyCard];
        char *palette = [Definitions paletteForCard:0];
        [bitmap drawCString:pixels palette:palette x:_pileX[i] y:_pileY[i]];
    }
    for (int i=0; i<NUMBER_OF_CARDS; i++) {
        char *pixels = [Definitions pixelsForCard:_cardID[i]];
        char *palette = [Definitions paletteForCard:_cardID[i]];
        [bitmap drawCString:pixels palette:palette x:_cardX[i] y:_cardY[i]];
    }
    if (_showOverlayText) {
        id text = nsfmt(@"%@\n%@\n%@\n%@\n%@",
            [self textForCardsOnTopOfCards],
            [[[self probabilitiesForValidFacedownCard] asProbabilityDistributionTextArray] join:@" "],
            [self textForTopmostCards],
            [self textForFacedownCards],
            [self textForFaceupCards]);
        int textWidth = [bitmap bitmapWidthForText:text];
        int textHeight = [bitmap bitmapHeightForText:text];
        [bitmap setColor:@"white"];
        [bitmap fillRect:[Definitions rectWithX:0 y:bitmapHeight-textHeight w:textWidth+10 h:textHeight]];
        [bitmap setColor:@"black"];
        [bitmap drawBitmapText:text x:5 y:bitmapHeight-textHeight];
    }
}

- (void)setup
{
    id deck = [Definitions shuffledDeckOfCards:NUMBER_OF_CARDS];
    for (int i=0; i<[deck count]; i++) {
        int card = [[deck nth:i] intValue];
        char *pixels = [Definitions pixelsForCard:card];
        int w = [Definitions widthForCString:pixels];
        int h = [Definitions heightForCString:pixels];
        _cardWidth[i] = w;
        _cardHeight[i] = h;
        _cardID[i] = card;
    }

    int bitmapHeight = [self bitmapHeight];
    if ([Definitions isiPad]) {
        _completeX = 100;
        _completeY = bitmapHeight-100-71;
        _deckX = 500;
        _deckY = bitmapHeight-100-71;
        for (int i=0; i<NUMBER_OF_PILES; i++) {
            _pileX[i] = 5+(71+5)*i;
            _pileY[i] = 9;
        }
    } else {
        _completeX = 100;
        _completeY = bitmapHeight-97-71;
        _deckX = 500;
        _deckY = bitmapHeight-97-71;
        for (int i=0; i<NUMBER_OF_PILES; i++) {
            _pileX[i] = 72*i;
            _pileY[i] = 0;
        }
    }

    for (int card=0; card<44; card++) {
        int pile = card%NUMBER_OF_PILES;
        int count = card/NUMBER_OF_PILES;
        _cardID[card] -= 52;
        _cardX[card] = _pileX[pile];
        _cardY[card] = _pileY[pile] + count*NUMBER_OF_PILES;
    }
    for (int card=44; card<NUMBER_OF_CARDS; card++) {
        _cardID[card] -= 52;
        _cardX[card] = _deckX-((card-44)/10)*12;
        _cardY[card] = _deckY;
    }
    [self dealCards];
}
- (void)dealCards
{
    int deckCard = [self cardForX:_deckX y:_deckY];
    if (deckCard >= 0) {
        int bottomDeckCard = [self bottommostCardUnderneathCard:deckCard];
        bottomDeckCard = [self fixupPile:bottomDeckCard];
        _animateIndex = 0;
        _animateMaxIndex = 0;
        _animateIteration = 0;
        _animateMaxIteration = 7;
        for (int pile=0; pile<NUMBER_OF_PILES; pile++) {
            int card = NUMBER_OF_CARDS-1-pile;
            if (card < bottomDeckCard) {
                break;
            }
            _animateCard[pile] = card;
            _animateFromX[pile] = _cardX[card];
            _animateFromY[pile] = _cardY[card];
            int pileCard = [self cardForX:_pileX[pile] y:_pileY[pile]];
            if (pileCard >= 0) {
                int topmostCard = [self topmostCardOnTopOfCard:pileCard];
                if (_cardID[topmostCard] < 0) {
                    _animateToX[pile] = _cardX[topmostCard];
                    _animateToY[pile] = _cardY[topmostCard]+10;
                } else {
                    _animateToX[pile] = _cardX[topmostCard];
                    _animateToY[pile] = _cardY[topmostCard]+30;
                }
            } else {
                _animateToX[pile] = _pileX[pile];
                _animateToY[pile] = _pileY[pile];
            }
            _animateMaxIndex++;
        }
    }
}
- (int)cardForX:(int)x y:(int)y underneathCard:(int)card
{
    for (int i=card-1; i>=0; i--) {
        if ([Definitions isX:x y:y insideRect:[Definitions rectWithX:_cardX[i] y:_cardY[i] w:_cardWidth[i] h:_cardHeight[i]]]) {
            return i;
        }
    }
    return -1;
}
- (int)cardAtX:(int)x y:(int)y
{
    for (int i=NUMBER_OF_CARDS-1; i>=0; i--) {
        if ((x == _cardX[i]) && (y == _cardY[i])) {
            return i;
        }
    }
    return -1;
}
- (int)cardForX:(int)x y:(int)y
{
    for (int i=NUMBER_OF_CARDS-1; i>=0; i--) {
        if ([Definitions isX:x y:y insideRect:[Definitions rectWithX:_cardX[i] y:_cardY[i] w:_cardWidth[i] h:_cardHeight[i]]]) {
            return i;
        }
    }
    return -1;
}
- (void)handleMouseDown:(id)event
{
    if ([self isAnimating]) {
        return;
    }
    int mouseX = [event intValueForKey:@"mouseX"];
    int mouseY = [event intValueForKey:@"mouseY"];
    _buttonDown = [self cardForX:mouseX y:mouseY];
    if (_buttonDown >= 0) {
        _buttonDownX = mouseX;
        _buttonDownY = mouseY;
        _buttonDownOffsetX = mouseX - _cardX[_buttonDown];
        _buttonDownOffsetY = mouseY - _cardY[_buttonDown];
        if (_cardID[_buttonDown] < 0) {
            int topmostCard = [self topmostCardOnTopOfCard:_buttonDown];
            if (_cardID[topmostCard] < 0) {
                _buttonDown = -1;
                [self dealCards];
                return;
            }
        }
        int card = [self fixupPile:_buttonDown];
        if ([self isMovablePile:card]) {
            _buttonDown = card;
        } else {
            _buttonDown = -1;
        }
    }
}
- (void)handleMouseUp:(id)event
{
    if ([self isAnimating]) {
        return;
    }
    if (_buttonDown < 0) {
        return;
    }
    BOOL success = NO;
    int validCardUnderneathCard = [self validCardUnderneathCard:_buttonDown];
    if (validCardUnderneathCard >= 0) {
        [self movePileOfCards:_buttonDown x:_cardX[validCardUnderneathCard] y:_cardY[validCardUnderneathCard]+30];
        int card = [self cardUnderneathRect:[Definitions rectWithX:_buttonDownX - _buttonDownOffsetX y:_buttonDownY - _buttonDownOffsetY w:_cardWidth[_buttonDown] h:_cardHeight[_buttonDown]]];
        if (card >= 0) {
            if (_cardID[card] < 0) {
                _cardID[card] += 52;
            }
        }

        if ([self isCompleteSuitOfCards:_buttonDown]) {
            [self moveCompleteSuitOfCards:_buttonDown];
        }
        success = YES;
    }
    if (!success) {
        for (int i=0; i<NUMBER_OF_PILES; i++) {
            int card = [self cardForX:_pileX[i] y:_pileY[i] underneathCard:_buttonDown];
            if (card >= 0) {
                continue;
            }
            Int4 pileRect = [Definitions rectWithX:_pileX[i] y:_pileY[i]-_cardHeight[0] w:_cardWidth[0] h:_cardHeight[0]];
            Int4 cardRect = [Definitions rectWithX:_cardX[_buttonDown] y:_cardY[_buttonDown]-_cardHeight[_buttonDown] w:_cardWidth[_buttonDown] h:_cardHeight[_buttonDown]];
            if ([Definitions doesRect:cardRect intersectRect:pileRect]) {
                [self movePileOfCards:_buttonDown x:_pileX[i] y:_pileY[i]];
                int cardUnderneath = [self cardUnderneathRect:[Definitions rectWithX:_buttonDownX - _buttonDownOffsetX y:_buttonDownY - _buttonDownOffsetY w:_cardWidth[_buttonDown] h:_cardHeight[_buttonDown]]];
                if (cardUnderneath >= 0) {
                    if (_cardID[cardUnderneath] < 0) {
                        _cardID[cardUnderneath] += 52;
                    }
                }
                success = YES;
                break;
            }
        }
    }
    if (!success) {
        [self movePileOfCards:_buttonDown x:_buttonDownX - _buttonDownOffsetX y:_buttonDownY - _buttonDownOffsetY];
    }

    _buttonDown = -1;
}
- (void)handleMouseMoved:(id)event
{
    if ([self isAnimating]) {
        return;
    }
    if (_buttonDown < 0) {
        return;
    }
    int mouseX = [event intValueForKey:@"mouseX"];
    int mouseY = [event intValueForKey:@"mouseY"];
    [self movePileOfCards:_buttonDown x:mouseX - _buttonDownOffsetX y:mouseY - _buttonDownOffsetY];
}
- (void)handleTouchesBegan:(id)event
{
    [event setValue:[event valueForKey:@"touchX"] forKey:@"mouseX"];
    [event setValue:[event valueForKey:@"touchY"] forKey:@"mouseY"];
    [self handleMouseDown:event];
}
- (void)handleTouchesEnded:(id)event
{
    [event setValue:[event valueForKey:@"touchX"] forKey:@"mouseX"];
    [event setValue:[event valueForKey:@"touchY"] forKey:@"mouseY"];
    [self handleMouseUp:event];
}
- (void)handleTouchesMoved:(id)event
{
    [event setValue:[event valueForKey:@"touchX"] forKey:@"mouseX"];
    [event setValue:[event valueForKey:@"touchY"] forKey:@"mouseY"];
    [self handleMouseMoved:event];
}
- (void)handleTouchesCancelled:(id)event
{
    [self handleTouchesEnded:event];
}

- (void)moveTopCardToX:(int)x y:(int)y
{
    int lastIndex = NUMBER_OF_CARDS-1;
    _cardX[lastIndex] = x;
    _cardY[lastIndex] = y;
}
- (void)moveCard:(int)card x:(int)x y:(int)y
{
    _cardX[card] = x;
    _cardY[card] = y;
}
- (void)movePileOfCards:(int)bottomOfPile x:(int)x y:(int)y
{
    int offsetX[NUMBER_OF_CARDS];
    int offsetY[NUMBER_OF_CARDS];
    for (int i=bottomOfPile+1; i<NUMBER_OF_CARDS; i++) {
        offsetX[i] = _cardX[i] - _cardX[bottomOfPile];
        offsetY[i] = _cardY[i] - _cardY[bottomOfPile];
    }
    _cardX[bottomOfPile] = x;
    _cardY[bottomOfPile] = y;
    for (int i=bottomOfPile+1; i<NUMBER_OF_CARDS; i++) {
        _cardX[i] = _cardX[bottomOfPile] + offsetX[i];
        _cardY[i] = _cardY[bottomOfPile] + offsetY[i];
    }
}
- (void)raiseCard:(int)index
{
    if (index < 0) {
        return;
    }
    if (index >= NUMBER_OF_CARDS) {
        return;
    }
    int lastIndex = NUMBER_OF_CARDS-1;
    if (index != lastIndex) {
        int tempID = _cardID[index];
        int tempX = _cardX[index];
        int tempY = _cardY[index];
        for (int i=index+1; i<NUMBER_OF_CARDS; i++) {
            _cardID[i-1] = _cardID[i];
            _cardX[i-1] = _cardX[i];
            _cardY[i-1] = _cardY[i];
        }
        _cardID[lastIndex] = tempID;
        _cardX[lastIndex] = tempX;
        _cardY[lastIndex] = tempY;
    }
}
- (int)fixupPile:(int)card
{
    int inPile[NUMBER_OF_CARDS];
    for (int i=0; i<NUMBER_OF_CARDS; i++) {
        inPile[i] = 0;
    }
    inPile[card] = 1;
    for (int i=card+1; i<NUMBER_OF_CARDS; i++) {
        Int4 r1 = [Definitions rectWithX:_cardX[i] y:_cardY[i] w:_cardWidth[i] h:_cardHeight[i]];
        for (int j=0; j<NUMBER_OF_CARDS; j++) {
            if (inPile[j]) {
                Int4 r2 = [Definitions rectWithX:_cardX[j] y:_cardY[j] w:_cardWidth[j] h:_cardHeight[j]];
                if ([Definitions doesRect:r1 intersectRect:r2]) {
                    inPile[i] = 1;
                    break;
                }
            }
        }
    }
    int topCard = NUMBER_OF_CARDS-1;
    for (int i=NUMBER_OF_CARDS-1; i>=0; i--) {
        if (inPile[i]) {
            int tempID = _cardID[i];
            int tempX = _cardX[i];
            int tempY = _cardY[i];
            for (int j=i+1; j<=topCard; j++) {
                _cardID[j-1] = _cardID[j];
                _cardX[j-1] = _cardX[j];
                _cardY[j-1] = _cardY[j];
            }
            _cardID[topCard] = tempID;
            _cardX[topCard] = tempX;
            _cardY[topCard] = tempY;
            topCard--;
        }
    }
    return topCard+1;
}
- (BOOL)isMovablePile:(int)bottomOfPile
{
    int cardID = _cardID[bottomOfPile];
    int cardSuit = cardID / 13;
    int cardRank = cardID % 13;
    for (int i=bottomOfPile+1; i<NUMBER_OF_CARDS; i++) {
        if (_cardID[i] / 13 != cardSuit) {
            return NO;
        }
        if (_cardID[i] % 13 != cardRank-1) {
            return NO;
        }
        cardRank--;
    }
    return YES;
}
- (int)cardUnderneathRect:(Int4)cardRect
{
    for (int i=NUMBER_OF_CARDS-1; i>=0; i--) {
        Int4 r = [Definitions rectWithX:_cardX[i] y:_cardY[i] w:_cardWidth[i] h:_cardHeight[i]];
        if ([Definitions doesRect:cardRect intersectRect:r]) {
            return i;
        }
    }
    return -1;
}

- (int)validCardUnderneathCard:(int)card
{
    Int4 cardRect = [Definitions rectWithX:_cardX[card] y:_cardY[card] w:_cardWidth[card] h:_cardHeight[card]];
    for (int i=card-1; i>=0; i--) {
        Int4 r = [Definitions rectWithX:_cardX[i] y:_cardY[i] w:_cardWidth[i] h:_cardHeight[i]];
        if ([Definitions doesRect:cardRect intersectRect:r]) {
            int cardOnTopOfCard = [self cardOnTopOfCard:i];
            if (cardOnTopOfCard == card) {
                if (_cardID[i] >= 0) {
                    if (_cardID[i]%13 == (_cardID[card]%13)+1) {
                        return i;
                    }
                }
            }
        }
    }
    return -1;
}
- (int)cardUnderneathCard:(int)card
{
    Int4 cardRect = [Definitions rectWithX:_cardX[card] y:_cardY[card] w:_cardWidth[card] h:_cardHeight[card]];
    for (int i=card-1; i>=0; i--) {
        Int4 r = [Definitions rectWithX:_cardX[i] y:_cardY[i] w:_cardWidth[i] h:_cardHeight[i]];
        if ([Definitions doesRect:cardRect intersectRect:r]) {
            return i;
        }
    }
    return card;
}
- (int)bottommostCardUnderneathCard:(int)card
{
    for(;;) {
        int nextCard = [self cardUnderneathCard:card];
        if (card == nextCard) {
            return card;
        }
        card = nextCard;
    }
}
- (int)cardOnTopOfCard:(int)card
{
    Int4 cardRect = [Definitions rectWithX:_cardX[card] y:_cardY[card] w:_cardWidth[card] h:_cardHeight[card]];
    for (int i=card+1; i<NUMBER_OF_CARDS; i++) {
        Int4 r = [Definitions rectWithX:_cardX[i] y:_cardY[i] w:_cardWidth[i] h:_cardHeight[i]];
        if ([Definitions doesRect:cardRect intersectRect:r]) {
            return i;
        }
    }
    return card;
}
- (int)topmostCardOnTopOfCard:(int)card
{
    for(;;) {
        int nextCard = [self cardOnTopOfCard:card];
        if (card == nextCard) {
            return card;
        }
        card = nextCard;
    }
}
- (BOOL)isCompleteSuitOfCards:(int)card
{
    card = [self topmostCardOnTopOfCard:card];
    int suit = _cardID[card] / 13;
    for (int i=0; i<13; i++) {
        if (_cardID[card] % 13 != i) {
            return NO;
        }
        if (_cardID[card] / 13 != suit) {
            return NO;
        }
        card = [self cardUnderneathCard:card];
    }
    return YES;
}
- (void)moveCompleteSuitOfCards:(int)card
{
    int toX = _completeX;
    int toY = _completeY;
    int completeCard = [self cardForX:_completeX y:_completeY];
    if (completeCard >= 0) {
        completeCard = [self topmostCardOnTopOfCard:completeCard];
        toX = _cardX[completeCard]+12;
        toY = _cardY[completeCard];
    }
    _animateIndex = 0;
    _animateMaxIndex = 0;
    _animateIteration = 0;
    _animateMaxIteration = 7;
    card = [self topmostCardOnTopOfCard:card];
    for (int i=0; i<13; i++) {
        _animateCard[i] = card;
        _animateFromX[i] = _cardX[card];
        _animateFromY[i] = _cardY[card];
        _animateToX[i] = toX;
        _animateToY[i] = toY;
        _animateMaxIndex++;
        card = [self cardUnderneathCard:card];
    }
    if (_cardID[card] < 0) {
        int i = 13;
        _animateCard[i] = card;
        _animateFromX[i] = 0;
        _animateFromY[i] = 0;
        _animateToX[i] = 0;
        _animateToY[i] = 0;
        _animateMaxIndex++;
    }
}
@end

