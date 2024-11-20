

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
    
reg [4:0] count=1;
always @(posedge clk) begin
    count<=!count? 1: count <<1;
end
    
    assign LEDS=count;
endmodule