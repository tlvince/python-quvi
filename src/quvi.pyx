"""Quvi is a media url parser supporting several hosts (youtube, dailymotion,
vimeo...)
See http://quvi.sourceforge.net/

You can use this module to parse an url from youtube, dailymotion... like this:
>> import quvi as q
>> q.parse("http://....")
>> print q.getproperties()

"""
__author__="Patrice FERLET <metal3d@gmail.com>"
__license__="LGPLv2.1+."

cimport cquvi

#those handles ctypes from quvi.h
cdef cquvi.quvi_t _c_quvi
cdef cquvi.quvi_media_t _c_m

def __cinit__ ():
    """Initialize quvi handle"""
    cquvi.quvi_init(&_c_quvi)

def parse(url):
    """Parse given url parameters"""
    cdef char* _url = url
    rc = cquvi.quvi_parse(_c_quvi, _url, &_c_m);
    if rc != cquvi.QUVI_OK:
        raise "Exception occured, next media error"

def getproperties():
    """Return a dict with media properties"""
    res = {}
    cdef char* resc
    cdef int   resi
    cdef long resl
    cdef double resd


    cquvi.quvi_getprop(_c_m, cquvi.QUVIPROP_HOSTID, &resc)
    res['hostid'] = resc

    cquvi.quvi_getprop(_c_m, cquvi.QUVIPROP_PAGEURL, &resc)
    res['pageurl'] = resc

    cquvi.quvi_getprop(_c_m, cquvi.QUVIPROP_PAGETITLE, &resc)
    res['pagetitle'] = resc
    
    cquvi.quvi_getprop(_c_m, cquvi.QUVIPROP_MEDIAID, &resc)
    res['mediaid'] = resc

    cquvi.quvi_getprop(_c_m, cquvi.QUVIPROP_MEDIAURL, &resc)
    res['mediaurl'] = resc
    
    cquvi.quvi_getprop(_c_m, cquvi.QUVIPROP_MEDIACONTENTLENGTH, &resl)
    res['mediacontentlength'] = resl;

    cquvi.quvi_getprop(_c_m, cquvi.QUVIPROP_MEDIACONTENTTYPE, &resc) 
    res['mediacontenttype'] = resc;

    cquvi.quvi_getprop(_c_m, cquvi.QUVIPROP_FILESUFFIX, &resc) 
    res['filesuffix'] = resc;

    cquvi.quvi_getprop(_c_m, cquvi.QUVIPROP_RESPONSECODE, &resl) 
    res['responsecode'] = resl

    cquvi.quvi_getprop(_c_m, cquvi.QUVIPROP_FORMAT, &resc) 
    res['format'] = resc

    cquvi.quvi_getprop(_c_m, cquvi.QUVIPROP_STARTTIME, &resc) 
    res['starttime'] = resc

    cquvi.quvi_getprop(_c_m, cquvi.QUVIPROP_MEDIATHUMBNAILURL, &resc) 
    res['mediathumbnail'] = resc

    cquvi.quvi_getprop(_c_m, cquvi.QUVIPROP_MEDIADURATION, &resd) 
    res['mediaduration'] = resd

    cquvi.quvi_getprop(_c_m, cquvi.QUVIPROP_VIDEOID, &resc) 
    res['videoid'] = resc

    cquvi.quvi_getprop(_c_m, cquvi.QUVIPROP_VIDEOURL, &resc) 
    res['videurl'] = resc

    cquvi.quvi_getprop(_c_m, cquvi.QUVIPROP_VIDEOFILELENGTH, &resd) 
    res['videofilelength'] = resd

    cquvi.quvi_getprop(_c_m, cquvi.QUVIPROP_VIDEOFILECONTENTTYPE, &resc) 
    res['videfilecontenttype'] = resc

    cquvi.quvi_getprop(_c_m, cquvi.QUVIPROP_VIDEOFILESUFFIX, &resc) 
    res['videofilesuffix'] = resc

    cquvi.quvi_getprop(_c_m, cquvi.QUVIPROP_HTTPCODE, &resl) 
    res['httpcode'] = resl

    cquvi.quvi_getprop(_c_m, cquvi.QUVIPROP_VIDEOFORMAT, &resc) 
    res['videoformat'] = resc

    return res

def next():
    """Jumps to next media"""
    rc = cquvi.quvi_next_media_url(&_c_m)
    if rc != cquvi.QUVI_OK:
        return False

    return True
    

def __del__():
    """Cleanup media handles"""
    cquvi.quvi_parse_close(&_c_m);
    cquvi.quvi_close(&_c_quvi)
    cquvi.quvi_free(&_c_quvi)

#call initialisation
__cinit__()
