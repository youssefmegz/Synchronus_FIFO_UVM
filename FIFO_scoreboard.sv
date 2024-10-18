package FIFO_scoreboard_pkg;
    import uvm_pkg::*;
`include "uvm_macros.svh"
import FIFO_seq_item_pkg::*;
import shared_pkg::*;

class FIFO_scoreboard extends uvm_scoreboard;
`uvm_component_utils(FIFO_scoreboard)
uvm_analysis_export #(FIFO_seq_item) sb_export;
uvm_tlm_analysis_fifo #(FIFO_seq_item) sb_fifo;
FIFO_seq_item seq_item_sb;

localparam max_fifo_addr = $clog2(FIFO_DEPTH);
bit [max_fifo_addr-1:0] wr_ptr_ref, rd_ptr_ref;
bit [max_fifo_addr:0] count_ref;

bit [FIFO_WIDTH-1:0] data_out_ref; 
bit full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref, wr_ack_ref, overflow_ref;
bit [FIFO_WIDTH-1:0] fifo_queue[$];           // Dynamically-sized queue


int error_count = 0;
int correct_count = 0;

function new(string name = "FIFO_scoreboard", uvm_component parent = null) ;
super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
sb_export = new("sb_export", this);
sb_fifo = new("sb_fifo", this);
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
sb_export.connect(sb_fifo.analysis_export);
endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
sb_fifo.get(seq_item_sb);
ref_model(seq_item_sb);


if (seq_item_sb.data_out != data_out_ref) begin
`uvm_error("run_phase", $sformatf("Comparsion failed, Transaction received by the DUT:%s While the refernce out:0b%0b",seq_item_sb.convert2string(),data_out_ref));
error_count++;
end

else if (full_ref!==seq_item_sb.full || empty_ref!==seq_item_sb.empty 
        || almostfull_ref!==seq_item_sb.almostfull ||overflow_ref!==seq_item_sb.overflow
        ||underflow_ref!==seq_item_sb.underflow ||wr_ack_ref!==seq_item_sb.wr_ack)begin
    `uvm_error("run_phase", $sformatf("Comparsion failed, Transaction received by the DUT:%s While the refernce is different",seq_item_sb.convert2string()));
error_count++;
end
else begin
`uvm_info("run_phase", $sformatf("Correct FIFO out: %s ", seq_item_sb.convert2string()), UVM_HIGH);
correct_count++;
end
end
endtask


task ref_model(FIFO_seq_item seq_item_ref);

 if (!seq_item_ref.rst_n) begin
      // Reset state
      fifo_queue.delete();         // Clear the queue on reset
      wr_ack_ref=0;
      wr_ptr_ref=0;
      rd_ptr_ref=0;
      overflow_ref=0;
      underflow_ref=0;
      count_ref=0;
    end else begin

        // Write operation
        if (seq_item_ref.wr_en) begin
          if(count_ref<FIFO_DEPTH)begin
            fifo_queue.push_back(seq_item_ref.data_in);           // Push data into the queue
            wr_ack_ref=1;
            wr_ptr_ref = wr_ptr_ref+1;
            overflow_ref=0;
          end
        else begin
          wr_ack_ref=0;
          overflow_ref=1;
        end
        end
        else begin
          overflow_ref=0;
          wr_ack_ref=0;
        end

      // Read operation
      if (seq_item_ref.rd_en) begin
        if(count_ref>0)begin
        data_out_ref = fifo_queue.pop_front();   // Pop data from the queue
        rd_ptr_ref=rd_ptr_ref+1;
        underflow_ref=0;  
      end
      else 
          underflow_ref=1;
        end
        else begin
          underflow_ref=0;
      end


case({seq_item_ref.wr_en ,seq_item_ref.rd_en})

              2'b01 : if(!empty_ref)
                count_ref=count_ref-1;
              2'b10 : if(!full_ref)
                count_ref=count_ref+1;
              2'b11: if(full_ref)
                count_ref=count_ref-1;
                  else if(empty_ref)
                count_ref=count_ref+1;

            endcase

    end

          // Update status signals based on queue size
      full_ref = (count_ref == FIFO_DEPTH);
      empty_ref = (count_ref== 0);
      almostfull_ref = (count_ref == FIFO_DEPTH - 1);
      almostempty_ref = (count_ref == 1);

endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase", $sformatf("Total successful transactions: %0d",correct_count),UVM_MEDIUM)
            `uvm_info("report_phase", $sformatf("Total failed transactions: %0d",error_count),UVM_MEDIUM)
        endfunction


endclass : FIFO_scoreboard
endpackage 