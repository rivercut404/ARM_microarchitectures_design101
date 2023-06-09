`timescale 1ns/1ps

`include "mux_2to1_4bit.v"
`include "mux_2to1_32bit.v"
`include "ALU_32bit.v"
`include "register_file.v"
`include "extend.v"

module datapath(
    output reg [31:0] PC,  // Certainly reg
    // Certainly wire
    output wire [31:0] ALUResult,  
    output wire [3:0] ALUFlags,
    output wire [31:0] WriteData,
    input wire clk, Reset,
    // Inputs from external memory
    input wire [31:0] Instr,
    input wire [31:0] ReadData,    
    // Control signals
    input wire PCSrc, RegWrite, MemtoReg, ALUSrc, 
    input wire [1:0] ALUCtrl, RegSrc, ImmSrc
);

    wire [3:0] RA1, RA2;
    wire [31:0] PCnxt, PCPlus4, PCPlus8, RD1, RD2, SrcA, SrcB, ExtImm, Result;

    mux_2to1_4bit mux_RA1 (RA1, Instr[19:16], 4'b1111, RegSrc[0]);
    mux_2to1_4bit mux_RA2 (RA2, Instr[3:0], Instr[15:12], RegSrc[1]);
    mux_2to1_32bit mux_PCnxt (PCnxt, PCPlus4, Result, PCSrc);
    mux_2to1_32bit mux_SrcB (SrcB, RD2, ExtImm, ALUSrc);
    mux_2to1_32bit mux_Result (Result, ALUResult, ReadData, MemtoReg);

    // 32bit ALU 
    ALU_32bit alu (ALUResult, ALUFlags, ALUCtrl, SrcA, SrcB);

    assign PCPlus4 = PC + 4;
    assign PCPlus8 = PCPlus4 + 4;

    assign SrcA = RD1;
    assign WriteData = RD2;

    // PC logics 
    always @ (posedge clk, negedge Reset) 
        begin 
            if 
                (!Reset) PC <= 0;
            else                
                PC <= PCnxt;
        end

    // Register File logics 
    register_file rf (RD1, RD2, clk, Reset, RegWrite, RA1, RA2, Instr[15:12], Result, PCPlus8);
    /***
    module RegisterFile (
        output reg [31:0] RD1, 
        output reg [31:0] RD2, 
        input wire clk, Reset, 
        input wire RegWrite, 
        input wire [3:0] A1, A2, A3,
        input wire [31:0] WD3, R15 );
    ***/

    // Extend logics 
    extend ext (ExtImm, Instr[23:0], ImmSrc);
endmodule