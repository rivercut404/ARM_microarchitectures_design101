`timescale 1ns/1ps

`include "control_unit.v"
`include "datapath.v"

module multicycle_arm (
    output wire [31:0] PC,
    output wire [31:0] ALUResult, WriteData,
    output wire MemWrite,
    input wire clk, Reset,
    input wire [31:0] ReadData, 
    input wire [31:0] ReadData
);

    // From controller to datapath
    wire PCWrite, RegWrite, IRWrite, AdrSrc, ALUSrcA;
    wire [1:0] ALUSrcB, ResultSrc, RegSrc, ImmSrc, ALUCtrl;

    // From datapath to controller 
    wire [3:0] Cond, ALUFlags;
    wire [1:0] Op;
    wire [5:0] Funct;
    wire [3:0] Rd;

    control_unit controller(PCWrite, RegWrite, MemWrite, IRWrite, AdrSrc, ResultSrc,
                            ALUSrcA, ALUSrcB, ImmSrc, RegSrc, ALUCtrl,
                            clk, Reset, Cond, ALUFlags, Op, Funct, Rd);
    // module control_unit(
    //     // Outputs produced by the conditional logic
    //     output wire PCWrite, RegWrite, MemWrite, 
    //     // Produced by decoder
    //     output wire IRWrite, AdrSrc,
    //     output wire [1:0] ResultSrc,
    //     output wire ALUSrcA, 
    //     output wire [1:0] ALUSrcB, ImmSrc, RegSrc,
    //     output wire [1:0] ALUCtrl,
    //     input wire clk, Reset, 
    //     input wire [3:0] Cond, ALUFlags, 
    //     input wire [1:0] Op,
    //     input wire [5:0] Funct, 
    //     input wire [3:0] Rd);

    datapath DP();
    
endmodule