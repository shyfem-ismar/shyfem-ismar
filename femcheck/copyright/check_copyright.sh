#!/bin/sh
#
# checks if copyright has been inserted
#
#--------------------------------------------------------

progdir=$HOME/shyfem/femcheck/copyright
progcheck="$progdir/check_copyright.pl -quiet"
proginclude="$progdir/include_copyright.sh"

#--------------------------------------------------------

Usage()
{
  echo "Usage: check_copyright.sh [-h|-help] [-options] dir"
}

FullUsage()
{
  Usage
  echo "  checks copyright inside files and if asked inserts it"
  echo ""
  echo "  -h|-help      this help screen"
  echo "  -include      include copyright"
  echo "  -silent       do not write statistics (implies -quiet)"
  echo "  -quiet        do not write info about non regular files"
  echo "  -ok           only list files with copyright"
  echo "  -no           only list files without copyright"
  echo ""
}

#--------------------------------------------------------

ok="YES"
no="YES"
quiet="NO"
silent="NO"
include="NO"

while [ -n "$1" ]
do
   case $1 in
        -include)       include="YES";;
        -silent)        silent="YES";quiet="YES";;
        -quiet)         quiet="YES";;
        -ok)            no="NO";quiet="YES";;
        -no)            ok="NO";quiet="YES";;
        -h|-help)       FullUsage; exit 0;;
        -*)             echo "no such option: $1"; exit 1;;
        *)              break;;
   esac
   shift
done

if [ $# -eq 0 ]; then
  Usage; exit 1
fi
cd $1

#--------------------------------------------------------
  
nofiles=0
files=$( ls *.[fhc] *.tex *.f90 *.F90 2> /dev/null )
files=$( ls *.[f] 2> /dev/null )
files=$( ls 2> /dev/null )

for file in $files
do
  if [ ! -f $file ]; then
    [ $quiet = "NO" ] && echo "skipping non regular $file"
    continue
  fi
  $progcheck $file
  status=$?
  #echo "$status  $file"
  if [ $status -eq 0 ]; then
    [ $ok = "YES" ] && echo "ok   $file"
    okfiles=$(($okfiles+1))
  else
    [ $no = "YES" ] && echo "***  $file"
    if [ $include = "YES" ]; then
      $proginclude $file
    fi
    nofiles=$(($nofiles+1))
  fi
done

if [ $silent = "NO" ]; then
  echo "$okfiles with copyright found"
  echo "$nofiles without copyright found"
fi

