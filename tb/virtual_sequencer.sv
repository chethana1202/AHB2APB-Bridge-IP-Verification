class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);

ahb_sequencer ahb_seqrh;

`uvm_component_utils(virtual_sequencer)

function new(string name="virtual_sequencer",uvm_component parent=null);
    super.new(name,parent);
endfunction:new

endclass:virtual_sequencer
