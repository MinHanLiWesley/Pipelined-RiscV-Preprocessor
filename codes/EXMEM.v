module EXMEM(clk_i,
             rst_i,
             RegWrite_i,
             MemtoReg_i,
             MemRead_i,
             MemWrite_i,
             ALU_result_i,
             MUX_result_i,
             instr_11_i,
             RegWrite_o,
             MemtoReg_o,
             MemRead_o,
             MemWrite_o,
             ALU_result_o,
             MUX_result_o,
             instr_11_o);
    input               clk_i,rst_i,RegWrite_i,MemtoReg_i,MemRead_i,MemWrite_i;
    input  [31:0]       ALU_result_i,MUX_result_i;
    input  [4:0]        instr_11_i;
    
    output  reg         RegWrite_o,MemtoReg_o,MemRead_o,MemWrite_o;
    output  reg  [31:0] ALU_result_o;
    output  reg  [4:0]  instr_11_o;
    output  reg  [31:0] MUX_result_o;
    
    always @(posedge clk_i  ) begin
        
            RegWrite_o   <= RegWrite_i;
            MemtoReg_o   <= MemtoReg_i;
            MemRead_o    <= MemRead_i;
            MemWrite_o   <= MemWrite_i;
            ALU_result_o <= ALU_result_i;
            instr_11_o   <= instr_11_i;
            MUX_result_o <= MUX_result_i;
    
        
    end
endmodule
