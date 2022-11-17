module tb_datapath(output err);
  // your implementation here

  reg clk;
  reg [15:0] datapath_in;
  reg wb_sel;
  reg [2:0] w_addr;
  reg w_en;
  reg [2:0] r_addr;
  reg en_A;
  reg en_B;
  reg [1:0] shift_op;
  reg sel_A;
  reg sel_B;
  reg [1:0] ALU_op;
  reg en_C;
  reg en_status;

  reg [15:0] datapath_out;
  reg Z_out;

  reg outErr;

  integer num_passes = 0;
  integer num_fails = 0;

  datapath DUT(.clk(clk), .datapath_in(datapath_in), .wb_sel(wb_sel), .w_addr(w_addr), .w_en(w_en), .r_addr(r_addr), .en_A(en_A),
                .en_B(en_B), .shift_op(shift_op), .sel_A(sel_A), .sel_B(sel_B),
                .ALU_op(ALU_op), .en_C(en_C), .en_status(en_status),
                .datapath_out(datapath_out), .Z_out(Z_out));

  `define regOne 3'b000
  `define regTwo 3'b001
  `define regThree 3'b010
  `define regFour 3'b011
  `define regFive 3'b100
  `define regSix 3'b101
  `define regSeven 3'b110
  `define regEight 3'b111
  
  //================================================================================TASKS===========================================
  
   task writeTo(input [2:0] address, input [15:0] valToAdd);
   #5;
   w_en = 1'b1;
   w_addr = address; 
   wb_sel = 1'b1;
   datapath_in = valToAdd;
   #10;

   endtask

   task set(input [2:0] destination,  input [2:0] oneR,  input [2:0] twoR, input signed [15:0] expectedVal, input [1:0] ALUcontrol);
   //load value in register oneR into flip-flop A 
   #5;
   r_addr = oneR;
   en_A = 1'b1;
   en_B = 1'b0;
   w_en = 1'b0;

   #10;

   //load value in register twoR into flip-flop B
   r_addr = twoR;
   en_A = 1'b0;
   en_B = 1'b1;
   w_en = 1'b0;
   #10;

   //perform computation
   #5;
   en_A = 1'b0; //might need to space out 
   en_B = 1'b0;
   ALU_op = ALUcontrol;
   sel_A = 1'b0;
   sel_B = 1'b0;
   shift_op = 2'b00;
   en_C = 1'b1;
   en_status = 1'b1;
   w_en = 1'b0;

    #10;
    assert (datapath_out === expectedVal)begin 
        $display("[PASS]: val is %-d", expectedVal);
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected %-d)", datapath_out, expectedVal);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

  

   //write back result and store in RF

#5;

en_status = 1'b0;
w_en = 1'b1;
wb_sel = 1'b0;
w_addr = destination;
#10;

   endtask
   task setNotSpecified(input [2:0] destination,  input [2:0] oneR,  input [2:0] twoR, input signed [15:0]  expectedVal, input [1:0] ALUcontrol);
   //load value in register oneR into flip-flop A 
   #5;
   r_addr = oneR;
   en_A = 1'b1;
   en_B = 1'b0;
   w_en = 1'b0;

   #10;

   //load value in register twoR into flip-flop B
   r_addr = twoR;
   en_A = 1'b0;
   en_B = 1'b1;
   w_en = 1'b0;
   #10;

   //perform computation
   #5;
   en_A = 1'b0; //might need to space out 
   en_B = 1'b0;
   ALU_op = ALUcontrol;
   sel_A = 1'b0;
   sel_B = 1'b0;
   
   en_C = 1'b1;
   en_status = 1'b1;
   w_en = 1'b0;

    #10;
    assert (datapath_out === expectedVal)begin 
        $display("[PASS]: val is %-d", expectedVal);
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected %-d)", datapath_out, expectedVal);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

  

   //write back result and store in RF

#5;

en_status = 1'b0;
w_en = 1'b1;
wb_sel = 1'b0;
w_addr = destination;
#10;

   endtask

  initial begin
    clk = 1'b1;
    forever #5 clk = ~clk;
  end
