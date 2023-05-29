`timescale 1ns/1ps

module conditional_logic(
    output reg PCSrc,
    output reg RegWrite,
    output reg MemWrite,
    input wire clk, Reset, 
    input wire PCS, RegW, MemW,
    input wire NoWrite,  // for CMP
    input wire [1:0] FlagW,
    input wire [3:0] Cond, ALUFlags
);

    reg CondEx;
    reg [3:0] Flags;  // Condition Flags Storage 

    // Condition Flags 
    always @ (posedge clk, negedge Reset)
        begin 
            if (!Reset) 
                begin Flags <= 4'b0000; end
            else  // postive edge triggered 
                begin  // Update flags when FlagW & CondEx enabled (CMPEQ!!!)
                    if (FlagW[1] & CondEx) Flags[3:2] <= ALUFlags[3:2];  // N, Z
                    if (FlagW[0] & CondEx) Flags[1:0] <= ALUFlags[1:0];  // C, V
                end
        end 
    
    // Condition Check Logic 
    always @* 
        begin 
            case (Cond)
                4'b0000 : CondEx = Flags[2];  // EQ
                4'b0001 : CondEx = ~Flags[2];  // NE
                4'b1010 : CondEx = ~(Flags[3] ^ Flags[0]);  // GE
                4'b1011 : CondEx = Flags[3] ^ Flags[0];  // LT
                4'b1100 : CondEx = ~Flags[2] & (~(Flags[3] ^ Flags[0]));  // GT
                4'b1101 : CondEx = Flags[2] | (Flags[3] ^ Flags[0]);  // LE
                4'b1110 : CondEx = 1'b1;  // AL, Always
                default : CondEx = 1'b1;
            endcase
        end

    // Output (Control Signal)
    always @* 
        begin
            PCSrc = PCS & CondEx;
            RegWrite = RegW & CondEx & (~NoWrite);
            MemWrite = MemW & CondEx;
            // $display("");
        end 

endmodule