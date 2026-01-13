class ahb_sequence extends uvm_sequence #(ahb_trans);

`uvm_object_utils(ahb_sequence)

function new(string name="ahb_sequence");
    super.new(name);
endfunction:new

endclass:ahb_sequence

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class ahb_single_sequence extends ahb_sequence;

`uvm_object_utils(ahb_single_sequence)

function new(string name="ahb_single_sequence");
    super.new(name);
endfunction:new

task body();
begin
        req=ahb_trans::type_id::create("req");
        start_item(req);
        assert(req.randomize() with {htrans == 2'b10;
                                     hwrite == 1'b1;});
        finish_item(req);
end
endtask:body

endclass:ahb_single_sequence

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class ahb_incr_sequence extends ahb_sequence;

`uvm_object_utils(ahb_incr_sequence)

function new(string name="ahb_incr_sequence");
    super.new(name);
endfunction:new

bit [31:0] addr;
bit [2:0] hburst, hsize;
bit hwrite;
bit [9:0] hlength;

task body();
begin
    req=ahb_trans::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {htrans == 2'b10;
                                 hburst inside{1,3,5,7};
                                 hwrite == 1'b1;});
    finish_item(req);

    addr=req.haddr;
    hsize=req.hsize;
    hburst=req.hburst;
    hwrite=req.hwrite;
    hlength=req.hlength;

    for(int i=1;i < hlength;i++)
    begin
        start_item(req);
        assert(req.randomize() with {htrans == 2'b11;
                                     hsize == hsize;
                                     hburst == hburst;
                                     hwrite == hwrite;
                                     req.haddr == addr + (2**hsize);});
        finish_item(req);

        this.addr=req.haddr;

    end
end
endtask:body

endclass:ahb_incr_sequence

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class ahb_wrap_sequence extends ahb_sequence;

`uvm_object_utils(ahb_wrap_sequence)

function new(string name="ahb_wrap_sequence");
    super.new(name);
endfunction:new

bit [31:0] addr;
bit [2:0] hburst, hsize;
bit hwrite;
bit [9:0] hlength;
bit [31:0] initial_addr;
bit [31:0] boundary_addr;         

task body();
begin
    req=ahb_trans::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {htrans == 2'b10;
                                 hburst inside{2,4,6};
                                 hwrite == 1'b1;});
    finish_item(req);

    addr=req.haddr;
    hsize=req.hsize;
    hburst=req.hburst;
    hwrite=req.hwrite;
    hlength=req.hlength;

    initial_addr = (addr/((2**hsize)*(hlength)))*((2**hsize)*(hlength));
    boundary_addr = initial_addr + ((2**hsize)*(hlength));
    
    addr = req.haddr + (2**hsize); //next addr calculation - this is to check whether the current address has reached the boundary address for every WO

    for(int i=1;i < hlength;i++)
    begin
        if(addr == boundary_addr)
        addr = initial_addr; //wrap back
        
        start_item(req);
        assert(req.randomize() with {htrans == 2'b11;
                                     hsize == hsize;
                                     hburst == hburst;
                                     hwrite == hwrite;
                                     haddr == addr;});
        finish_item(req);

        addr = req.haddr + (2**hsize);
    end
end
endtask:body

endclass:ahb_wrap_sequence

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
