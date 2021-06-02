module Control (Op_i,
                Noop_i,
                Branch_o,
                MemtoReg_o,
                MemRead_o,
                MemWrite_o,
                ALUOp_o,
                ALUSrc_o,
                RegWrite_o);
    
    //ports
    input   [6:0]   Op_i;
    input           Noop_i;
    output    reg      Branch_o;
    output     reg     MemtoReg_o;
    output     reg     MemRead_o;
    output     reg     MemWrite_o;
    output  reg [1:0]  ALUOp_o;
    output  reg        ALUSrc_o;
    output    reg      RegWrite_o;
    
    always @(*) begin
        // R type
        if (Noop_i == 1) begin
            ALUOp_o    <= 2'b00;
            ALUSrc_o   <= 0;
            MemtoReg_o <= 0;
            MemRead_o  <= 0;
            MemWrite_o <= 0;
            RegWrite_o <= 0;
            Branch_o   <= 0;
        end
        else if (Noop_i == 0)begin
            //r
            if (Op_i == 51) begin
                ALUOp_o    <= 2'b10;
                ALUSrc_o   <= 0;
                MemtoReg_o <= 0;
                MemRead_o  <= 0;
                MemWrite_o <= 0;
                RegWrite_o <= 1;
                Branch_o   <= 0;
                // I type
                end else if (Op_i == 19) begin
                ALUOp_o    <= 2'b11;
                ALUSrc_o   <= 1;
                MemtoReg_o <= 0;
                MemRead_o  <= 0;
                MemWrite_o <= 0;
                RegWrite_o <= 1;
                Branch_o   <= 0;
                // lw
                end else if (Op_i == 7'b0000011) begin
                ALUOp_o    <= 2'b00;
                ALUSrc_o   <= 1;
                MemtoReg_o <= 1;
                MemRead_o  <= 1;
                MemWrite_o <= 0;
                RegWrite_o <= 1;
                Branch_o   <= 0;
                // sw
                end else if (Op_i == 7'b0100011) begin
                ALUOp_o    <= 2'b00;
                ALUSrc_o   <= 1;
                MemtoReg_o <= 0;
                MemRead_o  <= 0;
                MemWrite_o <= 1;
                RegWrite_o <= 0;
                Branch_o   <= 0;
                // beq
                end else if (Op_i == 7'b1100011) begin
                ALUOp_o    <= 2'b01;
                ALUSrc_o   <= 0;
                MemtoReg_o <= 0;
                MemRead_o  <= 0;
                MemWrite_o <= 0;
                RegWrite_o <= 0;
                Branch_o   <= 1;
            end
            else begin
                ALUOp_o    <= 2'b00;
                ALUSrc_o   <= 0;
                MemtoReg_o <= 0;
                MemRead_o  <= 0;
                MemWrite_o <= 0;
                RegWrite_o <= 0;
                Branch_o   <= 0;
            end
        end
        else begin
            ALUOp_o    <= 2'b00;
            ALUSrc_o   <= 0;
            MemtoReg_o <= 0;
            MemRead_o  <= 0;
            MemWrite_o <= 0;
            RegWrite_o <= 0;
            Branch_o   <= 0;
        end
    end
endmodule
