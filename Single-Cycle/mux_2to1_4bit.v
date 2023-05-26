module mux_2to1_4bit(
    output wire [3:0] F, 
    input wire [3:0] A, B, 
    input wire Sel
);

    assign F = (Sel == 1'b0) ? A : B;

endmodule 