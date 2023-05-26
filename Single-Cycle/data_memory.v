module data_memory(
    input wire clk, Reset, WE,
    input wire [31:0] addr, WD,
    output reg [31:0] RD
);
    integer i;
    reg [31:0] RAM [63:0];

    // Memory read
    assign RD = RAM[addr[31:2]];

    // Memory write
    always @ (posedge clk, negedge Reset) 
        begin 
            if (!Reset) 
                begin 
                    for (i=0; i<64; i=i+1) 
                        begin RAM[i] = 32'h0000; end
                end
            else
                begin 
                    if (WE) 
                        begin 
                            RAM[addr[31:2]] <= WD;
                        end
                end
        end

endmodule 