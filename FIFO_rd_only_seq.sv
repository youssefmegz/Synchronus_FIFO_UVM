package FIFO_rd_only_pkg;
	import uvm_pkg ::*;
`include "uvm_macros.svh"
import FIFO_seq_item_pkg::*;
import shared_pkg::*;
class read_only_sequence extends uvm_sequence #(FIFO_seq_item);
`uvm_object_utils(read_only_sequence);
FIFO_seq_item seq_item;

function new (string name = "read_only_sequence");
super.new(name);
endfunction

task body;
repeat(50) begin
seq_item = FIFO_seq_item :: type_id :: create("seq_item");
seq_item.wr_only.constraint_mode(0);
seq_item.wr_en_c.constraint_mode(0);
seq_item.rd_en_c.constraint_mode(0);


start_item(seq_item);
assert(seq_item.randomize());
finish_item(seq_item);
end
endtask
endclass

endpackage