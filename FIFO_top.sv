import FIFO_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

module FIFO_top;


bit clk;
initial begin
	clk=0;
	forever 
	#10 clk=~clk;
end


FIFO_interface inter(clk);		
FIFO DUT(inter.data_in, inter.wr_en, inter.rd_en, clk, inter.rst_n, inter.full, inter.empty, inter.almostfull,
 inter.almostempty, inter.wr_ack, inter.overflow, inter.underflow, inter.data_out);
	
bind FIFO FIFO_SVA fifo_sva (
  inter.data_in, clk, inter.rst_n, inter.wr_en, inter.rd_en, inter.data_out,
  inter.wr_ack, inter.overflow, inter.full, inter.empty, inter.almostfull, 
  inter.almostempty, inter.underflow, DUT.count  // Assuming count is a valid port.
);


initial begin 
	uvm_config_db#(virtual FIFO_interface)::set(null,"uvm_test_top","FIFO_IF",inter);
	run_test("FIFO_test");
end


endmodule