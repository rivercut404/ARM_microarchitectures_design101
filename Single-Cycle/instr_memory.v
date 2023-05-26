module instr_memory(
    input wire [31:0] addr,
    output reg [31:0] RD
);
    // integer i;
    reg [31:0] RAM [63:0];

    initial 
        $readmemh("memfile.dat", RAM);

    // Memory read
    assign RD = RAM[addr[31:2]];
endmodule 