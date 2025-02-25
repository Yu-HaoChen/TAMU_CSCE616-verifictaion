///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// File name   : simple_mem_tb.sv
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////

module mem_test;
// TO DO : INSERT PORT DECLARATION
    logic clk;
    logic rst_n;
    logic rd_en;
    logic wr_en;
    logic [4:0] addr;
    logic [7:0] data_in;
    logic [7:0] data_out;
    logic [7:0] read_data;
    logic [7:0] data_rd;

  //simple mem instantiation
  simple_mem mem_inst (
// TO DO : PORT CONNECTION
    .clk (clk),
    .rst_n (rst_n),
    .rd_en (rd_en),
    .wr_en (wr_en),
    .addr (addr),
    .data_in (data_in),
    .data_out (data_out)
	);

  initial clk=1;
  always #10 clk = ~clk;

  initial
  begin : mem_t

    rst_n <= 1;
    #1 rst_n <= 0;
    #1 rst_n <= 1;
    $display ("-----Asynch Memory Reset-----");

//TO DO : After reset read from all addresses and confirm reset state

  for(int i=0; i<32; i++) begin
    mem_read (i, data_rd);  //=>data_rd(in task)
  end
      
//TO DO : Run a loop to write iter value on the address -- write 5 on memory[5] 
$display ("-----Write in Data-----");
  for(int y=0; y<32; y++) begin
     mem_write (y,y);
  end
//TO DO : Add your own stimulus to catch the bug in the design. Also display the current vs expected value
   $display("-----current vs expected value-----");
   for(int k=0; k<32; k++) begin
    mem_read (k,data_rd);
    if(data_rd != k) begin
    $display("[time:%0t] [\033[0;31mERROR\033[m] current addr[%0d] value: %d - expected value: %0d",$time, k, data_out, k);
    end
    else begin
    $display("[time:%0t] [\033[1;32mCorrect\033[m] current addr[%0d] value: %d - expected value: %0d",$time, k, data_out, k);
    end
   end

  $finish; 
  end

 task mem_write (input logic [4:0] addr_in, input logic [7:0] data_wr);
// TO DO : complete the task <insert display statement for debug>
  begin
    @(posedge clk);
    rd_en=1'b0; wr_en=1'b1;
    addr = addr_in;
    data_in = data_wr;
    $display ("[time:%0t] addr [%0d]  data_in %d ", $time, addr, data_in);
  end
	endtask

  task mem_read (input logic [4:0] addr_in, output logic [7:0] data_rd);
// TO DO : complete the task <insert display statement for debug>
 begin
    @(posedge clk);
    rd_en=1'b1; wr_en=1'b0;
    addr = addr_in;       // data_out <= memory[addr(addr_in)]
    data_rd = data_out;   // data_rd <= data_out
    $display ("[time:%0t] addr [%0d]: read_data %h", $time, addr_in, data_rd); 
  end
	endtask

endmodule
