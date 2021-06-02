module IFID(clk_i,
            rst_i,
            flush_i,
            stall_i,
            instr_i,
            addr_i,
            instr_o,
            addr_o);
    
    input               clk_i;
    input               rst_i;
    input               flush_i;
    input               stall_i;
    input       [31:0]  instr_i;
    output  reg [31:0]  instr_o;
    input       [31:0]  addr_i;
    output  reg [31:0]  addr_o;
    
    always @(posedge clk_i ) begin
            if (flush_i) begin
                addr_o  <= 0 ;
                instr_o <= 0;
            end
            //no stall
            else if (stall_i != 1)begin
            addr_o  <= addr_i;
            instr_o <= instr_i;
        end
    end
    
    // else stall, o remain the same
    

    // end
    
    // end
endmodule
