## Pipelined  Processor

32-bit MIPS processor written in Verilog while taking Digital Computer Architecture.

#### Details:
+ Implements instructions from the MIPS instruction set.
+ Five stage pipeline: Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), Memory (MEM), and Write Back (WB). 
+ Data forwarding unit to eliminate data dependencies. Forwards from the MEM and WB stages to the EX stage.
+ Hazard detection unit which stalls the pipelne to eliminate hazards such as the load-use hazard and inserts noops for branches and jumps.
+ Separate instruction and data memories.
+ Datapath with program counter, pipeline registers, register file, ALU, and other processor components.
+ Main Controller and ALU Controller.
