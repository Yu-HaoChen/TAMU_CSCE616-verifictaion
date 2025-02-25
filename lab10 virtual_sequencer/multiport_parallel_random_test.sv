class multiport_parallel_random_test extends base_test;

  `uvm_component_utils(multiport_parallel_random_test)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    uvm_config_wrapper::set(this,"tb.vsequencer.run_phase", "default_sequence", parallel_random_vsequence::type_id::get());
    super.build_phase(phase);
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_type_name(),"Starting multiport parallel test",UVM_NONE)
  endtask : run_phase

endclass : multiport_parallel_random_test

///////////////////////////// VIRTUAL SEQUENCE ///////////////////////////

class parallel_random_vsequence extends htax_base_vseq;

  `uvm_object_utils(parallel_random_vsequence)

  rand int port;

  function new (string name = "parallel_random_vsequence");
    super.new(name);
  endfunction : new

  task body();
    // 執行 10 次傳輸並行在埠 {0,1,2,3}
    repeat(10) begin
      fork
        `uvm_do_on(req, p_sequencer.htax_seqr[0])
        `uvm_do_on(req, p_sequencer.htax_seqr[1])
        `uvm_do_on(req, p_sequencer.htax_seqr[2])
        `uvm_do_on(req, p_sequencer.htax_seqr[3])
      join
    end
  endtask : body

endclass : parallel_random_vsequence