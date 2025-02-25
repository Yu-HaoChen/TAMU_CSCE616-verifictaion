class extreme_conditions_test extends base_test;

  `uvm_component_utils(extreme_conditions_test)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    uvm_config_wrapper::set(this,"tb.vsequencer.run_phase", "default_sequence", extreme_vsequence::type_id::get());
    super.build_phase(phase);
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_type_name(),"Starting extreme conditions test",UVM_NONE)
  endtask : run_phase

endclass : extreme_conditions_test

///////////////////////////// VIRTUAL SEQUENCE ///////////////////////////

class extreme_vsequence extends htax_base_vseq;

  `uvm_object_utils(extreme_vsequence)

  rand int port;

  function new (string name = "extreme_vsequence");
    super.new(name);
  endfunction : new

  task body();
    // 執行 10 次傳輸，在極端條件下測試
    repeat(10) begin
      port = $urandom_range(0, 3);
      `uvm_do_on_with(req, p_sequencer.htax_seqr[port], {
        req.delay == 1 || req.delay == 20;
        req.vc == 1;
        req.length == 3 || req.length == 63;
      })
    end
  endtask : body

endclass : extreme_vsequence