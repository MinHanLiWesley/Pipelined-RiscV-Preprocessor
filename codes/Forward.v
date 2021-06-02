module Forward(IDEX_rs1_i,
               IDEX_rs2_i,
               MEMWB_rd_i,
               MEMWB_RegWrite_i,
               EXMEM_rd_i,
               EXMEM_RegWrite_i,
               forward_A_o,
               forward_B_o);
    
    input  [4:0]   IDEX_rs1_i, IDEX_rs2_i, EXMEM_rd_i,MEMWB_rd_i;
    input          EXMEM_RegWrite_i,MEMWB_RegWrite_i;
    output reg [1:0]    forward_A_o,forward_B_o;
    
    always @(*) begin
    if (EXMEM_RegWrite_i && 
        (EXMEM_rd_i !=5'd0) && 
        (EXMEM_rd_i == IDEX_rs1_i))begin
        assign forward_A_o = 2'b10;
    end
    else if (MEMWB_RegWrite_i && 
            (MEMWB_rd_i != 5'b0) && 
            !(EXMEM_RegWrite_i && (EXMEM_rd_i != 5'b0) && (EXMEM_rd_i == IDEX_rs1_i)) && 
            (MEMWB_rd_i == IDEX_rs1_i)) begin
    // else if (MEMWB_RegWrite_i && 
    //         (MEMWB_rd_i != 5'b0) &&
    //         (MEMWB_rd_i == IDEX_rs1_i))begin
        assign forward_A_o = 2'b01;
    end
    else begin
        assign forward_A_o = 2'b00;
    end
    
    if (EXMEM_RegWrite_i && 
        (EXMEM_rd_i != 5'd0) && 
        (EXMEM_rd_i == IDEX_rs2_i))begin
        assign forward_B_o = 2'b10;
    end
    else if (MEMWB_RegWrite_i && 
            (MEMWB_rd_i != 5'b0) && 
            !(EXMEM_RegWrite_i && (EXMEM_rd_i != 5'b0) && (EXMEM_rd_i == IDEX_rs2_i)) && 
            (MEMWB_rd_i == IDEX_rs2_i)) begin
        // else if (MEMWB_RegWrite_i && 
        //     (MEMWB_rd_i != 5'b0) &&
        //     (MEMWB_rd_i == IDEX_rs2_i))begin
        assign forward_B_o = 2'b01;
    end
    else begin
        assign forward_B_o = 2'b00;
    end
    end
endmodule
