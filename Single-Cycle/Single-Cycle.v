module Single-Cycle(
    output wire [31:0] WriteData, DataAdr, 
    output wire MemWrite
    input wire clk, Reset, 
);

    wire [31:0] PC, Instr, ReadData;
    
    // instantiate processor and memories

    // module Arm(
    // output wire [31:0] PC,
    // output wire [31:0] ALUResult, WriteData,
    // output wire MemWrite
    // input wire clk, Reset,
    // input wire [31:0] Instr, 
    // input wire [31:0] ReadData,
    // );
    single_arm arm(PC, DataAdr, WriteData, MemWrite, clk, Reset, Instr, ReadData);

    // External Memories
    instr_memory imem(Instr, PC);
    data_memory dmem(ReadData, clk, MemWrite, DataAdr, WriteData);

endmodule
