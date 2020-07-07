# Mingw packahe config

export PATH=/build/bin_special/:$PATH

pkg-config --dump-personality
Triplet: x86_64-w64-mingw32
SysrootDir: /usr/x86_64-w64-mingw32/sys-root
DefaultSearchPaths: /usr/x86_64-w64-mingw32/sys-root/mingw/lib/pkgconfig /usr/x86_64-w64-mingw32/sys-root/mingw/share/pkgconfig /usr/share/pkgconfig
SystemIncludePaths: /usr/x86_64-w64-mingw32/sys-root/mingw/include
SystemLibraryPaths: /usr/x86_64-w64-mingw32/sys-root/mingw/lib

$ pkg-config --list-all
atk                            Atk - Accessibility Toolkit
cairo-fc                       cairo-fc - Fontconfig font backend for cairo graphics library
cairo-ft                       cairo-ft - FreeType font backend for cairo graphics library
cairo-gobject                  cairo-gobject - gobject functions for cairo graphics library
cairo-pdf                      cairo-pdf - PDF surface backend for cairo graphics library
cairo-png                      cairo-png - PNG functions for cairo graphics library
cairo-ps                       cairo-ps - PostScript surface backend for cairo graphics library
cairo-script                   cairo-script - script surface backend for cairo graphics library
cairo-svg                      cairo-svg - SVG surface backend for cairo graphics library
cairo-win32-font               cairo-win32-font - Microsoft Windows font backend for cairo graphics library
cairo-win32                    cairo-win32 - Microsoft Windows surface backend for cairo graphics library
cairo                          cairo - Multi-platform 2D graphics library
epoxy                          epoxy - epoxy GL dispatch Library
expat                          expat - expat XML parser
fontconfig                     Fontconfig - Font configuration and customization library
freetype2                      FreeType 2 - A free, high-quality, and portable font engine.
gail-3.0                       Gail - GNOME Accessibility Implementation Library
gdk-3.0                        GDK - GTK+ Drawing Kit
gdk-broadway-3.0               GDK - GTK+ Drawing Kit
gdk-pixbuf-2.0                 GdkPixbuf - Image loading and scaling
gdk-win32-3.0                  GDK - GTK+ Drawing Kit
gio-2.0                        GIO - glib I/O library
gio-windows-2.0                GIO Windows specific APIs - Windows specific headers for glib I/O library
glib-2.0                       GLib - C Utility Library
gmodule-2.0                    GModule - Dynamic module loader for GLib
gmodule-export-2.0             GModule - Dynamic module loader for GLib
gmodule-no-export-2.0          GModule - Dynamic module loader for GLib
gobject-2.0                    GObject - GLib Type, Object, Parameter and Signal Library
gthread-2.0                    GThread - Thread support for GLib
gtk+-3.0                       GTK+ - GTK+ Graphical UI Library
gtk+-broadway-3.0              GTK+ - GTK+ Graphical UI Library
gtk+-win32-3.0                 GTK+ - GTK+ Graphical UI Library
gtksourceview-3.0              gtksourceview - Source code editing widget
harfbuzz                       harfbuzz - HarfBuzz text shaping library
jasper                         JasPer - Image Processing/Coding Tool Kit with JPEG-2000 Support
libffi                         libffi - Library supporting Foreign Function Interfaces
libjpeg                        libjpeg - A SIMD-accelerated JPEG codec that provides the libjpeg API
liblzma                        liblzma - General purpose data compression library
libpcre                        libpcre - PCRE - Perl compatible regular expressions C library with 8 bit character support
libpcre16                      libpcre16 - PCRE - Perl compatible regular expressions C library with 16 bit character support
libpcre32                      libpcre32 - PCRE - Perl compatible regular expressions C library with 32 bit character support
libpcrecpp                     libpcrecpp - PCRECPP - C++ wrapper for PCRE
libpcreposix                   libpcreposix - PCREPosix - Posix compatible interface to libpcre
libpng                         libpng - Loads and saves PNG files
libpng16                       libpng - Loads and saves PNG files
libtiff-4                      libtiff - Tag Image File Format (TIFF) library.
libturbojpeg                   libturbojpeg - A SIMD-accelerated JPEG codec that provides the TurboJPEG API
libxml-2.0                     libXML - libXML library version2.
mpfr                           mpfr - C library for multiple-precision floating-point computations
pango                          Pango - Internationalized text handling
pangocairo                     Pango Cairo - Cairo rendering support for Pango
pangoft2                       Pango FT2 and Pango Fc - Freetype 2.0 and fontconfig font support for Pango
pangowin32                     Pango Win32 - Win32 GDI font support for Pango
pixman-1                       Pixman - The pixman library (version 1)
zlib                           zlib - zlib compression library

