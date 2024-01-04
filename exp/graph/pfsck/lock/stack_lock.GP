set terminal postscript eps noenhanced \
        color dashed dashlength 3 linewidth 2\
        rounded font "Helvetica, 32"
#giant font "Helvetica" 16
#set size 0.5, 0.5
set output 'lock_file32.eps'
set key outside top horizontal right font "Helvetica, 28" samplen 2
#set key outside right top font "Helvetica, 28" samplen 2
#set key left

set style line 2 lc rgb 'black' lt 1 lw 1
set grid y
set style data histograms
set style histogram rowstacked
set boxwidth 0.5
set style fill pattern border -1
set ytics autofreq 20
set yrange [0:8]
set ylabel "Pass 1 Runtime (sec)"
set xlabel "Threads"
set ytics 2

plot 'lock_file32.dat' using 2 t "lock wait time" ls 2, '' using 3:xtic(1) t "Pass 1" ls 2
