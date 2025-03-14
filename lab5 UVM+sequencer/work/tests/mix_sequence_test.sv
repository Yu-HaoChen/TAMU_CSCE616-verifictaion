///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////

class mix_sequence_test extends base_test;

	`uvm_component_utils(mix_sequence_test)

	htax_sequencer_c sequencer; //Sequencer handle
	htax_tx_driver_c driver;		//Driver Handle
	
	//Sequence Handle
	fix_dest_port_seq fix_dest_port_seq_;						//fix_dest_port sequence handle
	
	//TO DO - Create handle(pointer) for the sequences
	short_packet_seq short_packet_seq_; // Short packet sequence handle
	long_packet_short_delay_seq long_packet_short_delay_seq_; // Long packet short delay sequence handle
	med_packet_fix_vc_seq med_packet_fix_vc_seq_; // Medium packet fix VC sequence handle
	random_seq random_seq_; // True random VC sequence handle

	//Constructor
	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	//UVM build phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		sequencer = htax_sequencer_c::type_id::create("sequencer",this);	//Sequencer factory instantiation
		driver 		= htax_tx_driver_c::type_id::create("driver",this);			//Driver factory instantiation
		
		//UVM instance of sequence using factory
		fix_dest_port_seq_ 			= fix_dest_port_seq::type_id::create("fix_dest_port_seq_");	

		//TO DO - Create UVM instance of sequences using factory
		short_packet_seq_ = short_packet_seq::type_id::create("short_packet_seq_");
    	long_packet_short_delay_seq_ = long_packet_short_delay_seq::type_id::create("long_packet_short_delay_seq_");
    	med_packet_fix_vc_seq_ = med_packet_fix_vc_seq::type_id::create("med_packet_fix_vc_seq_");
    	random_seq_ = random_seq::type_id::create("random_seq_");

	endfunction : build_phase

  function void connect_phase(uvm_phase phase);
      driver.seq_item_port.connect(sequencer.seq_item_export);				//Sequencer<-->Driver connection
  endfunction : connect_phase

	//UVM run phase
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
		`uvm_info(get_type_name(),"Starting Mix Sequence Test", UVM_NONE)
		phase.raise_objection(this); //Raising objection to prevent the test to end in between
		
		//Starting sequence on sequencer
		fix_dest_port_seq_.start(sequencer);

		//TO DO - Start the sequences on sequencer
		short_packet_seq_.start(sequencer);
    	long_packet_short_delay_seq_.start(sequencer);
    	med_packet_fix_vc_seq_.start(sequencer);
    	random_seq_.start(sequencer);

		phase.drop_objection(this);  //droping objection 
		phase.phase_done.set_drain_time(this, 5us); //drain time after objection is drop
	endtask : run_phase

endclass : mix_sequence_test
