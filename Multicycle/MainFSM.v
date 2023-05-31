`timescale 1ns/1ps

module MainFSM(
    // Internal signals of the Decoder
    output reg Branch, ALUOp,
    // Write enable signals 
    output reg RegW, MemW, IRWrite, NextPC, 
    // Multiplexer select signals
    output reg AdrSrc, ALUSrcA,
    output reg [1:0] ALUSrcB, ResultSrc, 
    input wire clk, Reset, 
    input wire [1:0] Op,
    input wire [5:0] Funct
);

    // Modeling the states
    reg [3:0] Scur, Snxt;
    parameter Fetch = 4'b0000,  // Fetch instr. from IM / PC + 4
              Decode = 4'b0001,
              MemAdr = 4'b0010,
              MemRead = 4'b0011,
              MemWB = 4'b0100,
              MemWrite = 4'b0101,
              ExecuteR = 4'b0110,
              ExecuteI = 4'b0111,
              ALUWB = 4'b1000,
              Jump = 4'b1001;  // Branch Instr.
    
    // State memory block 
    always @ (posedge clk, negedge Reset) 
        begin 
            if (!Reset) 
                Scur <= Fetch;
            else 
                Scur <= Snxt;
        end
  
    // Next state logic 
    always @ (Scur, Op, Funct[5], Funct[0])
        begin 
            case (Scur)
                Fetch : Snxt = Decode;
                Decode : if (Op == 2'b01)  // Memory operations
                             begin Snxt = MemAdr; end
                         else if (Op == 2'b00)
                             begin  // DP, Funct: {I, cmd, S}
                                 if (Funct[5] == 1'b0) Snxt = ExecuteR; else Snxt = ExecuteI;
                             end
                         else  // Op == 2'b10 (Branch)
                             Snxt = Jump;
                // Memory oper.: Funct.= {~I, P, U, B, W, L}
                MemAdr : if (Funct[0] == 1'b1) Snxt = MemRead; else Snxt = MemWrite;                            
                MemRead : Snxt = MemWB;
                MemWB : Snxt = Fetch;
                MemWrite : Snxt = Fetch;
                ExecuteR : Snxt = ALUWB;
                ExecuteI : Snxt = ALUWB;
                ALUWB : Snxt = Fetch;
                Jump : Snxt = Fetch;

                default : Snxt = Fetch;
            endcase
        end
  
    // Output logic 
    always @ (Scur, Op, Funct) 
        begin 
            case (Scur) 
                // Why the Branch signal is don't care? : must be reseted at the Fetch state (next of the Jump state)
                Fetch : begin ALUOp = 0; Branch = 0; RegW = 0; MemW = 0; IRWrite = 1; NextPC = 1; AdrSrc = 0; ALUSrcA = 1; ALUSrcB = 2'b10; ResultSrc = 2'b10; end
                Decode : begin ALUOp = 0; RegW = 0; MemW = 0; IRWrite = 0; NextPC = 0; ALUSrcA = 1; ALUSrcB = 2'b10; ResultSrc = 2'b10; end
                MemAdr : begin ALUOp = 0; RegW = 0; MemW = 0; IRWrite = 0; NextPC = 0; ALUSrcA = 0; ALUSrcB = 2'b01; end
                MemRead : begin RegW = 0; MemW = 0; IRWrite = 0; NextPC = 0; AdrSrc = 1; ResultSrc = 2'b00; end
                MemWB : begin RegW = 1; MemW = 0; IRWrite = 0; NextPC = 0; ResultSrc = 2'b01; end
                MemWrite : begin RegW = 0; MemW = 1; IRWrite = 0; NextPC = 0; AdrSrc = 1; ResultSrc = 2'b00; end
                ExecuteR : begin ALUOp = 1; RegW = 0; MemW = 0; IRWrite = 0; NextPC = 0; ALUSrcA = 0; ALUSrcB = 2'b00; end
                ExecuteI : begin ALUOp = 1; RegW = 0; MemW = 0; IRWrite = 0; NextPC = 0; ALUSrcA = 0; ALUSrcB = 2'b01; end
                ALUWB : begin RegW = 1; MemW = 0; IRWrite = 0; NextPC = 0; ResultSrc = 2'b00; end
                Jump : begin ALUOp = 0; Branch = 1; RegW = 0; MemW = 0; IRWrite = 0; NextPC = 0; ALUSrcA = 0; ALUSrcB = 2'b01; ResultSrc = 2'b10; end
            endcase 
        end
  
endmodule