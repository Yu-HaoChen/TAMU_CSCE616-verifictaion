module cache_mem_test(cache_mem_intf.tb cmbus);

  initial
  begin : mem_t

//TO DO : Create your own stimulus (Hint call mem_write and mem_read task of cmbus instance)
    logic [4:0] random_addr;
    logic [7:0] random_data;
    logic [7:0] read_data;

  #1 
  cmbus.wr_en=0;
  cmbus.rd_en=0;
  #10

  repeat(33) begin
    //random_addr=24;
    random_addr= $urandom_range(0,31);
    random_data= $urandom;
  //for(int i=0; i<32; i++) begin
    cmbus.mem_write(random_addr,random_data); 
    #10;

    cmbus.mem_read(random_addr,read_data);
    #10;
  

    if(random_data == read_data)begin
    $display("[time:%0t] [\033[0;32mcorrect\033[m] addr[%0d] (correct_data: %0h) data: %0h",$time, random_addr, random_data, read_data);
    end 
    else begin 
    $display("[time:%0t] [\033[0;31mERROR\033[m] addr[%0d] (correct_data: %0h) data: %0h",$time, random_addr, random_data, read_data);  
    end 
  end
  //end


	$finish;
  end

endmodule
