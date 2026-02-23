#import "FROG.h"

#include "assets-Frogger.h"

static id _pool = nil;

static int _homeX[5] = { 3, 9, 15, 21, 27 };

static id _audioAssets = 0;
static id _sn76489 = 0;
static id _music = 0;
static int _musicCursor = 0;
static id _musicRepeat = 0;
static id _soundEffect = 0;
static int _soundEffectCursor = 0;

static unsigned char _tiles[65536];
static unsigned char _nametable[32*24];
static unsigned char _tileScrolling[24];

static id _bitmap = 0;

static int _frogX = 112;
static int _frogY = 176;
static char _facing = 'u';
static char _jumping = 0;
static int _jumpingFrame = 0;

static int _turtleAnimationFrame;

static unsigned char _frogAtHome[5];
static int _homeCount = 0;

static int _currentLevel;
static unsigned char _levelAttrs[32*24];
static unsigned char _rowCounter[10];
static unsigned char _rowMaxValue[10];

static unsigned char _dynamicAttrs[256];
static unsigned char _turtleSlowSinkingCounter;
static unsigned char _turtleSlowSinkingState;
static int _turtleSlowSinkingAddr;
static unsigned char _turtleFastSinkingCounter;
static unsigned char _turtleFastSinkingState;
static int _turtleFastSinkingAddr;

static unsigned char _alligatorCounter;
static unsigned char _alligatorState;
static int _alligatorAddr;

static unsigned char _homeFly;
static unsigned char _homeFlyCounter;
static unsigned char _homeFlyState;
static unsigned char _drawPointsCounter;
static unsigned char _drawPointsX;
static unsigned char _drawPointsY;

static unsigned char _homeAlligator;
static unsigned char _homeAlligatorCounter;
static unsigned char _homeAlligatorState;

static unsigned char _snakeCounter;
static int _snakeMinX;
static int _snakeMaxX;
static int _snakeX;
static unsigned char _snakeRow;
static unsigned char _snakeDirection;
static unsigned char _snakeActualX;

static unsigned char _otterCounter;
static unsigned char _otterState;
static int _otterX;
static int _otterStartX;
static int _otterEndX;
static unsigned char _otterRow;
static unsigned char _otterDirection;
static unsigned char _otterActualX;

static unsigned char _extraNametable[256];

static unsigned char _a = 0;

static id _data_contents;

static id get_sms_palette()
{
    static id palette = nil;

    if (palette) {
        return palette;
    }

    char *paletteChars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/!@#$";
    id results = nsarr();

    int i = 0;
    for (int b=0; b<4; b++) {
        for (int g=0; g<4; g++) {
            for (int r=0; r<4; r++) {
                id str = nsfmt(@"%c #%.2x%.2x%.2x\n", paletteChars[i], r<<6|r<<4|r<<2|r, g<<6|g<<4|g<<2|g, b<<6|b<<4|b<<2|b);
                [results addObject:str];
                i++;
            }
        }
    }

    palette = [[results join:@""] retain];
    return palette;
}

static id get_asset(id name)
{
    return [_data_contents valueForKey:name];
}



