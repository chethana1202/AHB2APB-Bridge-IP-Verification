class apb_monitor extends uvm_monitor;

`uvm_component_utils(apb_monitor)

virtual apb_intf.APB_MON vif;
apb_config apb_cfg;

uvm_analysis_port #(apb_trans) apb_ap;

function new(string name="apb_monitor",uvm_component parent=null);
    super.new(name,parent);
    apb_ap=new("apb_ap",this);
endfunction:new

function void build_phase(uvm_phase phase);
    if(!uvm_config_db #(apb_config)::get(this,"","apb_config",apb_cfg))
    `uvm_fatal("apb_config","cannot get() the configuration apb_cfg")
    super.build_phase(phase);
endfunction:build_phase

function void connect_phase(uvm_phase phase);
    vif=apb_cfg.vif;
super.connect_phase(phase);
endfunction:connect_phase

task run_phase(uvm_phase phase);
    forever
        collect_data();
endtask:run_phase

task collect_data();
    apb_trans xtn;
    xtn=apb_trans::type_id::create("xtn");
    
   wait(vif.apb_mon_cb.penable==1)
//    while(vif.apb_mon_cb.penable!==1)
//    @(vif.apb_mon_cb);

    xtn.paddr = vif.apb_mon_cb.paddr;
    xtn.pwrite = vif.apb_mon_cb.pwrite;
    xtn.pselx = vif.apb_mon_cb.pselx;
    xtn.penable = vif.apb_mon_cb.penable;

    if(xtn.pwrite==1)
    xtn.pwdata = vif.apb_mon_cb.pwdata;
    else
    xtn.prdata = vif.apb_mon_cb.prdata;
    repeat(2)
    @(vif.apb_mon_cb);

    `uvm_info(get_type_name(),$sformatf("Data sampled from the apb monitor\n:%s",xtn.sprint()),UVM_LOW)

    apb_ap.write(xtn);
endtask:collect_data

endclass:apb_monitor
