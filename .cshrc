# $Id: .cshrc,v 1.2 1998/05/02 21:42:28 amos Exp $
# .cshrc file - This file contains files that are used by the Csh
#  for setup and configuration purposes

# turn on masking so that only you can can read, write, and execute
# files that you create
umask 066

limit coredumpsize 0

# This switch statement tries to determine what type of machine you
# are on and sets variables and terminal settings that are 
# appropriate.  The important 'stty' settings is the first line or two.
switch ( `uname -s` )
  case SunOS:
      switch ( `uname -m` )
	case i86pc:
        case sun4c:
        case sun4m:
        case sun4u:
        case sun4:
          # Distinguish between SunOS 4.X and Solaris 2.X (SunOS 5.X)
          set a=`uname -r | awk -F. '{printf substr($i,1,1);}'`
          if ($a == 4 ) then
            set OS = sunos
          else
            set OS = sol
          endif
          unset a
        breaksw
      endsw
      breaksw
  case HP-UX:
      set OS = hpux
      if ( ! ${?DT} ) then
        stty dsusp ^y
      endif
      breaksw
  case IRIX:
       set OS = irix
      breaksw
endsw

# Skip remaining setup if not an interactive shell.
if ($?USER == 0 || $?prompt == 0) then
  set path = ( /usr/bin /bin /usr/local/bin /usr/openwin/bin /usr/ucb \
               /usr/ccs/bin )
  setenv MANPATH "/usr/man:/usr/local/man:/usr/openwin/man"
  goto the_end
endif

if ( $TERM != xterm ) then
  if ( ${?TERMINAL_EMULATOR} ) then
    setenv TERM $TERMINAL_EMULATOR
  else if ( -f /usr/local/bin/qterm ) then
    echo Querying terminal...
    if ( -f ~/.qtermtab ) then
      setenv TERM `/usr/local/bin/qterm +real +usrtab`
    else
      setenv TERM `/usr/local/bin/qterm +real +systab`
    endif
  endif
endif

if ( ! ${?DT} ) then
  stty intr ^c kill ^u
  stty start ^q stop ^s susp ^z
  stty erase ^h           # I like to use backspace instead of delete to erase
endif

# use escape to perform filename completion
  set filec=1

# settings for interactive shells
# To turn off the following settings comment it 
  set history = 40
# set ignoreeof		# Prevents usage of Control-D from logging out
  set noclobber		# Prevents '>' from overwriting files
# set noglob		# Prevents wildcard expansion from taking place
  unset noglob
  set notify		# Informs you when a background job terminates

# Aliases
# Some familiar DOS commands
alias   print           lpr
alias   cls             clear
alias   md              mkdir
alias   rd              rmdir
alias   type            cat
alias   del             rm -i
alias   erase           rm -i
if ($OS == sunos) then
  alias   dir             'ls -lagF \!* | more'
else
  alias   dir             'ls -laF \!* | more'
endif
alias	dri		dir
 
# Some so-I-won't-bash-my-head-into-the-wall-because-I-deleted-a-file commands
alias   cp              cp -i
alias   mv              mv -i
alias   rm              rm -i
 
# Some commands to make life easier
alias   open            chmod go+r
alias   shut            chmod go-r
#alias	fixlines	'stty rows 24 cols 80;stty -tabs'
alias	ts		'eval `tset -s \!*`'

# Some aliased ls commands
alias   la              'ls -a'
alias	lc		'ls -C'
alias   ll              'ls -la'
 
# Some help commands
alias   help            "man man"
alias   key             'man -k'
 
alias   bye             logout
alias   lo              logout

alias	ldir		'ls -l \!* | grep "^d" | more'

#alias setprompt 'set prompt="${cwd}% "'
#setprompt
#alias cd 'chdir \!* && setprompt'

#alias pushd 'pushd \!* && setprompt'
#alias popd  'popd \!* && setprompt'

# Some prompts
set prompt="`uname -n`{`logname`}\!: "
#set prompt="`uname -n`% "

# cd path - allows you to change directories without specifying a whole
# directory path
set lcd = ( )		# add the parents of frequently used directories
set cdpath = ( .. ~ ~/bin $lcd)

the_end:

# $Source: /warez/home/skel/src/RCS/.cshrc,v $
