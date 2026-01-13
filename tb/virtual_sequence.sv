class virtual_sequence_base extends uvm_sequence #(uvm_sequence_item);

ahb_sequencer ahb_seqrh;
virtual_sequencer vseqrh;

`uvm_object_utils(virtual_sequence_base)

function new(string name="virtual_sequence_base");
    super.new(name);
endfunction:new

task body();
    assert($cast(vseqrh,m_sequencer))
    else
        `uvm_error(get_full_name(),"virtual sequencer pointer cast failed")
    ahb_seqrh=vseqrh.ahb_seqrh;
endtask:body

endclass:virtual_sequence_base

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class virtual_single_sequence extends virtual_sequence_base;

ahb_single_sequence ahb_single_seqh;

`uvm_object_utils(virtual_single_sequence)

function new(string name="virtual_single_sequence");
    super.new(name);
endfunction:new

task body();
    super.body();
    ahb_single_seqh=ahb_single_sequence::type_id::create("ahb_single_seqh");
    fork
        begin
            ahb_single_seqh.start(ahb_seqrh);
        end
    join
endtask:body

endclass:virtual_single_sequence

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class virtual_incr_sequence extends virtual_sequence_base;

ahb_incr_sequence ahb_incr_seqh;

`uvm_object_utils(virtual_incr_sequence)

function new(string name="virtual_incr_sequence");
    super.new(name);
endfunction:new

task body();
    super.body();
    ahb_incr_seqh=ahb_incr_sequence::type_id::create("ahb_incr_seqh");
    fork
        begin
            ahb_incr_seqh.start(ahb_seqrh);
        end
    join
endtask:body

endclass:virtual_incr_sequence

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class virtual_wrap_sequence extends virtual_sequence_base;

ahb_wrap_sequence ahb_wrap_seqh;

`uvm_object_utils(virtual_wrap_sequence)

function new(string name="virtual_wrap_sequence");
    super.new(name);
endfunction:new

task body();
    super.body();
    ahb_wrap_seqh=ahb_wrap_sequence::type_id::create("ahb_wrap_seqh");
    fork
        begin
            ahb_wrap_seqh.start(ahb_seqrh);
        end
    join
endtask:body

endclass:virtual_wrap_sequence

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
