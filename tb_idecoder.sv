module tb_idecoder(output err);
  reg [15:0] ir;
  reg [1:0] reg_sel;
  reg[2:0] opcode;
  reg[1:0] ALU_op;
  reg[1:0] shift_op;
  reg[15:0] sximm5;
  reg [15:0] sximm8;
  reg[2:0] r_addr;
  reg[2:0] w_addr;

  reg outErr =0;
  integer num_passes = 0;
  integer num_fails = 0;

  idecoder DUT(.ir(ir), .reg_sel(reg_sel), .opcode((opcode)), .ALU_op(ALU_op), .shift_op(shift_op), .sximm5(sximm5), .sximm8(sximm8), .r_addr(r_addr),.w_addr(w_addr));

  // initial begin
  //   clk = 1'b1;
  //   forever #5 clk = ~clk;
  // end

  initial begin
    #1;
     $display("\n=== RESET ===");


    ir = 16'b0000000000000000; //=================================================================================================================
    reg_sel = 2'b10;

    opcode = 3'b000;
    ALU_op = 2'b00;
shift_op = 2'b00;
r_addr = 3'b000;
w_addr = 3'b000;
sximm8 = 16'b0000000000000000;
sximm5 = 16'b0000000000000000;


    #5;
    //opcode
assert (opcode === 3'b000)begin 
        $display("[PASS]: val is 000");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", opcode);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (ALU_op === 2'b00)begin 
        $display("[PASS]: val is 00");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", ALU_op);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (sximm5 === 16'b0000000000000000)begin 
        $display("[PASS]: val is correct");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", sximm5);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (sximm8 === 16'b0000000000000000)begin 
        $display("[PASS]: val is correct");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", sximm8);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (shift_op === 2'b00)begin 
        $display("[PASS]: val is correct");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", shift_op);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
    //testing Rn
   assert (r_addr === 3'b000)begin 
        $display("[PASS]: val is correct");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", r_addr);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (w_addr === 3'b000)begin 
        $display("[PASS]: val is correct");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", w_addr);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   #5;
   //Rd
    reg_sel = 01;
    #5;
    assert (r_addr === 3'b000)begin 
        $display("[PASS]: val is correct");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", r_addr);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (w_addr === 3'b000)begin 
        $display("[PASS]: val is correct");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", w_addr);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   #5;
   //Rm
    reg_sel = 00;
    #5;
    assert (r_addr === 3'b000)begin 
        $display("[PASS]: val is correct");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", r_addr);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (w_addr === 3'b000)begin 
        $display("[PASS]: val is correct");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", w_addr);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   ir = 16'b1111111111111111; //=================================================================================================================
    reg_sel = 2'b10;

//     opcode = 3'b000;
//     ALU_op = 2'b00;
// shift_op = 2'b00;
// r_addr = 3'b000;
// w_addr = 3'b000;
// sximm8 = 16'b0000000000000000;
// sximm5 = 16'b0000000000000000;


    #5;
    //opcode
assert (opcode === 3'b111)begin 
        $display("[PASS]: val is 000");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", opcode);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (ALU_op === 2'b11)begin 
        $display("[PASS]: val is 00");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", ALU_op);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (sximm5 === 16'b1111111111111111)begin 
        $display("[PASS]: val is correct");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", sximm5);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (sximm8 === 16'b1111111111111111)begin 
        $display("[PASS]: val is correct");
        num_passes = num_passes+1;
        
   end else begin   
        $error("[FAIL]: amount is %-d (expected 000)", sximm8);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (shift_op === 2'b11)begin 
        $display("[PASS]: val is correct");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", shift_op);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
    //testing Rn
   assert (r_addr === 3'b111)begin 
        $display("[PASS]: val is correct");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", r_addr);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (w_addr === 3'b111)begin 
        $display("[PASS]: val is correct");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", w_addr);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   #5;
   //Rd
    reg_sel = 01;
    #5;
    assert (r_addr === 3'b111)begin 
        $display("[PASS]: val is correct");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", r_addr);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (w_addr === 3'b111)begin 
        $display("[PASS]: val is correct");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", w_addr);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   #5;
   //Rm
    reg_sel = 00;
    #5;
    assert (r_addr === 3'b111)begin 
        $display("[PASS]: val is correct");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", r_addr);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (w_addr === 3'b111)begin 
        $display("[PASS]: val is correct");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", w_addr);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

    ir = 16'b1010101010101010; //=================================================================================================================
    reg_sel = 2'b10;

//     opcode = 3'b000;
//     ALU_op = 2'b00;
// shift_op = 2'b00;
// r_addr = 3'b000;
// w_addr = 3'b000;
// sximm8 = 16'b0000000000000000;
// sximm5 = 16'b0000000000000000;


    #5;
    //opcode
assert (opcode === 3'b101)begin 
        $display("[PASS]: val is 000");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", opcode);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (ALU_op === 2'b01)begin 
        $display("[PASS]: val is 00");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", ALU_op);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (sximm5 === 16'b0000000000001010)begin 
        $display("[PASS]: val is correct");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", sximm5);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (sximm8 === 16'b1111111110101010)begin 
        $display("[PASS]: val is correct");
        num_passes = num_passes+1;
        
   end else begin   
        $error("[FAIL]: amount is %-d (expected 000)", sximm8);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (shift_op === 2'b01)begin 
        $display("[PASS]: val is correct");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", shift_op);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   #5;
    //testing Rn
   assert (r_addr === 3'b010)begin 
        $display("[PASS]: val is correct");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", r_addr);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   #5;
   assert (w_addr === 3'b010)begin 
        $display("[PASS]: val is correct");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", w_addr);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   #5;
   //Rd
    reg_sel = 01;
    #5;
    assert (r_addr === 3'b101)begin 
        $display("[PASS]: val is correct");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 101)", r_addr);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (w_addr === 3'b101)begin 
        $display("[PASS]: val is correct");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", w_addr);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   #5;
   //Rm
    reg_sel = 00;
    #5;
    assert (r_addr === 3'b010)begin 
        $display("[PASS]: val is correct");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", r_addr);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (w_addr === 3'b010)begin 
        $display("[PASS]: val is correct");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected 000)", w_addr);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   $display("\n\n==== TEST SUMMARY ====");
    $display("  TEST COUNT: %-5d", num_passes + num_fails);
    $display("    - PASSED: %-5d", num_passes);
    $display("    - FAILED: %-5d", num_fails);
    $display("======================\n\n");
    $stop;
    

  end

  assign err = outErr;





endmodule: tb_idecoder

