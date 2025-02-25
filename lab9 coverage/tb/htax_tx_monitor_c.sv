class htax_tx_monitor_c extends uvm_monitor;
	
	parameter PORTS = `PORTS;	

	`uvm_component_utils(htax_tx_monitor_c)

	uvm_analysis_port #(htax_tx_mon_packet_c)	tx_collect_port;
	
	virtual interface htax_tx_interface htax_tx_intf;
	htax_tx_mon_packet_c tx_mon_packet;
	int pkt_len;

  covergroup cover_htax_packet;
    option.per_instance = 1;
    option.name = "cover_htax_packet";


    // Coverpoint for htax packet field : destination port
    DEST_PORT : coverpoint tx_mon_packet.dest_port  {
        bins dest_port[] = {[0:3]};
    }

    // TO DO : Coverpoint for htax packet field : vc (include vc=0 in illegal bin)
		//VC : 	
	VC : coverpoint tx_mon_packet.vc {
        bins valid_vc[] = {[1:`VC-1]};  // 合法 VC 值
        illegal_bins illegal_vc = {0};  // VC=0 是非法值
    }


    // TO DO : Coverpoint for htax packet field : length (Divide range [3:63] into 16 bins)
		//LENGTH : 
	LENGTH : coverpoint tx_mon_packet.length {
        bins length_bins[16] = {[3:7], [8:12], [13:17], [18:22],
                              [23:27], [28:32], [33:37], [38:42],
                              [43:47], [48:52], [53:57], [58:63]};
    }

	// Coverpoints for Crosses
	// TO DO : DEST_PORT cross VC
	DEST_PORT_cross_VC : cross DEST_PORT, VC;

	// TO DO : DEST_PORT cross LENGTH
	DEST_PORT_cross_LENGTH : cross DEST_PORT, LENGTH;

	// TO DO : VC cross LENGTH
	VC_cross_LENGTH : cross VC, LENGTH;

  endgroup

	covergroup cover_htax_tx_intf;
    option.per_instance = 1;
    option.name = "cover_htax_tx_intf";

		// TO DO : Coverpoint for tx_outport_req: covered all the values 0001,0010,0100,1000
		TX_OUTPORT_REQ : coverpoint htax_tx_intf.tx_outport_req {
			bins valid_values[] = {4'b0001, 4'b0010, 4'b0100, 4'b1000};
		}
		// TO DO : Coverpoint for tx_vc_req: All the VCs are requested atleast once. Ignore what is not allowed, or put it as illegal
		TX_VC_REQ : coverpoint htax_tx_intf.tx_vc_req {
			bins valid_vc_req[] = {[1:`VC-1]};  // 合法 VC 值
			illegal_bins illegal_vc_req = {0}; // 非法 VC 请求
		}
		// TO DO : Coverpoint for tx_vc_gnt: All the virtual channels are granted atleast once.
		TX_VC_GNT : coverpoint htax_tx_intf.tx_vc_gnt {
			bins valid_vc_gnt[] = {[1:`VC-1]};  // 合法 VC 授予
			illegal_bins illegal_vc_gnt = {0}; // 非法 VC 授予
		}

	endgroup

	//constructor
	function new (string name, uvm_component parent);
		super.new(name,parent);
		tx_collect_port = new("tx_collect_port",this);
		tx_mon_packet 	= new();

		//Instance for the covergroup cover_htax_packet
		this.cover_htax_packet = new();
		//Instance for the covergroup cover_htax_tx_intf
		this.cover_htax_tx_intf = new();
	endfunction : new

  //UVM build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
		if(!uvm_config_db#(virtual htax_tx_interface)::get(this,"","tx_vif",htax_tx_intf))
			`uvm_fatal("NO_TX_VIF",{"Virtual Interface needs to be set for ", get_full_name(),".tx_vif"})
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		forever begin
			pkt_len=0;
			
			//Assign tx_mon_packet.dest_port from htax_tx_intf.tx_outport_req
			@(posedge |htax_tx_intf.tx_vc_gnt) begin
				
				for(int i=0; i < PORTS; i++)
					if(htax_tx_intf.tx_outport_req[i]==1'b1)
						tx_mon_packet.dest_port = i;
				
				//Assign tx_vc_req to tx_mon_packet.vc
				tx_mon_packet.vc = htax_tx_intf.tx_vc_req;

				cover_htax_tx_intf.sample();       //Sample Coverage on htax_tx_intf  
			end		
					
			@(posedge htax_tx_intf.clk)
			//On consequtive cycles append htax_tx_intf.tx_data to tx_mon_packet.data[] till htax_tx_intf.tx_eot pulse
			while(htax_tx_intf.tx_eot==0) begin
					@(posedge htax_tx_intf.clk)
					tx_mon_packet.data = new[++pkt_len] (tx_mon_packet.data);
					tx_mon_packet.data[pkt_len-1]=htax_tx_intf.tx_data;
			end
			//Assign pkt_len to tx_mon_packet.length
			tx_mon_packet.length = pkt_len;
			tx_collect_port.write(tx_mon_packet);
			cover_htax_packet.sample();       //Sample Coverage on tx_mon_packet
		end
	endtask : run_phase

endclass : htax_tx_monitor_c
