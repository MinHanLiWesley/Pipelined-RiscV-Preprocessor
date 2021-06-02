module IDEX(clk_i,
            rst_i,
            RegWrite_i,
            MemtoReg_i,
            MemRead_i,
            MemWrite_i,
            ALUOp_i,
            ALUSrc_i,
            Read_data1_i,
            Read_data2_i,
            Imm_gen_i,
            instr_31_i,
            instr_19_i,
            instr_24_i,
            instr_11_i,
            RegWrite_o,
            MemtoReg_o,
            MemRead_o,
            MemWrite_o,
            ALUOp_o,
            ALUSrc_o,
            Read_data1_o,
            Read_data2_o,
            Imm_gen_o,
            instr_31_o,
            instr_19_o,
            instr_24_o,
            instr_11_o);
    
    
    
    
    input               clk_i,rst_i,RegWrite_i,MemtoReg_i,MemRead_i,MemWrite_i,ALUSrc_i;
    input       [1:0]   ALUOp_i;
    input       [9:0]   instr_31_i;
    input       [4:0]   instr_19_i,instr_24_i,instr_11_i;
    input       [31:0]  Read_data1_i,Read_data2_i,Imm_gen_i;
    output   reg         clk_o, RegWrite_o,MemtoReg_o,MemRead_o,MemWrite_o,ALUSrc_o;
    output   reg [1:0]   ALUOp_o;
    output   reg [9:0]   instr_31_o;
    output   reg [4:0]   instr_19_o,instr_24_o,instr_11_o;
    output   reg [31:0]  Read_data1_o,Read_data2_o,Imm_gen_o;
    
    always @(posedge clk_i) begin
        
            RegWrite_o   <= RegWrite_i;
            MemtoReg_o   <= MemtoReg_i;
            MemRead_o    <= MemRead_i;
            MemWrite_o   <= MemWrite_i;
            ALUOp_o      <= ALUOp_i;
            ALUSrc_o     <= ALUSrc_i;
            instr_31_o   <= instr_31_i;
            instr_19_o   <= instr_19_i;
            instr_24_o   <= instr_24_i;
            instr_11_o   <= instr_11_i;
            Read_data1_o <= Read_data1_i;
            Read_data2_o <= Read_data2_i;
            Imm_gen_o    <= Imm_gen_i;
    
        
        
    end
endmodule
