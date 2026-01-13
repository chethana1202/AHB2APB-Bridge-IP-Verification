module top;

import bridge_pkg::*;
import uvm_pkg::*;

bit clock;

always 
    #5 clock = ~clock;

ahb_interface ahb_if(clock);
apb_intf apb_if(clock);

rtl_top DUV(.Hclk(clock),.Hresetn(ahb_if.hresetn),.Htrans(ahb_if.htrans),.Hsize(ahb_if.hsize),.Hreadyin(ahb_if.hreadyin),
            .Hwdata(ahb_if.hwdata),.Haddr(ahb_if.haddr),.Hwrite(ahb_if.hwrite),.Hrdata(ahb_if.hrdata),.Hresp(ahb_if.hresp),
            .Hreadyout(ahb_if.hreadyout),.Prdata(apb_if.prdata),.Pselx(apb_if.pselx),.Pwrite(apb_if.pwrite),.Penable(apb_if.penable),
            .Paddr(apb_if.paddr),.Pwdata(apb_if.pwdata));



initial
    begin
        
        uvm_config_db #(virtual ahb_interface)::set(null,"*","vif",ahb_if);
        uvm_config_db #(virtual apb_intf)::set(null,"*","vif0",apb_if);

        run_test();
    end

endmodule:top
