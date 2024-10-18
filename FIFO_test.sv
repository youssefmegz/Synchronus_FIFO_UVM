package FIFO_test_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_env_pkg::*;
import FIFO_config_pkg::*;
import FIFO_wr_only_pkg::*;
import FIFO_rd_only_pkg::*;
import FIFO_wr_rd_pkg::*;


class FIFO_test extends uvm_test;
	`uvm_component_utils(FIFO_test)

FIFO_env env;
FIFO_config FIFO_cfg;
virtual FIFO_interface FIFO_vif;
write_only_sequence wr_seq;
read_only_sequence rd_seq;
wr_rd_sequence wr_rd_seq;



function new(string name="FIFO_test",uvm_component parent =null);

	super.new(name,parent);
endfunction : new

function void build_phase(uvm_phase phase);
super.build_phase(phase);
env = FIFO_env::type_id :: create("env",this);
FIFO_cfg = FIFO_config::type_id::create("FIFO_cfg",this);
wr_seq = write_only_sequence::type_id :: create("wr_seq",this);
rd_seq = read_only_sequence::type_id:: create("rd_seq",this);
wr_rd_seq = wr_rd_sequence::type_id:: create("wr_rd_seq",this);

if(!uvm_config_db #(virtual FIFO_interface)::get(this,"","FIFO_IF",FIFO_cfg.FIFO_vif))begin
`uvm_fatal("build_phase","FIFO_IF is not set for the test");
end
uvm_config_db#(FIFO_config)::set(this,"*","CFG",FIFO_cfg);
endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
phase.raise_objection(this);

//write sequence
`uvm_info("run_phase", "write sequence start", UVM_LOW)
wr_seq.start(env.agt.sqr);
`uvm_info("run_phase", "write sequence stop", UVM_LOW)

//read sequence
`uvm_info("run_phase", "read sequence start", UVM_LOW)
rd_seq.start(env.agt.sqr);
`uvm_info("run_phase", "read sequence end", UVM_LOW)

//write read sequence
`uvm_info("run_phase", "write read sequence start", UVM_LOW)
wr_rd_seq.start(env.agt.sqr);
`uvm_info("run_phase", "write read sequence stop", UVM_LOW)

phase.drop_objection(this);
endtask
endclass 
endpackage 











