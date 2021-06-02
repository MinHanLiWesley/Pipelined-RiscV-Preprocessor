module CPU (clk_i,
            rst_i,
            start_i);
    
    // Ports
    input               clk_i;
    input               rst_i;
    input               start_i;
    
    
    wire wControl_Branch_o, wControl_MemtoReg_o,wControl_MemRead_o, wControl_MemWrite_o, wControl_ALUSrc_o, wControl_RegWrite_o;
    wire [1:0] wControl_ALUOP_o;
    
    Control Control(
    .Op_i       (wIFID_instr_o[6:0]),     // IFID.instr_o[6:0]
    .Noop_i     (wHazard_Detection_Noop_o), // Hazard_Detection.Noop_o
    .Branch_o   (wControl_Branch_o),    // Control.Branch_o
    .MemtoReg_o (wControl_MemtoReg_o),  // Control.MemtoReg_o
    .MemRead_o  (wControl_MemRead_o),  // Control.MemRead_o
    .MemWrite_o (wControl_MemWrite_o),  // Control.MemWrite_o
    .ALUOp_o    (wControl_ALUOP_o),     // Control.ALUOp_o
    .ALUSrc_o   (wControl_ALUSrc_o),    // Control.ALUSrc_o
    .RegWrite_o (wControl_RegWrite_o)   // Control.RegWrite_o
    );
    
    wire [31:0] wAdd_PC_data_o;
    
    
    Adder Add_PC(
    .data1_in   (wPC_pc_o),              // PC.pc_o
    .data2_in   (32'b100),
    .data_o     (wAdd_PC_data_o)         // Add_PC.data_o
    );
    
    
    wire [31:0] wADD_Hazard_data_o;
    
    Adder ADD_Hazard(
    .data1_in    (wleftshift_data_o), // leftshift.data_o
    .data2_in    (wIFID_addr_o), // IFID.addr_o
    .data_o      (wADD_Hazard_data_o)
    );
    
    wire [31:0] wPC_pc_o;
    
    PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .PCWrite_i   (wHazard_Detection_PCwrite_o), // Hazard_Detection.PCwrite_o
    .pc_i       (wMUX_PC_data_o), // MUX_PC.data_o
    .pc_o       (wPC_pc_o)
    );
    
    wire [31:0] wInstruction_Memory_instr_o;
    
    Instruction_Memory Instruction_Memory(
    .addr_i     (wPC_pc_o), // PC.pc_o
    .instr_o    (wInstruction_Memory_instr_o)
    );
    
    
    wire [31:0] wRegisters_RS1data_o, wRegisters_RS2data_o;
    
    Registers Registers(
    .clk_i      (clk_i),
    .RS1addr_i   (wIFID_instr_o[19:15]), // IFID.instr_o[19:15]
    .RS2addr_i   (wIFID_instr_o[24:20]), // IFID.instr_o[24:20]
    .RDaddr_i   (wMEMWB_instr_11_o),    // MEMWB.instr_11_o
    .RDdata_i  (wMUX_WBSrc_data_o),     // MUX_WBSRC.data_o
    .RegWrite_i (wMEMWB_RegWrite_o),    // MEMWB.RegWrite_o
    .RS1data_o   (wRegisters_RS1data_o),
    .RS2data_o   (wRegisters_RS2data_o)
    );
    
    wire [31:0] wMUX_ALUSrc_data_o;
    
    MUX32 MUX_ALUSrc(
    .data1_i    (wMUX_forwardB_data_o), // MUX_forwardB.data_o
    .data2_i    (wIDEX_Imm_gen_o),      // IDEX.Imm_gen_o
    .select_i   (wIDEX_ALUSrc_o),       // IDEX.ALUSrc_o
    .data_o     (wMUX_ALUSrc_data_o)
    );
    
    wire [31:0] wMUX_WBSrc_data_o;
    MUX32 MUX_WBSrc(
    .data1_i    (wMEMWB_addr_o),    // MEMWB.addr_o
    .data2_i    (wMEMWB_Read_data_o), // MEMWB.Read_data_o
    .select_i   (wMEMWB_MemtoReg_o),  // MEMWB.MemtoReg_o
    .data_o     (wMUX_WBSrc_data_o)
    );
    
    wire [31:0] wMUX_PC_data_o;
    
    MUX32 MUX_PC(
    .data1_i    (wAdd_PC_data_o), // Add_PC.data_o
    .data2_i    (wADD_Hazard_data_o),  // ADD_Hazard.data_o
    .select_i   (wBr_Comparer_data_o), // Br_Comparer.data_o
    .data_o     (wMUX_PC_data_o)
    );
    
    
    wire wBr_Comparer_data_o;
    And Br_Comparer(
    .data1_i    (wControl_Branch_o), // Control.Branch_o
    .data2_i    (wEqual_data_o),     //  Equal.data_o
    .data_o     (wBr_Comparer_data_o)
    );
    
    wire [31:0] wIFID_instr_o, wIFID_addr_o;
    wire Flush;
    assign Flush = wBr_Comparer_data_o;

    IFID IFID(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .flush_i(Flush),    //Br_Comparer.data_o
    .stall_i(wHazard_Detection_stall_o),  // Hazard_Detection.stall_o
    .instr_i(wInstruction_Memory_instr_o), //  Instruction_Memory.instr_o
    .addr_i(wPC_pc_o),                  // PC.pc_o
    .instr_o(wIFID_instr_o),
    .addr_o(wIFID_addr_o)
    );
    
    wire wIDEX_RegWrite_o,wIDEX_MemtoReg_o, wIDEX_MemRead_o, wIDEX_MemWrite_o, wIDEX_ALUSrc_o;
    wire [1:0]  wIDEX_ALUOp_o;
    wire [31:0] wIDEX_Read_data1_o,wIDEX_Read_data2_o,wIDEX_Imm_gen_o;
    wire [4:0]   wIDEX_instr_19_o,wIDEX_instr_24_o,wIDEX_instr_11_o;
    wire [9:0]   wIDEX_instr_31_o;
    
    
    IDEX IDEX(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .RegWrite_i(wControl_RegWrite_o), // Control.RegWrite_o
    .MemtoReg_i(wControl_MemtoReg_o), // Control.MemtoReg_o
    .MemRead_i(wControl_MemRead_o),  //  Control.MemRead_o
    .MemWrite_i(wControl_MemWrite_o),  //  Control.MemWrite_o
    .ALUOp_i(wControl_ALUOP_o),    //  Control.ALUOp_o
    .ALUSrc_i(wControl_ALUSrc_o),   //   Control.ALUSrc_o
    .Read_data1_i(wRegisters_RS1data_o),    //  Registers.RS1data_o
    .Read_data2_i(wRegisters_RS2data_o),    //   Registers.RS2data_o
    .Imm_gen_i(wImm_gen_data_o),    //  Imm_gen.data_o
    .instr_31_i({wIFID_instr_o[31:25],wIFID_instr_o[14:12]}),    // {IFID.instr_o[31:25],IFID.instr_o[14:12]}
    .instr_19_i(wIFID_instr_o[19:15]),       // IFID.instr_o[19:15]
    .instr_24_i(wIFID_instr_o[24:20]),       // IFID.instr_o[24:20]
    .instr_11_i(wIFID_instr_o[11:7]),         // IFID.instr_o[11:7]
    .RegWrite_o(wIDEX_RegWrite_o),
    .MemtoReg_o(wIDEX_MemtoReg_o),
    .MemRead_o(wIDEX_MemRead_o),
    .MemWrite_o(wIDEX_MemWrite_o),
    .ALUOp_o(wIDEX_ALUOp_o),
    .ALUSrc_o(wIDEX_ALUSrc_o),
    .Read_data1_o(wIDEX_Read_data1_o),
    .Read_data2_o(wIDEX_Read_data2_o),
    .Imm_gen_o(wIDEX_Imm_gen_o),
    .instr_31_o(wIDEX_instr_31_o),
    .instr_19_o(wIDEX_instr_19_o),
    .instr_24_o(wIDEX_instr_24_o),
    .instr_11_o(wIDEX_instr_11_o)
    );
    
    
    wire wEXMEM_RegWrite_o,wEXMEM_MemtoReg_o,wEXMEM_MemRead_o,wEXMEM_MemWrite_o;
    wire [31:0] wEXMEM_ALU_result_o;
    wire  [4:0]  wEXMEM_instr_11_o;
    wire [31:0] wEXMEM_MUX_result_o;
    
    EXMEM EXMEM(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .RegWrite_i(wIDEX_RegWrite_o),  //IDEX.RegWrite_o
    .MemtoReg_i(wIDEX_MemtoReg_o),  //IDEX.MemtoReg_o
    .MemRead_i(wIDEX_MemRead_o),    //IDEX.MemRead_o
    .MemWrite_i(wIDEX_MemWrite_o),   //IDEX.MemWrite_o
    .ALU_result_i(wALU_data_o),          // ALU.data_o
    .MUX_result_i(wMUX_forwardB_data_o),   //   MUX_forwardB.data_o
    .instr_11_i(wIDEX_instr_11_o),     //  IDEX.instr_11_o
    .RegWrite_o(wEXMEM_RegWrite_o),
    .MemtoReg_o(wEXMEM_MemtoReg_o),
    .MemRead_o(wEXMEM_MemRead_o),
    .MemWrite_o(wEXMEM_MemWrite_o),
    .ALU_result_o(wEXMEM_ALU_result_o),
    .MUX_result_o(wEXMEM_MUX_result_o),
    .instr_11_o(wEXMEM_instr_11_o)
    );
    
    
    wire wMEMWB_RegWrite_o,wMEMWB_MemtoReg_o;
    wire [31:0] wMEMWB_addr_o,wMEMWB_Read_data_o;
    wire [4:0]   wMEMWB_instr_11_o;
    MEMWB MEMWB(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .RegWrite_i(wEXMEM_RegWrite_o), //EXMEM.RegWrite_o
    .MemtoReg_i(wEXMEM_MemtoReg_o),  //EXMEM.MemtoReg_o
    .addr_i(wEXMEM_ALU_result_o),   // EXMEM.ALU_result_o
    .Read_data_i(wData_Memory_data_o),   //Data_Memory.data_o
    .instr_11_i(wEXMEM_instr_11_o),   //  EXMEM.instr_11_o
    .RegWrite_o(wMEMWB_RegWrite_o),
    .MemtoReg_o(wMEMWB_MemtoReg_o),
    .addr_o(wMEMWB_addr_o),
    .Read_data_o(wMEMWB_Read_data_o),
    .instr_11_o (wMEMWB_instr_11_o)
    );
    
    
    wire wHazard_Detection_stall_o,wHazard_Detection_PCwrite_o,wHazard_Detection_Noop_o;
    
    Hazard_Detection Hazard_Detection(
    .MemRead_i  (wIDEX_MemRead_o),               //IDEX.MemRead_o
    .instr_11_i (wIDEX_instr_11_o),              //IDEX.instr_11_o
    .instr_19_i (wIFID_instr_o[19:15]) ,     //IFID.instr_o[19:15]
    .instr_24_i (wIFID_instr_o[24:20]),      //IFID.instr_o[24:20]
    .stall_o    (wHazard_Detection_stall_o),
    .PCwrite_o  (wHazard_Detection_PCwrite_o),  
    .Noop_o     (wHazard_Detection_Noop_o)
    );
    
    wire [1:0]    wForward_forward_A_o,wForward_forward_B_o;
    Forward Forward(
    .IDEX_rs1_i(wIDEX_instr_19_o),               //IDEX.instr_19_o
    .IDEX_rs2_i(wIDEX_instr_24_o),               //IDEX.instr_24_o
    .MEMWB_rd_i(wMEMWB_instr_11_o),              //MEMWB.instr_11_o
    .MEMWB_RegWrite_i(wMEMWB_RegWrite_o),           //MEMWB.RegWrite_o
    .EXMEM_rd_i(wEXMEM_instr_11_o),                  //EXMEM.instr_11_o
    .EXMEM_RegWrite_i(wEXMEM_RegWrite_o),            //EXMEM.RegWrite_o
    .forward_A_o(wForward_forward_A_o),
    .forward_B_o(wForward_forward_B_o)
    );
    
    
    wire [31:0] wMUX_forwardA_data_o;
    MUX_forward MUX_forwardA(
    .data0_i(wIDEX_Read_data1_o),            //IDEX.Read_data1_o
    .data1_i(wMUX_WBSrc_data_o),             //MUX_WBSrc.data_o
    .data2_i(wEXMEM_ALU_result_o),           //EXMEM.ALU_result_o
    .select_i(wForward_forward_A_o),         //Forward.forward_A_o
    .data_o(wMUX_forwardA_data_o)
    );
    
    wire [31:0] wMUX_forwardB_data_o;
    MUX_forward MUX_forwardB(
    .data0_i(wIDEX_Read_data2_o),
    .data1_i(wMUX_WBSrc_data_o),
    .data2_i(wEXMEM_ALU_result_o),
    .select_i(wForward_forward_B_o),
    .data_o(wMUX_forwardB_data_o)
    );
    
    wire wEqual_data_o;
    Equal Equal(
    .data1_i(wRegisters_RS1data_o),          //Registers.RS1data_o
    .data2_i(wRegisters_RS2data_o),              //Registers.RS2data_o
    .data_o(wEqual_data_o)
    );
    
    wire [31:0]      wData_Memory_data_o;
    Data_Memory Data_Memory(
    .clk_i     (clk_i),
    .addr_i    (wEXMEM_ALU_result_o),            //EXMEM.ALU_result_o
    .MemRead_i (wEXMEM_MemRead_o),               //EXMEM.MemRead_o
    .MemWrite_i(wEXMEM_MemWrite_o),                  //EXMEM.MemWrite_o
    .data_i    (wEXMEM_MUX_result_o),            //EXMEM.MUX_result_o
    .data_o     (wData_Memory_data_o)
    );
    
    
    wire [31:0] wImm_gen_data_o;
    Imm_gen Imm_gen(
    .data_i(wIFID_instr_o),                   //IFID.instr_o
    .data_o(wImm_gen_data_o)
    );
    
    
    wire [31:0] wleftshift_data_o;
    leftshift leftshift(
    .data_i(wImm_gen_data_o),               //Imm_gen.data_o
    .data_o(wleftshift_data_o)
    );
    
    
    wire [31:0] wALU_data_o;
    wire wALU_Zero_o;
    ALU ALU(
    .data1_i    (wMUX_forwardA_data_o),          //MUX_forwardA.data_o
    .data2_i    (wMUX_ALUSrc_data_o),                //MUX_ALUSrc.data_o
    .ALUCtrl_i  (wALU_Control_ALUCtrl_o),        //ALU_Control.ALUCtrl_o
    .data_o     (wALU_data_o),
    .Zero_o     ()
    );
    
    wire [3:0] wALU_Control_ALUCtrl_o;
    
    ALU_Control ALU_Control(
    .funct_i    (wIDEX_instr_31_o),              //IDEX.instr_31_o
    .ALUOp_i    (wIDEX_ALUOp_o),             //IDEX.ALUOp_o
    .ALUCtrl_o  (wALU_Control_ALUCtrl_o)
    );
    
    
endmodule
    
