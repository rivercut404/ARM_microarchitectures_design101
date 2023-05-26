module Extend(
    output reg [31:0] ExtImm,
    input wire [23:0] Instr,
    input wire [1:0] ImmSrc
);

    parameter DP = 2'b00,
              MEM = 2'b01,
              B = 2'b10;

    always @ (ImmSrc, Instr) 
        begin 
            case (ImmSrc) 
                DP : ExtImm = {24'b0, Instr[7:0]};
                MEM : ExtImm = {20'b0, Instr[11:0]};
                B : ExtImm = {{6{Instr[23]}}, Instr[23:0], 2'b00};
            endcase
        end

endmodule 
