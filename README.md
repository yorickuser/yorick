##################
-------

Modification in this fork
-------

* Directory "myYorick" have been added. "myYorick" contains some additional functions for 2D- and 3D-plot and for event-driven control by mouse (function "idl").
* Currently, documents for "help, function_name" may be incomplete and source codes are not tidy, but all functions listed below have examples, shown by "help, function_name" at yorick prompt.
* Functions for 3D-cones and for smooth shading will be added (not yet).

Usage
-------

* If "Yorick" directory does not exist under your home directory, just put "myYorick" at your home directory and rename it to "Yorick". If exist, merge the two "custom.i" files in "myYorick" and in "Yorick", and then put all other files and directories in "myYorick" into "Yorick".
* Type "help,function_name" at yorick prompt show its example.

Functions in idl.i
-------

* idl: idling function for event driven programing controlled by mouse click.

Functions in idl_demo0.i, idl_demo1.i, idl_demo2.i, idl_demo3.i
-------

* idl_demo0: demo for idl
* idl_demo1: demo for idl
* idl_demo2: demo for idl
* idl_demo3: demo for idl

Functions in graph2d.i
-------

* win2: changes window properties such as size, shape and ticks.

* plgl:"plg" function with graph-legends on window.
* plgf:"plg" function filling under the line with specified color.
* plh: plots histogram from frequency data (with graph-legends as line segments).
* plhf: plots histogram from frequency data (with graph-legends as filled boxes).
* pler: plots error bars.

* fp: plots line of specified function y=f(x).
* fp2: plots a surface of 2D function f(x,y) with plwf.
* fpfc: plots filled contour of 2D function z=f(x,y) with plfc.
* cbfc: plots color bar with tickes for plfc function.
* make_hist: make frequency data from raw data, and plot histogram.
* hist2d: aggregates 2D dataset.
* make_xy_plf: make x-y coordinates for plf.
* xyt: plots titles for x- and y-axes with a slightly finer adjustment than xytitles.

* pal: sets color palette.
* cb: draws a color bar to the right of the plot by "plf" function.
* fmal: resets plottings and graph-legend.
* outpng: saves plottings in png format.
* hcpng: saves plottings in png and/or eps format.

* scalexy: scales plotting in horizontal and vertical directions separately.
* scalex: scales plotting in horizontal direction.
* scaley: scales plotting in vertical direction.
* scale: scales plotting in horizontal and vertical directions by the same ratio.
* I:short expression of "include" function.


Functions in graph3d.i
-------

* ro: rotates 3D-plottings with mouse.

* win3: initializes the window to 3D-mode
* changech: changes properties of cage3.
* read_poly: reads polygon data for pl3surf and pl3tree to a text file.
* write_poly: writes polygon data for pl3surf and pl3tree to a text file.

* lim3: a short-name version of limit3.
* lim32xz: adjusts the rotation and scale of plottings so that the scales of x- and z-axes in "win2" coincide with those of x- and z-axes on the 3D-cage.
* lim32xy: adjusts the rotation and scale of plottings so that the scales of x- and y-axes in "win2" coincide with those of x- and y-axes on the 3D-cage.
* lim32yz: adjusts the rotation and scale of plottings so that the scales of y- and z-axes in "win2" coincide with those of y- and z-axes on the 3D-cage.

* spal: prepares two different palettes (mainly for pl3tree).
* make_mypal : gets palette data.
* make_xyz: transform data for plwf into data for pl3surf and pl3tree.
* get_light:calculates brightness of each polygon consisting surface in the same manner with pl3surf.


Functions in tube3.i
-------

* tube3: 3D-tube plot.

Functions in lcontour3.i
-------

* lcontour3: cuts polygon into parts between contours for values defined on the surface of the polygon.
* lcon3: emurates smooth shading.
* plfc3: plots 3D filled contours for function z=f(y,x)

##################
-------

Welcome
-------

Yorick is an interactive programming language for scientific computing
that includes scientific visualization functions, and text and binary
I/O functions geared to millions of numbers.

