`timescale 1ns/1ps

`include "control_unit.v"

module testbench();
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
//     input wire [3:0] Rd

    wire PCWrite, RegWrite, MemWrite; 
    wire IRWrite, AdrSrc;
    wire [1:0] ResultSrc;
    wire ALUSrcA;
    wire [1:0] ALUSrcB, ImmSrc, RegSrc;
    wire [1:0] ALUCtrl;
    // for debugging 
    wire ALUOp;

    reg clk, Reset;
    reg [3:0] Cond, ALUFlags;
    reg [1:0] Op;
    reg [5:0] Funct;
    reg [3:0] Rd;

    control_unit DUT(PCWrite, RegWrite, MemWrite, IRWrite, AdrSrc, ResultSrc, ALUSrcA, ALUSrcB, ImmSrc, RegSrc,
                     ALUCtrl, ALUOp, clk, Reset, Cond, ALUFlags, Op, Funct, Rd);

    initial begin
        Reset = 0;
        #12 Reset = 1;
    end

    initial begin
        clk = 0;
    end

    always begin
        #5 clk = ~clk;
    end

    initial begin
        #14 Cond = 4'b1110; Rd = 5;
        // parameter Add = 4'b0100,
        //       Sub = 4'b0010,
        //       And = 4'b0000,
        //       Or = 4'b1100,
        //       Cmp = 4'b1010;

        // DP reg OR
        Op = 2'b0; Funct = 6'b011000;

        // LDR 
        #40 Op = 2'b01; Funct = 6'b111001;

        // STR
        #40 Op = 2'b01; Funct = 6'b111000;

        // Branch 
        #40 Op = 2'b10; 
        
        #50 $finish();
    end

    initial begin
        $dumpfile("testbench.vcd") ;
        $dumpvars(0, testbench);
    end

endmodule