@interface Frogger : IvarObject
@end
@implementation Frogger
+ (void)loadAudioAssets
{
    _audioAssets = [nsdict() retain];

    id arr = [_data_contents allKeys];
    for (int i=0; i<[arr count]; i++) {
        id elt = [arr nth:i];
        if ([elt hasSuffix:@".psg"]) {
            id val = [_data_contents valueForKey:elt];
            val = [val componentsSeparatedByString:@"\n"];
            [_audioAssets setValue:val forKey:elt];
NSLog(@"loaded audio '%@'", elt);
        }
    }
}
+ (void)loadIntValues:(id)path dst:(unsigned char *)dst len:(int)len
{
    id str = get_asset(path);
    if (!str) { 
        NSLog(@"Unable to open '%@'", path);
        return;
    }
    id arr = [str split];
    int count = [arr count];
    if (count != len) {
        NSLog(@"Wrong number of values in '%@', found %d, expecting %d", path, count, len);
        return;
    }
    for (int i=0; i<count; i++) {
        id elt = [arr nth:i];
        int val = [elt intValue];
        dst[i] = (unsigned char)val;
    }
}
+ (void)loadAttrs:(id)path dst:(unsigned char *)dst len:(int)len
{
    id str = get_asset(path);
    if (!str) { 
        NSLog(@"Unable to open '%@'", path);
        return;
    }
    str = [str find:@"\n" replace:@""];
    unsigned char *bytes = [str UTF8String];
    if ([str length] != len) {
        NSLog(@"Wrong length for '%@', length is %d, expecting %d", path, [str length], len);
        return;
    }
    for (int i=0; i<[str length]; i++) {
        _levelAttrs[i] = bytes[i];
    }
}
+ (void)loadLevel:(int)level
{
NSLog(@"loadLevel:%d", level);
    [self loadIntValues:nsfmt(@"nametable%d.txt", level) dst:_nametable len:32*24];
    [self loadAttrs:nsfmt(@"attrs%d.txt", level) dst:_levelAttrs len:32*24];
    _currentLevel = level;
    if (level == 1) {
        _rowMaxValue[0] = 3;
        _rowMaxValue[1] = 2;
        _rowMaxValue[2] = 3;
        _rowMaxValue[3] = 2;
        _rowMaxValue[4] = 3;
        _rowMaxValue[5] = 2;
        _rowMaxValue[6] = 3;
        _rowMaxValue[7] = 2;
        _rowMaxValue[8] = 3;
        _rowMaxValue[9] = 3;

        _dynamicAttrs['B'] = 't';
        _turtleSlowSinkingAddr = 4*32+0;

        _dynamicAttrs['C'] = 't';
        _turtleFastSinkingAddr = 10*32+5;

    } else if (level == 2) {
        _rowMaxValue[0] = 2;
        _rowMaxValue[1] = 2;
        _rowMaxValue[2] = 2;
        _rowMaxValue[3] = 3;
        _rowMaxValue[4] = 2;
        _rowMaxValue[5] = 3;
        _rowMaxValue[6] = 2;
        _rowMaxValue[7] = 2;
        _rowMaxValue[8] = 2;
        _rowMaxValue[9] = 2;

        _dynamicAttrs['B'] = 't';
        _turtleSlowSinkingAddr = 4*32+0;

        _dynamicAttrs['C'] = 't';
        _turtleFastSinkingAddr = 10*32+5;

        _dynamicAttrs['A'] = 'l';
        _alligatorAddr = 2*32+16;

    } else if (level == 3) {
        _rowMaxValue[0] = 2;
        _rowMaxValue[1] = 2;
        _rowMaxValue[2] = 2;
        _rowMaxValue[3] = 1;
        _rowMaxValue[4] = 2;
        _rowMaxValue[5] = 3;
        _rowMaxValue[6] = 2;
        _rowMaxValue[7] = 1;
        _rowMaxValue[8] = 2;
        _rowMaxValue[9] = 1;

        _dynamicAttrs['B'] = 't';
        _turtleSlowSinkingAddr = 4*32+0;

        _dynamicAttrs['C'] = 't';
        _turtleFastSinkingAddr = 10*32+5;

        _dynamicAttrs['A'] = 'l';
        _alligatorAddr = 2*32+30;

        _snakeMinX = 0;
        _snakeMaxX = 64;
        _snakeX = 24;
        _snakeRow = 3;

        _otterCounter = 0;
        _otterState = 0;
        _otterX = 0;
        _otterStartX = 4*8;
        _otterEndX = 13*8;
        _otterRow = 1;
        _otterDirection = 1;
    } else if (level == 4) {
        _rowMaxValue[0] = 2;
        _rowMaxValue[1] = 2;
        _rowMaxValue[2] = 1;
        _rowMaxValue[3] = 2;
        _rowMaxValue[4] = 1;
        _rowMaxValue[5] = 2;
        _rowMaxValue[6] = 1;
        _rowMaxValue[7] = 1;
        _rowMaxValue[8] = 2;
        _rowMaxValue[9] = 1;

        _dynamicAttrs['B'] = 't';
        _turtleSlowSinkingAddr = 4*32+0;

        _dynamicAttrs['C'] = 't';
        _turtleFastSinkingAddr = 10*32+5;

        _dynamicAttrs['A'] = 'l';
        _alligatorAddr = 2*32+30;

        _snakeMinX = 0;
        _snakeMaxX = 64;
        _snakeX = 24;
        _snakeRow = 3;

        _otterCounter = 0;
        _otterState = 0;
        _otterX = 0;
        _otterStartX = 4*8;
        _otterEndX = 13*8;
        _otterRow = 1;
        _otterDirection = 1;
    } else if (level == 5) {
        _rowMaxValue[0] = 1;
        _rowMaxValue[1] = 2;
        _rowMaxValue[2] = 1;
        _rowMaxValue[3] = 2;
        _rowMaxValue[4] = 1;
        _rowMaxValue[5] = 2;
        _rowMaxValue[6] = 1;
        _rowMaxValue[7] = 1;
        _rowMaxValue[8] = 2;
        _rowMaxValue[9] = 1;

        _dynamicAttrs['B'] = 't';
        _turtleSlowSinkingAddr = 4*32+0;

        _dynamicAttrs['C'] = 't';
        _turtleFastSinkingAddr = 10*32+5;

        _dynamicAttrs['A'] = 'l';
        _alligatorAddr = 2*32+30;

        _snakeMinX = 0;
        _snakeMaxX = 64;
        _snakeX = 24;
        _snakeRow = 3;

        _otterCounter = 0;
        _otterState = 0;
        _otterX = 28*8;
        _otterStartX = 28*8;
        _otterEndX = 10*8;
        _otterRow = 2;
        _otterDirection = 0;
    }
}
+ (void)loadTiles:(id)path addr:(uint16_t)addr
{
    id str = get_asset(path);
    if (!str) { 
        NSLog(@"Unable to open '%@'", path);
        exit(1);
    }
    str = [str find:@"\n" replace:@""];
    int len = [str length];
    unsigned char *bytes = [str UTF8String];
    for (int i=0; i<len; i++) {
        _tiles[addr] = bytes[i];
        addr++;
    }
}


