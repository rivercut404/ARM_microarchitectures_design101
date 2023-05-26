module ALU_32bit(
    output wire [31:0] Result, 
    output wire [3:0] ALUFlags,
    // output wire Cout, 
    input wire [1:0] ALUCtrl,
    input wire [31:0] A, B
    // input wire Cin
);

    wire [31:0] Bn, SrcB, Sum, G, P;
    wire Cout, V1, V2;

    parameter Add = 2'b00,
              Sub = 2'b01,  // Including CMP instr.
              And = 2'b10,
              Or = 2'b11;

    assign Bn = ~B;
    assign V1 = ~(ALUCtrl ^ A[31] ^ B[31]);
    assign V2 = A[31] ^ Sum[31];
    assign G = A & B;
    assign P = A | B;

    // Produce ALU Flags 
    assign ALUFlags[3] = Result[31];  // N
    assign ALUFlags[2] = ~|Result;  // Z
    assign ALUFlags[1] = (~ALUCtrl[1]) & Cout;  // C
    assign ALUFlags[0] = V1 & V2 & (~ALUCtrl[1]);  // V

    mux_2to1_32bit mux_SrcB (SrcB, B, Bn, ALUCtrl[0]);

    adder_32bit adder (Sum, Cout, A, SrcB, ALUCtrl[0]);

    mux_4to1_32bit mux_Result (Result, Sum, Sum, G, P, ALUCtrl);

endmodule


module adder_32bit(
    output wire [31:0] Sum,
    output wire Cout,
    input wire [31:0] A, B,
    input wire Cin
);

    assign {Cout, Sum} = A + B + Cin;

endmodule 


module mux_4to1_32bit(
    output wire [31:0] F, 
    input wire [31:0] A, B, C, D,
    input wire [1:0] Sel 
);

    assign F = (Sel == 2'b00) ? A :
               (Sel == 2'b01) ? B :
               (Sel == 2'b10) ? C :
               (Sel == 2'b11) ? D :
               {32{1'bX}};

endmodule
