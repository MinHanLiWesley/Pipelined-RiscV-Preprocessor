
module ALU_Control(funct_i,
                   ALUOp_i,
                   ALUCtrl_o);
    input   [1:0]       ALUOp_i;
    input   [9:0]       funct_i;
    output  reg [3:0]   ALUCtrl_o;
    
    always @(*) begin
        if (ALUOp_i == 2'b10) begin
            // add sub mul
            case (funct_i)
                //and
                10'b0000000111: assign ALUCtrl_o = 1;
                //xor
                10'b0000000100: assign ALUCtrl_o = 2;
                
                //sll
                10'b0000000001: assign ALUCtrl_o = 3;
                //add
                10'b0000000000: assign ALUCtrl_o = 4;
                
                //sub
                10'b0100000000: assign ALUCtrl_o = 5;
                
                //mul
                10'b0000001000: assign ALUCtrl_o = 6;
                //or
                10'b0000000110: assign ALUCtrl_o = 8;
                
            endcase
        end
        else if (ALUOp_i == 2'b11) begin
            case (funct_i[2:0])
                //addi
                3'b000: assign ALUCtrl_o = 4;
                
                //srai
                3'b101: assign ALUCtrl_o = 7;
            endcase
        end
        else if (ALUOp_i == 2'b00) begin
            
            assign ALUCtrl_o = 4;
        end
            //beq
        else if (ALUOp_i == 2'b01) begin
            assign ALUCtrl_o = 5;
        end
    end
            
endmodule


