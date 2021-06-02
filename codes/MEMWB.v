module MEMWB(clk_i,
             rst_i,
             RegWrite_i,
             MemtoReg_i,
             addr_i,
             Read_data_i,
             instr_11_i,
             RegWrite_o,
             MemtoReg_o,
             addr_o,
             Read_data_o,
             instr_11_o);
    
    
    input clk_i,rst_i,RegWrite_i,MemtoReg_i;
    input [31:0] addr_i,Read_data_i;
    input [4:0]  instr_11_i;
    
    output reg RegWrite_o,MemtoReg_o;
    output reg [31:0] addr_o,Read_data_o;
    output reg [4:0]   instr_11_o;
    
    always @(posedge clk_i) begin
        
        RegWrite_o  <= RegWrite_i;
        MemtoReg_o  <= MemtoReg_i;
        addr_o      <= addr_i;
        Read_data_o <= Read_data_i;
        instr_11_o  <= instr_11_i;
        
    end
endmodule
