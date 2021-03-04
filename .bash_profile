
# $Id: profile,v 1.7 1999/07/27 23:22:40 root Exp $
# Global profile used by sh, ksh, bash

cleanpath() {

   _UTDOLDPATH=`echo $PATH | tr ' ' '^' | sed -e 's%/$%%g' -e 's%/:%:%g' -e 's%:% %g'`

   for var in $_UTDOLDPATH; do
      case $_UTDNEWPATH in
         "") _UTDNEWPATH="$var" ;;
         $var*|*:$var:*|*:$var) continue ;;
         *) _UTDNEWPATH="$_UTDNEWPATH:$var" ;;
      esac
   done
   PATH=`echo $_UTDNEWPATH | tr '^' ' '`
   unset _UTDOLDPATH _UTDNEWPATH
}

if [ x$LOGNAME = x ] ; then
  USER=`logname`; export USER
else
  USER=$LOGNAME; export USER
fi

if [ x$HOSTTYPE = x ] ; then
  if [ `uname -s` = "HP-UX" ] ; then
    HOSTTYPE="hp9000s700"; export HOSTTYPE
  elif [ `uname -s` = "IRIX" ] ; then
    HOSTTYPE="sgi"; export HOSTTYPE
  elif [ `uname -m | awk '{ printf substr($i,1,4);}'` = sun4 ] ; then
    HOSTTYPE="sparc"; export HOSTTYPE
  elif [ `uname -m` = "i86pc" ] ; then
    HOSTTYPE="i86pc"; export HOSTTYPE
  elif [ `uname -m` = "x86_64" ] ; then
    HOSTTYPE="x86_64"; export HOSTTYPE
  else
    echo "**** Architecture Unknown ****"
  fi
fi

if [ x$OSTYPE = x ] ; then
  if [ $HOSTTYPE = sparc ] || [ $HOSTTYPE = i86pc ] ; then
    a=`uname -r | awk -F. '{printf substr($i,1,1);}'`
    if [ $a = 4 ] ; then
      OSTYPE="SunOS4"; export OSTYPE
    else
      OSTYPE="SunOS5"; export OSTYPE
    fi
    unset a
  fi
else
  case $OSTYPE in
    solaris*) OSTYPE="SunOS5"; export OSTYPE ;;
  esac
fi

# export variables automatically
set -a

OLDPATH=$PATH

#echo "HOSTTYPE=$HOSTTYPE"

case $HOSTTYPE in
  sparc|sun4|i86pc|i386)
    if [ $OSTYPE = SunOS5 ] ; then				# Sparc-Solaris 2.X 
      OPENWINHOME=/usr/openwin
      XKEYSYMDB=/usr/local/lib/X11/XKeysymDB
      PATH=$PATH:/usr/local/bin;			export PATH
      PATH=$PATH:/usr/bin;				export PATH
      PATH=$PATH:/usr/ccs/bin;				export PATH
      PATH=$PATH:$OPENWINHOME/bin;			export PATH
      PATH=$PATH:/usr/dt/bin;				export PATH
      PATH=$PATH:/opt/bin;				export PATH
      PATH=$PATH:/usr/xpg4/bin;				export PATH
      PATH=$PATH:/usr/ucb;				export PATH
      PATH=$PATH:$OLDPATH; 				export PATH

      MANPATH=$MANPATH:/usr/local/man;			export MANPATH
      MANPATH=$MANPATH:/usr/man;			export MANPATH
      MANPATH=$MANPATH:$OPENWINHOME/share/man;		export MANPATH
      MANPATH=$MANPATH:/usr/dt/man;			export MANPATH

      MAIL=/var/mail/$USER;				export MAIL
