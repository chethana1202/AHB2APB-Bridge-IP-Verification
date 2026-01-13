class apb_driver extends uvm_driver #(apb_trans);

`uvm_component_utils(apb_driver)

virtual apb_intf.APB_DRV vif;
apb_config apb_cfg;

function new(string name="apb_driver",uvm_component parent=null);
    super.new(name,parent);
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
        send_to_dut();
endtask:run_phase

task send_to_dut();

apb_trans trans; 
       trans = apb_trans :: type_id::create("trans");
    wait(vif.apb_drv_cb.pselx!==0)
//    while(vif.apb_drv_cb.pselx==0)
  //  @(vif.apb_drv_cb);

    if(vif.apb_drv_cb.pwrite==0)
    begin
        wait(vif.apb_drv_cb.penable==1)
      //  while(vif.apb_drv_cb.penable!==1)
     //   @(vif.apb_drv_cb);

        vif.apb_drv_cb.prdata <= {$random};
    end
    repeat(2)
    @(vif.apb_drv_cb);
`uvm_info("APB_DRIVER",$sformatf("printing from driver \n %s", trans.sprint()),UVM_LOW)
endtask:send_to_dut

endclass:apb_driver
