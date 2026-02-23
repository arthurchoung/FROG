#import "FROG.h"

#include <fcntl.h>

#include <sys/types.h>
#include <sys/wait.h>
#include <stdio.h>
#include <signal.h>
#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <X11/keysym.h>
#include <X11/cursorfont.h>
#include <X11/extensions/shape.h>

#include <GL/gl.h>
#include <GL/glx.h>

static Display *_display = 0;
static int _displayFD = -1;
static Window _rootWindow = 0;
static int _rootWindowX = 0;
static int _rootWindowY = 0;
static int _rootWindowWidth = 0;
static int _rootWindowHeight = 0;
static XVisualInfo _visualInfo;
static Colormap _colormap = 0;
static Window _window = 0;
static int _windowWidth = 0;
static int _windowHeight = 0;

static GLuint _textureID = 0;
static char _eventBuf[1024];

void setupX11Iteration(int x, int y, int w, int h)
{
    _display = XOpenDisplay(0);
    if (!_display) {
NSLog(@"XOpenDisplay failed");
        exit(1);
    }

    _displayFD = ConnectionNumber(_display);

    _rootWindow = DefaultRootWindow(_display);
    XWindowAttributes rootAttrs;
    XGetWindowAttributes(_display, _rootWindow, &rootAttrs);
    _rootWindowX = rootAttrs.x;
    _rootWindowY = rootAttrs.y;
    _rootWindowWidth = rootAttrs.width;
    _rootWindowHeight = rootAttrs.height;

    if (!XMatchVisualInfo(_display, DefaultScreen(_display), 32, TrueColor, &_visualInfo)) {
NSLog(@"XMatchVisualInfo failed for depth 32, trying 24");
        if (!XMatchVisualInfo(_display, DefaultScreen(_display), 24, TrueColor, &_visualInfo)) {
NSLog(@"XMatchVisualInfo failed for depth 24");
            exit(1);
        }
    }
NSLog(@"XMatchVisualInfo depth %d", _visualInfo.depth);

    _colormap = XCreateColormap(_display, _rootWindow, _visualInfo.visual, AllocNone);


    XSetWindowAttributes setAttrs;
    setAttrs.colormap = _colormap;
    setAttrs.event_mask = ButtonPressMask|ButtonReleaseMask|PointerMotionMask|VisibilityChangeMask|KeyPressMask|KeyReleaseMask|StructureNotifyMask|FocusChangeMask;
    setAttrs.bit_gravity = NorthWestGravity;
    setAttrs.background_pixmap = None;
    setAttrs.border_pixel = 0;
    unsigned long attrFlags = CWColormap|CWEventMask|CWBackPixmap|CWBorderPixel;
/*
    if (overrideRedirect) {
        setAttrs.override_redirect = True;
        attrFlags |= CWOverrideRedirect;
    }
*/
    _window = XCreateWindow(_display, _rootWindow, x, y, w, h, 0, _visualInfo.depth, InputOutput, _visualInfo.visual, attrFlags, &setAttrs);
    _windowWidth = w;
    _windowHeight = h;


/*
    if (name) {
        XStoreName(_display, _window, [name UTF8String]);
    }
*/

    Atom wm_delete_window = XInternAtom(_display, "WM_DELETE_WINDOW", 0);
    XSetWMProtocols(_display, _window, &wm_delete_window, 1);


    GLXContext glContext = glXCreateContext(_display, &_visualInfo, 0, True);
    if (!glContext) {
NSLog(@"glXCreateContext failed");
        exit(1);
    }
    
    glXMakeCurrent(_display, _window, glContext);

    PFNGLXSWAPINTERVALMESAPROC glXSwapIntervalMESA;
    glXSwapIntervalMESA = (PFNGLXSWAPINTERVALMESAPROC)glXGetProcAddress((const GLubyte *)"glXSwapIntervalMESA");
    if (glXSwapIntervalMESA != NULL) {
NSLog(@"glXSwapIntervalMESA");
        glXSwapIntervalMESA(1);
    } else {
        PFNGLXSWAPINTERVALSGIPROC glXSwapIntervalSGI;
        glXSwapIntervalSGI = (PFNGLXSWAPINTERVALSGIPROC)glXGetProcAddress((const GLubyte *)"glXSwapIntervalSGI");
        if (glXSwapIntervalSGI != NULL) {
NSLog(@"glXSwapIntervalSGI");
            glXSwapIntervalSGI(1);
        } else {
NSLog(@"glXSwapInterval failed");
            exit(1);
        }
    }
/*
            PFNGLXSWAPINTERVALEXTPROC glXSwapIntervalEXT;
            glXSwapIntervalEXT = (PFNGLXSWAPINTERVALEXTPROC)glXGetProcAddress((const GLubyte *)"glXSwapIntervalEXT");
            if (glXSwapIntervalEXT != NULL) {
NSLog(@"glXSwapIntervalEXT");
                glXSwapIntervalEXT(_display, _window, 1);
            }
*/



    glGenTextures(1, &_textureID);

    XMapWindow(_display, _window);
}

