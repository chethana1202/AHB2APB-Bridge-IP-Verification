class scoreboard extends uvm_scoreboard;

uvm_tlm_analysis_fifo #(ahb_trans) ahb_fifoh;
uvm_tlm_analysis_fifo #(apb_trans) apb_fifoh;

ahb_trans ahb_xtn;
apb_trans apb_xtn;

`uvm_component_utils(scoreboard);

covergroup ahb_cg;
    HADDR:  coverpoint ahb_xtn.haddr{
                bins slave1 = {[32'h8000_0000:32'h8000_03ff]};
                bins slave2 = {[32'h8400_0000:32'h8400_03ff]};
                bins slave3 = {[32'h8800_0000:32'h8800_03ff]};
                bins slave4 = {[32'h8c00_0000:32'h8c00_03ff]};}
    HWRITE: coverpoint ahb_xtn.hwrite{
                bins write = {1};
                bins read = {0};}
    HSIZE:  coverpoint ahb_xtn.hsize{
                bins _byte = {0};
                bins half_word = {1};
                bins full_word = {2};}
    HADDR_X_HWRITE_X_HSIZE: cross HADDR,HWRITE,HSIZE;
endgroup:ahb_cg

covergroup apb_cg;
    PADDR:  coverpoint apb_xtn.paddr{
                bins slave1 = {[32'h8000_0000:32'h8000_03ff]};
                bins slave2 = {[32'h8400_0000:32'h8400_03ff]};
                bins slave3 = {[32'h8800_0000:32'h8800_03ff]};
                bins slave4 = {[32'h8c00_0000:32'h8c00_03ff]};}
    PWRITE: coverpoint apb_xtn.pwrite{
                bins write = {1};
                bins read = {0};}
    PSELX:  coverpoint apb_xtn.pselx{
                bins p1 = {1};
                bins p2 = {2};
                bins p4 = {4};
                bins p8 = {8};}
    PADDR_X_PWRITE_X_PSELX: cross PADDR,PWRITE,PSELX;
endgroup:apb_cg

function new(string name="scoreboard",uvm_component parent=null);
    super.new(name,parent);
    ahb_cg=new();
    apb_cg=new();
endfunction:new

function void build_phase(uvm_phase phase);
    ahb_fifoh=new("ahb_fifoh",this);
    apb_fifoh=new("apb_fifoh",this);
    super.build_phase(phase);
endfunction:build_phase


task run_phase(uvm_phase phase);
forever
    begin
        fork
             begin
                ahb_fifoh.get(ahb_xtn);
                `uvm_info(get_type_name(),$sformatf("AHB Data\n:%s",ahb_xtn.sprint()),UVM_LOW)
                ahb_cg.sample();
            end
    
            begin
                apb_fifoh.get(apb_xtn);
                `uvm_info(get_type_name(),$sformatf("APB Data\n:%s",apb_xtn.sprint()),UVM_LOW)
                ahb_cg.sample();
            end
        join
        check_data(ahb_xtn,apb_xtn);
    end
endtask:run_phase

task compare(int haddr,paddr,hdata,pdata);
    if(haddr == paddr)
        `uvm_info(get_type_name(),"Address comparison from AHB and APB side is successful",UVM_LOW)
    else
        `uvm_error(get_type_name(),"Address comparison from AHB and APB side is failed")

    if(hdata == pdata)
        `uvm_info(get_type_name(),"Data comparison from AHB and APB side is successful",UVM_LOW)
    else
        `uvm_error(get_type_name(),"Data comparison from AHB and APB side is failed")
endtask:compare

task check_data(ahb_trans ahb_xtn,apb_trans apb_xtn);

    if(ahb_xtn.hwrite == 1'b1)
    begin
        if(ahb_xtn.hsize == 3'd0)
        begin
            if(ahb_xtn.haddr[1:0] == 2'b00)
                compare(ahb_xtn.haddr,apb_xtn.paddr,ahb_xtn.hwdata[7:0],apb_xtn.pwdata);
            if(ahb_xtn.haddr[1:0] == 2'b01)
                compare(ahb_xtn.haddr,apb_xtn.paddr,ahb_xtn.hwdata[15:8],apb_xtn.pwdata);
            if(ahb_xtn.haddr[1:0] == 2'b10)
                compare(ahb_xtn.haddr,apb_xtn.paddr,ahb_xtn.hwdata[23:16],apb_xtn.pwdata);
            if(ahb_xtn.haddr[1:0] == 2'b11)
                compare(ahb_xtn.haddr,apb_xtn.paddr,ahb_xtn.hwdata[31:24],apb_xtn.pwdata);
        end
        
        if(ahb_xtn.hsize == 3'd1)
        begin
            if(ahb_xtn.haddr[1:0] == 2'b00)
                compare(ahb_xtn.haddr,apb_xtn.paddr,ahb_xtn.hwdata[15:0],apb_xtn.pwdata);
            if(ahb_xtn.haddr[1:0] == 2'b10)
                compare(ahb_xtn.haddr,apb_xtn.paddr,ahb_xtn.hwdata[31:16],apb_xtn.pwdata);
        end

        if(ahb_xtn.hsize == 3'd2)
            compare(ahb_xtn.haddr,apb_xtn.paddr,ahb_xtn.hwdata[31:0],apb_xtn.pwdata);
    end

    if(ahb_xtn.hwrite == 1'b0)
    begin
        if(ahb_xtn.hsize == 3'd0)
        begin
            if(ahb_xtn.haddr[1:0] == 2'b00)
                compare(ahb_xtn.haddr,apb_xtn.paddr,ahb_xtn.hrdata,apb_xtn.prdata[7:0]);
            if(ahb_xtn.haddr[1:0] == 2'b01)
                compare(ahb_xtn.haddr,apb_xtn.paddr,ahb_xtn.hrdata,apb_xtn.prdata[15:8]);
            if(ahb_xtn.haddr[1:0] == 2'b10)
                compare(ahb_xtn.haddr,apb_xtn.paddr,ahb_xtn.hrdata,apb_xtn.prdata[23:16]);
            if(ahb_xtn.haddr[1:0] == 2'b11)
                compare(ahb_xtn.haddr,apb_xtn.paddr,ahb_xtn.hrdata,apb_xtn.prdata[31:24]);
        end
        
        if(ahb_xtn.hsize == 3'd1)
        begin
            if(ahb_xtn.haddr[1:0] == 2'b00)
                compare(ahb_xtn.haddr,apb_xtn.paddr,ahb_xtn.hrdata,apb_xtn.prdata[15:0]);
            if(ahb_xtn.haddr[1:0] == 2'b10)
                compare(ahb_xtn.haddr,apb_xtn.paddr,ahb_xtn.hrdata,apb_xtn.prdata[31:16]);
        end

        if(ahb_xtn.hsize == 3'd2)
            compare(ahb_xtn.haddr,apb_xtn.paddr,ahb_xtn.hrdata,apb_xtn.pwdata[31:0]);
    end

endtask:check_data

endclass:scoreboard
