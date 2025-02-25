///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// File name   : top.sv
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns //1ns/1ps
module top;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	`include "htax_defines.sv"
	`include "htax_packet_c.sv"

	htax_packet_c pkt, fac_pkt; //handle for class objects
	
	logic clk=0;
	int i=0;
	//Create variables to store port (4-bit) and one data packet (64-bit) 
	logic [3:0] port;
	logic [63:0] data;
	logic [3:0] portin [0:3] = {4'b0001, 4'b0010, 4'b0100, 4'b1000};
	
//clock definition 

initial forever #5 clk = ~clk;

initial begin
//TO-DO create two instance with above handles with instructions provided below
	//system verilog instance
	pkt = new();
	//randomize pkt
	if (!pkt.randomize()) begin
    $fatal("Randomization failed!");
	end
	//print pkt
	pkt.print();
	$display("length= %0d", pkt.length);
	//drive pkt 
	drive_packet(pkt);

	// UVM factory instantiation
	fac_pkt = htax_packet_c::type_id::create();
	//randomize fac_pkt
	if (!fac_pkt.randomize()) begin
    $fatal("Randomization failed!");
	end
	//print fac_pkt
	fac_pkt.print();
	$display("length= %0d", fac_pkt.length);
	//drive fac_pkt
	drive_packet(fac_pkt);
	
	factory.print();
	#10 $finish;
end

//TO DO complete the below task
task drive_packet (htax_packet_c pkt1); 
//At every posedge of clk load each data packet from pkt.data to variable data
//The whole time the bit of variable port equal to pkt.dest_port is 1 and rest bits are 0
// pkt.dest_port = 0 >= 0001, pkt.dest_port = 0 >= 0010, pkt.dest_port = 0 >= 0100, pkt.dest_port = 3 >= 1000
	for(i=0; i < pkt1.length; i++)begin
		@(posedge clk);
		port = portin[pkt1.dest_port];
		data = pkt1.data[i];
	end
//Assign port = 4'bx and data = 64'bx after the last data packet
	port <= 4'bx;
	data <= 64'bx;
endtask : drive_packet
endmodule