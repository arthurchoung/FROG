#import "FROG.h"

#include <sys/socket.h>
#include <sys/un.h>

#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>

#include <linux/input-event-codes.h>

static int _waylandFD = -1;

static int _shmFD[2];
static void *_shmData[2];
static int _shmPoolSize[2];

static int _wlCurrentID = 1;

static int _wlRegistry;
static int _wlSHM;
static int _wlCompositor;

static int _wlSeat;
static int _wlPointer;
static int _wlKeyboard;

static int _xdgWMBase;
static int _xdgSurface[2];
static int _xdgSurfaceOld[2];
static int _xdgToplevel;
static int _xdgPositioner;
static int _xdgPopup;
static int _xdgPopupOld;
static int _wlSurface[2];
static int _wlSurfaceOld[2];
static int _wlSHMPool[2];
static int _wlBuffer[2];
static int _wlBufferOld[2];

static int _wpViewporter;
static int _wpViewport;

static int _wlBufferReleased[2];

static int _xdgToplevelWidth;
static int _xdgToplevelHeight;

static int _xdgPopupWidth;
static int _xdgPopupHeight;

static id _object;
static id _bitmap;
static int _mouseX;
static int _mouseY;

static id _popupObject;
static id _popupBitmap;

static void updateBitmap();

static double parse_wl_fixed(unsigned char *ptr)
{
    int32_t *p = (int32_t *)ptr;

    int32_t f = *p;

	union {
		double d;
		int64_t i;
	} u;

	u.i = ((1023LL + 44LL) << 52) + (1LL << 51) + f;

	return u.d - (3LL << 43);
}
static int32_t int_to_wl_fixed(int i)
{
	return i * 256;
}



static uint32_t padded_len(uint32_t len)
{
    if (len % 4 != 0) {
        len += 4-(len % 4);
    }
    return len;
}

static uint32_t parse_uint32(unsigned char *ptr)
{
    uint32_t *p = (uint32_t *)ptr;
    return *p;
}

static uint16_t parse_uint16(unsigned char *ptr)
{
    uint16_t *p = (uint16_t *)ptr;
    return *p;
}

static void write_uint32(unsigned char *ptr, uint32_t val)
{
    uint32_t *p = (uint32_t *)ptr;
    *p = val;
}
static void write_uint16(unsigned char *ptr, uint16_t val)
{
    uint16_t *p = (uint16_t *)ptr;
    *p = val;
}

