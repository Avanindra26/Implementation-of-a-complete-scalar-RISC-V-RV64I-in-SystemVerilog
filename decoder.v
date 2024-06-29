module decoder(input   wire [31:0]  instruction,
               input   wire [63:0]  pc,
               output  reg  branch,
               output  reg  memRead,
               output  reg  memWrite,
               output  reg  memToReg,
               output  reg  [1:0] aluOp,
               output  reg  [3:0] aluCtl,
               output  reg  aluSrc,
               output  reg  writeReg,
               output  reg  [4:0]   readAddr01,
               output  reg  [4:0]   readAddr02,
               output  reg  [4:0]   writeAddr01,
               output  wire [63:0]  newPC,
               output  wire [63:0]  curretPC,
               output  reg  [63:0]  immidiateValue);

parameter rType      = 7'b0110011,
          memLoad    = 7'b0000011,
          memStore   = 7'b0100011,
          branchIfEq = 7'b1100011,
          Add        = 10'b0000000000,
          Subtract   = 10'b0100000000,
          And        = 10'b0000000111,
          Or         = 10'b0000000110;              

wire [6:0] opCode; 

//Update current PC
assign curretPC = pc;

//Increment PC to next fetch next instruction
assign newPC = pc + 4;

//OpCode 
assign opCode = instruction[6:0];

// Control Signals Settings based on core instruction format
always @(*)         
begin 
    case (opCode) 
        // R Type instruction  
        rType      : begin
                     branch   = 1'b0;
                     memRead  = 1'b0;
                     memWrite = 1'b0;
                     memToReg = 1'b0;
                     aluSrc   = 1'b0;
                     writeReg = 1'b1;
                     end
        // Memory load instrution 
        memLoad    : begin
                     branch   = 1'b0;
                     memRead  = 1'b1;
                     memWrite = 1'b0;
                     memToReg = 1'b1;
                     aluSrc   = 1'b1;
                     writeReg = 1'b1;
                     end
        // Memory store instrution 
        memStore   : begin
                     branch   = 1'b0;
                     memRead  = 1'b0;
                     memWrite = 1'b1;
                     memToReg = 1'b0;
                     aluSrc   = 1'b1;
                     writeReg = 1'b0;
                     end
        // Branch instruction 
        branchIfEq : begin
                     branch   = 1'b1;
                     memRead  = 1'b0;
                     memWrite = 1'b0;
                     memToReg = 1'b0;
                     aluSrc   = 1'b0;
                     writeReg = 1'b0;
                     end 
        // Default setting
        default    : begin
                     branch   = 1'b0;
                     memRead  = 1'bX;
                     memWrite = 1'bX;
                     memToReg = 1'bX;
                     aluSrc   = 1'bX;
                     writeReg = 1'bX;
                     end 
     endcase
end

// ALU Operation Control based on core instruction format
always @(*)
begin
    case (opCode)
        // 31      25 24     20 19     15 14  12 11 7 6 0
        // | funct7 | rs2 | rs1 | funct3 | rd | opcode |       
        // R Type instruction decoding 
        rType      :         
                     begin
                     readAddr01 = instruction [19:15];
                     readAddr02 = instruction [24:20];
                     writeAddr01 = instruction [11:7];
                     aluOp = 2'b10;                     
                     // Determing the exact R type instruction
                     case ({instruction[31:25], instruction[14:12]} )
                        Add      : aluCtl = 4'b0010; 
                        Subtract : aluCtl = 4'b0110; 
                        And      : aluCtl = 4'b0000; 
                        Or       : aluCtl = 4'b0001; 
                     endcase
                     end
        
        // 31       25 24      20 19 15 14 12 11 7 6      0
        // |  imm[11:0]  |  rs1  | funct3 |  rd  | opcode |
        // Memory load instrution decoding
        memLoad    : 
                     begin
                        aluOp  = 2'b00;         // Setting the ALU mode
                        aluCtl = 4'b0010;       // Setting ALU operation
                        readAddr01 = instruction [19:15];
                        writeAddr01 = instruction [11:7];
                        immidiateValue[63:12] = 0;
                        immidiateValue[11:0]  =  instruction[31:20];
                     end       
        
        // 31      25 24     20 19     15 14     12 11 7 6      0
        // | imm[11:5] | rs2 | rs1 | funct3 | imm[4:0] | opcode |      
        // Memory store instrution decoding
        memStore   : 
                     begin
                        aluOp  = 2'b00;         // Setting the ALU mode 
                        aluCtl = 4'b0010;       // Setting ALU operation
                        readAddr01 = instruction [19:15];
                        readAddr02 = instruction [24:20];
                        immidiateValue[63:12] = 0;
                        immidiateValue[11:5]  = instruction[31:25];
                        immidiateValue[4:0]   = instruction[11:7];
                     end
        
        // 31       25 24     20 19     15 14     12 11      7 6      0
        // | imm[12|10:5] | rs2 | rs1 | funct3 | imm[4:1|11] | opcode |
        // Branch instruction decoding
        branchIfEq : // Branch instruction decoding
                     begin
                        aluOp  = 2'b01;         // Setting the ALU mode 
                        aluCtl = 4'b0110;       // Setting ALU operation
                        readAddr01 = instruction [19:15];
                        readAddr02 = instruction [24:20];
                        immidiateValue[63:12] = 0;
                        immidiateValue[11]    = instruction[31];
                        immidiateValue[10]    = instruction[7];
                        immidiateValue[9:4]   = instruction[30:25];
                        immidiateValue[3:0]   = instruction[11:8];
                     end
         // Default settings           
         default    : begin
                        aluOp  = 2'bXX;
                        aluCtl = 4'bXXXX;
                        readAddr01 = 5'bXXXXX;
                        readAddr02 = 5'bXXXXX;
                        immidiateValue[63:12] = 0;
                        immidiateValue[11]    = 0;
                        immidiateValue[10]    = 0;
                        immidiateValue[9:4]   = 0;
                        immidiateValue[3:0]   = 0;
                     end
    endcase
end
endmodule
