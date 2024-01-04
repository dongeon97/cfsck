set terminal postscript eps enhanced \
        color dashed dashlength 3 linewidth 2\
        rounded font "Helvetica, 32"
#giant font "Helvetica" 16

set output 'pass2.eps'
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
set ylabel "Pass 2 Runtime (sec)"
set ytics 5

plot 'pass2.dat' using 2 t "check_consistency" ls 2, '' using 3 t "read_dir_block" ls 2, '' using 4:xtic(1) t "icount_update" ls 2, '' using 5 t "lock_wait" ls 2, \
     'pass2_a.dat' using 2 t "check_consistency" ls 2, '' using 3 t "read_dir_block" ls 2, '' using 4:xtic(1) t "icount_update" ls 2, '' using 5 t "lock_wait" ls 2

