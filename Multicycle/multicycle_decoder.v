`timescale 1ns/1ps

`include "MainFSM.v"

module multicycle_decoder(
    output wire PCS,
    // Write enables 
    output wire RegW, MemW, IRWrite, NextPC,
    // Multiplexer Selects 
    output wire AdrSrc, ALUSrcA,
    output wire [1:0] ALUSrcB, ResultSrc,
    // Produced by ALU_Decoder 
    output wire [1:0] ALUCtrl, FlagW,
    output wire NoWrite,
    // Produced by Instr_Decoder 
    output wire [1:0] RegSrc, ImmSrc, 
    input wire clk, Reset, 
    input wire [1:0] Op,
    input wire [5:0] Funct,
    input wire [3:0] Rd
);

    wire Branch, ALUOp;

    PC_logic pcl (PCS, Rd, Branch, RegW);

    MainFSM fsm (Branch, ALUOp, RegW, MemW, IRWrite, NextPC, 
                 AdrSrc, ALUSrcA, ALUSrcB, ResultSrc, 
                 clk, Reset, Op, Funct);

    ALU_decoder alu_dec (ALUCtrl, FlagW, NoWrite, Funct[4:0], ALUOp);

    Instr_decoder idec (RegSrc, ImmSrc, Op);

endmodule


module PC_logic(
    output wire PCS, 
    input wire [3:0] Rd,
    input wire Branch,
    input wire RegW);
    
    // Implementation of PC Logic in Decoder
    assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
    
endmodule


module ALU_decoder(
    output reg [1:0] ALUCtrl, FlagW,
    output reg NoWrite,
    input wire [4:0] Funct, 
    input wire ALUOp);
    
    parameter Add = 4'b0100,
              Sub = 4'b0010,
              And = 4'b0000,
              Or = 4'b1100,
              Cmp = 4'b1010;
    
    // Implementation of the ALU Decoder
    always @ (ALUOp, Funct[4:0])
        begin
            if (!ALUOp)  // No DP Instr. 
                begin ALUCtrl = 2'b00; FlagW = 2'b00; end
            else  // DP Instr.
                begin
                    case (Funct[4:1])
                        Add : if (Funct[0] == 1'b0) begin ALUCtrl = 2'b00; FlagW = 2'b00; NoWrite = 1'b0; end 
                              else begin ALUCtrl = 2'b00; FlagW = 2'b11; NoWrite = 1'b0; end  
                        Sub : if (Funct[0] == 1'b0) begin ALUCtrl = 2'b01; FlagW = 2'b00; NoWrite = 1'b0; end 
                              else begin ALUCtrl = 2'b01; FlagW = 2'b11; NoWrite = 1'b0; end
                        And : if (Funct[0] == 1'b0) begin ALUCtrl = 2'b10; FlagW = 2'b00; NoWrite = 1'b0; end 
                              else begin ALUCtrl = 2'b10; FlagW = 2'b10; NoWrite = 1'b0; end
                        Or : if (Funct[0] == 1'b0) begin ALUCtrl = 2'b11; FlagW = 2'b00; NoWrite = 1'b0; end 
                             else begin ALUCtrl = 2'b11; FlagW = 2'b10; NoWrite = 1'b0; end
                        Cmp : begin ALUCtrl = 2'b01; FlagW = 2'b11; NoWrite = 1'b1; end
                    endcase
                end
        end
    
endmodule


module Instr_decoder(
    output wire [1:0] RegSrc, ImmSrc,
    input wire [1:0] Op
);
    assign RegSrc[1] = (Op == 2'b01);
    assign RegSrc[0] = (Op == 2'b10);
    assign ImmSrc = Op;
endmodule