//=====================================================================TESTS=====================================================
//=====================================================================TESTS=====================================================
  initial begin
     $display("\n=== RESET ===");
  #1;
    {clk, datapath_in, wb_sel, w_addr, w_en, r_addr, en_A, //might not be supposed to reset everything
                en_B, shift_op, sel_A, sel_B,
                ALU_op, en_C, en_status,
                datapath_out, Z_out} = 51'b000000000000000000000000000000000000000000000000000;

   
     outErr = 1'b0;


    //write to all registers

    writeTo(3'b000,16'b0000000000000000);
    writeTo(3'b001,16'b0000000000000001);
    writeTo(3'b010,16'b0000000000000010);
    writeTo(3'b011,16'b0000000000000011);
    writeTo(3'b100,16'b0000000000000100);
    writeTo(3'b101,16'b0000000000000101);
    writeTo(3'b110,16'b0000000000000110);
    writeTo(3'b111,16'b0000000000000111);

    //ADD 1,2,3
    set(`regOne,`regTwo,`regThree, 16'd3, 2'b00);
       

    //ADD 1,2,3
    set(`regOne,`regOne,`regThree, 16'd5,2'b00);
   

    //SUB 4,5,6
    set(`regFour,`regFive,`regSix, -16'd1, 2'b01);
    
    set(`regFour, `regFive, `regFour, 16'd5, 2'b01 ); //= 4-(-1)

    writeTo(3'b000,16'b0000000000000000);
    writeTo(3'b001,16'b0000000000000001);
    writeTo(3'b010,16'b0000000000000010);
    writeTo(3'b011,16'b0000000000000011);
    writeTo(3'b100,16'b0000000000000100);
    writeTo(3'b101,16'b0000000000000101);
    writeTo(3'b110,16'b0000000000000110);
    writeTo(3'b111,16'b0000000000000111);
    

    set(`regEight, `regSeven, `regSix, 16'b0000000000000100, 2'b10);

    


    set(`regSeven, `regEight, `regFour, 16'b0000000000000000, 2'b10);


    set(`regOne, `regFive, `regSix, 16'b1111111111111010, 2'b11);


    set(`regThree, `regFive, `regOne, 16'b0000000000000101, 2'b11);


    writeTo(3'b000,16'b0000000000000000);


    set(`regOne,`regFive, `regOne, 16'b1111111111111111,2'b11);



    writeTo(3'b000,16'b0000000000000000);
    writeTo(3'b001,16'b0000000000000001);
    writeTo(3'b010,16'b0000000000000010);
    writeTo(3'b011,16'b0000000000000011);
    writeTo(3'b100,16'b0000000000000100);
    writeTo(3'b101,16'b0000000000000101);
    writeTo(3'b110,16'b0000000000000110);
    writeTo(3'b111,16'b0000000000000111);
    #3;

//Sel A and b are 1 ================================================================================
datapath_in = 16'd0;
sel_A=1'b1;
sel_B=1'b1;

en_C=1;
ALU_op = 2'b00;
en_status = 1'b1;
#5;
 assert (datapath_out === 16'd0)begin 
        $display("[PASS]: val is decimal 0");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected decimal 0)", datapath_out);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
  assert (Z_out === 1'b1)begin
    $display("[PASS]: Z_out is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: Z_out is %-d (expected 1)", Z_out);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   #5;
   

datapath_in = 16'd10;
sel_A=1'b1;
sel_B=1'b1;
#5;
en_C=1;
ALU_op = 2'b01;
#5;
 assert (datapath_out === 16'd10)begin 
        $display("[PASS]: val is decimal 10");
        num_passes = num_passes+1;
        
   end else begin
        $error("[FAIL]: amount is %-d (expected decimal 10)", datapath_out);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

//============================================================================================================with addition

#5;
    writeTo(3'b000,16'b0000000000000000);
    writeTo(3'b001,16'b0000000000000001);
    writeTo(3'b010,16'b0000000000000010);
    writeTo(3'b011,16'b0000000000000011);
    writeTo(3'b100,16'b0000000000000100);
    writeTo(3'b101,16'b0000000000000101);
    writeTo(3'b110,16'b0000000000000110);
    writeTo(3'b111,16'b0000000000000111);

    //left shift
    shift_op = 2'b01;

//(input [2:0] destination,  input [2:0] oneR,  input [2:0] twoR, input [15:0] expectedVal, input [1:0] ALUcontrol);
setNotSpecified(`regTwo, `regOne, `regSix, 16'd10, 2'b00);
setNotSpecified(`regOne, `regEight, `regOne, 16'd7, 2'b00);
writeTo(3'b000,16'b0000000000000000);
writeTo(3'b001,16'b0000000000000001);

//right shift
shift_op = 2'b10;
setNotSpecified(`regTwo, `regThree, `regOne, 16'd2, 2'b00);
setNotSpecified(`regTwo, `regSix, `regEight, 16'd8, 2'b00 );

 writeTo(3'b001,16'b0000000000000001);
 writeTo(3'b111,16'b1000000000000111);

//arithmetic right shift
shift_op = 2'b11;
setNotSpecified(`regTwo, `regTwo, `regEight,16'b1100000000000100, 2'b00);
writeTo(3'b111,16'b0000000000000111);
setNotSpecified(`regTwo,`regOne, `regEight, 16'd3, 2'b00);

//-========================================================================================================with subtraction
#5;
    writeTo(3'b000,16'b0000000000000000);
    writeTo(3'b001,16'b0000000000000001);
    writeTo(3'b010,16'b0000000000000010);
    writeTo(3'b011,16'b0000000000000011);
    writeTo(3'b100,16'b0000000000000100);
    writeTo(3'b101,16'b0000000000000101);
    writeTo(3'b110,16'b0000000000000110);
    writeTo(3'b111,16'b0000000000000111);

    //left shift
    shift_op = 2'b01;

//(input [2:0] destination,  input [2:0] oneR,  input [2:0] twoR, input [15:0] expectedVal, input [1:0] ALUcontrol);
setNotSpecified(`regTwo, `regOne, `regSix, -16'd10, 2'b01);
setNotSpecified(`regOne, `regEight, `regOne, 16'd7, 2'b01);
writeTo(3'b000,16'b0000000000000000);
writeTo(3'b001,16'b0000000000000001);

//right shift
shift_op = 2'b10;
setNotSpecified(`regTwo, `regThree, `regOne, 16'd2, 2'b01);
setNotSpecified(`regTwo, `regSix, `regEight, 16'd2, 2'b01 );

 writeTo(3'b001,16'b0000000000000001);
 writeTo(3'b111,16'b1000000000000111);

//arithmetic right shift
shift_op = 2'b11;
setNotSpecified(`regTwo, `regTwo, `regEight,16'd16382, 2'b01);
writeTo(3'b111,16'b0000000000000111);
setNotSpecified(`regTwo,`regOne, `regEight, -16'd3, 2'b01);

//============================================================================================================with AND

#5;
    writeTo(3'b000,16'b0000000000000000);
    writeTo(3'b001,16'b0000000000000001);
    writeTo(3'b010,16'b0000000000000010);
    writeTo(3'b011,16'b0000000000000011);
    writeTo(3'b100,16'b0000000000000100);
    writeTo(3'b101,16'b0000000000000101);
    writeTo(3'b110,16'b0000000000000110);
    writeTo(3'b111,16'b0000000000000111);

    //left shift
    shift_op = 2'b01;

//(input [2:0] destination,  input [2:0] oneR,  input [2:0] twoR, input [15:0] expectedVal, input [1:0] ALUcontrol);
setNotSpecified(`regTwo, `regOne, `regSix, 16'd0, 2'b10);
en_status = 1'b1;
#5;
  assert (Z_out === 1'b1)begin
    $display("[PASS]: Z_out is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: Z_out is %-d (expected 1)", Z_out);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   #5;
setNotSpecified(`regOne, `regEight, `regOne, 16'd0, 2'b10);
en_status = 1'b1;
#5;
  assert (Z_out === 1'b1)begin
    $display("[PASS]: Z_out is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: Z_out is %-d (expected 1)", Z_out);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   #5;
writeTo(3'b000,16'b0000000000000000);
writeTo(3'b001,16'b0000000000000001);

//right shift
shift_op = 2'b10;
setNotSpecified(`regTwo, `regThree, `regOne, 16'd0, 2'b10);
en_status = 1'b1;
#5;
  assert (Z_out === 1'b1)begin
    $display("[PASS]: Z_out is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: Z_out is %-d (expected 1)", Z_out);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   #5;
setNotSpecified(`regTwo, `regSix, `regEight, 16'd1, 2'b10 );

 writeTo(3'b001,16'b0000000000000001);
 writeTo(3'b111,16'b1000000000000111);

//arithmetic right shift
shift_op = 2'b11;
setNotSpecified(`regTwo, `regTwo, `regEight,16'd1, 2'b10);
writeTo(3'b111,16'b0000000000000111);
setNotSpecified(`regTwo,`regOne, `regEight, 16'd0, 2'b10);
en_status = 1'b1;
#5;
  assert (Z_out === 1'b1)begin
    $display("[PASS]: Z_out is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: Z_out is %-d (expected 1)", Z_out);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   #5;
//-========================================================================================================with negation
#5;
    writeTo(3'b000,16'b0000000000000000);
    writeTo(3'b001,16'b0000000000000001);
    writeTo(3'b010,16'b0000000000000010);
    writeTo(3'b011,16'b0000000000000011);
    writeTo(3'b100,16'b0000000000000100);
    writeTo(3'b101,16'b0000000000000101);
    writeTo(3'b110,16'b0000000000000110);
    writeTo(3'b111,16'b0000000000000111);

    //left shift
    shift_op = 2'b01;

//(input [2:0] destination,  input [2:0] oneR,  input [2:0] twoR, input [15:0] expectedVal, input [1:0] ALUcontrol);
setNotSpecified(`regTwo, `regOne, `regSix, -16'd11, 2'b11);
setNotSpecified(`regOne, `regEight, `regOne, -16'd1, 2'b11);
writeTo(3'b000,16'b0000000000000000);
writeTo(3'b001,16'b0000000000000001);

//right shift
shift_op = 2'b10;
setNotSpecified(`regTwo, `regThree, `regOne,  -16'd1, 2'b11);
setNotSpecified(`regTwo, `regSix, `regEight,  -16'd4, 2'b11 );

 writeTo(3'b001,16'b0000000000000001);
 writeTo(3'b111,16'b1000000000000111);

//arithmetic right shift
shift_op = 2'b11;
setNotSpecified(`regTwo, `regTwo, `regEight,16'd16380, 2'b11);
writeTo(3'b111,16'b0000000000000111);
setNotSpecified(`regTwo,`regOne, `regEight, -16'd4, 2'b11);






  

$display("\n\n==== TEST SUMMARY ====");
    $display("  TEST COUNT: %-5d", num_passes + num_fails);
    $display("    - PASSED: %-5d", num_passes);
    $display("    - FAILED: %-5d", num_fails);
    $display("======================\n\n");
    $stop;
    

  end

  assign err = outErr;


  
endmodule: tb_datapath

