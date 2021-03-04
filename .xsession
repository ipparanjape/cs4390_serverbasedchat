#!/bin/sh
# $Id: .xsession,v 1.1 1998/05/02 21:24:18 amos Exp $

if [ `uname` = "Linux" ] ; then
  exit
fi


LD_LIBRARY_PATH=/usr/lib:/usr/local/lib:/usr/dt/lib; export LD_LIBRARY_PATH

xterm -C -title Console -geometry 124x5+120+0 &

xterm -geometry 80x24+0-100 &


if [ -x /usr/local/bin/fvwm ]; then
    /usr/local/bin/fvwm
else
    twm
fi
# $Source: /warez/home/skel/src/RCS/.xsession,v $