Yorick is open source software, under a
[BSD license](https://github.com/dhmunro/yorick/blob/master/LICENSE.md).
Yorick runs under UNIX, MacOS X (X windows), and MS Windows.  You can
find many yorick resources online:

* Home pages at [yorick.github.com][] and [yorick.sourceforge.net][],
  including the user manual and extensive documentation.
* User forums at [yorick.sourceforge.net][].
* Browse or download sourcecode at [github.com/dhmunro/yorick][].
* Read end of Quick start section below on running yorick demo programs.

[yorick.github.com]:         http://yorick.github.com
[yorick.sourceforge.net]:    http://yorick.sourceforge.net
[github.com/dhmunro/yorick]: http://github.com/dhmunro/yorick

Files in the regexp/ subdirectory are the work of Guido van Rossum and
Henry Spencer; read the files for details.  The latter is Copyright
(c) 1986 by University of Toronto.

Files in the fft directory are C translations of the Swarztrauber
fortran FFTPACK routines.  Files in the matrix directory are C
translations of the fortran LAPACK routines.  The original fortran is
available from [netlib.org](http://netlib.org/).


Quick start
-----------

On most UNIX-like systems (including Linux and MacOS X), you can build
yorick by changing to the top level directory of the source
distribution and typing:

    make install

This will create a subdirectory relocate/ in the source tree.  The
yorick executable is relocate/bin/yorick.  You can move the relocate/
directory wherever you want (the name "relocate" is unimportant), but
any changes in the relative locations of the files therein will
prevent yorick from starting correctly.  You can, of course, softlink
to the yorick executable from wherever you like, or exec yorick from a
shell script outside its relocate/ directory.  The relocate/ directory
is organized as follows:

    relocate/  files required for building compiled packages, and:
      bin/     binary executables
      lib/     binary libraries for compiled packages
      include/ header files for compiled package APIs
      i0/      interpreted code required for yorick to start
      i/       optional interpreted code libraries
      i-start/ interpreted code that autoloads at startup
      g/       graphics style files, palettes, and templates
      doc/     documentation files

To build a tarball containing a yorick executable, type instead:

    make relocatable

This creates a tarball yorick-V.N-RR.tgz containing the yorick code,
interpreted library, and documentation.  Move it to the directory
where you wish to install yorick, then unpack it with:

    gzip -dc yorick-V.N-RR.tgz | tar xvf -

The yorick executable will be yorick-V.N-RR/bin/yorick.  Read
yorick-V.N-RR/README for more information.

To build yorick on a MS Windows machine, read win/README.

Yorick is a command line program; you need to run it in a terminal
window.  You will want command line recall and editing.  If your
terminal window does not support that, you can either run yorick under
emacs (see the emacs/ directory in the source), or you can get a
readline wrapper like [rlwrap](http://freshmeat.net/projects/rlwrap/).

If you need some test programs to run, you can try the demos.  Start
yorick and type:

    include, "demo3.i"  
    demo3

The demo3 runs a simulation of a chaotic pendulum (it will stop after
about a minute).  Yorick functions generally have documentation which
you can read in the terminal using the help command:

    help, demo3

The help message includes the path to the source file, which you can
open and read with any text editor, to find out exactly how demo3
works (or any other yorick interpreted command).  There are five demo
programs (demo1 through demo5).  You can also do a comprehensive test
of your yorick installation by typing:

    include, "testfull.i"


Roadmap of yorick source
------------------------

The top-level distribution directory contains this README, scripts for
configuring and building yorick, and a number of subdirectories.  Some
subdirectories contain core parts of yorick; others are extras which
you might reasonably omit.  Here's a quick roadmap:

    play/     (portability layer)
      here are event loop, low level io, graphics primitives
      everything else is supposed to be strictly architecture-independent
        (however, other non-core packages may slightly violate this rule)
    win/      (MS Windows specific files)
      here are the MS Visual C++ project files
      some Windows code is in subdirectories like play/win
    gist/
      play-based 2D scientific visualization library
    yorick/
      yorick language interpreter (C source)
    matrix/
      LAPACK linear algebra functions (C source)
    math/
      non-matrix mathematical functions (C source)
    fft/
      Swartztrauber Fast Fourier Transform (C source)
    i/
      library of interpreted functions
    i0/
      interpreted code required at startup
    i-start/
      interpreted code run at startup, usually containing autoloads
    extend/
      sample trivial compiled extension for yorick
    mpy/
      MPI-based yorick multiprocessing package
    drat/
      compiled extension to do 2D cylindrical radiation transport
    hex/
      compiled extension to do 3D radiation transport
    doc/
      documentation: yorick user manual, quick reference cards
    emacs/
      GNU Emacs lisp code for running yorick and editing yorick source
  
    distribs/
      files for creating RedHat RPM, FreeBSD, and other distributions
    debian/
      instructions for creating Debian .deb distribution


Other build options
-------------------

You can take up to four steps to configure, build, test, and install
yorick.  In order, the four separate commands are:

    make config
    make
    make check
    make install

 Yorick requires an ANSI C compiler and libraries, some POSIX standard
 functions (plus either poll or select, which are not covered by any
 standard, but are present on all UNIX systems), and the basic X11
 library (R4 might work, but anything R5 or better should certainly
 work).  However, these components may be misinstalled or installed in
 places where the configuration process cannot find them.  If so, you
 can either fix your system or edit the files Make.cfg and
 play/unix/config.h by hand to repair any errors or oversights of "make
 config".
 
 The "make config" step creates the file Make.cfg (in this top-level
 directory).  By default, the compiler and loader flags are just "-O".
 If you want fancier options, you can edit Make.cfg before you build;
 just modify the Y_CFLAGS and/or Y_LDFLAGS variable.  Optimization flags
 like -g or -O are handled separately; use the COPT_DEFAULT variable
 to set those.
 
 Instead of editing Make.cfg by hand after the "make config" step, you
 can also set a variety of environment variables to control the
 configuration process.  You can read the configuration scripts --
 configure, play/unix/config.sh, play/x11/xconfig.sh, and
 yorick/yconfig.sh -- to find out precisely what they do.  Here they
 are, with sample non-default values:
 
    CC='xlc -q64'      # C compiler name plus overall mode switch
    CFLAGS=-g          # compile flags (-O is default)
    LDFLAGS=-g         # load flags (optimization CFLAGS is default)
    AR='ar -X 64'      # ar archive program
    RANLIB='ranlib -X 64'  # ranlib archive indexer
    MATHLIB=-lmcompat      # math library (-lm is default)
 
    FPU_IGNORE=yes  # give up trying to catch floating point exceptions
    NO_PLUGINS=yes  # build yorick with no plugin support
    LD_STATIC=yes   # force hex and drat packages to be statically loaded
    NO_PASSWD=yes   # hack for crippled OSes or crosscompilers (catamount)
    NO_CUSERID=yes  # hack for crippled OSes or crosscompilers (catamount)
    NO_PROCS=yes    # build yorick with no subprocess or poll/select support
                      (catamount) - this cripples yorick event handling
    NO_POLL=yes     # forces use of select when poll present but broken
                      (Mac OS X uses this by default)
 
    NO_XLIB=yes     # build yorick with no onscreen graphics
    X11BASE=/weird/X11root         # try -I/weird/X11root/include, and
                                         -L/weird/X11root/lib
    X11INC=/weird/X11root/include  # directory containing X11/Xlib.h
    X11LIB=/weird/X11root/lib      # directory containing libX11.a or .so

Other make targets include:

    clean      -- get rid of the mess left over from the build
       do this after successful install
    distclean  -- clean plus all files generated by the config step
       config does distclean before it begins
    siteclean  -- distclean plus resets ysite.sh to original settings
    uninstall  -- gets rid of all installed files
       be sure to do uninstall before distclean if you want to
       get rid of the yorick you installed (otherwise you will
       need to make ysite again)

There are many more build targets and make macros.  Read the comments
in Makefile and Makepkg for more information.
