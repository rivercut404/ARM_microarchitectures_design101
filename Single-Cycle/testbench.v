`timescale 1ns/1ps

`include "single_cycle.v"

module testbench();
// module Single-Cycle(
    // output wire [31:0] WriteData, DataAdr, 
    // output wire MemWrite,
    // input wire clk, Reset);

    wire [31:0] WriteData, DataAdr;
    wire MemWrite;
    wire [31:0] Instr, PC;  // for checking the state of sim

    reg clk, Reset;

    single_cycle DUT(WriteData, DataAdr, MemWrite, Instr, PC, clk, Reset);

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

    // check results
    always @(negedge clk)
        begin
            if(MemWrite) begin
                if(DataAdr === 100 & WriteData === 7) begin
                $display("Simulation succeeded");
                $stop;
                end else if (DataAdr !== 96) begin
                $display("Simulation failed");
                $stop;
                end
            end
        end

    // check the simultion goes well 
    always @(Instr)
        begin
            $display("PC: %h", PC);
            $display("Executing Instr.: %h", Instr);
        end

    initial begin
        $dumpfile("testbench.vcd") ;
        $dumpvars(0, testbench);
    end

endmodule