`timescale 1ns/1ps

module decoder(
        output wire PCS, RegW, MemW, NoWrite,
        output wire MemtoReg, ALUSrc,
        output wire [1:0] RegSrc, ImmSrc, ALUCtrl, FlagW,
        input wire [1:0] Op,
        input wire [5:0] Funct,
        input wire [3:0] Rd
);

    wire Branch, ALUOp;
    
    PC_logic pcl (PCS, Rd, Branch, RegW);
    
    main_decoder main_dec (RegW, MemW, MemtoReg, ALUSrc, RegSrc, ImmSrc, Branch, ALUOp, Op, Funct);
    
    ALU_decoder alu_dec (NoWrite, ALUCtrl, FlagW, Funct[4:0], ALUOp);    
    
endmodule


module PC_logic(
    output wire PCS, 
    input wire [3:0] Rd,
    input wire Branch,
    input wire RegW
);
    
    // Implementation of PC Logic in Decoder
    assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
    
endmodule   


module main_decoder(
    // Declare outputs as reg for a procedural assignment
    output reg RegW, MemW, MemtoReg, ALUSrc, 
    output reg [1:0] RegSrc, ImmSrc,  
    output reg Branch, ALUOp, 
    input wire [1:0] Op,
    input wire [5:0] Funct
);
    
    parameter DP = 2'b00,
              Mem = 2'b01,
              B = 2'b10;    
    
    // Implementation of the Main Decoder
    always @ (Op, Funct)
        begin
            case (Op)
                // Set the control signals: RegW, MemW, MemtoReg, ALUSrc, RegSrc, ImmSrc, Branch, ALUOp
                DP: if (Funct[5] == 1'b0) 
                        begin  // DP Reg 
                            Branch = 1'b0; MemtoReg = 1'b0; MemW = 1'b0; ALUSrc = 1'b0; RegW = 1'b1; RegSrc = 2'b00; ALUOp = 1'b1;
                        end
                    else 
                        begin  // DP Imm
                            Branch = 1'b0; MemtoReg = 1'b0; MemW = 1'b0; ALUSrc = 1'b1; ImmSrc = 2'b00; RegW = 1'b1; RegSrc = 2'bX0; ALUOp = 1'b1;
                        end 
                Mem: if (Funct[0] == 1'b0) 
                         begin  // STR 
                             Branch = 1'b0; MemW = 1'b1; ALUSrc = 1'b1; ImmSrc = 2'b01; RegW = 1'b0; RegSrc = 2'b10; ALUOp = 1'b0;
                         end
                     else
                        begin  // LDR 
                             Branch = 1'b0; MemtoReg = 1'b1; MemW = 1'b0; ALUSrc = 1'b1; ImmSrc = 2'b01; RegW = 1'b1; RegSrc = 2'bX0; ALUOp = 1'b0;
                        end
                B : begin 
                        Branch = 1'b1; MemtoReg = 1'b0; MemW = 1'b0; ALUSrc = 1'b1; ImmSrc = 2'b10; RegW = 1'b0; RegSrc = 2'bX1; ALUOp = 1'b0;
                    end
            endcase  
        end
    
endmodule


module ALU_decoder(
    // Declare outputs as reg for a procedural assignment
    output reg NoWrite,
    output reg [1:0] ALUCtrl, FlagW,
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
