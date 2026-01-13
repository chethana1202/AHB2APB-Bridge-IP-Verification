class ahb_driver extends uvm_driver #(ahb_trans);

`uvm_component_utils(ahb_driver)

function new(string name="ahb_driver",uvm_component parent=null);
super.new(name,parent);
endfunction:new

virtual ahb_interface.AHB_DRV vif;
ahb_config ahb_cfg;

function void build_phase(uvm_phase phase);
    if(!uvm_config_db #(ahb_config)::get(this,"","ahb_config",ahb_cfg))
    `uvm_fatal("ahb config","cannot get() the config ahb_cfg")
    super.build_phase(phase);
endfunction:build_phase

function void connect_phase(uvm_phase phase);
    vif=ahb_cfg.vif;
endfunction:connect_phase

task run_phase(uvm_phase phase);
    @(vif.ahb_drv_cb);
    vif.ahb_drv_cb.hresetn <= 1'b0;
    
//    $display("hresetn is 0");

    @(vif.ahb_drv_cb);
    vif.ahb_drv_cb.hresetn <= 1'b1;

  //  $display("hresetn is 1");

    forever
        begin
            seq_item_port.get_next_item(req);
            send_to_dut(req);
            seq_item_port.item_done();
        end
endtask:run_phase

task send_to_dut(ahb_trans req);
    req.print();
    wait(vif.ahb_drv_cb.hreadyout==1)
 //   while(vif.ahb_drv_cb.hreadyout==0)
   // @(vif.ahb_drv_cb);
    
    vif.ahb_drv_cb.haddr <= req.haddr;
    vif.ahb_drv_cb.hsize <= req.hsize;
    vif.ahb_drv_cb.hwrite <= req.hwrite;
    vif.ahb_drv_cb.htrans <= req.htrans;
    vif.ahb_drv_cb.hreadyin <= req.hreadyin;

    @(vif.ahb_drv_cb);
    wait(vif.ahb_drv_cb.hreadyout==1)
   // while(vif.ahb_drv_cb.hreadyout==1)
   // @(vif.ahb_drv_cb);

    if(req.hwrite==1)
        vif.ahb_drv_cb.hwdata <= req.hwdata;
    else
        vif.ahb_drv_cb.hwdata <= 32'b0;
endtask:send_to_dut

endclass:ahb_driver
