# $Id: .login,v 1.1 1998/05/02 21:25:11 amos Exp $
# Used by csh and tcsh

# To pick a default editor besides pico uncomment one of the following lines
#setenv	EDITOR	vi
#setenv EDITOR	emacs

# Don't generate a core file
limit	coredumpsize	0

#stty intr ^c kill ^u
#stty start ^q stop ^s susp ^z

# I like my default window manager to be fvwm
#setenv startwindows fvwm

# If you want to add your own paths in and still use the global
# login file set the path here.  For example,
#   set path = ( $path ~/bin )
# will add ~/bin to the path.  The $path variable *must* be
# used here.

setenv  HOST `uname -n`

if ( ! ${?LOGNAME} ) then
  setenv USER `logname`
else
  setenv USER $LOGNAME
endif

if ( ! ${?HOSTTYPE} ) then
  if ( "`uname -s`" == HP-UX ) then
    setenv HOSTTYPE "hp9000s700"
  else if ( "`uname -s`" == IRIX ) then
    setenv HOSTTYPE "sgi"
  else if ( "`uname -m | awk '{ printf substr("'$i'",1,4);}'`" == sun4 ) then
    setenv HOSTTYPE "sparc"
  else if ( "`uname -m`" == i86pc ) then
    setenv HOSTTYPE "i86pc"
  else
    echo "**** Architecture Unknown ****"
  endif
endif

if ( ! ${?OSTYPE} ) then
  if ( $HOSTTYPE == "sparc" || $HOSTTYPE == "i86pc" ) then
    set a=`uname -r | awk -F. '{printf substr($i,1,1);}'`
    if ( $a == 4 ) then
      setenv OSTYPE "SunOS4"
    else
      setenv OSTYPE "SunOS5"
    endif
    unset a
  endif
endif

setenv OLDPATH $PATH

switch ( $HOSTTYPE )
  case sparc:
  case sun4:
  case i86pc:
  case i386:
       if ($OS == sol || $OSTYPE == solaris || $OSTYPE == SunOS5) then
         setenv  OPENWINHOME            /usr/openwin
         setenv  XKEYSYMDB              /usr/local/lib/X11/XKeysymDB
	 set	 path = ( /usr/local/bin /usr/bin /usr/ccs/bin \
				$OPENWINHOME/bin /usr/dt/bin /opt/bin \
				/unlocal/bin /usr/xpg4/bin /usr/ucb )

         setenv  MANPATH "/usr/man:/usr/local/man:$OPENWINHOME/man:$OPENWINHOME/share/man:/usr/dt/man"

         setenv  MAIL /var/mail/$USER

       else if ( $OS == sunos || $OSTYPE == sunos4 || $OSTYPE == SunOS4) then
         setenv  OPENWINHOME        /usr/local/openwin
         setenv  FMHOME	            /usr/local/frame
         setenv  PUBHOME	    /usr/local/publisher
         setenv  GUIDE	            /usr/local/guide
         setenv  XKEYSYMDB	    /usr/local/X11/lib/XKeysymDB

	 set     pubpath  = ( $PUBHOME/bin )
	 set     binpath  = ( /bin /usr/bin /usr/local/bin )
	 set     langpath = ( /usr/lang )
	 set     path     =  ( $binpath /usr/ucb  /usr/local/X11/bin \
                               $OPENWINHOME/bin /usr/5bin $langpath \
				$FMHOME/bin $pubpath)
	 setenv  MANPATH "/usr/man:/usr/local/man:/usr/lang/man:$OPENWINHOME/share/man:/usr/local/X11/man"
       endif
       breaksw
  case hp:
       set mail = /usr/mail/$USER
       setenv MAIL    /usr/mail/$USER
       setenv XKEYSYMDB /usr/local/X11/lib/XKeysymDB
       set path = ( /bin/posix /bin /usr/bin /usr/contrib/bin /usr/contrib/bin/X11 /usr/local/bin )
       setenv MANPATH "/usr/man:/usr/contrib/man:/usr/local/man"

       setenv OPENWINHOME /usr/local/X11/bin
       breaksw
  case sgi:
        set mail = /usr/mail/$USER
        setenv MAIL        /usr/mail/$USER
	setenv OPENWINHOME /usr/bin/X11
	set path  = ( /usr/bsd /bin /usr/bin /usr/local/bin \
		      /etc /usr/etc /usr/demos /usr/demos/bin /usr/bin/X11 )
        breaksw
  default:
        echo "**** Unknown Architecture: `uname -m`"
        breaksw
