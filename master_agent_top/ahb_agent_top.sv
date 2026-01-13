class ahb_agent_top extends uvm_env;

ahb_agent ahb_agnth;

env_config env_cfg;

`uvm_component_utils(ahb_agent_top)

function new(string name="ahb_agent_top",uvm_component parent=null);
    super.new(name,parent);
endfunction:new

function void build_phase(uvm_phase phase);
    if(!uvm_config_db #(env_config)::get(this,"","env_config",env_cfg))
    `uvm_fatal("env_config","cannot get() the configuration env_cfg")

    uvm_config_db #(ahb_config)::set(this,"ahb_agnth*","ahb_config",env_cfg.ahb_cfg);
    ahb_agnth=ahb_agent::type_id::create("ahb_agnth",this);
    super.build_phase(phase);

endfunction:build_phase

endclass:ahb_agent_top
