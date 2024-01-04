# 
# 
# Author: SukJoon Oh, sjoon@kaist.ac.kr

# Frequently used keywords
# httpointsize://hirophysics.com/gnuplot/gnuplot08.html

reset session

# Set the necessaries
DATA_DIR="./"

DATA_FNAME1="compare_pfsck.dat"
DATA_FNAME2="compare_sfsck.dat"


EXPORT_DIR="./"
EXPORT_NAME="compare_file256"

# Export path
set output EXPORT_DIR.EXPORT_NAME.".eps"

# New setting
FONT_GLOBAL="Helvetica,32"
FONT_TITLE="Helvetica,32"
FONT_XLABEL="Helvetica,32"
FONT_YLABEL="Helvetica,32"
FONT_XTICS="Helvetica,32"
FONT_YTICS="Helvetica,32"
FONT_KEY="Helvetica,28"

#
# Data specifications 
TITLE=""

XLABEL="Threads"
YLABEL="Runtime (sec)"

#
# Settings starts here.
# Overall graph structure settings lies here.
# ----

# set terminal postscript eps \
#     enhanced monochrome 28 \
#     font FONT_GLOBAL

set terminal postscript eps \
    color \
    font FONT_GLOBAL \
#size 5, 1.6

set title TITLE font FONT_TITLE
unset title

set xlabel XLABEL font FONT_XLABEL
set ylabel YLABEL font FONT_YLABEL

set xtics nomirror
set ytics nomirror

# 
set grid ytics

# set key on \
#     bottom \
#     noautotitle \
#     font FONT_KEY

# set key reverse \
#     samplen 2 width 0 \
#     right top \
#     Left nobox font FONT_KEY

set key reverse \
    samplen 2 width 1 height 0 \
    right top \
    maxrows 1 \
    Left nobox font FONT_KEY

# unset key

# 
# Set your options: outside, inside, bottom, ...

set style line 1 linecolor rgb "red"     linetype 1 linewidth 3.5 pointtype 1 pointsize 1.5 pi -1  ## +
set style line 2 linecolor rgb "blue"    linetype 2 linewidth 3.5 pointtype 2 pointsize 1.5 pi -1  ## x
set style line 3 linecolor rgb "#00CC00" linetype 1 linewidth 3.5 pointtype 3 pointsize 1.5 pi -1  ## *
set style line 4 linecolor rgb "#7F171F" linetype 4 linewidth 3.5 pointtype 4 pointsize 1.5 pi -1  ## box
set style line 5 linecolor rgb "#FFD800" linetype 3 linewidth 3.5 pointtype 5 pointsize 1.5 pi -1  ## solid box
set style line 6 linecolor rgb "#000078" linetype 6 linewidth 3.5 pointtype 6 pointsize 1.5 pi -1  ## circle
set style line 7 linecolor rgb "#732C7B" linetype 7 linewidth 3.5 pointtype 7 pointsize 1.5 pi -1
set style line 8 linecolor rgb "black"   linetype 8 linewidth 3.5 pointtype 8 pointsize 1.5 pi -1  ## triangle

# set style line 1 linecolor rgb "black"    linetype 1 linewidth 2 pointtype 1 pointsize 1.5 pi -1  ## +
# set style line 2 linecolor rgb "black"    linetype 2 linewidth 2 pointtype 2 pointsize 1.5 pi -1  ## x
# set style line 3 linecolor rgb "black"    linetype 1 linewidth 2 pointtype 3 pointsize 1.5 pi -1  ## *
# set style line 4 linecolor rgb "black"    linetype 4 linewidth 2 pointtype 4 pointsize 1.5 pi -1  ## box
# set style line 5 linecolor rgb "black"    linetype 3 linewidth 2 pointtype 5 pointsize 1.5 pi -1  ## solid box
# set style line 6 linecolor rgb "black"    linetype 6 linewidth 2 pointtype 6 pointsize 1.5 pi -1  ## circle
# set style line 7 linecolor rgb "black"    linetype 7 linewidth 2 pointtype 7 pointsize 1.5 pi -1
# set style line 8 linecolor rgb "black"    linetype 8 linewidth 2 pointtype 8 pointsize 1.5 pi -1  ## triangle

#
# Write plots here
# ----
set style fill pattern
set style histogram clustered gap 1 #errorbars linewidth 1000

set border 3

# set xrange[0:36]
set xtics ("1" 0, "2" 1, "4" 2, "8" 3, "16" 4) \
    font FONT_XTICS

set yrange[0:70]
set ytics 20 \
    font FONT_YTICS

plot \
    DATA_DIR.DATA_FNAME1 using 6 title "pFSCK" linewidth 3 linetype -1 with histogram, \
    DATA_DIR.DATA_FNAME2 using 6 title "oFSCK" linewidth 3 linetype -1 with histogram
   
