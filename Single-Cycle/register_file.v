`timescale 1ns/1ps

module register_file (
    output reg [31:0] RD1, 
    output reg [31:0] RD2, 
    input wire clk, Reset, 
    input wire RegWrite,  // enable signal
    input wire [3:0] A1, A2, A3,
    input wire [31:0] WD3, R15 
);

    integer i;  // variable for iteration
    reg [31:0] register_set [14:0];

    // Register write logics with RegWrite as an enable signal
    always @ (posedge clk, negedge Reset) 
        begin 
            if (!Reset) 
                begin 
                    for (i=0; i<15; i=i+1) 
                        begin register_set[i] = 32'h0000; end
                end
            else
                begin 
                    if (RegWrite) 
                        begin 
                            if (A3 != 15)
                                register_set[A3] <= WD3;
                        end
                end
        end

    always @ (A1)
        begin 
            if (A1 == 15) 
                RD1 = R15;
            else 
                RD1 = register_set[A1];
        end
    
    always @ (A2) 
        begin 
            if (A1 == 15) 
                RD2 = R15;
            else               
                RD2 = register_set[A2]; 
        end

endmodule