+ (void)drawSprite:(id)name x:(int)basex y:(int)basey
{
    int minx = 256;
    int miny = 256;
    id attrs = [get_asset(nsfmt(@"%@~attrs", name)) split:@"\n"];
    if (!attrs) {
NSLog(@"drawSprite %@~attrs not found", name);
        return;
    }
    for (int i=0; i<[attrs count]; i++) {
        id elt = [attrs nth:i];
        int eltx = [elt intValueForKey:@"x"];
        int elty = [elt intValueForKey:@"y"];
        if (eltx < minx) {
            minx = eltx;
        }
        if (elty < miny) {
            miny = elty;
        }
    }

    char *palette = [get_asset(nsfmt(@"%@~palette", name)) UTF8String];
    if (!palette) {
NSLog(@"drawSprite %@~palette not found", name);
        return;
    }
    char *pixels = [get_asset(nsfmt(@"%@~frame", name)) UTF8String];
    if (!pixels) {
NSLog(@"drawSprite %@~frame not found", name);
        return;
    }
    int pixelsLength = strlen(pixels);
    int offset = 0;
    for (int i=0; i<[attrs count]; i++) {
        id elt = [attrs nth:i];
        int eltx = [elt intValueForKey:@"x"];
        int elty = [elt intValueForKey:@"y"];
        int size = [elt intValueForKey:@"size"];
        int x = eltx-minx+basex;
        int y = elty-miny+basey;

        int len = (size+1)*size;
        if (offset+len-1 < pixelsLength) {
            pixels[offset+len-1] = 0;
        }
        
        [_bitmap drawCString:pixels+offset palette:palette x:x y:y];

        offset += len;
    }
}
+ (void)drawFroggerX:(int)x y:(int)y
{
    id pixels = get_asset(@"frogup1.txt");
    if (!pixels) {
        return;
    }
    id palette = get_sms_palette();
    [_bitmap drawCString:[pixels UTF8String] palette:[palette UTF8String] x:x y:y];
}
+ (void)drawFrogX:(int)x y:(int)y
{
x -= 8;
y -= 32;
    int frame = 0;
    if (_jumping) {
        frame = (_jumpingFrame / 4)%4;
        frame++;
    }
    if (_facing == 'u') {
        y += 4;
        if (frame == 0) { y += 8; y-=_jumpingFrame*2; }
        else if (frame == 2) { y += 7; y-=_jumpingFrame*2; }
        else if (frame == 3) { y += 7; y-=16; }
        else if (frame == 4) { y += 15; y-=16; }
        [self drawSprite:nsfmt(@"FrogUp%d", frame+1) x:x y:y];
    } else if (_facing == 'd') {
        if (frame == 0) { y += 12; }
        else if (frame == 2) { y += 13; }
        else if (frame == 3) { y += 13; }
        else if (frame == 4) { y -= 16; y += 29; }
        [self drawSprite:nsfmt(@"FrogDown%d", frame+1) x:x y:y+_jumpingFrame];
    } else if (_facing == 'l') {
        if (frame == 0) { y += 11; }
        else if (frame == 1) { x -= 1; }
        else if (frame == 2) { x -= 2; y += 11; }
        else if (frame == 3) { x -= 3; y += 11; }
        else if (frame == 4) { x -= 3; x -= 13; y += 11; }
        [self drawSprite:nsfmt(@"FrogLeft%d", frame+1) x:x y:y];
    } else if (_facing == 'r') {
        if (frame == 0) { y += 11; }
        else if (frame == 1) { x += 1; }
        else if (frame == 2) { x += 2; y += 11; }
        else if (frame == 3) { x += 3; y += 11; }
        else if (frame == 4) { x += 3; x += 13; y += 11; }
        [self drawSprite:nsfmt(@"FrogRight%d", frame+1) x:x y:y];
    }
}
+ (void)drawFrogDying:(int)frame x:(int)x y:(int)y
{
    id palette = get_sms_palette();
    if (frame < 16) {
        id pixels = get_asset(@"PlayerRanOver1.txt");
        if (pixels) {
            [_bitmap drawCString:[pixels UTF8String] palette:[palette UTF8String] x:x y:y];
        }
    } else if (frame < 32) {
        id pixels = get_asset(@"PlayerRanOver2.txt");
        if (pixels) {
            [_bitmap drawCString:[pixels UTF8String] palette:[palette UTF8String] x:x y:y];
        }
    } else {
        id pixels = get_asset(@"PlayerRanOver3.txt");
        if (pixels) {
            [_bitmap drawCString:[pixels UTF8String] palette:[palette UTF8String] x:x y:y];
        }
    }

}
+ (void)drawFrogDieInWater:(int)frame x:(int)x y:(int)y
{
    id palette = get_sms_palette();
    if (frame < 16) {
        id pixels = get_asset(@"PlayerDieInWater1.txt");
        if (pixels) {
            [_bitmap drawCString:[pixels UTF8String] palette:[palette UTF8String] x:x y:y];
        }
    } else if (frame < 32) {
        id pixels = get_asset(@"PlayerDieInWater2.txt");
        if (pixels) {
            [_bitmap drawCString:[pixels UTF8String] palette:[palette UTF8String] x:x y:y];
        }
    } else {
        id pixels = get_asset(@"PlayerDieInWater3.txt");
        if (pixels) {
            [_bitmap drawCString:[pixels UTF8String] palette:[palette UTF8String] x:x y:y];
        }
    }
}
+ (void)resetPlayer
{
    _frogX = 112;
    _frogY = 176;
    _facing = 'u';
    _musicCursor = 0;
}
+ (void)setMusic:(id)name
{
    id val = [_audioAssets valueForKey:name];
    _music = val;
    _musicCursor = 0;
}
+ (void)setMusicRepeat:(id)name
{
    id val = [_audioAssets valueForKey:name];
    _musicRepeat = val;
}
+ (void)drawBackground
{
    id palette = get_sms_palette();
    if (!palette) {
        return;
    }

    unsigned char buf[257*192+1];

    for (int j=0; j<192; j++) {
        for (int i=0; i<256; i++) {
            unsigned char srcx = _tileScrolling[j/8];
            srcx += i;
            int tilex = srcx/8;
            int tiley = j/8;
            int tilenum = _nametable[tiley*32+tilex];
            unsigned char pixel = _tiles[tilenum*64+(j%8)*8+(srcx%8)];
if (!pixel) {
    pixel = ' ';
}
            buf[j*257+i] = pixel;
        }
        buf[j*257+256] = '\n';
    }
    buf[257*192] = 0;
    [_bitmap drawCString:buf palette:[palette UTF8String] x:0 y:0];
}
+ (void)drawAttrs
{
    [_bitmap setColor:@"white"];
    for (int j=0; j<24; j++) {
        for (int i=0; i<32; i++) {
            id str = nsfmt(@"%c", [self getAttr:j*32+i]);
            unsigned char x = i*8;
            x -= _tileScrolling[j];
            [_bitmap drawBitmapText:str x:x y:j*8];
        }
    }
}
+ (void)handleKeyDown:(id)event
{
    id keyString = [event valueForKey:@"keyString"];
    if (_jumping) {
        return;
    }
    if ([keyString isEqual:@"up"]) {
        [Frogger playSound:@"hop.psg"];
        _facing = 'u';
        _jumping = 1;
        _jumpingFrame = 0;
    } else if ([keyString isEqual:@"down"]) {
        if (_frogY >= 176) {
            return;
        }
        [Frogger playSound:@"hop.psg"];
        _facing = 'd';
        _jumping = 1;
        _jumpingFrame = 0;
    } else if ([keyString isEqual:@"left"]) {
        [Frogger playSound:@"hop.psg"];
        _facing = 'l';
        _jumping = 1;
        _jumpingFrame = 0;
    } else if ([keyString isEqual:@"right"]) {
        [Frogger playSound:@"hop.psg"];
        _facing = 'r';
        _jumping = 1;
        _jumpingFrame = 0;
    }
}
+ (void)playSound:(id)name
{
    id val = [_audioAssets valueForKey:name];
    _soundEffect = val;
    _soundEffectCursor = 0;
}
+ (void)resetPSG
{
    [_sn76489 writeLine:nsfmt(@" %d %d %d %d", 128+16+15, 128+32+16+15, 128+64+16+15, 255)];
}
+ (void)handleAudio
{
    for (int i=0; i<12; i++) {

        if (_music) {
            [_sn76489 writeString:[_music nth:_musicCursor]];
            _musicCursor++;
            if (_musicCursor >= [_music count]) {
                _music = _musicRepeat;
                _musicCursor = 0;
            }
        }

        if (_soundEffect) {
            int count = [_soundEffect count];

            id elt = [_soundEffect nth:_soundEffectCursor];
                
            if ([elt hasPrefix:@".db "]) {
                id tokens = [elt split:@" "];
                int val = [[tokens nth:1] intValue];
                for (int j=0; j<val; j++) {
                    _soundEffectCursor++;
                    int val2 = [[[[_soundEffect nth:_soundEffectCursor] split:@" "] nth:1] intValue];
                    [_sn76489 writeString:nsfmt(@" %d", val2)];
                }
            }
            _soundEffectCursor++;
            if (_soundEffectCursor >= count) {
                _soundEffect = nil;
                _soundEffectCursor = 0;
            }
        }

        [_sn76489 writeString:@"\n"];
    }
}

