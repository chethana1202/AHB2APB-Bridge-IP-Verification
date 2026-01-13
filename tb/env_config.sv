class env_config extends uvm_object;

`uvm_object_utils(env_config)

function new(string name="env_config");
super.new(name);
endfunction:new

ahb_config ahb_cfg;
apb_config apb_cfg;

int has_scoreboard;
int has_virtual_sequencer;

endclass:env_config
