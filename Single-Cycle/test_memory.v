`timescale 1ns/1ps

// `include "instr_memory.v"

module test_memory();
    reg [31:0] memory [63:0];
    integer i;

    initial 
        begin 
            $readmemh("memfile.dat", memory);
        end
    
    initial
        begin 
            for (i=0; i<64; i=i+1)
                begin $display("printing memory at index %d is %h", i, memory[i]); end
        end
endmodule