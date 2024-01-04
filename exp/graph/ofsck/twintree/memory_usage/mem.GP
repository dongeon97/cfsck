set terminal postscript eps enhanced \
        color dashed dashlength 3 linewidth 2\
        rounded font "Helvetica, 32"

set output 'tt_dir64_1.eps'
set key  top horizontal font "Helvetica, 28" samplen 2

set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12

# color definitions
set style line 1 lc rgb '#8b1a0e' pt 6 ps 2 lt 2 lw 2 # --- red
set style line 2 lc rgb '#5e9c36' pt 8 ps 2 lt 2 lw 2 # --- green


set xlabel 'Threads'
set ylabel 'Max Memory Usage (MB)'

set xrange [0.9:16.5]
set yrange [0: 40]
set ytics 10

set logscale x 2

#set xtics (1, 2, 4, 8, 16)
#set mxtics 2

plot 'dir64_1.dat' u 1:2 t 'oFSCK' w lp ls 1, \
     ''        u 1:3 t 'pFSCK' w lp ls 2