void drawX11RGBA8888(unsigned char *pixels, int bitmapWidth, int bitmapHeight, int draw_GL_NEAREST)
{
    int x = 0;
    int y = 0;

    glViewport(0, 0, _windowWidth, _windowHeight);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    if (draw_GL_NEAREST) {
        glBindTexture(GL_TEXTURE_2D, _textureID);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, bitmapWidth, bitmapHeight, 0, GL_BGRA, GL_UNSIGNED_INT_8_8_8_8_REV, pixels);
    } else {
        glBindTexture(GL_TEXTURE_2D, _textureID);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, bitmapWidth, bitmapHeight, 0, GL_BGRA, GL_UNSIGNED_INT_8_8_8_8_REV, pixels);
    }

    int inW = _windowWidth;
    int inH = _windowHeight;
    double llX = ((double)x / (double)(inW))*2.0-1.0;
    double llY = ((double)y / (double)(inH))*2.0-1.0;
    double urX = ((double)(x+_windowWidth) / (double)(inW))*2.0-1.0;
    double urY = ((double)(y+_windowHeight) / (double)(inH))*2.0-1.0;

    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, _textureID);

    glBegin(GL_QUADS);
    glTexCoord2f(0.0f, 0.0f);
    glVertex3f(llX, urY, 0.0f);
    glTexCoord2f(1.0f, 0.0f);
    glVertex3f(urX, urY, 0.0f);
    glTexCoord2f(1.0f, 1.0f);
    glVertex3f(urX, llY, 0.0f);
    glTexCoord2f(0.0f, 1.0f);
    glVertex3f(llX, llY, 0.0f);
    glEnd();

    glXSwapBuffers(_display, _window);
}

void drawX11BGR565(unsigned char *pixels, int bitmapWidth, int bitmapHeight, int draw_GL_NEAREST)
{
    int x = 0;
    int y = 0;

    glViewport(0, 0, _windowWidth, _windowHeight);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    if (draw_GL_NEAREST) {
        glBindTexture(GL_TEXTURE_2D, _textureID);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, bitmapWidth, bitmapHeight, 0, GL_RGB, GL_UNSIGNED_SHORT_5_6_5, pixels);
    } else {
        glBindTexture(GL_TEXTURE_2D, _textureID);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, bitmapWidth, bitmapHeight, 0, GL_RGB, GL_UNSIGNED_SHORT_5_6_5, pixels);
    }

    int inW = _windowWidth;
    int inH = _windowHeight;
    double llX = ((double)x / (double)(inW))*2.0-1.0;
    double llY = ((double)y / (double)(inH))*2.0-1.0;
    double urX = ((double)(x+_windowWidth) / (double)(inW))*2.0-1.0;
    double urY = ((double)(y+_windowHeight) / (double)(inH))*2.0-1.0;

    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, _textureID);

    glBegin(GL_QUADS);
    glTexCoord2f(0.0f, 0.0f);
    glVertex3f(llX, urY, 0.0f);
    glTexCoord2f(1.0f, 0.0f);
    glVertex3f(urX, urY, 0.0f);
    glTexCoord2f(1.0f, 1.0f);
    glVertex3f(urX, llY, 0.0f);
    glTexCoord2f(0.0f, 1.0f);
    glVertex3f(llX, llY, 0.0f);
    glEnd();

    glXSwapBuffers(_display, _window);
}

