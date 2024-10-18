vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.FIFO_top -classdebug -uvmcontrol=all -cover
add wave /FIFO_top/inter/*
coverage save FIFO_top.ucdb -onexit -du FIFO

run -all
