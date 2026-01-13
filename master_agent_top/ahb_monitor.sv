class ahb_monitor extends uvm_monitor;

`uvm_component_utils(ahb_monitor)

uvm_analysis_port #(ahb_trans) ahb_ap;

virtual ahb_interface.AHB_MON vif;
ahb_config ahb_cfg;

function new(string name="ahb_monitor",uvm_component parent=null);
    super.new(name,parent);
    ahb_ap=new("ahb_ap",this);
endfunction:new

function void build_phase(uvm_phase phase);
    if(!uvm_config_db #(ahb_config)::get(this,"","ahb_config",ahb_cfg))
    `uvm_fatal("ahb_config","cannot get() the configuration ahb_cfg")
    super.build_phase(phase);
endfunction:build_phase

function void connect_phase(uvm_phase phase);
    vif=ahb_cfg.vif;
endfunction:connect_phase

task run_phase(uvm_phase phase);
forever
    begin
        collect_data();
    end
endtask:run_phase

task collect_data();
    ahb_trans xtn;
    xtn=ahb_trans::type_id::create("xtn");

    wait(vif.ahb_mon_cb.hreadyout==1)
//    while(vif.ahb_mon_cb.hreadyout!==1)
   // @(vif.ahb_mon_cb);

    xtn.haddr = vif.ahb_mon_cb.haddr;
    xtn.hsize = vif.ahb_mon_cb.hsize;
    xtn.hwrite = vif.ahb_mon_cb.hwrite;
    xtn.htrans = vif.ahb_mon_cb.htrans;
    xtn.hburst = vif.ahb_mon_cb.hburst;
    xtn.hreadyin = vif.ahb_mon_cb.hreadyin;

    @(vif.ahb_mon_cb);
    wait(vif.ahb_mon_cb.hreadyout==1)
 //   while(vif.ahb_mon_cb.hreadyout!==1)
   // @(vif.ahb_mon_cb);

    if(xtn.hwrite==1)
        xtn.hwdata = vif.ahb_mon_cb.hwdata;
    else
        xtn.hrdata = vif.ahb_mon_cb.hrdata;

    `uvm_info(get_type_name(),$sformatf("Data sampled from the DUT\n:%s",xtn.sprint()),UVM_LOW)

    ahb_ap.write(xtn);

endtask:collect_data

endclass:ahb_monitor