static void write_int32(unsigned char *ptr, int32_t val)
{
    int32_t *p = (int32_t *)ptr;
    *p = val;
}
static void create_shm(int index, char *path, int size)
{
    int fd = shm_open(path, O_RDWR|O_CREAT, 0600);
    if (fd < 0) {
NSLog(@"unable to create shm");
perror("shm");
        exit(1);
    }
    if (ftruncate(fd, size) < 0) {
NSLog(@"unable to truncate shm");
        exit(1);
    }

    void *shmdata = mmap(0, size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
    if (shmdata == MAP_FAILED) {
NSLog(@"unable to mmap");
        exit(1);
    }

    _shmFD[index] = fd;
    _shmData[index] = shmdata;
    _shmPoolSize[index] = size;
NSLog(@"create_shm index %d fd %d size %d", index, fd, size);
}

static int WLDisplayGetRegistry()
{
    unsigned char buf[1024];
    unsigned char *p = buf;
    write_uint32(p, 1); // 1 - wldisplay object id
    p += 4;
    write_uint16(p, 1); // get registry opcode
    p += 2;
    unsigned char *sizePtr = p;
    p += 2;
    _wlCurrentID++;
    write_uint32(p, _wlCurrentID);
    p += 4;

    write_uint16(sizePtr, p-buf);
    write(_waylandFD, buf, p-buf);

    return _wlCurrentID;
}

static int WLRegistryBind(uint32_t name, unsigned char *str, uint32_t version)
{
    unsigned char buf[1024];
    unsigned char *p = buf;
    write_uint32(p, _wlRegistry);
    p += 4;
    write_uint16(p, 0); // bind opcode
    p += 2;
    unsigned char *sizePtr = p;
    p += 2;

NSLog(@"name %lu", name);
    write_uint32(p, name);
    p += 4;

    int len = strlen(str)+1;
    int paddedlen = padded_len(len);
    write_uint32(p, len);
    p += 4;
    strcpy(p, str);
    p += paddedlen;
    write_uint32(p, version);
    p += 4;

    _wlCurrentID++;
    write_uint32(p, _wlCurrentID);
    p += 4;

    write_uint16(sizePtr, p-buf);
    write(_waylandFD, buf, p-buf);

    return _wlCurrentID;
}

static int WLCompositorCreateSurface()
{
    unsigned char buf[1024];
    unsigned char *p = buf;

    write_uint32(p, _wlCompositor);
    p += 4;
    write_uint16(p, 0); // create surface opcode
    p += 2;
    unsigned char *sizePtr = p;
    p += 2;
    _wlCurrentID++;
    write_uint32(p, _wlCurrentID);
    p += 4;

    write_uint16(sizePtr, p-buf);
    write(_waylandFD, buf, p-buf);

    return _wlCurrentID;
}

static void XDGWMBasePong(uint32_t ping)
{
    unsigned char buf[1024];
    unsigned char *p = buf;

    write_uint32(p, _xdgWMBase);
    p += 4;
    write_uint16(p, 3); // pong opcode
    p += 2;
    unsigned char *sizePtr = p;
    p += 2;
    write_uint32(p, ping);
    p += 4;

    write_uint16(sizePtr, p-buf);
    write(_waylandFD, buf, p-buf);

    
}
static void XDGPositionerSetSize(uint32_t width, uint32_t height)
{
    unsigned char buf[1024];
    unsigned char *p = buf;

    write_uint32(p, _xdgPositioner);
    p += 4;
    write_uint16(p, 1); // set size opcode
    p += 2;
    unsigned char *sizePtr = p;
    p += 2;
    write_uint32(p, width);
    p += 4;
    write_uint32(p, height);
    p += 4;

    write_uint16(sizePtr, p-buf);
    write(_waylandFD, buf, p-buf);
}

static void XDGPositionerSetAnchorRect(uint32_t x, uint32_t y, uint32_t width, uint32_t height)
{
    unsigned char buf[1024];
    unsigned char *p = buf;

    write_uint32(p, _xdgPositioner);
    p += 4;
    write_uint16(p, 2); // set anchor rect opcode
    p += 2;
    unsigned char *sizePtr = p;
    p += 2;
    write_uint32(p, x);
    p += 4;
    write_uint32(p, y);
    p += 4;
    write_uint32(p, width);
    p += 4;
    write_uint32(p, height);
    p += 4;

    write_uint16(sizePtr, p-buf);
    write(_waylandFD, buf, p-buf);
}



static void XDGSurfaceAckConfigure(uint32_t xdgSurface, uint32_t serial)
{
    unsigned char buf[1024];
    unsigned char *p = buf;

    write_uint32(p, xdgSurface);
    p += 4;
    write_uint16(p, 4); // ack configure opcode
    p += 2;
    unsigned char *sizePtr = p;
    p += 2;
    write_uint32(p, serial);
    p += 4;

    write_uint16(sizePtr, p-buf);
    write(_waylandFD, buf, p-buf);
}

static uint32_t WLSHMCreatePool(int shmfd, int shmsize)
{
    unsigned char buf[1024];
    unsigned char *p = buf;

    write_uint32(p, _wlSHM);
    p += 4;
    write_uint16(p, 0); // create pool opcode
    p += 2;
    unsigned char *sizePtr = p;
    p += 2;
    _wlCurrentID++;
    write_uint32(p, _wlCurrentID);
    p += 4;

    write_uint32(p, shmsize);
    p += 4;

    write_uint16(sizePtr, p-buf);

    char ancillarybuf[CMSG_SPACE(sizeof(shmfd))] = "";
    struct iovec io = { .iov_base = buf, .iov_len = p-buf };
    struct msghdr socketmsg = { .msg_iov = &io, .msg_iovlen = 1, .msg_control = ancillarybuf, .msg_controllen = sizeof(ancillarybuf) };

    struct cmsghdr *cmsg = CMSG_FIRSTHDR(&socketmsg);
    cmsg->cmsg_level = SOL_SOCKET;
    cmsg->cmsg_type = SCM_RIGHTS;
    cmsg->cmsg_len = CMSG_LEN(sizeof(shmfd));

    *((int *)CMSG_DATA(cmsg)) = shmfd;
    socketmsg.msg_controllen = CMSG_SPACE(sizeof(shmfd));

    if (sendmsg(_waylandFD, &socketmsg, 0) < 0) {
        NSLog(@"unable to sendmsg");
        perror("sendmsg");
        exit(1);
    }

    return _wlCurrentID;
}

static uint32_t XDGWMBaseCreatePositioner()
{
    unsigned char buf[1024];
    unsigned char *p = buf;

    write_uint32(p, _xdgWMBase);
    p += 4;
    write_uint16(p, 1); // create positioner opcode
    p += 2;
    unsigned char *sizePtr = p;
    p += 2;

    _wlCurrentID++;
    write_uint32(p, _wlCurrentID);
    p += 4;

    write_uint16(sizePtr, p-buf);
    write(_waylandFD, buf, p-buf);

    return _wlCurrentID;
}
static uint32_t XDGWMBaseGetXDGSurface(int index)
{
    unsigned char buf[1024];
    unsigned char *p = buf;

    write_uint32(p, _xdgWMBase);
    p += 4;
    write_uint16(p, 2); // get xdg surface opcode
    p += 2;
    unsigned char *sizePtr = p;
    p += 2;

    uint32_t objectID;
    if (_xdgSurfaceOld[index]) {
        objectID = _xdgSurfaceOld[index];
    } else {
        _wlCurrentID++;
        objectID = _wlCurrentID;
    }
    write_uint32(p, objectID);
    p += 4;

    write_uint32(p, _wlSurface[index]);
    p += 4;

    write_uint16(sizePtr, p-buf);
    write(_waylandFD, buf, p-buf);

    return objectID;
}

static uint32_t WLSHMPoolCreateBuffer(int wlSHMPool, int index)
{
    unsigned char buf[1024];
    unsigned char *p = buf;

    write_uint32(p, wlSHMPool);
    p += 4;
    write_uint16(p, 0); // create buffer opcode
    p += 2;
    unsigned char *sizePtr = p;
    p += 2;

    uint32_t objectID;
    if (_wlBufferOld[index]) {
        objectID = _wlBufferOld[index];
    } else {
        _wlCurrentID++;
        objectID = _wlCurrentID;
    }
    write_uint32(p, objectID);
    p += 4;

    int width = (index) ? _xdgPopupWidth : _xdgToplevelWidth;
    int height = (index) ? _xdgPopupHeight : _xdgToplevelHeight;
    if (!width) {
        width = 640;
    }
    if (!height) {
        height = 480;
    }

    write_uint32(p, 0); // offset
    p += 4;
    write_uint32(p, width); // width
    p += 4;
    write_uint32(p, height), // height
    p += 4;
    write_uint32(p, width*4); // stride;
    p += 4;

    write_uint32(p, 1); // xrgb8888
    p += 4;

    write_uint16(sizePtr, p-buf);
    write(_waylandFD, buf, p-buf);

    return objectID;
}

static void WLSurfaceDamage(uint32_t wlSurface, int x, int y, int w, int h)
{
    unsigned char buf[1024];
    unsigned char *p = buf;

    write_uint32(p, wlSurface);
    p += 4;
    write_uint16(p, 2); // damage opcode
    p += 2;
    unsigned char *sizePtr = p;
    p += 2;

    write_uint32(p, x);
    p += 4;
    write_uint32(p, y);
    p += 4;
    write_uint32(p, w);
    p += 4;
    write_uint32(p, h);
    p += 4;

    write_uint16(sizePtr, p-buf);
    write(_waylandFD, buf, p-buf);
}


static void WLSurfaceAttach(uint32_t wlSurface, uint32_t wlBuffer)
{
    unsigned char buf[1024];
    unsigned char *p = buf;

    write_uint32(p, wlSurface);
    p += 4;
    write_uint16(p, 1); // attach opcode
    p += 2;
    unsigned char *sizePtr = p;
    p += 2;

    write_uint32(p, wlBuffer);
    p += 4;

    write_uint32(p, 0); // x
    p += 4;
    write_uint32(p, 0); // y
    p += 4;

    write_uint16(sizePtr, p-buf);
    write(_waylandFD, buf, p-buf);
}

static uint32_t XDGSurfaceGetToplevel(uint32_t xdgSurface)
{
    unsigned char buf[1024];
    unsigned char *p = buf;

    write_uint32(p, xdgSurface);
    p += 4;
    write_uint16(p, 1); // get toplevel opcode
    p += 2;
    unsigned char *sizePtr = p;
    p += 2;

    _wlCurrentID++;
    write_uint32(p, _wlCurrentID);
    p += 4;

    write_uint16(sizePtr, p-buf);
    write(_waylandFD, buf, p-buf);

    return _wlCurrentID;
}
static uint32_t XDGSurfaceGetPopup(uint32_t xdgSurface, uint32_t parent, uint32_t positioner)
{
    unsigned char buf[1024];
    unsigned char *p = buf;

    write_uint32(p, xdgSurface);
    p += 4;
    write_uint16(p, 2); // get popup opcode
    p += 2;
    unsigned char *sizePtr = p;
    p += 2;

    uint32_t objectID;
    if (_xdgPopupOld) {
        objectID = _xdgPopupOld;
    } else {
        _wlCurrentID++;
        objectID = _wlCurrentID;
    }
    write_uint32(p, objectID);
    p += 4;

    write_uint32(p, parent);
    p += 4;

    write_uint32(p, positioner);
    p += 4;

    write_uint16(sizePtr, p-buf);
    write(_waylandFD, buf, p-buf);

    return objectID;
}

static void WLSurfaceCommit(uint32_t wlSurface)
{
    unsigned char buf[1024];
    unsigned char *p = buf;

    write_uint32(p, wlSurface);
    p += 4;
    write_uint16(p, 6); // commit opcode
    p += 2;
    unsigned char *sizePtr = p;
    p += 2;

    write_uint16(sizePtr, p-buf);
    write(_waylandFD, buf, p-buf);

    if (wlSurface == _wlSurface[0]) {
        _wlBufferReleased[0] = 0;
    } else if (wlSurface == _wlSurface[1]) {
        _wlBufferReleased[1] = 0;
    }
}
static uint32_t WLSeatGetPointer()
{
    unsigned char buf[1024];
    unsigned char *p = buf;

    write_uint32(p, _wlSeat);
    p += 4;
    write_uint16(p, 0); // get pointer opcode
    p += 2;
    unsigned char *sizePtr = p;
    p += 2;

    _wlCurrentID++;
    write_uint32(p, _wlCurrentID);
    p += 4;

    write_uint16(sizePtr, p-buf);
    write(_waylandFD, buf, p-buf);

    return _wlCurrentID;
}
static uint32_t WLSeatGetKeyboard()
{
    unsigned char buf[1024];
    unsigned char *p = buf;

    write_uint32(p, _wlSeat);
    p += 4;
    write_uint16(p, 1); // get keyboard opcode
    p += 2;
    unsigned char *sizePtr = p;
    p += 2;

    _wlCurrentID++;
    write_uint32(p, _wlCurrentID);
    p += 4;

    write_uint16(sizePtr, p-buf);
    write(_waylandFD, buf, p-buf);

    return _wlCurrentID;
}
static void WLSurfaceDestroy(uint32_t wlSurface)
{
    unsigned char buf[1024];
    unsigned char *p = buf;

    write_uint32(p, wlSurface);
    p += 4;
    write_uint16(p, 0); // destroy opcode
    p += 2;
    unsigned char *sizePtr = p;
    p += 2;

    write_uint16(sizePtr, p-buf);
    write(_waylandFD, buf, p-buf);

}
static void XDGSurfaceDestroy(uint32_t xdgSurface)
{
    unsigned char buf[1024];
    unsigned char *p = buf;

    write_uint32(p, xdgSurface);
    p += 4;
    write_uint16(p, 0); // destroy opcode
    p += 2;
    unsigned char *sizePtr = p;
    p += 2;

    write_uint16(sizePtr, p-buf);
    write(_waylandFD, buf, p-buf);

}
static void XDGPopupDestroy()
{
    unsigned char buf[1024];
    unsigned char *p = buf;

    write_uint32(p, _xdgPopup);
    p += 4;
    write_uint16(p, 0); // destroy opcode
    p += 2;
    unsigned char *sizePtr = p;
    p += 2;

    write_uint16(sizePtr, p-buf);
    write(_waylandFD, buf, p-buf);

}

static void WLBufferDestroy(uint32_t wlBuffer)
{
    unsigned char buf[1024];
    unsigned char *p = buf;

    write_uint32(p, wlBuffer);
    p += 4;
    write_uint16(p, 0); // destroy opcode
    p += 2;
    unsigned char *sizePtr = p;
    p += 2;

    write_uint16(sizePtr, p-buf);
    write(_waylandFD, buf, p-buf);

}
static int WPViewporterGetViewport(int wlSurface)
{
    unsigned char buf[1024];
    unsigned char *p = buf;

    write_uint32(p, _wpViewporter);
    p += 4;
    write_uint16(p, 1); // get viewport opcode
    p += 2;
    unsigned char *sizePtr = p;
    p += 2;

    _wlCurrentID++;
    write_uint32(p, _wlCurrentID);
    p += 4;

    write_uint32(p, wlSurface);
    p += 4;

    write_uint16(sizePtr, p-buf);
    write(_waylandFD, buf, p-buf);

    return _wlCurrentID;
}
static void WPViewportSetSource(int fd, int x, int y, int w, int h)
{
    unsigned char buf[1024];
    unsigned char *p = buf;

    write_uint32(p, _wpViewport);
    p += 4;
    write_uint16(p, 1); // set source opcode
    p += 2;
    unsigned char *sizePtr = p;
    p += 2;

    write_int32(p, int_to_wl_fixed(x));
    p += 4;

    write_int32(p, int_to_wl_fixed(y));
    p += 4;

    write_int32(p, int_to_wl_fixed(w));
    p += 4;

    write_int32(p, int_to_wl_fixed(h));
    p += 4;

    write_uint16(sizePtr, p-buf);
    write(fd, buf, p-buf);
    
}
static void WPViewportSetDestination(int fd, int w, int h)
{
    unsigned char buf[1024];
    unsigned char *p = buf;

    write_uint32(p, _wpViewport);
    p += 4;
    write_uint16(p, 2); // set destination opcode
    p += 2;
    unsigned char *sizePtr = p;
    p += 2;

    write_uint32(p, w);
    p += 4;

    write_uint32(p, h);
    p += 4;

    write_uint16(sizePtr, p-buf);
    write(fd, buf, p-buf);
    
}

static void handleWLRegistryGlobalEvent(unsigned char *buf, int size)
{
    unsigned char *p = buf;

    uint32_t numericName = parse_uint32(p+8);
    if (size < 16) {
        return;
    }
    uint32_t len = parse_uint32(p+12);
    uint32_t paddedLen = padded_len(len);
    if (size < 20+paddedLen) {
        return;
    }
    unsigned char *str = p+16;
    uint32_t version = parse_uint32(p+16+paddedLen);
NSLog(@"handleWLRegistryGlobalEvent numericName %d string '%s' len %d paddedLen %d version %d", numericName, str, len, paddedLen, version);

    if (!strncmp(str, "wl_shm", 7)) {
        _wlSHM = WLRegistryBind(numericName, str, version);
    } else if (!strncmp(str, "xdg_wm_base", 12)) {
        _xdgWMBase = WLRegistryBind(numericName, str, version);
    } else if (!strncmp(str, "wl_compositor", 14)) {
        _wlCompositor = WLRegistryBind(numericName, str, version);
    } else if (!strncmp(str, "wp_viewporter", 14)) {
        _wpViewporter = WLRegistryBind(numericName, str, version);
    } else if (!strncmp(str, "wl_seat", 8)) {
        _wlSeat = WLRegistryBind(numericName, str, version);
NSLog(@"_wlSeat %d", _wlSeat);
        _wlPointer = WLSeatGetPointer();
NSLog(@"_wlPointer %d", _wlPointer);
        _wlKeyboard = WLSeatGetKeyboard();
NSLog(@"_wlKeyboard %d", _wlKeyboard);
    }
}
static void handleXDGSurfaceConfigureEvent(unsigned char *buf, int size)
{
NSLog(@"handleXDGSurfaceConfigureEvent");
     unsigned char *p = buf;

    if (size < 12) {
        return;
    }
    uint32_t xdgSurface = parse_uint32(p);
    uint32_t serial = parse_uint32(p+8);

    XDGSurfaceAckConfigure(xdgSurface, serial);

    int index = -1;
    if (xdgSurface == _xdgSurface[0]) {
        index = 0;
    } else if (xdgSurface == _xdgSurface[1]) {
        index = 1;
    }

    if (index < 0) {
        return;
    }

    if (!_wlSHMPool[index]) {
        _wlSHMPool[index] = WLSHMCreatePool(_shmFD[index], _shmPoolSize[index]);
NSLog(@"_wlSHMPool[%d] %d", index, _wlSHMPool[index]);
    }
    if (!_wlBuffer[index]) {
        _wlBuffer[index] = WLSHMPoolCreateBuffer(_wlSHMPool[index], index);
NSLog(@"_wlBuffer[%d] %d", index, _wlBuffer[index]);
    }
    if (_wlSHMPool[index] && _wlBuffer[index]) {
NSLog(@"WLSurfaceAttach");
        WLSurfaceAttach(_wlSurface[index], _wlBuffer[index]);
NSLog(@"WLSurfaceCommit");
        WLSurfaceCommit(_wlSurface[index]);
NSLog(@"check");
    }

}
static void handleWLSHMFormatEvent(unsigned char *buf, int size)
{
    unsigned char *p = buf;

    if (size < 12) {
        return;
    }
    uint32_t format = parse_uint32(p+8);
NSLog(@"handleWLSHMFormatEvent format %x", format);
}
static void handleWLSurfacePreferredBufferScaleEvent(unsigned char *buf, int size)
{
    unsigned char *p = buf;

    if (size < 12) {
        return;
    }

    uint32_t factor = parse_uint32(p+8);
NSLog(@"handleWLSurfacePreferredBufferScaleEvent factor %d", factor);
}
static void handleWLSurfacePreferredBufferTransformEvent(unsigned char *buf, int size)
{
    unsigned char *p = buf;

    if (size < 12) {
        return;
    }

    uint32_t transform = parse_uint32(p+8);
NSLog(@"handleWLSurfacePreferredBufferTransformEvent transform %d", transform);
}
static void handleXDGToplevelConfigureEvent(unsigned char *buf, int size)
{
    unsigned char *p = buf;

    if (size < 16) {
        return;
    }

    uint32_t width = parse_uint32(p+8);
    uint32_t height = parse_uint32(p+12);
    uint32_t arraySize = parse_uint32(p+16);
    uint32_t paddedArraySize = padded_len(arraySize);
    if (size < 20+paddedArraySize) {
        return;
    }
        if (_wlBuffer[0]) {
NSLog(@"reallocating _wlBuffer[0] %d", _wlBuffer[0]);
            _xdgToplevelWidth = width;
            _xdgToplevelHeight = height;
            WLBufferDestroy(_wlBuffer[0]);
NSLog(@"WLBufferDestroy[0]");
            _wlBufferOld[0] = _wlBuffer[0];
            _wlBuffer[0] = 0;
            _wlBuffer[0] = WLSHMPoolCreateBuffer(_wlSHMPool[0], 0);
NSLog(@"WLSHMPoolCreateBuffer[0]");
        }





NSLog(@"handleXDGToplevelConfigureEvent width %d height %d arraySize %d", width, height, arraySize);
for (int i=0; i<arraySize; i++) {
NSLog(@"  i %d %.2x", i, p[20+i]);
}
}

static void handleXDGToplevelWMCapabilitiesEvent(unsigned char *buf, int size)
{
    unsigned char *p = buf;

    if (size < 12) {
        return;
    }

    uint32_t arraySize = parse_uint32(p+8);
    uint32_t paddedArraySize = padded_len(arraySize);
    if (size < 12+paddedArraySize) {
        return;
    }
NSLog(@"handleXDGToplevelWMCapabilitiesEvent arraySize %d", arraySize);
for (int i=0; i<arraySize; i++) {
NSLog(@"  i %d %.2x", i, p[20+i]);
}
}
static void handleXDGPopupConfigureEvent(unsigned char *buf, int size)
{
    unsigned char *p = buf;

    if (size < 24) {
        return;
    }

    uint32_t x = parse_uint32(p+8);
    uint32_t y = parse_uint32(p+12);
    uint32_t width = parse_uint32(p+16);
    uint32_t height = parse_uint32(p+20);

        if (_wlBuffer[1]) {
NSLog(@"reallocating _wlBuffer[1] %d", _wlBuffer[1]);
            _xdgPopupWidth = width;
            _xdgPopupHeight = height;
            WLBufferDestroy(_wlBuffer[1]);
NSLog(@"WLBufferDestroy[1]");
            _wlBufferOld[1] = _wlBuffer[1];
            _wlBuffer[1] = 0;
            _wlBuffer[1] = WLSHMPoolCreateBuffer(_wlSHMPool[1], 1);
NSLog(@"WLSHMPoolCreateBuffer[1]");
        }

}
static void handleWLBufferReleaseEvent(unsigned char *buf, int size)
{
    unsigned char *p = buf;

    if (size < 8) {
        return;
    }

    uint32_t objectID = parse_uint32(p);

    if (objectID == _wlBuffer[0]) {
NSLog(@"handleWLBufferReleaseEvent[0]");
        _wlBufferReleased[0] = 1;
    } else if (objectID == _wlBuffer[1]) {
NSLog(@"handleWLBufferReleaseEvent[1]");
        _wlBufferReleased[1] = 1;
    }
}
static void handleWLPointerMotionEvent(unsigned char *buf, int size)
{
    unsigned char *p = buf;

    if (size < 20) {
        return;
    }
    uint32_t time = parse_uint32(p+8);
    double x = parse_wl_fixed(p+12);
    double y = parse_wl_fixed(p+16);
    _mouseX = (int)x;
    _mouseY = (int)y;
NSLog(@"handleWLPointerMotionEvent time %lu x %f y %f", time, x, y);
    id event = nsfmt(@"mouseX:%d mouseY:%d", _mouseX, _mouseY);
    id context = nsfmt(@"w:%d h:%d", _xdgToplevelWidth, _xdgToplevelHeight);
    if ([_object respondsToSelector:@selector(handleMouseMoved:context:)]) {
        [_object handleMouseMoved:event context:context];
    }

    updateBitmap();
}
static void showPopupMenu();
static void handleWLPointerButtonEvent(unsigned char *buf, int size)
{
    unsigned char *p = buf;

    if (size < 24) {
        return;
    }
    uint32_t serial = parse_uint32(p+8);
    uint32_t time = parse_uint32(p+12);
    uint32_t button = parse_uint32(p+16);
    uint32_t state = parse_uint32(p+20);
NSLog(@"handleWLPointerButtonEvent serial %lu time %lu button %lu state %lu", serial, time, button, state);
    id event = nsfmt(@"mouseX:%d mouseY:%d", _mouseX, _mouseY);
    id context = nsfmt(@"w:%d h:%d", _xdgToplevelWidth, _xdgToplevelHeight);
    if (button == BTN_LEFT) {
        if (state) {
            if ([_object respondsToSelector:@selector(handleMouseDown:context:)]) {
                [_object handleMouseDown:event context:context];
            } else if ([_object respondsToSelector:@selector(handleMouseDown:)]) {
                [_object handleMouseDown:event];
            }
        } else {
            if ([_object respondsToSelector:@selector(handleMouseUp:context:)]) {
                [_object handleMouseUp:event context:context];
            } else if ([_object respondsToSelector:@selector(handleMouseUp:)]) {
                [_object handleMouseUp:event];
            }
        }
    } else if (button == BTN_RIGHT) {
        if (state) {
showPopupMenu();
return;
            if ([_object respondsToSelector:@selector(handleRightMouseDown:context:)]) {
                [_object handleRightMouseDown:event context:context];
            } else if ([_object respondsToSelector:@selector(handleRightMouseDown:)]) {
                [_object handleRightMouseDown:event];
            }
        } else {
XDGPopupDestroy();
_xdgPopupOld = _xdgPopup;
_xdgPopup = 0;
XDGSurfaceDestroy(_xdgSurface[1]);
_xdgSurfaceOld[1] = _xdgSurface[1];
_xdgSurface[1] = 0;
WLSurfaceDestroy(_wlSurface[1]);
_wlSurfaceOld[1] = _wlSurface[1];
_wlSurface[1] = 0;
return;
            if ([_object respondsToSelector:@selector(handleRightMouseUp:context:)]) {
                [_object handleRightMouseUp:event context:context];
            } else if ([_object respondsToSelector:@selector(handleRightMouseUp:)]) {
                [_object handleRightMouseUp:event];
            }
        }
    }

    updateBitmap();
}
static void handleWLPointerAxisEvent(unsigned char *buf, int size)
{
    unsigned char *p = buf;

    if (size < 20) {
        return;
    }
    uint32_t time = parse_uint32(p+8);
    uint32_t axis = parse_uint32(p+12);
    double value = parse_wl_fixed(p+16);
NSLog(@"handleWLPointerAxisEvent time %lu axis %lu value %f", time, axis, value);
    if (axis == 0) {
        id event = nsfmt(@"mouseX:%d mouseY:%d deltaY:%d", _mouseX, _mouseY, (int)-value);
        id context = nsfmt(@"w:%d h:%d", _xdgToplevelWidth, _xdgToplevelHeight);
NSLog(@"event %@ context %@", event, context);
        if ([_object respondsToSelector:@selector(handleScrollWheel:context:)]) {
            [_object handleScrollWheel:event context:context];
        } else if ([_object respondsToSelector:@selector(handleScrollWheel:)]) {
            [_object handleScrollWheel:event];
        }

        updateBitmap();
    }
}


static void handleWLDisplayError(unsigned char *buf, int size)
{
    unsigned char *p = buf;

    if (size < 20) {
        return;
    }
    uint32_t objectID = parse_uint32(p+8);
    uint32_t code = parse_uint32(p+12);
    uint32_t len = parse_uint32(p+16);
    if (size < 20+len) {
        return;
    }

    NSLog(@"handleWLDisplayError objectID %lu code %lu text '%.*s'", objectID, code, len, p+20);
}


static int handleMessage(unsigned char *buf, int buflen)
{
    if (buflen < 4) {
        return 0;
    }
    unsigned char *p = buf;
    uint32_t objectID = parse_uint32(p);
    uint16_t opcode = parse_uint16(p+4);
    uint16_t size = parse_uint16(p+6);
    if (buflen < size) {
        return 0;
    }

    if (objectID == _wlRegistry) {
        if (opcode == 0) {
            handleWLRegistryGlobalEvent(buf, size);
        } else {
NSLog(@"handleMessage wlRegistry %lu opcode %u size %u", objectID, opcode, size);
        }
    } else if (objectID == _xdgSurface[0]) {
        if (opcode == 0) {
            handleXDGSurfaceConfigureEvent(buf, size);
        } else {
NSLog(@"handleMessage xdgSurface[0] %lu opcode %u size %u", objectID, opcode, size);
        }
    } else if (objectID == _xdgSurface[1]) {
        if (opcode == 0) {
            handleXDGSurfaceConfigureEvent(buf, size);
        } else {
NSLog(@"handleMessage xdgSurface[1] %lu opcode %u size %u", objectID, opcode, size);
        }
    } else if (objectID == _wlSHM) {
        if (opcode == 0) {
            handleWLSHMFormatEvent(buf, size);
        } else {
NSLog(@"handleMessage wlSHM %lu opcode %u size %u", objectID, opcode, size);
        }
    } else if (objectID == _wlSurface[0]) {
        if (opcode == 2) {
            handleWLSurfacePreferredBufferScaleEvent(buf, size);
        } else if (opcode == 3) {
            handleWLSurfacePreferredBufferTransformEvent(buf, size);
        } else {
NSLog(@"handleMessage wlSurface[0] %lu opcode %u size %u", objectID, opcode, size);
        }
    } else if (objectID == _xdgToplevel) {
        if (opcode == 0) {
            handleXDGToplevelConfigureEvent(buf, size);
        } else if (opcode == 3) {
            handleXDGToplevelWMCapabilitiesEvent(buf, size);
        } else {
NSLog(@"handleMessage xdgToplevel %lu opcode %u size %u", objectID, opcode, size);
        }
    } else if (objectID == _xdgPopup) {
        if (opcode == 0) {
            handleXDGPopupConfigureEvent(buf, size);
        } else {
NSLog(@"handleMessage xdgPopup %lu opcode %u size %u", objectID, opcode, size);
        }
    } else if (objectID == _wlBuffer[0]) {
        if (opcode == 0) {
            handleWLBufferReleaseEvent(buf, size);
        } else {
NSLog(@"handleMessage wlBuffer[0] %lu opcode %u size %u", objectID, opcode, size);
        }
    } else if (objectID == _wlBuffer[1]) {
        if (opcode == 0) {
            handleWLBufferReleaseEvent(buf, size);
        } else {
NSLog(@"handleMessage wlBuffer[1] %lu opcode %u size %u", objectID, opcode, size);
        }
    } else if (objectID == _wlPointer) {
        if (opcode == 2) {
            handleWLPointerMotionEvent(buf, size);
        } else if (opcode == 3) {
            handleWLPointerButtonEvent(buf, size);
        } else if (opcode == 4) {
            handleWLPointerAxisEvent(buf, size);
        } else {
NSLog(@"handleMessage wlPointer %lu opcode %u size %u", objectID, opcode, size);
        }
    } else if (objectID == 1) {
        if (opcode == 0) {
            handleWLDisplayError(buf, size);
        } else {
NSLog(@"handleMessage wlDisplay %lu opcode %u size %u", objectID, opcode, size);
        }
    } else {
NSLog(@"handleMessage objectID %lu opcode %u size %u", objectID, opcode, size);
    }

    return size;
}

static void updatePopupBitmap();
static void updateBitmap()
{
    if (!_xdgToplevelWidth || !_xdgToplevelHeight) {
        return;
    }
    if (_bitmap) {
        int bitmapWidth = [_bitmap bitmapWidth];
        int bitmapHeight = [_bitmap bitmapHeight];
        if ((bitmapWidth == _xdgToplevelWidth) && (bitmapHeight == _xdgToplevelHeight)) {
        } else {
            [_bitmap autorelease];
            _bitmap = nil;
        }
    }
    if (!_bitmap) {
        _bitmap = [[Definitions bitmapWithWidth:_xdgToplevelWidth height:_xdgToplevelHeight] retain];
    }

    Int4 r;
    r.x = 0;
    r.y = 0;
    r.w = _xdgToplevelWidth;
    r.h = _xdgToplevelHeight;
    if ([_object respondsToSelector:@selector(beginIteration:rect:)]) {
        [_object beginIteration:nil rect:r];
    }
    if ([_object respondsToSelector:@selector(drawInBitmap:rect:)]) {
        [_object drawInBitmap:_bitmap rect:r];
    }
    if ([_object respondsToSelector:@selector(endIteration:rect:)]) {
        [_object endIteration:nil];
    }
    memcpy(_shmData[0], [_bitmap pixelBytes], _xdgToplevelWidth*_xdgToplevelHeight*4);
    WLSurfaceDamage(_wlSurface[0], 0, 0, _xdgToplevelWidth, _xdgToplevelHeight);
    WLSurfaceAttach(_wlSurface[0], _wlBuffer[0]);
    WLSurfaceCommit(_wlSurface[0]);
updatePopupBitmap();
}
static void updatePopupBitmap()
{
NSLog(@"updatePopupBitmap objectID %d w %d h %d", _xdgPopup, _xdgPopupWidth, _xdgPopupHeight);
    if (!_xdgPopup) {
        return;
    }
    if (!_xdgPopupWidth || !_xdgPopupHeight) {
        return;
    }
NSLog(@"updatePopupBitmap check1");
    if (_popupBitmap) {
        int bitmapWidth = [_popupBitmap bitmapWidth];
        int bitmapHeight = [_popupBitmap bitmapHeight];
        if ((bitmapWidth == _xdgPopupWidth) && (bitmapHeight == _xdgPopupHeight)) {
        } else {
            [_popupBitmap autorelease];
            _popupBitmap = nil;
        }
    }
NSLog(@"updatePopupBitmap check2");
    if (!_popupBitmap) {
        _popupBitmap = [[Definitions bitmapWithWidth:_xdgPopupWidth height:_xdgPopupHeight] retain];
    }
NSLog(@"updatePopupBitmap check3");

    Int4 r;
    r.x = 0;
    r.y = 0;
    r.w = [_popupBitmap bitmapWidth];
    r.h = [_popupBitmap bitmapHeight];
    if ([_popupObject respondsToSelector:@selector(beginIteration:rect:)]) {
        [_popupObject beginIteration:nil rect:r];
    }
    if ([_popupObject respondsToSelector:@selector(drawInBitmap:rect:context:)]) {
        [_popupObject drawInBitmap:_popupBitmap rect:r context:nil];
    }
    if ([_popupObject respondsToSelector:@selector(endIteration:rect:)]) {
        [_popupObject endIteration:nil];
    }
    memcpy(_shmData[1], [_popupBitmap pixelBytes], _xdgPopupWidth*_xdgPopupHeight*4);
    WLSurfaceDamage(_wlSurface[1], 0, 0, _xdgPopupWidth, _xdgPopupHeight);
    WLSurfaceAttach(_wlSurface[1], _wlBuffer[1]);
    WLSurfaceCommit(_wlSurface[1]);
NSLog(@"updatePopupBitmap check4");
}


static void showPopupMenu()
{
if (!_popupObject) {
    id path = [Definitions frogDir:@"Config/waylandRootWindowMenu.csv"];
    id obj = [[path parseCSVFile] asWaylandMenu];
    [obj retain];
    _popupObject = obj;
}

    if (!_wlSurface[1]) {
        _wlSurface[1] = WLCompositorCreateSurface();
        NSLog(@"_wlSurface[1] %d", _wlSurface[1]);
    }
    if (!_xdgSurface[1]) {
        _xdgSurface[1] = XDGWMBaseGetXDGSurface(1);
        NSLog(@"_xdgSurface[1] %d", _xdgSurface[1]);
    }
    if (!_xdgPositioner) {
        _xdgPositioner = XDGWMBaseCreatePositioner();
        NSLog(@"_xdgPositioner %d", _xdgPositioner);
    }

    int w = [_popupObject preferredWidth];
    int h = [_popupObject preferredHeight];
_xdgPopupWidth = w;
_xdgPopupHeight = h;
NSLog(@"preferred w %d h %d", w, h);
    XDGPositionerSetSize(w, h);
    XDGPositionerSetAnchorRect(0, 0, w, h);
    _xdgPopup = XDGSurfaceGetPopup(_xdgSurface[1], _xdgSurface[0], _xdgPositioner);
    NSLog(@"_xdgPopup %d", _xdgPopup);
    WLSurfaceCommit(_wlSurface[1]);
}

@implementation Definitions(fmekwlfmklsdmfksdmklf)
+ (id)Wayland
{
    id pool = [[NSAutoreleasePool alloc] init];

    id path = @"wayland-0";

    struct sockaddr_un addr;

    _waylandFD = socket(AF_UNIX, SOCK_STREAM, 0);
    if (_waylandFD < 0) {
NSLog(@"unable to open socket");
exit(1);
    }

    memset(&addr, 0, sizeof(struct sockaddr_un));
    addr.sun_family = AF_UNIX;
    strcpy(addr.sun_path, "wayland-0");

    if (connect(_waylandFD, &addr, sizeof(addr)) < 0) {
NSLog(@"unable to connect");
exit(1);
    }
    
    _wlRegistry = WLDisplayGetRegistry();

    for(;;) {
        unsigned char buf[4096];
        int buflen = 0;

        int bytesread = read(_waylandFD, buf, 4096-buflen);
NSLog(@"bytesread %d", bytesread);
        if (bytesread <= 0) {
            break;
        }
write(1, buf, bytesread);
        buflen = bytesread;

        for(;;) {
NSLog(@"buflen %d", buflen);
            int n = handleMessage(buf, buflen);
        NSLog(@"_wlSHM %d _xdgWMBase %d _wlCompositor %d", _wlSHM, _xdgWMBase, _wlCompositor);
            if (!n) {
                break;
            }
            for (int i=n; i<buflen; i++) {
                buf[i-n] = buf[i];
            }
            buflen -= n;
        }
        if (_wlSHM && _xdgWMBase && _wlCompositor) {
            break;
        }
    }
    
NSLog(@"creating shm");
    create_shm(0, "/temp0.shm", 4096*4096*4);
    create_shm(1, "/temp1.shm", 4096*4096*4);
_object = [[Definitions Dir] retain];
//updateBitmap();
    
    _wlSurface[0] = WLCompositorCreateSurface();
NSLog(@"_wlSurface[0] %d", _wlSurface[0]);
//    _wpViewport = WPViewporterGetViewport(_wlSurface[i]);
//NSLog(@"_wpViewport[0] %d", _wpViewport[i]);
    _xdgSurface[0] = XDGWMBaseGetXDGSurface(0);
NSLog(@"_xdgSurface[0] %d", _xdgSurface[0]);
    _xdgToplevel = XDGSurfaceGetToplevel(_xdgSurface[0]);
NSLog(@"_xdgToplevel %d", _xdgToplevel);
    WLSurfaceCommit(_wlSurface[0]);


    for(;;) {
        unsigned char buf[4096];
        int buflen = 0;

        int bytesread = read(_waylandFD, buf, 4096-buflen);
NSLog(@"bytesread %d", bytesread);
        if (bytesread <= 0) {
            break;
        }
        buflen = bytesread;

        for(;;) {
NSLog(@"buflen %d", buflen);
            int n = handleMessage(buf, buflen);
            if (!n) {
                break;
            }
            for (int i=n; i<buflen; i++) {
                buf[i-n] = buf[i];
            }
            buflen -= n;
        }
        [pool drain];
        pool = [[NSAutoreleasePool alloc] init];
    }


    return nil;
}
@end


