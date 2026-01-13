class base_test extends uvm_test;

env_config env_cfg;
ahb_config ahb_cfg;
apb_config apb_cfg;

environment envh;

int has_scoreboard=1;
int has_virtual_sequencer=1;

`uvm_component_utils(base_test)

function new(string name="base_test",uvm_component parent=null);
    super.new(name,parent);
endfunction:new

function void build_phase(uvm_phase phase);
    env_cfg=env_config::type_id::create("env_cfg");
    
    ahb_cfg=ahb_config::type_id::create("ahb_cfg");

    ahb_cfg.is_active=UVM_ACTIVE;
    if(!uvm_config_db #(virtual ahb_interface)::get(this,"","vif",ahb_cfg.vif))
    `uvm_fatal("ahb config","cannot get the virtual interface from ahb config")

    env_cfg.ahb_cfg=ahb_cfg;

    apb_cfg=apb_config::type_id::create("apb_cfg");

    apb_cfg.is_active=UVM_ACTIVE;

    if(!uvm_config_db #(virtual apb_intf)::get(this,"","vif0",apb_cfg.vif))
    `uvm_fatal("apb config","cannot get the virtual interface from apb config")

    env_cfg.apb_cfg=apb_cfg;

    env_cfg.has_scoreboard=has_scoreboard;
    env_cfg.has_virtual_sequencer=has_virtual_sequencer;

    uvm_config_db #(env_config)::set(this,"*","env_config",env_cfg);

    envh=environment::type_id::create("envh",this);
endfunction:build_phase

function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
endfunction:end_of_elaboration_phase

endclass:base_test

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class single_sequence_test extends base_test;

virtual_single_sequence vsingle_seqh;

`uvm_component_utils(single_sequence_test)

function new(string name="single_sequence_test",uvm_component parent=null);
    super.new(name,parent);
endfunction:new

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction:build_phase

function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
endfunction:end_of_elaboration_phase

task run_phase(uvm_phase phase);

    phase.raise_objection(this);
    begin

    vsingle_seqh=virtual_single_sequence::type_id::create("vsingle_seqh");

    vsingle_seqh.start(envh.vseqrh);
    end
    #50;

    phase.drop_objection(this);
endtask:run_phase

endclass:single_sequence_test

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class incr_sequence_test extends base_test;

virtual_incr_sequence vincr_seqh;

`uvm_component_utils(incr_sequence_test)

function new(string name="incr_sequence_test",uvm_component parent=null);
    super.new(name,parent);
endfunction:new

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction:build_phase

function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
endfunction:end_of_elaboration_phase

task run_phase(uvm_phase phase);

    phase.raise_objection(this);
    begin

    vincr_seqh=virtual_incr_sequence::type_id::create("vincr_seqh");

    vincr_seqh.start(envh.vseqrh);
    end

    #50;

    phase.drop_objection(this);
endtask:run_phase

endclass:incr_sequence_test

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class wrap_sequence_test extends base_test;

virtual_wrap_sequence vwrap_seqh;

`uvm_component_utils(wrap_sequence_test)

function new(string name="wrap_sequence_test",uvm_component parent=null);
    super.new(name,parent);
endfunction:new

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction:build_phase

function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
endfunction:end_of_elaboration_phase

task run_phase(uvm_phase phase);

    phase.raise_objection(this);
    begin

    vwrap_seqh=virtual_wrap_sequence::type_id::create("vwrap_seqh");

    vwrap_seqh.start(envh.vseqrh);
    end
    #50;

    phase.drop_objection(this);
endtask:run_phase

endclass:wrap_sequence_test
