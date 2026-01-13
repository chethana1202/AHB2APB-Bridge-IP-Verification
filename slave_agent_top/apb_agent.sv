class apb_agent extends uvm_agent;

apb_driver apb_drvh;
apb_monitor apb_monh;

apb_config apb_cfg;

`uvm_component_utils(apb_agent)

function new(string name="apb_agent",uvm_component parent=null);
    super.new(name,parent);
endfunction:new

function void build_phase(uvm_phase phase);
    if(!uvm_config_db #(apb_config)::get(this,"","apb_config",apb_cfg))
    `uvm_fatal("apb_config","cannot get() the configuration apb_cfg")

    apb_monh=apb_monitor::type_id::create("apb_monh",this);

    if(apb_cfg.is_active == UVM_ACTIVE)
    apb_drvh=apb_driver::type_id::create("apb_drvh",this);

    super.build_phase(phase);
endfunction:build_phase

endclass:apb_agent
