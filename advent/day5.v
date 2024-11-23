/*
    * The register bank and the state machine* 
    Goal: impliement state machine and finish the whole process 
        state1: fetch the instruction: instr <= MEM[PC]
        state2: fetch the values of rs1 and rs2: 
            rs1 <= RegisterBank[rs1Id]; 
            rs2 <= RegisterBank[rs2Id] where rs1 and rs2 are two registers. 
        state3: compute rs1 OP rs2
    store the result in rd: RegisterBank[rdId] <= writeBackData

    not quit familiar with the verilog always block convention 
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
reg[31:0] instr;
reg[5:0] PC;
initial begin
    PC = 0;
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


///RegisterBank
reg[31:0] RegisterBank [0:31];
reg [31:0] rs1;
reg [31:0] rs2;
wire[4:0] rs1Id=instr[19:15];
wire[4:0] rs2Id=instr[24:20];
wire[4:0] rdId=instr[11:7];

wire writeBackEn;
wire[31:0] writeBackData;
assign writeBackEn =0;
assign writeBackData =0;

// state machine 
reg [1:0] state=0;
localparam Fet_Inst = 0;
localparam Fet_Reg = 1;
localparam EXE = 2;
always @(posedge clk) begin
    if(!resetn) begin
        PC<=0;
        instr <= 32'b0000000_00000_00000_000_00000_0110011; 
        state <= 0;
    end 
    else begin

        case (state) 
            Fet_Inst:begin 
                instr<= MEM[PC];
                state<=Fet_Reg;
            end 

            Fet_Reg: begin 
                rs1<= RegisterBank[rs1Id];
                rs2<= RegisterBank[rs2Id];
                state<=EXE;
            end 

            EXE: begin
                if(!isSys) begin
                    PC<=PC+1;
                end 
                state<=Fet_Inst;
            end 

        endcase

        if (writeBackEn && rdId!= 0)begin 
            RegisterBank[rdId]<= writeBackData;
        end 
       
    end 
end

assign LEDS = isSys? 5'b11111 : 1<<state;
endmodule