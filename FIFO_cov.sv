package FIFO_cov_pkg;
	import uvm_pkg ::*;
`include "uvm_macros.svh"
	import FIFO_seq_item_pkg::*;
import shared_pkg::*;
class FIFO_coverage extends uvm_component;
`uvm_component_utils(FIFO_coverage)
uvm_analysis_export #(FIFO_seq_item) cov_export;
uvm_tlm_analysis_fifo #(FIFO_seq_item) cov_fifo;
FIFO_seq_item seq_item_cov;

covergroup all_comb;
				write: coverpoint seq_item_cov.wr_en ;
				read:  coverpoint seq_item_cov.rd_en ;
				Full_flag: coverpoint seq_item_cov.full ;
				Overflow_flag: coverpoint seq_item_cov.overflow ;
				Empty_flag: coverpoint seq_item_cov.empty ;
				Underflow_flag: coverpoint seq_item_cov.underflow ;
				Write_ack: coverpoint seq_item_cov.wr_ack ;
				almostfull_flag: coverpoint seq_item_cov.almostfull;
				almostempty_flag: coverpoint seq_item_cov.almostempty;

full_cp :cross write,read,Full_flag 
				{
					ignore_bins imp_case_1 = binsof(Full_flag ) intersect {1} &&binsof(read) intersect {1};
					ignore_bins imp_case_2 = binsof(write) intersect {0} &&binsof(read) intersect {0};
				}

empty_cp: cross write, read,Empty_flag 
				{
					ignore_bins imp_case_3 = binsof(Empty_flag ) intersect {1} &&binsof(write) intersect {1};
					ignore_bins imp_case_4 = binsof(write) intersect {0} &&binsof(read) intersect {0};
				}


almostfull_cp: cross write,read,almostfull_flag {
	ignore_bins imp_case_5 = binsof(write) intersect {0} &&binsof(read) intersect {0};
	ignore_bins imp_case_13 = binsof(write) intersect {1} &&binsof(read) intersect {1}&&binsof(almostfull_flag) intersect {1};
}

almost_empty_cp: cross write, read ,almostempty_flag {
	ignore_bins imp_case_6 = binsof(write) intersect {0} &&binsof(read) intersect {0};
}

overflow_cp: cross write,read,Overflow_flag 
				{
					ignore_bins imp_case_7 = binsof(Overflow_flag) intersect {1} &&binsof(write) intersect {0} ;
					ignore_bins imp_case_8 = binsof(write) intersect {0} &&binsof(read) intersect {0};
					ignore_bins imp_case_13 = binsof(write) intersect {1} &&binsof(read) intersect {1}&&binsof(Overflow_flag) intersect {1};

				}	
			 			
underflow_cp: cross write, read,Underflow_flag			
			 	{
					ignore_bins imp_case_9 = binsof(Underflow_flag ) intersect {1} &&binsof(read) intersect {0} ;
					ignore_bins imp_case_10 = binsof(write) intersect {0} &&binsof(read) intersect {0};
				}	

wr_ack_cp: cross write,read,Write_ack 
			 	{
					ignore_bins imp_case_11 = binsof(Write_ack ) intersect {1} &&binsof(write) intersect {0} ;
					ignore_bins imp_case_12 = binsof(write) intersect {0} &&binsof(read) intersect {0};
				}	

endgroup : all_comb

function new(string name = "FIFO_coverage", uvm_component parent = null) ;
super.new(name, parent);
all_comb = new();
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
seq_item_cov = FIFO_seq_item::type_id::create("seq_item_cov");
cov_export = new("cov_export", this);
cov_fifo = new("cov_fifo", this);
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
cov_export.connect(cov_fifo.analysis_export);
endfunction

task run_phase(uvm_phase phase);
super.run_phase (phase);
forever begin
cov_fifo.get(seq_item_cov);	// if(seq_item_cov.rst_n)
all_comb.sample();
end
endtask

endclass
endpackage