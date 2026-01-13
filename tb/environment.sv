class environment extends uvm_env;

env_config env_cfg;

ahb_agent_top ahb_agnt_toph;
apb_agent_top apb_agnt_toph;

virtual_sequencer vseqrh;
scoreboard sbh;

`uvm_component_utils(environment)

function new(string name="environment",uvm_component parent=null);
    super.new(name,parent);
endfunction:new

function void build_phase(uvm_phase phase);
    if(!uvm_config_db #(env_config)::get(this,"","env_config",env_cfg))
    `uvm_fatal("env_config","cannot get() the configuration env_cfg")

    ahb_agnt_toph=ahb_agent_top::type_id::create("ahb_agnt_toph",this);
    apb_agnt_toph=apb_agent_top::type_id::create("apb_agnt_toph",this);

    if(env_cfg.has_scoreboard)
    sbh=scoreboard::type_id::create("sbh",this);

    if(env_cfg.has_virtual_sequencer)
    vseqrh=virtual_sequencer::type_id::create("vseqrh",this);

    super.build_phase(phase);
endfunction:build_phase

function void connect_phase(uvm_phase phase);
    if(env_cfg.has_scoreboard)
    begin
        ahb_agnt_toph.ahb_agnth.ahb_monh.ahb_ap.connect(sbh.ahb_fifoh.analysis_export);
        apb_agnt_toph.apb_agnth.apb_monh.apb_ap.connect(sbh.apb_fifoh.analysis_export);
    end

    if(env_cfg.has_virtual_sequencer)
    vseqrh.ahb_seqrh=ahb_agnt_toph.ahb_agnth.ahb_seqrh;
endfunction:connect_phase

endclass:environment
