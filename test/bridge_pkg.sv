package bridge_pkg;

import uvm_pkg::*;

typedef enum{UVM_ACTIVE,UVM_PASSIVE} uvm_active_passive_enum;

`include "uvm_macros.svh"
`include "ahb_trans.sv"
`include "apb_trans.sv"
`include "ahb_config.sv"
`include "apb_config.sv"
`include "env_config.sv"
`include "ahb_sequencer.sv"
`include "ahb_driver.sv"
`include "apb_driver.sv"
`include "ahb_monitor.sv"
`include "apb_monitor.sv"
`include "ahb_agent.sv"
`include "apb_agent.sv"
`include "ahb_agent_top.sv"
`include "apb_agent_top.sv"
`include "virtual_sequencer.sv"
`include "scoreboard.sv"
`include "environment.sv"
`include "ahb_sequence.sv"
`include "virtual_sequence.sv"
`include "test.sv"

endpackage
