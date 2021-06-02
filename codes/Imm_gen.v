module Imm_gen(
    data_i,
    data_o
);
//read opcode
    input [31:0] data_i;
    output reg [31:0] data_o;




    always @(*) begin
        case(data_i[6:0])
            7'b1100011:
                 data_o = ($signed({data_i[31], data_i[7], data_i[30:25], data_i[11:8]}));
            7'b0100011:
                 data_o = ($signed({data_i[31:25], data_i[11:7]}));
            default:
                 data_o =  $signed(data_i[31:20]);
        endcase
    end



endmodule