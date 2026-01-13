class ahb_agent extends uvm_agent;

ahb_sequencer ahb_seqrh;
ahb_driver ahb_drvh;
ahb_monitor ahb_monh;

ahb_config ahb_cfg;

`uvm_component_utils(ahb_agent)

function new(string name="ahb_agent",uvm_component parent=null);
    super.new(name,parent);
endfunction:new

function void build_phase(uvm_phase phase);
    if(!uvm_config_db #(ahb_config)::get(this,"","ahb_config",ahb_cfg))
    `uvm_fatal("ahb_config","cannot get() the configuration ahb_cfg")

    ahb_monh=ahb_monitor::type_id::create("ahb_monh",this);

    if(ahb_cfg.is_active == UVM_ACTIVE)
        begin
            ahb_drvh=ahb_driver::type_id::create("ahb_drvh",this);
            ahb_seqrh=ahb_sequencer::type_id::create("ahb_seqrh",this);
        end

    super.build_phase(phase);
endfunction:build_phase

function void connect_phase(uvm_phase phase);
    if(ahb_cfg.is_active == UVM_ACTIVE)
    ahb_drvh.seq_item_port.connect(ahb_seqrh.seq_item_export);
endfunction:connect_phase

endclass:ahb_agent
