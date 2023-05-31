`timescale 1ns/1ps

`include "multicycle_arm.v"
`include "./../Single-Cycle/instr_memory.v"
`include "./../Single-Cycle/data_memory.v"

module multicycle_top(
    output wire [31:0] WriteData, DataAdr, 
    output wire MemWrite,
    output wire [31:0] PC, exe_instr,  // for simulation
    input wire clk, Reset 
);

    wire [31:0] Instr, ReadData;  // PC

    assign exe_instr = Instr;
    
    // instantiate processor and memories
    multicycle_arm processing_unit(PC, DataAdr, WriteData, MemWrite, clk, Reset, Instr, ReadData);
    // module multicycle_arm(
    //     output wire [31:0] PC,
    //     output wire [31:0] ALUResult, WriteData,
    //     output wire MemWrite,
    //     input wire clk, Reset,
    //     input wire [31:0] Instr, 
    //     input wire [31:0] ReadData);

    // External Memories
    instr_memory imem(Instr, PC);
    data_memory dmem(ReadData, clk, MemWrite, DataAdr, WriteData);

endmodule