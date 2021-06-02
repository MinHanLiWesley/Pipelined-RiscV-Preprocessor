module Hazard_Detection(MemRead_i,
                        instr_11_i,
                        instr_19_i,
                        instr_24_i,
                        stall_o,
                        PCwrite_o,
                        Noop_o);
    
    
    input               MemRead_i;
    input  [4:0]        instr_11_i;
    input  [4:0]        instr_19_i;
    input  [4:0]        instr_24_i;
    output reg          stall_o;
    output reg          PCwrite_o;
    output reg          Noop_o;
    
    always @(*) begin
        if (MemRead_i && ((instr_11_i==instr_24_i) || (instr_11_i==instr_19_i))) begin
            assign stall_o   = 1;
            assign PCwrite_o = 0;
            assign Noop_o    = 1;
        end
        else begin
            assign stall_o   = 0;
            assign PCwrite_o = 1;
            assign Noop_o    = 0;
        end
    end
endmodule
