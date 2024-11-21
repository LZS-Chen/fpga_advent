/*
    *The instruction decoder* 
    Goal: load instruction sequentially. recogniye among the 11 instructions by lighting up the leds  
    step1: instructions create
    step2: recongnize pattern create 
    instruction types: alureg, aluimm, load, store, system 
    instruction length: 32 bits and let's try 10 instructions this time 
    feedback: initialize the instr
*/

`include "clockworks.v"

module SOC (
    input CLK,
    input RESET,
    output[4:0] LEDS
);
    
wire clk;
wire resetn;
Clockworks #(24) 
    CW(
    .CLK(CLK),
    .RESET(RESET),
    .clk(clk),
    .resetn(resetn)
    );

reg [32:0] MEM[0:10];
initial begin
    MEM[0] = 32'b0000000_00000_00000_000_00000_0110011; // alureg(r-type) 
    MEM[1] = 32'b000000000000_00000_000_00000_0010011; //aluimm
    MEM[2] = 32'b00000000_00000000_000000000_0100011; // s-type
    MEM[3] = 32'b00000000_00000000_000000000_1100011; //B-type
    MEM[4] = 32'b00000000_00000000_000000000_0000011; // U-type
    MEM[5] = 32'b00000000_00000000_000000000_1101111; // J-type 
    MEM[6] = 32'b00000000_00000000_000000000_1110011; // system
    // MEM[7] = 32'b00000000_00000000_00000000_00000000;
    // MEM[8] = 32'b00000000_00000000_00000000_00000000;
    // MEM[9] = 32'b00000000_00000000_00000000_00000000;
    // MEM[10] = 32'b00000000_00000000_00000000_00000000;
end

wire isAluReg = (instr[6:0]==7'b0110011);
wire isAluImm = (instr[6:0]==7'b0010011);
wire isStype = (instr[6:0]==7'b0100011);
wire isBtype = (instr[6:0]==7'b1100011);
wire isUtype = (instr[6:0]==7'b0000011);
wire isJtype = (instr[6:0]==7'b1101111);
wire isSys = (instr[6:0]==7'b1110011);


reg[32:0] instr;
reg[5:0] PC=0;
always @(posedge clk) begin
    if(!resetn) begin
        PC<=0;
        instr <= 32'b0000000_00000_00000_000_00000_0110011; // NOP
    end 
    else if(!isSys)begin
        instr<= MEM[PC];
        PC<=PC+1;
    end 
end

assign LEDS = isSys? 5'b11111 : {isUtype,isBtype,isStype,isAluImm,isAluReg};
endmodule