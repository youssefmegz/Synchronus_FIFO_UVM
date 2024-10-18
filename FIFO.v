////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(data_in, wr_en, rd_en, clk, rst_n, full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
input [FIFO_WIDTH-1:0] data_in;
input clk, rst_n, wr_en, rd_en;
output reg [FIFO_WIDTH-1:0] data_out;
output reg wr_ack, overflow, underflow;
output  full, empty, almostfull, almostempty;
localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;


always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		wr_ptr <= 0;
		wr_ack <= 0;								//reset acknowledge
		overflow<=0;								//reset overflow
	end
	else if (wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= data_in;
		wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		overflow<=0;
	end
	else begin 
		wr_ack <= 0; 
		if (full & wr_en)
			overflow <= 1;
		else
			overflow <= 0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		rd_ptr <= 0;							
		underflow<=0;											//reset underflow

	end
	else if (rd_en && count != 0) begin
		data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		underflow<=0;
	end
	else 
		underflow <= (empty && rd_en)? 1 : 0;		//sequential output

end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({wr_en, rd_en} == 2'b11) && !full && !empty)		//done at the same time 
			count <= count ;
		else if ( ({wr_en, rd_en} == 2'b11) && empty)					//write is done firstly when empty
			count <= count + 1;
		else if ( ({wr_en, rd_en} == 2'b11) && full)					//read is done firstly when full
			count <= count - 1;
		else if ( wr_en == 1 && !full)
			count <= count + 1;
		else if ( rd_en == 1 && !empty)
			count <= count - 1;
	end

end

assign full = (count == FIFO_DEPTH)? 1 : 0;
assign empty = (count == 0)? 1 : 0; 
assign almostfull = (count == FIFO_DEPTH-1)? 1 : 0; 						// minus one
assign almostempty = (count == 1)? 1 : 0;

endmodule