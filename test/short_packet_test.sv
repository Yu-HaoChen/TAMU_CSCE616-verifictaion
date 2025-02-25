class short_packet_test extends base_test;

  `uvm_component_utils(short_packet_test)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    uvm_config_wrapper::set(this, "tb.vsequencer.run_phase", "default_sequence", short_packet_vsequence::type_id::get());
    super.build_phase(phase);
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_type_name(), "Starting short packet test", UVM_NONE)
  endtask : run_phase

endclass : short_packet_test

///////////////////////////// VIRTUAL SEQUENCE ///////////////////////////

class short_packet_vsequence extends htax_base_vseq;

  `uvm_object_utils(short_packet_vsequence)

  htax_packet_c req0,req1,req2,req3;

  function new (string name = "random_vsequence");
    super.new(name);
  endfunction : new

  task body();
		// Exectuing 10 TXNs on ports {0,1,2,3} randomly 
    repeat(200) begin
	fork
	begin	
		`uvm_info(get_type_name(),"Starting test on port 0", UVM_NONE)

		`uvm_do_on_with(req0,p_sequencer.htax_seqr[0], {req0.dest_port == 0; req0.length ==10; req0.delay ==4;})
	end
	
	begin	
		`uvm_info(get_type_name(),"Starting test on port 1", UVM_NONE)
		`uvm_do_on_with(req1,p_sequencer.htax_seqr[1], {req1.dest_port == 1; req1.length ==10; req1.delay ==4;})
	end

	begin	
		`uvm_info(get_type_name(),"Starting test on port 2", UVM_NONE)
		`uvm_do_on_with(req2,p_sequencer.htax_seqr[2], {req2.dest_port == 2; req2.length ==10; req2.delay ==4;})
	end

	begin	
		`uvm_info(get_type_name(),"Starting test on port 3", UVM_NONE)
		`uvm_do_on_with(req3,p_sequencer.htax_seqr[3], {req3.dest_port == 3; req3.length ==10; req3.delay ==4;})
	end

	join
  end
  endtask : body
endclass : short_packet_vsequence