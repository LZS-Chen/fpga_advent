module SOC (
    input CLK,
    input RESET,
    output[4:0] LEDS
);

reg [4:0] count;
always @(posedge CLK) begin
    count <= count +1;
end
    
    assign LEDS=count;
endmodule