# Cygwin package config

Triplet: default
DefaultSearchPaths: /usr/lib/pkgconfig /usr/share/pkgconfig
SystemIncludePaths: /usr/include
SystemLibraryPaths: /usr/lib

$ pkg-config --list-all
applewmproto                   applewmproto - applewmproto headers
bigreqsproto                   bigreqsproto - bigreqsproto headers
compositeproto                 compositeproto - compositeproto headers
damageproto                    damageproto - damageproto headers
dmxproto                       dmxproto - dmxproto headers
dpmsproto                      dpmsproto - dpmsproto headers
dri2proto                      dri2proto - dri2proto headers
dri3proto                      dri3proto - dri3proto headers
fixesproto                     fixesproto - fixesproto headers
fontsproto                     fontsproto - fontsproto headers
form                           formw - ncurses 6.1 add-on library
formw                          formw - ncurses 6.1 add-on library
gdk-pixbuf-2.0                 GdkPixbuf - Image loading and scaling
gio-2.0                        GIO - glib I/O library
gio-unix-2.0                   GIO unix specific APIs - unix specific headers for glib I/O library
glib-2.0                       GLib - C Utility Library
glproto                        glproto - glproto headers
gmodule-2.0                    GModule - Dynamic module loader for GLib
gmodule-export-2.0             GModule - Dynamic module loader for GLib
gmodule-no-export-2.0          GModule - Dynamic module loader for GLib
gobject-2.0                    GObject - GLib Type, Object, Parameter and Signal Library
gthread-2.0                    GThread - Thread support for GLib
inputproto                     inputproto - inputproto headers
kbproto                        kbproto - kbproto headers
libpcre                        libpcre - PCRE - Perl compatible regular expressions C library with 8 bit character support
libpcre16                      libpcre16 - PCRE - Perl compatible regular expressions C library with 16 bit character support
libpcre32                      libpcre32 - PCRE - Perl compatible regular expressions C library with 32 bit character support
libpcrecpp                     libpcrecpp - PCRECPP - C++ wrapper for PCRE
libpcreposix                   libpcreposix - PCREPosix - Posix compatible interface to libpcre
libpng16                       libpng - Loads and saves PNG files
menu                           menuw - ncurses 6.1 add-on library
menuw                          menuw - ncurses 6.1 add-on library
ncurses++                      ncurses++w - ncurses 6.1 add-on library
ncurses++w                     ncurses++w - ncurses 6.1 add-on library
ncurses                        ncursesw - ncurses 6.1 library
ncursesw                       ncursesw - ncurses 6.1 library
panel                          panelw - ncurses 6.1 add-on library
panelw                         panelw - ncurses 6.1 add-on library
presentproto                   presentproto - presentproto headers
randrproto                     randrproto - randrproto headers
recordproto                    recordproto - recordproto headers
renderproto                    renderproto - renderproto headers
resourceproto                  resourceproto - resourceproto headers
scrnsaverproto                 scrnsaverproto - scrnsaverproto headers
tic                            ticw - ncurses 6.1 add-on library
ticw                           ticw - ncurses 6.1 add-on library
uuid                           uuid - Universally unique id library
videoproto                     videoproto - videoproto headers
x11                            X11 - X Library
xau                            Xau - X authorization file management libary
xcb                            XCB - X-protocol C Binding
xcmiscproto                    xcmiscproto - xcmiscproto headers
xdmcp                          Xdmcp - X Display Manager Control Protocol library
xextproto                      xextproto - xextproto headers
xf86bigfontproto               xf86bigfontproto - xf86bigfontproto headers
xf86dgaproto                   xf86dgaproto - xf86dgaproto headers
xf86driproto                   xf86driproto - xf86driproto headers
xf86vidmodeproto               xf86vidmodeproto - xf86vidmodeproto headers
xineramaproto                  xineramaproto - xineramaproto headers
xproto                         xproto - xproto headers
zlib                           zlib - zlib compression library