#      IDL_DIR=/opt/envi_3.0/idl_5;			export IDL_DIR
#      ENVI_DIR=/opt/envi_3.0;				export ENVI_DIR
#      IDL_PATH=\+$IDL_DIR/lib:\+$IDL_DIR/examples;	export IDL_PATH
#      alias idl=$IDL_DIR/bin/idl
#      alias idlde=$IDL_DIR/bin/idlde
#      alias idlhelp=$IDL_DIR/bin/idlhelp
#      alias idldemo=$IDL_DIR/bin/idldemo
#      alias idlrpc=$IDL_DIR/bin/idlrpc
#      alias insight=$IDL_DIR/bin/insight
#      alias envi=$ENVI_DIR/bin/envi
#      alias envi_rt=$ENVI_DIR/bin/envi_rt
#      alias envi_tut=$ENVI_DIR/bin/envi_tut
#      alias envihelp=$ENVI_DIR/bin/envihelp
    elif [ $OSTYPE = SunOS4 ] ; then  
      OPENWINHOME=/usr/local/openwin;			export OPENWINHOME
      FMHOME=/usr/local/frame;				export FMHOME
      PUBHOME=/usr/local/publisher;			export PUBHOME
      GUIDE=/usr/local/guide;				export GUIDE
      XKEYSYMDB=/usr/local/X11/lib/XKeysymDB;		export XKEYSYMDB

      PUBPATH=$PUBHOME/bin:$PUBHOME/bin/$HOSTTYPE;	export PUBPATH
      BINPATH=/bin:/usr/bin:/usr/local/bin;		export BINPATH
      LANGPATH=/usr/lang;				export LANGPATH
      PATH=$BINPATH:/usr/ucb:/usr/local/X11/bin:$OPENWINHOME/bin:/usr/5bin:$LANGPATH:$FMHOME/bin:$PUBPATH; export PATH
      MANPATH=/usr/man:/usr/local/man:/usr/lang/man:$OPENWINHOME/share/man:/usr/local/X11/man; export MANPATH
      MAIL=/var/spool/mail/$USER;			export MAIL
    fi
      ;;

  hp9000s700)						# Hewlett Packard
    MAIL=/usr/mail/$USER;				export MAIL

    XKEYSYMDB=/usr/local/X11/lib/XKeysymDB;		export XKEYSYMDB
    OPENWINHOME=/usr/local/X11/bin;			export OPENWINHOME
    PATH=/bin/posix:/bin:/usr/bin:/usr/contrib/bin:/usr/contrib/bin/X11:/usr/local/bin
    MANPATH=/usr/man:/usr/contrib/man:/usr/local/man;	export MANPATH
      ;;
  sgi)							# Silicon Graphics
    MAIL=/usr/mail/$USER;				export MAIL

    OPENWINHOME=/usr/bin/X11;				export OPENWINHOME
    PATH=/bin:/usr/bin:/usr/local/bin:/usr/bsd:/usr/demos:/usr/demos/bin:/usr/bin/X11;	export PATH
      ;;
  x86_64)
    PATH=/usr/local/bin:/bin:/usr/bin; export PATH
      ;;
  *) 
    echo "**** Unknown Architecture: `uname -m`"
      ;;
esac

# Appends users path to the end of the default path.  The cleanpath function
# magically takes out duplicate entries in the PATH variable
cleanpath

#        define global variables if not already defined
: ${NNTPSERVER:=news.utdallas.edu}

: ${MBOX:="$HOME/MAIL"}

# set default printers
if [ "$HOSTNAME" = "solarium" ]
then
  LPR=eeljsol
  PRINTER=eeljsol
  PRDEST=eeljsol
  LPDEST=eeljsol
fi

# set the default editor to pico
: ${EDITOR:=pico}
: ${VISUAL:=pico}
: ${EDIT:=pico}
: ${ED:=pico}

: ${PAGER:=less}

: ${TMPDIR:=/usr/tmp}

: ${FMHOME:=/usr/local/frame}

SIGN="$HOME/.signature"

# stop exporting variables automatically
set +a

if [ x$DT = x ] ; then
  if [ "`tty`" = /dev/console ] && [ $HOSTTYPE != sgi ] ; then
    if [ x$startwindows = x ] ; then
      echo    "     X -- twm           : x"
      echo    "          fvwm          : f"
      echo    "     OpenWindows        : o"
      echo    "     NO window system   : N"
      echo -n "Window System [xfoN] <N> "
      read choice
    fi
    case $choice in
      N|n|none|None)
          ;;
      f|F|fvwm)
        WM="fvwm"; export WM
        kbd_mode -a
        xinit -- -authtype magic-cookie
        clear
          ;;
      s|S|sun)
        XINITRC=~/.xinitrc-twm;					export XINITRC
        MANPATH "/usr/lang/man:/usr/local/man:/usr/share/man";	export MANPATH
        LD_LIBRARY_PATH "/usr/local/lib:/usr/lib";		export LD_LIBRARY_PATH
        DEFAULT_FONT /usr/lib/fonts/fixedwidthfonts/screen.r.14;	export DEFAULT_FONT
        sunview -i
        unset DEFAULT_FONT
        clear
          ;;
      o|O|open)
#        clear
#        CURDISPLAY=$HOST:0.0;					export CURDISPLAY
        GUIDEHOME=/usr/local/guide;				export GUIDEHOME
	XINITRC=~/.xinitrc-ow;					export XINITRC
        WM="olwm"; export WM
        if [ $TERM = "sun" ] ; then
          kbd_mode -a
        fi
        openwin -auth magic-cookie
        unset XINITRC
        unset GUIDEHOME
        unset CURDISPLAY
        clear_colormap
        clear
          ;;
      x|twm)
        clear
        WM="twm"; export WM
        xinit -- -authtype magic-cookie
        kbd_mode -a
        clear
    esac
    unset startwindows
  fi
fi

# $Source: /warez/home/skel/src/global/RCS/profile,v $

if [ -f $HOME/.bashrc ] ; then 
  source ~/.bashrc
fi


