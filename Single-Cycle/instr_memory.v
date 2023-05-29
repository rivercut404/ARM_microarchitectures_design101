`timescale 1ns/1ps

module instr_memory(
    input wire [31:0] addr,
    output wire [31:0] RD
);
    // integer i;
    reg [31:0] RAM [22:0];

    initial 
        $readmemh("memfile.dat", RAM);

    // Memory read
    assign RD = RAM[addr[31:2]];
endmodule 