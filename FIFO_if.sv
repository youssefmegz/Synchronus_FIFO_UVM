import shared_pkg::*;

interface FIFO_interface(clk);
	
	localparam max_fifo_addr = $clog2(FIFO_DEPTH);
	input bit clk;

bit [FIFO_WIDTH-1:0] data_in;							//input
bit rst_n, wr_en, rd_en;								//input
bit [FIFO_WIDTH-1:0] data_out;							//output
bit wr_ack, overflow;									//output
bit full, empty, almostfull, almostempty, underflow;	//output



endinterface 

