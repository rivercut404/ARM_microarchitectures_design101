module mux_2to1_32bit(
    output wire [31:0] F, 
    input wire [31:0] A, B, 
    input wire Sel
);

    assign F = (Sel == 1'b0) ? A : B;

endmodule