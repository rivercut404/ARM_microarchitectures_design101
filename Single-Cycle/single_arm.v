module single_arm(
    output wire [31:0] PC,
    output wire [31:0] ALUResult, WriteData, 
    output wire MemWrite
    input wire clk, Reset,
    input wire [31:0] Instr, 
    input wire [31:0] ReadData,
    );
    
    wire [3:0] ALUFlags;
    wire PCSrc, RegWrite, ALUSrc, MemtoReg;
    wire [1:0] RegSrc, ImmSrc, ALUCtrl;
    
    // module control_unit(
    //     // Outputs from conditional logic
    //     output reg PCSrc, RegWrite, MemWrite,        
    //     // Outputs from decoder
    //     output reg MemtoReg, ALUSrc, 
    //     output reg [1:0] RegSrc, ImmSrc, ALUCtrl,
    //     input wire clk, Reset, 
    //     input wire [31:12] Instr, 
    //     input wire [3:0] ALUFlags
    // );
    control_unit ctrl_unit (PCSrc, RegWrite, MemWrite, MemtoReg, ALUSrc, RegSrc, ImmSrc, ALUCtrl, 
                            clk, Reset, Instr[31:12], ALUFlags);
                          
    datapath dp (PC, ALUResult, ALUFlags, WriteData,
                 clk, Reset,
                 // Inputs from external memory
                 Instr,
                 ReadData,
                 // Control signals
                 PCSrc, MemtoReg, ALUSrc, RegWrite,
                 ALUCtrl, RegSrc, ImmSrc);
endmodule
