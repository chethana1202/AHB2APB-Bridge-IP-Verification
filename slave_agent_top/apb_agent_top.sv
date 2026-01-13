class apb_agent_top extends uvm_env;

apb_agent apb_agnth;
env_config env_cfg;

`uvm_component_utils(apb_agent_top)

function new(string name="apb_agent_top",uvm_component parent=null);
    super.new(name,parent);
endfunction:new

function void build_phase(uvm_phase phase);
    if(!uvm_config_db #(env_config)::get(this,"","env_config",env_cfg))
    `uvm_fatal("env_config","cannot get() the configuration env_cfg")

    uvm_config_db #(apb_config)::set(this,"apb_agnth*","apb_config",env_cfg.apb_cfg);
    apb_agnth=apb_agent::type_id::create("apb_agnth",this);
    super.build_phase(phase);

endfunction:build_phase

endclass:apb_agent_top
