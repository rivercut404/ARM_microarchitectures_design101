`timescale 1ns/1ps

`include "./../mux_2to1_4bit.v"
`include "./../mux_2to1_32bit.v"
`include "./../register_file.v"
`include "./../extend.v"
`include "./../ALU_32bit"

module datapath(
    output wire [31:0] Adr, WriteData,  // for I/D memory input
    // for control unit
    output wire [31:12] Instr_fields,  
    output wire [3:0] ALUFlags,
    input wire clk, Reset,
    input wire PCWrite, RegWrite, IRWrite, AdrSrc, ALUSrcA,
    input wire [1:0] ALUSrcB, ResultSrc, RegSrc, ImmSrc, ALUCtrl,
    input wire [31:0] ReadData,  // Data from memory
);

    // wire and reg declararion 
    reg [31:0] PC, PCnxt;
    reg [31:0] Instr, Data;  // store instr./data read from memory
    reg [31:0] A, B, ALUOut;

    wire [31:0] RA1, RA2, RD1, RD2, ExtImm, SrcA, SrcB, ALUResult, Result; 

    // Declare multiplexers before register file
    mux_2to1_32bit mux_Adr(Adr, PC, Result, AdrSrc);
    mux_2to1_4bit mux_RA1(RA1, Instr[19:16], 4'b1111, RegSrc[0]);
    mux_2to1_4bit mux_RA2(RA2, Instr[3:0], Instr[15:12], RegSrc[1]);

    register_file reg_set(RD1, RD2, clk, Reset, RegWrite, RA1, RA2, Instr[15:12], Result, Result);
    // module register_file (
    //     output reg [31:0] RD1, 
    //     output reg [31:0] RD2, 
    //     input wire clk, Reset, 
    //     input wire RegWrite,  // enable signal
    //     input wire [3:0] A1, A2, A3,
    //     input wire [31:0] WD3, R15);

    extend ext(ExtImm, Instr[23:0], ImmSrc);
    // module extend(
    //     output reg [31:0] ExtImm,
    //     input wire [23:0] Instr,
    //     input wire [1:0] ImmSrc);

    // Multiplexers for sources of ALU
    mux_2to1_32bit mux_SrcA(SrcA, A, PC, ALUSrcA);
    mux_3to1_32bit mux_SrcB(SrcB, B, ExtImm, 32'd4, ALUSrcB);

    // ALU 
    ALU_32bit ALU(ALUResult, ALUFlags, ALUCtrl, SrcA, SrcB);

    // mux for Result
    mux_3to1_32bit mux_Result(Result, ALUOut, Data, ALUResult, ResultSrc);

    // PC logic 
    always @(posedge clk, negedge Reset) begin
        if (!Reset) 
            PC <= 31'b0;
        else begin
            if (PCWrite)
                PC <= PCnxt;
        end
    end

endmodule


module mux_3to1_32bit (
    output wire [31:0] F,
    input wire [31:0] A, B, C,
    input wire Sel
);

    assign F = (Sel == 2'b00) ? A :
               (Sel == 2'b01) ? B : 
               (Sel == 2'b10) ? C :
               32'bX;

endmodule