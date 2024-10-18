import shared_pkg::*;
module FIFO_SVA #(parameter FIFO_WIDTH=16 , FIFO_DEPTH = 8)
( input bit [FIFO_WIDTH-1:0] data_in,
input bit clk, rst_n, wr_en, rd_en,
input bit [FIFO_WIDTH-1:0] data_out,
input bit wr_ack, overflow,
input bit full, empty, almostfull, almostempty, underflow,
input bit [$clog2(FIFO_DEPTH):0] count);



always_comb begin

if(!rst_n) 
begin
                R1: assert final(full == 0);
                R2: assert final(empty == 1);
                R3: assert final (almostfull == 0);
                R4: assert final (almostempty == 0);
                R5: assert final (overflow == 0);
                R6: assert final (underflow == 0);
                R7: assert final (wr_ack ==0 );
end

if(count==FIFO_DEPTH)
full_assert:assert final(full==1);

if(count==0)
empty_assert:assert final(empty==1);

if(count == FIFO_DEPTH-1)
almostfull_assert:assert final(almostfull==1);

if(count == 1)
almostempty_assert:assert final(almostempty==1);

end


property acknowledge;
@(posedge clk) disable iff(rst_n==0)(wr_en && count < FIFO_DEPTH) |=> wr_ack==1;
endproperty

acknowledge_assert:assert property(acknowledge) else $display("ERROR : acknowledge assert FAIL");
acknowledge_cover:cover property(acknowledge);


property over_flow;
@(posedge clk) disable iff(rst_n==0)(full && wr_en) |=> overflow==1;
endproperty

overflow_assert:assert property(over_flow) else $display("ERROR : overflow assert FAIL");
overflow_cover:cover property(over_flow);      

property under_flow;
@(posedge clk)disable iff(rst_n==0) (empty && rd_en) |=> underflow==1;
endproperty

underflow_assert:assert property(under_flow) else $display("ERROR : underflow assert FAIL");
underflow_cover:cover property(under_flow);

endmodule