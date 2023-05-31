`timescale 1ns/1ps

module instr_memory(
    output wire [31:0] RD,
    input wire [31:0] addr
);
    // integer i;
    reg [31:0] RAM [63:0];

    initial 
        $readmemh("memfile.dat", RAM);

    // Memory read
    assign RD = RAM[addr[31:2]];
endmodule 