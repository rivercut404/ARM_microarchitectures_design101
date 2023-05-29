`timescale 1ns/1ps

module data_memory(
    output wire [31:0] RD,
    input wire clk, WE,
    input wire [31:0] addr, WD
);

    reg [31:0] RAM [63:0];

    // Memory read
    assign RD = RAM[addr[31:2]];

    // Memory write
    always @ (posedge clk) 
        begin 
            if (WE) 
                begin 
                    RAM[addr[31:2]] <= WD;
                end
        end

endmodule 