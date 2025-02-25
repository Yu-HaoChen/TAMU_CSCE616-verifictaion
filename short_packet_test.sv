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

  rand int port;

  function new (string name = "short_packet_vsequence");
    super.new(name);
  endfunction : new

  task body();
    // 執行 100 次傳輸，針對短封包的測試
    repeat(100) begin
      fork
        // 測試端口 0
        begin
          `uvm_info(get_type_name(), "Starting short packet test on port 0", UVM_NONE)
          `uvm_do_on_with(req, p_sequencer.htax_seqr[0], {
            req.length == 6; 
            req.delay == 4;
            req.vc == 1; 
            req.dest_port == 0; 
          })
        end

        // 測試端口 1
        begin
          `uvm_info(get_type_name(), "Starting short packet test on port 1", UVM_NONE)
          `uvm_do_on_with(req, p_sequencer.htax_seqr[1], {
            req.length == 6; 
            req.delay == 4;
            req.vc == 1; 
            req.dest_port == 1;
          })
        end

        // 測試端口 2
        begin
          `uvm_info(get_type_name(), "Starting short packet test on port 2", UVM_NONE)
          `uvm_do_on_with(req, p_sequencer.htax_seqr[2], {
            req.length == 6; 
            req.delay == 4;
            req.vc == 1; 
            req.dest_port == 2;
          })
        end

        // 測試端口 3
        begin
          `uvm_info(get_type_name(), "Starting short packet test on port 3", UVM_NONE)
          `uvm_do_on_with(req, p_sequencer.htax_seqr[3], {
            req.length == 6; 
            req.delay == 4;
            req.vc == 1; 
            req.dest_port == 3;
          })
        end
      join
    end
  endtask : body

endclass : short_packet_vsequence