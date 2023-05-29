`timescale 1ns/1ps

`include "single_arm.v"
`include "instr_memory.v"
`include "data_memory.v"

module single_cycle(
    output wire [31:0] WriteData, DataAdr, 
    output wire MemWrite,
    output wire [31:0] exe_instr,  // for simulation
    input wire clk, Reset 
);

    wire [31:0] PC, Instr, ReadData;

    assign exe_instr = Instr;
    
    // instantiate processor and memories
    single_arm arm(PC, DataAdr, WriteData, MemWrite, clk, Reset, Instr, ReadData);
    // module single_arm(
    // output wire [31:0] PC,
    // output wire [31:0] ALUResult, WriteData,
    // output wire MemWrite,
    // input wire clk, Reset,
    // input wire [31:0] Instr, 
    // input wire [31:0] ReadData);

    // External Memories
    instr_memory imem(Instr, PC);
    data_memory dmem(ReadData, clk, MemWrite, DataAdr, WriteData);

endmodule
