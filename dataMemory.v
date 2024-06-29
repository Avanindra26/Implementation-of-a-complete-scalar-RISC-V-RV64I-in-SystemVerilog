module dataMemory(input   wire         clk,
                  input   wire         memWriteEnable,
                  input   wire         memReadEnable,
                  input   wire [63:0]   address,
                  input   wire [63:0]   writeData,
                  output  reg  [63:0]  readData);
                  
reg [7:0] memoryFile [127:0];

// Write operation if memory write enable
always @(posedge clk)
begin
    if (memWriteEnable) begin
          {memoryFile[address+7],memoryFile[address+6],memoryFile[address+5],memoryFile[address+4],memoryFile[address+3],memoryFile[address+2],memoryFile[address+1],memoryFile[address]} <= writeData[63:0];      
    end 
end    

// Read operation if memoryr read ewnable
always @(*)  begin                
    if(memReadEnable) begin
       readData[7:0]    = memoryFile[address]   ;             
       readData[15:8]   = memoryFile[address+1] ;             
       readData[23:16]  = memoryFile[address+2] ;             
       readData[31:24]  = memoryFile[address+3] ;             
       readData[39:32]  = memoryFile[address+4] ;             
       readData[47:40]  = memoryFile[address+5] ;             
       readData[55:48]  = memoryFile[address+6] ;             
       readData[63:56]  = memoryFile[address+7] ;                    
    end                  
end

// Initializing data
initial begin
    // Doubleword 1
    memoryFile[0] = 8'hcc;
    memoryFile[1] = 8'hdd;
    memoryFile[2] = 8'hee;
    memoryFile[3] = 8'hff;
    memoryFile[4] = 8'h11;
    memoryFile[5] = 8'h22;
    memoryFile[6] = 8'h33;
    memoryFile[7] = 8'h44;
    
    // Doubleword 2
    memoryFile[8]  = 8'haa;
    memoryFile[9]  = 8'hbb;
    memoryFile[10] = 8'hcc;
    memoryFile[11] = 8'hdd;
    memoryFile[12] = 8'h55;
    memoryFile[13] = 8'h66;
    memoryFile[14] = 8'h77;
    memoryFile[15] = 8'h88;
    
end

endmodule
