`timescale 1ns/1ps

`include "multicycle_decoder.v"
`include "multicycle_condlogic.v"

module control_unit(
    // Outputs produced by the conditional logic
    output wire PCWrite, RegWrite, MemWrite, 
    // Produced by decoder
    output wire IRWrite, AdrSrc,
    output wire [1:0] ResultSrc,
    output wire ALUSrcA, 
    output wire [1:0] ALUSrcB, ImmSrc, RegSrc,
    output wire [1:0] ALUCtrl,
    // for debugging 
    output wire ALUOp,
    input wire clk, Reset, 
    input wire [3:0] Cond, ALUFlags, 
    input wire [1:0] Op,
    input wire [5:0] Funct, 
    input wire [3:0] Rd
);

    wire [1:0] FlagW;
    wire PCS, RegW, MemW, NextPC;

    multicycle_decoder dec(PCS, RegW, MemW, IRWrite, NextPC, AdrSrc, ALUSrcA, ALUSrcB, ResultSrc,
                           ALUCtrl, FlagW, NoWrite, RegSrc, ImmSrc, ALUOp, clk, Reset, Op, Funct, Rd);
    // module multicycle_decoder(
    // output wire PCS,
    // // Register enables 
    // output wire RegW, MemW, IRWrite, NextPC,
    // // Multiplexer Selects 
    // output wire AdrSrc, ALUSrcA,
    // output wire [1:0] ALUSrcB, ResultSrc,
    // // From ALU_Decoder 
    // output wire [1:0] ALUCtrl, FlagW,
    // // From Instr_Decoder 
    // output wire [1:0] RegSrc, ImmSrc, 
    // input wire clk, Reset, 
    // input wire [1:0] Op,
    // input wire [5:0] Funct,
    // input wire [3:0] Rd);

    multicycle_condlogic CL(PCWrite, RegWrite, MemWrite, clk, Reset, NextPC, PCS, RegW, MemW, 
                            NoWrite, FlagW, Cond, ALUFlags);
    // module multicycle_condlogic(
    // output reg PCWrite,
    // output reg RegWrite,
    // output reg MemWrite,
    // input wire clk, Reset, 
    // input wire NextPC, PCS, RegW, MemW, 
    // input wire NoWrite,  // for CMP
    // input wire [1:0] FlagW,
    // input wire [3:0] Cond, ALUFlags);

endmodule