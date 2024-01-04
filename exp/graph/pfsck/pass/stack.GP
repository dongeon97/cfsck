set terminal postscript eps enhanced \
        color dashed dashlength 3 linewidth 2\
        rounded font "Helvetica, 40"
#giant font "Helvetica" 16

set output 'file256.eps'
set key outside top horizontal right font "Helvetica, 28" samplen 2
#set key left

set style line 2 lc rgb 'black' lt 1 lw 1
set grid y
set style data histograms
set style histogram rowstacked
set boxwidth 0.5
set style fill pattern border -1
set ytics autofreq 20
set yrange [0:]
set ylabel "Runtime (sec)"
set ytics 10

plot 'file256.dat' using 2 t "Pass 1" ls 2, '' using 3 t "Pass 2" ls 2, '' using 4:xtic(1) t "Pass 3" ls 2, '' using 5 t "Pass 4" ls 2, '' using 6 t "Pass 5" ls 2
