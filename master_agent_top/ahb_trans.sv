class ahb_trans extends uvm_sequence_item;

bit hresetn, hreadyin, hreadyout;

rand bit hwrite; 
rand bit [1:0] htrans;
rand bit [2:0] hsize;
rand bit [2:0] hburst;

rand bit [31:0] haddr;
rand bit [31:0] hwdata;

bit [31:0] hrdata;

rand bit [9:0] hlength;

`uvm_object_utils(ahb_trans)

function new(string name="ahb_trans");
    super.new(name);
endfunction:new

constraint valid_size{hsize inside{[0:2]};}
constraint aligned_haddr{hsize==1 -> haddr%2==0;
                         hsize==2 -> haddr%4==0;}
constraint valid_haddr{haddr inside{[32'h8000_0000:32'h8000_03ff],
                                    [32'h8400_0000:32'h8400_03ff],
                                    [32'h8800_0000:32'h8800_03ff],
                                    [32'h8c00_0000:32'h8c00_03ff]};}
constraint valid_length{hburst == 0 -> hlength == 1;
                        hburst == 1 -> hlength == (haddr % 1024) + (hlength*(2**hsize)) <= 1023;
                        hburst == 2 -> hlength == 4;
                        hburst == 3 -> hlength == 4;
                        hburst == 4 -> hlength == 8;
                        hburst == 5 -> hlength == 8;
                        hburst == 6 -> hlength == 16;
                        hburst == 7 -> hlength == 16;}

function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_field("hresetn",this.hresetn,1,UVM_BIN);
    printer.print_field("hwrite",this.hwrite,1,UVM_BIN);
    printer.print_field("hreadyin",this.hreadyin,1,UVM_BIN);
    printer.print_field("hreadyout",this.hreadyout,1,UVM_BIN);
    printer.print_field("htrans",this.htrans,2,UVM_DEC);
    printer.print_field("hsize",this.hsize,3,UVM_DEC);
    printer.print_field("hburst",this.hburst,3,UVM_DEC);
    printer.print_field("haddr",this.haddr,32,UVM_HEX);
    printer.print_field("hwdata",this.hwdata,32,UVM_HEX);
    printer.print_field("hrdata",this.hrdata,32,UVM_HEX);
    printer.print_field("hlength",this.hlength,10,UVM_DEC);
endfunction:do_print

endclass:ahb_trans