+ (void)resetScrolling
{
    for (int i=0; i<24; i++) {
        _tileScrolling[i] = 0;
    }
}
+ (void)handleScrolling
{
    int row = _frogY / 16;
    BOOL movePlayer = NO;
    if (!_jumping || (_jumping && (_facing == 'l')) || (_jumping && (_facing == 'r'))) {
        movePlayer = YES;
    }

    _rowCounter[0]++;
    if (_rowCounter[0] >= _rowMaxValue[0]) {
        _tileScrolling[2]--;
        _tileScrolling[3]--;
        _rowCounter[0] = 0;
        if (movePlayer && (row == 1)) {
            _frogX++;
        }
    }

    _rowCounter[1]++;
    if (_rowCounter[1] >= _rowMaxValue[1]) {
        _tileScrolling[4]++;
        _tileScrolling[5]++;
        _rowCounter[1] = 0;
        if (movePlayer && (row == 2)) {
            _frogX--;
        }
    }

    _rowCounter[2]++;
    if (_rowCounter[2] >= _rowMaxValue[2]) {
        _tileScrolling[6]--;
        _tileScrolling[7]--;
        _rowCounter[2] = 0;
        if (movePlayer && (row == 3)) {
            _frogX++;
        }
    }

    _rowCounter[3]++;
    if (_rowCounter[3] >= _rowMaxValue[3]) {
        _tileScrolling[8]--;
        _tileScrolling[9]--;
        _rowCounter[3] = 0;
        if (movePlayer && (row == 4)) {
            _frogX++;
        }
    }

    _rowCounter[4]++;
    if (_rowCounter[4] >= _rowMaxValue[4]) {
        _tileScrolling[10]++;
        _tileScrolling[11]++;
        _rowCounter[4] = 0;
        if (movePlayer && (row == 5)) {
            _frogX--;
        }
    }

    _rowCounter[5]++;
    if (_rowCounter[5] >= _rowMaxValue[5]) {
        _tileScrolling[12]++;
        _tileScrolling[13]++;
        _rowCounter[5] = 0;
    }

    _rowCounter[6]++;
    if (_rowCounter[6] >= _rowMaxValue[6]) {
        _tileScrolling[14]--;
        _tileScrolling[15]--;
        _rowCounter[6] = 0;
    }

    _rowCounter[7]++;
    if (_rowCounter[7] >= _rowMaxValue[7]) {
        _tileScrolling[16]++;
        _tileScrolling[17]++;
        _rowCounter[7] = 0;
    }

    _rowCounter[8]++;
    if (_rowCounter[8] >= _rowMaxValue[8]) {
        _tileScrolling[18]--;
        _tileScrolling[19]--;
        _rowCounter[8] = 0;
    }

    _rowCounter[9]++;
    if (_rowCounter[9] >= _rowMaxValue[9]) {
        _tileScrolling[20]++;
        _tileScrolling[21]++;
        _rowCounter[9] = 0;
    }

}
+ (void)updateTurtleAnimation
{
    if (_turtleAnimationFrame == 0) {
        [self loadTiles:@"turtle1Tiles.txt" addr:0];
    } else if (_turtleAnimationFrame == 16) {
        [self loadTiles:@"turtle2Tiles.txt" addr:0];
    } else if (_turtleAnimationFrame == 32) {
        [self loadTiles:@"turtle3Tiles.txt" addr:0];
    }
    _turtleAnimationFrame++;
    if (_turtleAnimationFrame >= 48) {
        _turtleAnimationFrame = 0;
    }
}
+ (void)updateNametable2x2:(int)addr src:(unsigned char *)src
{
    _nametable[addr+0] = src[0];
    _nametable[addr+1] = src[1];
    _nametable[addr+32+0] = src[2];
    _nametable[addr+32+1] = src[3];
}
+ (void)updateNametable2x2:(int)addr src:(unsigned char *)src width:(int)width
{
    if (width == 1) {
        _nametable[addr+0] = src[0];
        _nametable[addr+32+0] = src[2];
        return;
    }
    for (int i=0; i<width; i+=2) {
        [self updateNametable2x2:addr+i src:src];
    }
}
+ (void)updateNametable2x2:(int)addr tile:(int)tile
{
    _nametable[addr+0] = tile+0;
    _nametable[addr+1] = tile+1;
    _nametable[addr+32+0] = tile+2;
    _nametable[addr+32+1] = tile+3;
}
+ (void)updateNametable2x2:(int)addr tile:(int)tile width:(int)width
{
    for (int i=0; i<width; i+=2) {
        [self updateNametable2x2:addr+i tile:tile];
    }
}
+ (void)handleTurtleSlowSinking
{
    _turtleSlowSinkingCounter++;
    if (_turtleSlowSinkingState == 0) {
        if (_turtleSlowSinkingCounter >= 24*3) {
            // goto sinking 1
            _turtleSlowSinkingState++;
            _turtleSlowSinkingCounter = 0;
            [self updateNametable2x2:_turtleSlowSinkingAddr src:_extraNametable+2*4 width:4];
        }
    } else if (_turtleSlowSinkingState == 1) {
        if (_turtleSlowSinkingCounter >= 24) {
            // goto sinking 2
            _turtleSlowSinkingState++;
            _turtleSlowSinkingCounter = 0;
            [self updateNametable2x2:_turtleSlowSinkingAddr src:_extraNametable+3*4 width:4];
        }
    } else if (_turtleSlowSinkingState == 2) {
        if (_turtleSlowSinkingCounter >= 24) {
            // goto water
            _turtleSlowSinkingState++;
            _turtleSlowSinkingCounter = 0;
            _dynamicAttrs['B'] = ' ';
            [self updateNametable2x2:_turtleSlowSinkingAddr src:_extraNametable+4*4 width:4];
        }
    } else if (_turtleSlowSinkingState == 3) {
        if (_turtleSlowSinkingCounter >= 18) {
            // goto sinking 2
            _turtleSlowSinkingState++;
            _turtleSlowSinkingCounter = 0;
            _dynamicAttrs['B'] = 't';
            [self updateNametable2x2:_turtleSlowSinkingAddr src:_extraNametable+3*4 width:4];
        }
    } else if (_turtleSlowSinkingState == 4) {
        if (_turtleSlowSinkingCounter >= 24) {
            // goto sinking 1
            _turtleSlowSinkingState++;
            _turtleSlowSinkingCounter = 0;
            [self updateNametable2x2:_turtleSlowSinkingAddr src:_extraNametable+2*4 width:4];
        }
    } else {
        if (_turtleSlowSinkingCounter >= 24) {
            // goto normal
            _turtleSlowSinkingState = 0;
            _turtleSlowSinkingCounter = 0;
            [self updateNametable2x2:_turtleSlowSinkingAddr tile:0 width:4];
        }
    }
}
+ (void)handleTurtleFastSinking
{
    _turtleFastSinkingCounter++;
    if (_turtleFastSinkingState == 0) {
        if (_turtleFastSinkingCounter >= 16*3) {
            // goto sinking 1
            _turtleFastSinkingState++;
            _turtleFastSinkingCounter = 0;
            [self updateNametable2x2:_turtleFastSinkingAddr src:_extraNametable+2*4 width:6];
        }
    } else if (_turtleFastSinkingState == 1) {
        if (_turtleFastSinkingCounter >= 16) {
            // goto sinking 2
            _turtleFastSinkingState++;
            _turtleFastSinkingCounter = 0;
            [self updateNametable2x2:_turtleFastSinkingAddr src:_extraNametable+3*4 width:6];
        }
    } else if (_turtleFastSinkingState == 2) {
        if (_turtleFastSinkingCounter >= 16) {
            // goto water
            _turtleFastSinkingState++;
            _turtleFastSinkingCounter = 0;
            _dynamicAttrs['C'] = ' ';
            [self updateNametable2x2:_turtleFastSinkingAddr src:_extraNametable+4*4 width:6];
        }
    } else if (_turtleFastSinkingState == 3) {
        if (_turtleFastSinkingCounter >= 12) {
            // goto sinking 2
            _turtleFastSinkingState++;
            _turtleFastSinkingCounter = 0;
            _dynamicAttrs['C'] = 't';
            [self updateNametable2x2:_turtleFastSinkingAddr src:_extraNametable+3*4 width:6];
        }
    } else if (_turtleFastSinkingState == 4) {
        if (_turtleFastSinkingCounter >= 16) {
            // goto sinking 1
            _turtleFastSinkingState++;
            _turtleFastSinkingCounter = 0;
            [self updateNametable2x2:_turtleFastSinkingAddr src:_extraNametable+2*4 width:6];
        }
    } else {
        if (_turtleFastSinkingCounter >= 16) {
            // goto normal
            _turtleFastSinkingState = 0;
            _turtleFastSinkingCounter = 0;
            [self updateNametable2x2:_turtleFastSinkingAddr tile:0 width:6];
        }
    }
}
+ (void)handleAlligator
{
    _alligatorCounter++;
    if (_alligatorState == 0) {
        if (_alligatorCounter >= 240) {
            // goto open
            _alligatorState++;
            _alligatorCounter = 0;
            _dynamicAttrs['A'] = 'a';
            [self updateNametable2x2:_alligatorAddr src:_extraNametable+7*4 width:2];
        }
    } else {
        if (_alligatorCounter >= 240) {
            // goto closed
            _alligatorState = 0;
            _alligatorCounter = 0;
            _dynamicAttrs['A'] = 'l';
            [self updateNametable2x2:_alligatorAddr src:_extraNametable+6*4 width:2];
        }
    }
}
+ (void)handleHomeFly
{
    static int home = 0;
    _homeFlyCounter++;
    if (_homeFlyState == 0) {
        if (_homeFlyCounter >= 90) {
            if (_frogAtHome[home]) {
                _homeFlyCounter = 0;
                home++;
                home %= 5;
            } else {
                // goto fly
                _homeFlyState++;
                _homeFlyCounter = 0;
                _homeFly = home+1;
                [self updateNametable2x2:_homeX[home] src:_extraNametable+5*4 width:2];
            }
        }
    } else {
        if (_homeFlyCounter >= 90) {
            // goto no fly
            _homeFlyState = 0;
            _homeFlyCounter = 0;
            _homeFly = 0;
            [self updateNametable2x2:_homeX[home] src:_extraNametable+4*4 width:2];
            home++;
            home %= 5;
        }
    }
}
+ (void)handleAux
{
    int level = _currentLevel;
    [self handleTurtleSlowSinking];
    [self handleTurtleFastSinking];
    if (level == 1) {
        [self handleHomeFly];
    //    [self handleHomeAlligator];
//        [self handleAlligator];
//        [self handleSnake];
//        [self handleOtter];
    } else if (level == 2) {
//        [self handleHomeFly];
        [self handleHomeAlligator];
        [self handleAlligator];
//        [self handleSnake];
//        [self handleOtter];
    } else if (level == 3) {
        [self handleHomeFly];
//        [self handleHomeAlligator];
        [self handleAlligator];
        [self handleSnake];
        [self handleOtter];
    } else if (level == 4) {
//        [self handleHomeFly];
        [self handleHomeAlligator];
        [self handleAlligator];
        [self handleSnake];
        [self handleOtter];
    } else if (level == 5) {
        [self handleHomeFly];
//        [self handleHomeAlligator];
        [self handleAlligator];
        [self handleSnake];
        [self handleOtter];
    }
    [self handleDrawPoints];
}
+ (void)handleHomeAlligator
{
    static int home = 0;
    _homeAlligatorCounter++;
    if (_homeAlligatorState == 0) {
        if (_homeAlligatorCounter >= 60) {
            if (_frogAtHome[home]) {
                _homeAlligatorCounter = 0;
                home++;
                home %= 5;
            } else {
                // goto half alligator
                _homeAlligatorState++;
                _homeAlligatorCounter = 0;
                _homeAlligator = home+1;
                [self updateNametable2x2:_homeX[home] src:_extraNametable+7*4+1 width:1];
            }
        }
    } else if (_homeAlligatorState == 1) {
        if (_homeAlligatorCounter >= 180) {
            // goto full alligator
            _homeAlligatorState++;
            _homeAlligatorCounter = 0;
            [self updateNametable2x2:_homeX[home] src:_extraNametable+7*4 width:2];
        }
    } else {
        if (_homeAlligatorCounter >= 180) {
            // goto no alligator
            _homeAlligatorState = 0;
            _homeAlligatorCounter = 0;
            _homeAlligator = 0;
            [self updateNametable2x2:_homeX[home] src:_extraNametable+4*4 width:2];
            home++;
            home %= 5;
        }
    }
}
+ (void)handleSnake
{
    id palette = get_sms_palette();
    _snakeCounter++;
    _snakeCounter %= 24;
    if (_snakeCounter % 5 == 0) {
        if (_snakeDirection == 0) {
            _snakeX--;
            if (_snakeX < _snakeMinX) {
                _snakeX = _snakeMinX;
                _snakeDirection = 1;
            }
        } else {
            _snakeX++;
            if (_snakeX > _snakeMaxX) {
                _snakeX = _snakeMaxX;
                _snakeDirection = 0;
            }
        }
    }
    id name = nil;
    if (_snakeCounter < 6) {
        name = (_snakeDirection) ? @"SnakeRight1.txt" : @"SnakeLeft1.txt";
    } else if (_snakeCounter < 12) {
        name = (_snakeDirection) ? @"SnakeRight2.txt" : @"SnakeLeft2.txt";
    } else if (_snakeCounter < 18) {
        name = (_snakeDirection) ? @"SnakeRight3.txt" : @"SnakeLeft3.txt";
    } else {
        name = (_snakeDirection) ? @"SnakeRight2.txt" : @"SnakeLeft2.txt";
    }

    id pixels = get_asset(name);
    if (!pixels) {
        return;
    }
    unsigned char x = _snakeX;
    x -= _tileScrolling[_snakeRow*2];
    [_bitmap drawCString:[pixels UTF8String] palette:[palette UTF8String] x:x y:_snakeRow*16];
    
    _snakeActualX = x;
}
+ (void)handleOtter
{
    id palette = get_sms_palette();
    if (_otterState == 0) {
        _otterCounter++;
        if (_otterCounter >= 90) {
            _otterState = 1;
            _otterCounter = 0;
            _otterX = _otterStartX;
        }
        return;
    }
    _otterCounter++;
    if (_otterCounter % 5 == 0) {
        if (_otterDirection == 0) {
            _otterX--;
            _otterCounter = 0;
            if (_otterX <= _otterEndX) {
                _otterState = 0;
                _otterCounter = 0;
                return;
            }
        } else {
            _otterX++;
            _otterCounter = 0;
            if (_otterX >= _otterEndX) {
                _otterState = 0;
                _otterCounter = 0;
                return;
            }
        }
    }

    unsigned char x = _otterX;
    x -= _tileScrolling[_otterRow*2];

    id name = nil;
    name = (_otterDirection) ? @"OtterRight1.txt" : @"OtterLeft1.txt";
    int row = _frogY / 16;
    if (row == _otterRow) {
        if (_otterDirection == 1) {
            if ((_frogX - x >= 0) && (_frogX - x < 24)) {
                name = (_otterDirection) ? @"OtterRight2.txt" : @"OtterLeft2.txt";
            }
        } else {
            if ((x - _frogX >= 0) && (x - _frogX < 24)) {
                name = (_otterDirection) ? @"OtterRight2.txt" : @"OtterLeft2.txt";
            }
        }
    }
    id pixels = get_asset(name);
    if (!pixels) {
        return;
    }
    [_bitmap drawCString:[pixels UTF8String] palette:[palette UTF8String] x:x y:_otterRow*16];
    
    _otterActualX = x;
}
+ (void)handleDrawPoints
{
    if (_drawPointsCounter <= 0) {
        return;
    }
    _drawPointsCounter--;
    id pixels = get_asset(@"200.txt");
    if (!pixels) {
        return;
    }
    id palette = get_sms_palette();
    [_bitmap drawCString:[pixels UTF8String] palette:[palette UTF8String] x:_drawPointsX y:_drawPointsY];
}
+ (unsigned char)getAttr:(int)addr
{
    unsigned char attr = _levelAttrs[addr];
    if (!_dynamicAttrs[attr]) {
        return attr;
    }
    return _dynamicAttrs[attr];
}
+ (void)runLoop
{

MainLoop:
for (;;) {
    [_pool drain];
    _pool = [[NSAutoreleasePool alloc] init];

    void drawX11RGBA8888(void *, int, int, int);
    drawX11RGBA8888([_bitmap pixelBytes], 256, 192, 1);
    for(;;) {
        char *getX11Event(void);
        char *event = getX11Event();
        if (!event) {
            break;
        }
        NSLog(@"event '%s'", event);
        if (!strncmp(event, "keyDown keyString:escape ", 25)) {
            exit(0);
        }
        id str = nsfmt(@"%s", event);
        if ([str hasPrefix:@"keyDown"]) {
            [Frogger handleKeyDown:str];
        }
    }

    [self handleAudio];

    [_bitmap clear:@"black"];

    [self drawBackground];
//[self drawAttrs];

    [self drawFrogX:_frogX y:_frogY];
//[self drawFroggerX:_frogX y:_frogY];
    if (_jumping) {
        _jumpingFrame++;
        if (_jumpingFrame >= 16) {
            if (_facing == 'u') {
                _frogY -= 16;
            } else if (_facing == 'd') {
                _frogY += 16;
            } else if (_facing == 'l') {
                _frogX -= 16;
            } else if (_facing == 'r') {
                _frogX += 16;
            }
            _jumping = 0;
            _jumpingFrame = 0;
        }
    }

    [self handleScrolling];
    [self updateTurtleAnimation];
    [self handleAux];


    {
        int row = _frogY / 16;
        int tileY = ((_frogY+8)/8)%24;
        unsigned char leftTileX = _frogX+2;
        leftTileX += _tileScrolling[tileY];
        leftTileX /= 8;
        unsigned char rightTileX = _frogX+13;
        rightTileX += _tileScrolling[tileY];
        rightTileX /= 8;
        unsigned char leftAttr = [self getAttr:tileY*32+leftTileX];
        unsigned char rightAttr = [self getAttr:tileY*32+rightTileX];
        [_bitmap setColor:@"white"];
//        [_bitmap drawBitmapText:nsfmt(@"(%c) (%c)", leftAttr, rightAttr) x:0 y:192-8];


        if (!_jumping) {
            if (row == 0) {
                if ((leftAttr >= '1') && (leftAttr <= '5')) {
                    if (leftAttr == rightAttr) {
                        _a = leftAttr-'1';
                        goto HandleFrogAtHome;
                    }
                }
                goto PlayerDie;
            } else if (row == 1) {
                if ((leftAttr == ' ') && (rightAttr == ' ')) {
                    goto PlayerDieInWater;
                }
                if ((leftAttr == 'a') || (rightAttr == 'a')) {
                    goto PlayerDie;
                }
            } else if (row == 2) {
                if ((leftAttr == ' ') && (rightAttr == ' ')) {
                    goto PlayerDieInWater;
                }
            } else if (row == 3) {
                if ((leftAttr == ' ') && (rightAttr == ' ')) {
                    goto PlayerDieInWater;
                }
            } else if (row == 4) {
                if ((leftAttr == ' ') && (rightAttr == ' ')) {
                    goto PlayerDieInWater;
                }
            } else if (row == 5) {
                if ((leftAttr == ' ') && (rightAttr == ' ')) {
                    goto PlayerDieInWater;
                }
            } else {
                if ((leftAttr == 'c') || (rightAttr == 'c')) {
//NSLog(@"tileY %d tileX %d %d leftAttr '%c' rightAttr '%c'", tileY, leftTileX, rightTileX, leftAttr, rightAttr);
                    goto PlayerDie;
                }
                
            }
            if (_snakeRow == row) {
                if (_snakeDirection == 0) {
                    if (abs(_snakeActualX - _frogX) < 16) {
                        goto PlayerDie;
                    }
                } else {
                    if (abs(_snakeActualX+16 - _frogX) < 16) {
                        goto PlayerDie;
                    }
                }
            }
            if (_otterState) {
                if (_otterRow == row) {
                    if (abs(_otterActualX - _frogX) < 16) {
                        goto PlayerDie;
                    }
                }
            }
        }
    }

    if (_frogX > 240) {
        goto PlayerDie;
    } else if (_frogX < 0) {
        goto PlayerDie;
    }

    if (_frogX >= 256) {
        _frogX -= 256;
    } else if (_frogX < 0) {
        _frogX += 256;
    }

}
goto MainLoop;

PlayerDie:
{
    [self resetPSG];
    [self playSound:@"die.psg"];
    _music = 0;
    _musicCursor = 0;
    for (int i=0; i<48; i++) {
        for(;;) {
            char *getX11Event(void);
            char *event = getX11Event();
            if (!event) {
                break;
            }
            NSLog(@"event '%s'", event);
            if (!strncmp(event, "keyDown keyString:escape ", 25)) {
                exit(0);
            }
        }

        [self handleAudio];

        [_bitmap clear:@"black"];

        [self drawBackground];
//[self drawAttrs];
        [self drawFrogDying:i x:_frogX y:_frogY];

        [self handleScrolling];
        [self updateTurtleAnimation];
        [self handleAux];

        void drawX11RGBA8888(void *, int, int, int);
        drawX11RGBA8888([_bitmap pixelBytes], 256, 192, 1);
    }
    [self setMusic:@"respawn.psg"];
    [self resetPlayer];
    goto MainLoop;
}

PlayerDieInWater:
    [self resetPSG];
    [self playSound:@"dieInWater.psg"];
    _music = 0;
    _musicCursor = 0;
    for (int i=0; i<48; i++) {
        for(;;) {
            char *getX11Event(void);
            char *event = getX11Event();
            if (!event) {
                break;
            }
            NSLog(@"event '%s'", event);
            if (!strncmp(event, "keyDown keyString:escape ", 25)) {
                exit(0);
            }
        }

        [self handleAudio];

        [_bitmap clear:@"black"];

        [self drawBackground];
//[self drawAttrs];
        [self drawFrogDieInWater:i x:_frogX y:_frogY];

        [self handleScrolling];
        [self updateTurtleAnimation];
        [self handleAux];

        void drawX11RGBA8888(void *, int, int, int);
        drawX11RGBA8888([_bitmap pixelBytes], 256, 192, 1);
    }
    [self setMusic:@"respawn.psg"];
    [self resetPlayer];
    goto MainLoop;


HandleFrogAtHome:
{
    unsigned char val = _a;
    if (_frogAtHome[val]) {
        goto PlayerDie;;
    }
    if (_homeAlligator == val+1) {
        if (_homeAlligatorState == 2) {
            goto PlayerDie;
        }
        _homeAlligator = 0;
        _homeAlligatorState = 0;
        _homeAlligatorCounter = 0;
    }
    _frogAtHome[val] = 1;
    int x = _homeX[val];
    [self updateNametable2x2:x src:_extraNametable+0*4];

    if (_homeFly == val+1) {
        _drawPointsCounter = 120;
        _drawPointsX = _homeX[val]*8;
        _drawPointsY = 0;
        _homeFly = 0;
        _homeFlyState = 0;
        _homeFlyCounter = 0;
    }


    [self playSound:@"croak.psg"];
    [self resetPlayer];

    if (_frogAtHome[0] && _frogAtHome[1] && _frogAtHome[2] && _frogAtHome[3] && _frogAtHome[4]) {
        goto HandleLevelComplete;
    }

    _homeCount++;
    if (_homeCount > 20) {
        _homeCount = 1;
    }
    [self setMusic:nsfmt(@"%d.psg", _homeCount)];
    goto MainLoop;
}
HandleLevelComplete:
{
    if (_currentLevel < 5) {
        [self loadLevel:_currentLevel+1];
    }
    [self resetScrolling];
    [self setMusic:@"levelcomplete.psg"];
    [self setMusicRepeat:nil];

    for(int i=0;; i++) {
        void drawX11RGBA8888(void *, int, int, int);
        drawX11RGBA8888([_bitmap pixelBytes], 256, 192, 1);
        for(;;) {
            char *getX11Event(void);
            char *event = getX11Event();
            if (!event) {
                break;
            }
            NSLog(@"event '%s'", event);
            if (!strncmp(event, "keyDown keyString:escape ", 25)) {
                exit(0);
            }
        }

        [self handleAudio];
        if (!_music) {
            break;
        }

        [_bitmap clear:@"black"];

        [self drawBackground];
//[self drawAttrs];

        [self handleScrolling];
        [self updateTurtleAnimation];
        [self handleAux];

        if (i == 90) {
            [self updateNametable2x2:_homeX[0] src:_extraNametable+1*4];
        } else if (i == 120) {
            [self updateNametable2x2:_homeX[1] src:_extraNametable+1*4];
        } else if (i == 150) {
            [self updateNametable2x2:_homeX[2] src:_extraNametable+1*4];
        } else if (i == 180) {
            [self updateNametable2x2:_homeX[3] src:_extraNametable+1*4];
        } else if (i == 210) {
            [self updateNametable2x2:_homeX[4] src:_extraNametable+1*4];
        }
            
    }
    for (int i=0; i<5; i++) {
        _frogAtHome[i] = 0;
        [self updateNametable2x2:_homeX[i] src:_extraNametable+4*4];
    }
    [self setMusic:@"frogstheme.psg"];
    [self setMusicRepeat:@"frogstheme.psg"];
    goto MainLoop;
}


}
@end

@implementation Definitions(mekflmskdlfmklsdmfklsdfm)
+ (void)Frogger
{
    _pool = [[NSAutoreleasePool alloc] init];

    _sn76489 = [[[@"frog runSN76489" split] runCommandAndReturnProcess] retain];

    _bitmap = [[Definitions bitmapWithWidth:256 height:192] retain];
    [_bitmap useC64Font];

    _data_contents = [get_data_contents() retain];

    id obj = [Frogger class];
[obj loadAudioAssets];
[obj loadTiles:@"backgroundTiles.txt" addr:4*64];
[obj loadIntValues:@"extraNametable.txt" dst:_extraNametable len:8*4];
[obj loadLevel:1];
[obj setMusic:@"frogstheme.psg"];
[obj setMusicRepeat:@"frogstheme.psg"];

[obj updateTurtleAnimation];

    void setupX11Iteration(int, int, int, int);
    setupX11Iteration(0, 0, 512, 384);

    [Frogger runLoop];

    exit(0);
}
@end
