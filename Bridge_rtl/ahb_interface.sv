interface ahb_interface(input bit clk);

logic hresetn;
logic [1:0] htrans;
logic hwrite;
logic hreadyin;
logic [2:0] hsize;
logic [31:0] haddr;
logic [31:0] hwdata;
logic [2:0] hburst;
logic hreadyout;
logic [1:0] hresp;
logic [31:0] hrdata;

clocking ahb_drv_cb@(posedge clk);
default input #1 output #0;
output hresetn;
output htrans;
output hwrite;
output hreadyin;
output hsize;
output haddr;
output hwdata;
output hburst;
input hreadyout;
endclocking:ahb_drv_cb

clocking ahb_mon_cb@(posedge clk);
default input #1 output #0;
input hresetn;
input htrans;
input hwrite;
input hreadyin;
input hsize;
input haddr;
input hwdata;
input hburst;
input hreadyout;
input hresp;
input hrdata;
endclocking:ahb_mon_cb

modport AHB_DRV(clocking ahb_drv_cb);
modport AHB_MON(clocking ahb_mon_cb);

endinterface:ahb_interface

interface apb_intf(input bit clk);

logic pwrite;
logic [3:0] pselx;
logic penable;
logic [31:0] paddr;
logic [31:0] prdata;
logic [31:0] pwdata;

clocking apb_drv_cb@(posedge clk);
default input #1 output #0;
output prdata;
input pselx;
input penable;
input pwrite;
endclocking:apb_drv_cb

clocking apb_mon_cb@(posedge clk);
default input #1 output #0;
input paddr;
input pwdata;
input pselx;
input penable;
input pwrite;
input prdata;
endclocking:apb_mon_cb

modport APB_DRV(clocking apb_drv_cb);
modport APB_MON(clocking apb_mon_cb);

endinterface:apb_intf