static char *handleX11KeyPress(XKeyEvent *e)
{
    int keysym = XLookupKeysym(e, 0);
    id keyString = [Definitions keyForXKeyCode:keysym modifiers:e->state];
    int altKey = (e->state & Mod1Mask) ? 1 : 0;
    int windowsKey = (e->state & Mod4Mask) ? 1 : 0;

    sprintf(_eventBuf, "keyDown keyString:%@ keyCode:%d altKey:%d windowsKey:%d mouseRootX:%d mouseRootY:%d mouseX:%d mouseY:%d", keyString, keysym, altKey, windowsKey, e->x_root, e->y_root, e->x, e->y);
    return _eventBuf;
}

static char *handleX11KeyRelease(XKeyEvent *e)
{
    if (XEventsQueued(_display, QueuedAfterReading)) {
        XEvent nextEvent;
        XPeekEvent(_display, &nextEvent);

        if ((nextEvent.type == KeyPress)
            && (nextEvent.xkey.time == e->time)
            && (nextEvent.xkey.keycode == e->keycode))
        {
NSLog(@"handleX11KeyRelease repeat");
            return 0;
        }
    }

    int keysym = XLookupKeysym(e, 0);
    id keyString = [Definitions keyForXKeyCode:keysym modifiers:e->state];
    int altKey = (e->state & Mod1Mask) ? 1 : 0;
    int windowsKey = (e->state & Mod4Mask) ? 1 : 0;

    sprintf(_eventBuf, "keyUp keyString:%@ keyCode:%d altKey:%d windowsKey:%d mouseRootX:%d mouseRootY:%d mouseX:%d mouseY:%d", keyString, keysym, altKey, windowsKey, e->x_root, e->y_root, e->x, e->y);
    return _eventBuf;
}

static char *handleX11ButtonPress(XButtonEvent *e)
{
    int shiftKey = (e->state & ShiftMask) ? 1 : 0;
    int altKey = (e->state & Mod1Mask) ? 1 : 0;
    int windowsKey = (e->state & Mod4Mask) ? 1 : 0;

    if ((e->button == 1) || (e->button == 3)) {
        sprintf(_eventBuf, "mouseDown button:%d shiftKey:%d altKey:%d windowsKey:%d mouseRootX:%d mouseRootY:%d mouseX:%d mouseY:%d", e->button, shiftKey, altKey, windowsKey, e->x_root, e->y_root, e->x, e->y);
        return _eventBuf;
    } else if (e->button == 4) {
        sprintf(_eventBuf, "scrollWheel button:%d shiftKey:%d altKey:%d windowsKey:%d mouseRootX:%d mouseRootY:%d mouseX:%d mouseY:%d deltaY:20 scrollingDeltaY:-20", e->button, shiftKey, altKey, windowsKey, e->x_root, e->y_root, e->x, e->y);
        return _eventBuf;
    } else if (e->button == 5) {
        sprintf(_eventBuf, "scrollWheel button:%d shiftKey:%d altKey:%d windowsKey:%d mouseRootX:%d mouseRootY:%d mouseX:%d mouseY:%d deltaY:-20 scrollingDeltaY:20", e->button, shiftKey, altKey, windowsKey, e->x_root, e->y_root, e->x, e->y);
        return _eventBuf;
    } else if (e->button == 6) {
        sprintf(_eventBuf, "horizontalScroll button:%d shiftKey:%d altKey:%d windowsKey:%d mouseRootX:%d mouseRootY:%d mouseX:%d mouseY:%d deltaX:-100 scrollingDeltaX:100", e->button, shiftKey, altKey, windowsKey, e->x_root, e->y_root, e->x, e->y);
        return _eventBuf;
    } else if (e->button == 7) {
        sprintf(_eventBuf, "horizontalScroll button:%d shiftKey:%d altKey:%d windowsKey:%d mouseRootX:%d mouseRootY:%d mouseX:%d mouseY:%d deltaX:-100 scrollingDeltaX:100", e->button, shiftKey, altKey, windowsKey, e->x_root, e->y_root, e->x, e->y);
        return _eventBuf;
    }
    return 0;
}
static char *handleX11ButtonRelease(XButtonEvent *e)
{
    int shiftKey = (e->state & ShiftMask) ? 1 : 0;
    int altKey = (e->state & Mod1Mask) ? 1 : 0;
    int windowsKey = (e->state & Mod4Mask) ? 1 : 0;

    if ((e->button == 1) || (e->button == 3)) {
        sprintf(_eventBuf, "mouseUp button:%d shiftKey:%d altKey:%d windowsKey:%d mouseRootX:%d mouseRootY:%d mouseX:%d mouseY:%d", e->button, shiftKey, altKey, windowsKey, e->x_root, e->y_root, e->x, e->y);
        return _eventBuf;
    }
    return 0;
}
static char *handleX11MotionNotify(XMotionEvent *e)
{
    int shiftKey = (e->state & ShiftMask) ? 1 : 0;
    int altKey = (e->state & Mod1Mask) ? 1 : 0;
    int windowsKey = (e->state & Mod4Mask) ? 1 : 0;

    sprintf(_eventBuf, "mouseMoved shiftKey:%d altKey:%d windowsKey:%d mouseRootX:%d mouseRootY:%d mouseX:%d mouseY:%d", shiftKey, altKey, windowsKey, e->x_root, e->y_root, e->x, e->y);
    return _eventBuf;
}




