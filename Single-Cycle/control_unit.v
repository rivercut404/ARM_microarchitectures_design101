module control_unit(
        // Outputs from conditional logic
        output wire PCSrc, RegWrite, MemWrite,  // Should not be reg
        // Outputs from decoder
        output wire MemtoReg, ALUSrc, 
        output wire [1:0] RegSrc, ImmSrc, ALUCtrl,
        input wire clk, Reset, 
        input wire [31:12] Instr, 
        input wire [3:0] ALUFlags
    );

    wire [1:0] FlagW;
    wire PCS, RegW, MemW, NoWrite;

    decoder decoder(PCS, RegW, MemW, NoWrite, MemtoReg, ALUSrc, RegSrc, ImmSrc, ALUCtrl, FlagW, Instr[27:26], Instr[25:20], Instr[15:12]);
    // module decoder(
    //     output wire PCS, RegW, MemW, NoWrite,
    //     output wire MemtoReg, ALUSrc,
    //     output wire [1:0] RegSrc, ImmSrc, ALUCtrl, FlagW,
    //     input wire [1:0] Op,
    //     input wire [5:0] Funct,
    //     input wire [3:0] Rd);
    // endmodule

    conditional_logic CL(PCSrc, RegWrite, MemWrite, clk, Reset, PCS, RegW, MemW, NoWrite, FlagW, Instr[31:28], ALUFlags);
    // module conditional_logic(
    //     output reg PCSrc,
    //     output reg RegWrite,
    //     output reg MemWrite,
    //     input wire clk, Reset, 
    //     input wire PCS, RegW, MemW,
    //     input wire NoWrite,  // for CMP
    //     input wire [1:0] FlagW,
    //     input wire [3:0] Cond, ALUFlags);
    // endmodule

endmodule
