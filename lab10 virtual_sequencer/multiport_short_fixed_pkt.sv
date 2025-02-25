class multiport_short_fixed_pkt extends base_test;

  `uvm_component_utils(multiport_short_fixed_pkt)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    uvm_config_wrapper::set(this, "tb.vsequencer.run_phase", "default_sequence", short_fixed_vsequence::type_id::get());
    super.build_phase(phase);
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_type_name(), "Starting multiport short packet test", UVM_NONE)
  endtask : run_phase

endclass : multiport_short_fixed_pkt

///////////////////////////// VIRTUAL SEQUENCE ///////////////////////////

class short_fixed_vsequence extends htax_base_vseq;

  `uvm_object_utils(short_fixed_vsequence)

  rand int port;

  function new (string name = "short_fixed_vsequence");
    super.new(name);
  endfunction : new

  task body();
    repeat(100) begin // 減少重複次數，更適合固定的短封包測試
      fork
        // 執行端口 0 測試
        begin
          `uvm_info(get_type_name(), "Starting short fixed packet test on port 0", UVM_NONE)
          `uvm_do_on_with(req, p_sequencer.htax_seqr[0], {
            req.length == 3;      // 設定封包長度為3
            req.delay == 2;       // 設定延遲為2
            req.vc == 1;          // 設定 VC 為 1
            req.dest_port == 0;   // 設定目標端口為 0
          })
        end
        // 執行端口 1 測試
        begin
          `uvm_info(get_type_name(), "Starting short fixed packet test on port 1", UVM_NONE)
          `uvm_do_on_with(req, p_sequencer.htax_seqr[1], {
            req.length == 3;
            req.delay == 2;
            req.vc == 1;
            req.dest_port == 1;
          })
        end
        // 執行端口 2 測試
        begin
          `uvm_info(get_type_name(), "Starting short fixed packet test on port 2", UVM_NONE)
          `uvm_do_on_with(req, p_sequencer.htax_seqr[2], {
            req.length == 3;
            req.delay == 2;
            req.vc == 1;
            req.dest_port == 2;
          })
        end
        // 執行端口 3 測試
        begin
          `uvm_info(get_type_name(), "Starting short fixed packet test on port 3", UVM_NONE)
          `uvm_do_on_with(req, p_sequencer.htax_seqr[3], {
            req.length == 3;
            req.delay == 2;
            req.vc == 1;
            req.dest_port == 3;
          })
        end
      join
    end
  endtask : body

endclass : short_fixed_vsequence