endsw

# Appends users path to the end of the default path.  The awk program tries
# to take out duplicate path entries if possible
if ( -f $HOME/.path ) then
  setenv PATH `echo $PATH":"$OLDPATH | awk -F: -f $HOME/.path` > /dev/null
else
  setenv PATH `echo $PATH":"$OLDPATH`
  unsetenv OLDPATH
endif

#             Define environment variables
# machine independent environment variables
test $?NNTPSERVER != 1 && setenv	NNTPSERVER	news.utdallas.edu
test $?MBOX	!= 1 && setenv	MBOX	$HOME/Mail
# set default printers
test $?LPR 	!= 1 && setenv	LPR	jolab
test $?PRINTER	!= 1 && setenv	PRINTER	jolab
test $?PRDEST	!= 1 && setenv	PRDEST	jolab
test $?LPDEST	!= 1 && setenv	LPDEST	jolab

# set the default editor to pico
test $?EDITOR	!= 1 && setenv	EDITOR	pico
test $?VISUAL	!= 1 && setenv	VISUAL	pico
test $?EDIT	!= 1 && setenv	EDIT	pico
test $?ED	!= 1 && setenv	ED	pico

test $?PAGER	!= 1 && setenv	PAGER	less

test $?TMPDIR	!= 1 && setenv	TMPDIR	/usr/tmp

test $?FMHOME	!= 1 && setenv	FMHOME	/usr/local/frame

setenv	sign 	~/.signature


#       Window managers
if ( ! ${?DT} ) then
  if ("`tty`" == /dev/console && $HOSTTYPE != sgi) then
    if ($?startwindows != 1) then 
      echo    "     X -- twm           : x"
      echo    "          fvwm          : f"
      echo    "     OpenWindows        : o"
      echo    "     NO window system   : N"
      echo -n "Window System [xfoN] <N> "
      set startwindows = $<
    endif 
    switch ($startwindows)
      case f:
      case fvwm:
	 clear
	 setenv WM fvwm
         kbd_mode -a
	 xinit -- -authtype magic-cookie
	 clear_colormap
	 clear
	 breaksw
      case s:
      case sun:
         setenv LD_LIBRARY_PATH "/usr/local/lib:/usr/lib"
         setenv DEFAULT_FONT /usr/lib/fonts/fixedwidthfonts/screen.r.14
         sunview -i
         unsetenv DEFAULT_FONT
         clear
	 breaksw
      case o:
      case open:
#         clear
#         setenv CURDISPLAY $HOST:0.0
         setenv GUIDEHOME  /usr/local/guide
         setenv XINITRC   ~/.xinitrc-ow
	 setenv WM olwm
         if ( $TERM == sun ) then
           kbd_mode -a
         endif
         openwin -auth magic-cookie
         unsetenv XINITRC
         unsetenv GUIDEHOME
         unsetenv CURDISPLAY
#         clear_colormap
#         clear 
         breaksw
      case x:
      case twm:
         clear
	 setenv WM twm
         xinit -- -authtype magic-cookie
         kbd_mode -a
         clear
         breaksw
      case N:
      case n:
      case none:
      case None:
      default:
         breaksw
    endsw

  unset startwindows

  endif
endif

# $Source: /warez/home/skel/src/RCS/.login,v $
