/*
    Task: A blinker that loads LEDs patterns from ROM
    step0: copy the code from day2
    step1: LED patterns create and in MEM store
    step2: fetch patterns and blink the led vectors via program counter(PC)
    Feedback: can not directly assign to LEDS have to do it via a reg
*/

`include "clockworks.v"

module SOC ( 
    input CLK,
    input RESET,
    output[4:0] LEDS
);

wire clk;
wire resetn;
Clockworks  #(23)CW (
    .CLK(CLK),  
    .RESET(RESET), 
    .clk(clk),  
    .resetn(resetn)
);

reg [5:0] MEM [0:15];
reg [4:0] PC;

initial begin
    PC=0;
    MEM[0]  =5'b00000;
    MEM[1]  =5'b00001;
    MEM[2]  =5'b00010;
    MEM[3]  =5'b00100;
    MEM[4]  =5'b01000;
    MEM[5]  =5'b10000;
    MEM[6]  =5'b10001;
    MEM[7]  =5'b10010;
    MEM[8]  =5'b10100;
    MEM[9]  =5'b11000;
    MEM[10] =5'b11001;
    MEM[11] =5'b11010;
    MEM[12] =5'b11100;
    MEM[13] =5'b11101;
    MEM[14] =5'b11110;
    MEM[15] =5'b11111;
end


reg [4:0] leds;
assign LEDS=leds;
always @(posedge clk) begin
    PC<=(!resetn||PC==15)? 0: PC+1;
    leds<= MEM[PC];
end
    

endmodule