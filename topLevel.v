module topLevel(input wire clk,
                input wire reset,
                input wire flashEn,
                input wire [7:0] flashInstruction
                );

//************************************************************************************************
// Signal declaration
//************************************************************************************************

// Program Counter declaration                
reg [63:0] pc ;

// Wires to interconnect instruction memeory and instruction decoder
wire  [63:0]  pcBypass;
wire  [31:0]  instruction;

// Wires to interconect instruction decoder and register file
wire         regWriteFlag;
wire [4:0]   readAddr01;
wire [4:0]   readAddr02;
wire [4:0]   writeAddr01;
wire         branch  ;
wire         memRead ;
wire         memWrite;
wire         memToReg;
wire [1:0]   aluOp   ;
wire [3:0]   aluCtl  ;
wire         aluSrc  ;
wire [63:0]  writeResult;
reg [63:0] writeResultReg;
wire [63:0]  newPC;
wire [63:0]  curretPC;
wire [63:0]  immidiateValue;

// Wires to interconnect Register File and ALU
wire [63:0]  readResult01;
wire [63:0]  readResult02;
wire [63:0]  muxReadResult02;
wire           zeroFlag;
wire  [63:0]    aluResult;

// Wires to interconnect the PC genrator and Instrcution memory block
wire [63:0]  nextPC;

//************************************************************************************************
// Program Counter Register
//************************************************************************************************

// Reset processor and update PC 
always @( posedge reset, posedge clk)
begin    
        // Reset PC register
        if(reset) 
            pc <= 64'd0; 
        else begin
           // Flash code from debugger
           if(flashEn)
                pc <= pc + 1;
           // Update PC
           else
                pc <= nextPC; 
        end
end 

//************************************************************************************************
// Processor Module Instantiation
//************************************************************************************************
  
// Instrcution Memory instantiation
instructionMemory insMem( pc , flashEn, flashInstruction, pcBypass,instruction);

// Decoder instantiation
decoder dec(instruction, pcBypass, branch,memRead, memWrite, memToReg, 
            aluOp, aluCtl, aluSrc, regWriteFlag, readAddr01, readAddr02, 
            writeAddr01, newPC, curretPC, immidiateValue);
            
// Register File instantiation
regFile regFl(clk, reset, regWriteFlag, readAddr01, readAddr02, writeAddr01, 
              writeResultReg, readResult01, readResult02);

// Mux to control ALU second operand datapath
assign muxReadResult02 = aluSrc ? immidiateValue : readResult02 ;
            
// ALU instantiation
ALU_Bhv alu(readResult01, muxReadResult02, aluCtl, aluOp, zeroFlag, aluResult);

// next PC generator instantiation
branchPCGenrator branchPCGen(branch, zeroFlag, newPC, curretPC, immidiateValue, nextPC);

// Data Memory instantiation
dataMemory dataMem(clk, memWrite, memRead, aluResult, readResult02, writeResult);

// Mux to control datapath of memory and ALU result
always @(writeResult, aluResult, aluResult)
    writeResultReg = memToReg ? writeResult : aluResult ;
                       
endmodule
