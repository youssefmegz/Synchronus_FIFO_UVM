package FIFO_seq_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import shared_pkg::*;
class FIFO_seq_item extends uvm_sequence_item;
`uvm_object_utils(FIFO_seq_item)

rand bit [FIFO_WIDTH-1:0] data_in;						//input
rand bit rst_n, wr_en, rd_en;							//input
bit clk;
bit [FIFO_WIDTH-1:0] data_out;							//output
bit wr_ack, overflow;									//output
bit full, empty, almostfull, almostempty, underflow;	//output

function new(string name = "FIFO_seq_item");
super.new(name);
endfunction

function string convert2string();
return $sformatf("%s rst_n = 0b%b, wr_en = 0b%b, rd_en = 0b%b, wr_ack = 0b%b, overflow = 0b%b,full = 0b%b,
 empty = 0b%b, almostfull = 0b%b, almostempty = 0b%b, underflow = 0b%b, data_in = 0b%b, data_out = 0b%b",super.convert2string(),
   rst_n, wr_en, rd_en,wr_ack, overflow,full, empty, almostfull, almostempty, underflow,data_in,data_out);
endfunction

function string convert2string_stimulus();
return $sformatf("%s rst_n = 0b%b, wr_en = 0b%b, rd_en = 0b%b, wr_ack = 0b%b, overflow = 0b%b,full = 0b%b,
 empty = 0b%b, almostfull = 0b%b, almostempty = 0b%b, underflow = 0b%b, data_in = 0b%b, data_out = 0b%b",super.convert2string(),
   rst_n, wr_en, rd_en,wr_ack, overflow,full, empty, almostfull, almostempty, underflow,data_in,data_out);
endfunction


constraint reset_c {rst_n dist{1:=97,0:=3};}
constraint wr_en_c {wr_en dist{1:=WR_EN_ON_DIST,0:=100-WR_EN_ON_DIST};}
constraint rd_en_c {rd_en dist{1:=RD_EN_ON_DIST,0:=100-RD_EN_ON_DIST};}
constraint wr_only {wr_en ==1;	rd_en==0;}
constraint rd_only {wr_en ==0;	rd_en==1;}




endclass


endpackage 