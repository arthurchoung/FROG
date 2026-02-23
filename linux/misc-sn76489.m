#import "FROG.h"

#include "emu76489.h"
#include <stdio.h>

#define SAMPLERATE 44100
#define FRAMECOUNT 735

static int16_t audiobuf[FRAMECOUNT];

@implementation Definitions(fmeklwfmkldsmkflsmdklfjfdksjfk)
+ (void)runSN76489
{
    [Definitions runSN76489:12];
}
+ (void)runSN76489:(int)divider
{
    id process = [[@"aplay -f S16_LE -r 44100" split] runCommandAndReturnProcess];

    SNG *sng = SNG_new(3579545, SAMPLERATE);
    if (!sng) {
        NSLog(@"unable to allocate SNG");
        exit(1);
    }
    SNG_reset(sng);

    char buf[4096];
    for (;;) {
        if (!fgets(buf, 4096, stdin)) {
            break;
        }

        char *p = buf;
        for(;;) {
            if (!*p) {
                break;
            }
            if (!isdigit(*p)) {
                p++;
                continue;
            }
            char *q = strchr(p+1, ' ');
            if (q) {
                *q = 0;
                q++;
            }
            int val = (int)strtol(p, 0, 10);
            SNG_writeIO(sng, val);
            if (!q) {
                break;
            }
            p = q;
        }
        for (int i=0; i<FRAMECOUNT/divider; i++) {
            audiobuf[i] = SNG_calc(sng);
        }
//        fwrite(audiobuf, 2, FRAMECOUNT, stdout);
        [process writeBytes:audiobuf length:(FRAMECOUNT/divider)*2];
    }

    exit(0);
}
+ (void)runSN76489stdout
{
    SNG *sng = SNG_new(3579545, SAMPLERATE);
    if (!sng) {
        NSLog(@"unable to allocate SNG");
        exit(1);
    }
    SNG_reset(sng);

    char buf[4096];
    for (;;) {
        if (!fgets(buf, 4096, stdin)) {
            break;
        }

        char *p = buf;
        for(;;) {
            if (!*p) {
                break;
            }
            if (!isdigit(*p)) {
                p++;
                continue;
            }
            char *q = strchr(p+1, ' ');
            if (q) {
                *q = 0;
                q++;
            }
            int val = (int)strtol(p, 0, 10);
            SNG_writeIO(sng, val);
            if (!q) {
                break;
            }
            p = q;
        }
        for (int i=0; i<FRAMECOUNT; i++) {
            audiobuf[i] = SNG_calc(sng);
        }
        write(1, audiobuf, FRAMECOUNT*2);
    }

    exit(0);
}
@end