char *getX11Event()
{
    while (XPending(_display) > 0) {
        XEvent event;
        XNextEvent(_display, &event);
        if (event.type == KeyPress) {
            return handleX11KeyPress((XKeyEvent *)&event);
        } else if (event.type == KeyRelease) {
            return handleX11KeyRelease((XKeyEvent *)&event);
        } else if (event.type == ButtonPress) {
            return handleX11ButtonPress((XButtonEvent *)&event);
        } else if (event.type == ButtonRelease) {
            return handleX11ButtonRelease((XButtonEvent *)&event);
        } else if (event.type == MotionNotify) {
            return handleX11MotionNotify((XMotionEvent *)&event);
        } else if (event.type == FocusIn) {
NSLog(@"FocusIn");
        } else if (event.type == FocusOut) {
NSLog(@"FocusOut");
        } else if (event.type == Expose) {
NSLog(@"Expose");
        } else if (event.type == VisibilityNotify) {
NSLog(@"VisibilityNotify");
        } else if (event.type == UnmapNotify) {
NSLog(@"UnmapNotify");
        } else if (event.type == MapNotify) {
NSLog(@"MapNotify");
        } else if (event.type == ConfigureNotify) {
            XConfigureEvent *e = (XConfigureEvent *)&event;
            XWindowAttributes attrs;
            XGetWindowAttributes(_display, e->window, &attrs);
NSLog(@"configureNotify x:%d y:%d w:%d h:%d", attrs.x, attrs.y, attrs.width, attrs.height);
            _windowWidth = attrs.width;
            _windowHeight = attrs.height;
        } else if (event.type == PropertyNotify) {
NSLog(@"PropertyNotify");
        } else if (event.type == ClientMessage) {
            if (event.xclient.message_type == XInternAtom(_display, "WM_PROTOCOLS", 1)
                && event.xclient.data.l[0] == XInternAtom(_display, "WM_DELETE_WINDOW", 1))
            {
                exit(1);
            }
        } else {
NSLog(@"received X event type %d", event.type);
        }
    }
    XFlush(_display);
    return 0;
}

@implementation Definitions(fmekwlmfklsdmfklsdmklfm)
+ (void)testRunLoop
{
    setupX11Iteration(0, 0, 640, 480);

int i=0;
    id bitmap = [Definitions bitmapWithWidth:256 height:192];
    id pool = nil;
    for(;;) {
        [pool drain];
        pool = [[NSAutoreleasePool alloc] init];
Int4 r;
r.x = 0;
r.y = 0;
r.w = 256;
r.h = 192;
[bitmap setColor:@"black"];
[bitmap fillRect:r];
[bitmap setColor:@"white"];
[bitmap drawBitmapText:nsfmt(@"HELLO %d", i) x:0 y:0];
        drawX11RGBA8888([bitmap pixelBytes], 256, 192, 0);
i++;
        for(;;) {
            char *event = getX11Event();
            if (event) {
NSLog(@"event '%s'", event);
if (!strncmp(event, "keyDown keyString:escape ", 25)) {
    exit(0);
}
            } else {
break;
            }
        }
    }
}
@end

