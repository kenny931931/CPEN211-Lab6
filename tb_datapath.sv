module tb_datapath(output err);
  // your implementation here

  reg clk, w_en, en_A, en_B, sel_A, sel_B, en_C, en_status, Z_out, N_out, V_out;
  reg [15:0] mdata, sximm8, sximm5, datapath_out;
  reg [7:0] pc;
  reg [2:0] w_addr, r_addr;
  reg [1:0] wb_sel, shift_op, ALU_op;

  reg outErr;

  integer num_passes = 0;
  integer num_fails = 0;

  datapath DUT(.clk(clk), .mdata(mdata), .pc(pc), .wb_sel(wb_sel), .w_addr(w_addr), .w_en(w_en), .r_addr(r_addr), .en_A(en_A),
                .en_B(en_B), .shift_op(shift_op), .sel_A(sel_A), .sel_B(sel_B),
                .ALU_op(ALU_op), .en_C(en_C), .en_status(en_status),
				.sximm8(sximm8), .sximm5(sximm5),
                .datapath_out(datapath_out), .Z_out(Z_out), .N_out(N_out), .V_out(V_out));

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
    w_en = 1'b1;
    w_addr = address; 
    wb_sel = 2'b10;
    sximm8 = valToAdd;
    #10;
  endtask

  task test(input [2:0] destination,  input [2:0] valA,  input [2:0] valB, input signed [15:0] exp_val, input [2:0] exp_f, input [1:0] ALU_ctrl, input [1:0] sh_ctrl);
    //load value in register oneR into flip-flop A 
    r_addr = valA;
    en_A = 1'b1;
    en_B = 1'b0;
    w_en = 1'b0;
    #10;

    //load value in register twoR into flip-flop B
    r_addr = valB;
    en_A = 1'b0;
    en_B = 1'b1;
    w_en = 1'b0;
    #10;

    //perform computation
    en_A = 1'b0; //might need to space out 
    en_B = 1'b0;
    ALU_op = ALU_ctrl;
    shift_op = sh_ctrl;
    en_C = 1'b1;
    en_status = 1'b1;
    w_en = 1'b0;
    #10;
   
    assert (datapath_out == exp_val && {Z_out, N_out, V_out} == exp_f)begin 
      $display("[PASS]: val is %-d and flag[ZNV] is %-b", exp_val, exp_f);
      num_passes = num_passes+1;
        
      end else begin
      $error("[FAIL]: val is %-d (expected %-d) and flag[ZNV] is %-b (expected %-b)", datapath_out, exp_val, {Z_out, N_out, V_out}, exp_f);
      outErr = 1'b1;
      num_fails = num_fails+1;
    end
	#10;
	
    //write back result and store in RF
    en_status = 1'b0;
    w_en = 1'b1;
    wb_sel = 2'b00;
    w_addr = destination;
    #10;
  endtask

  initial begin
    clk = 1'b1;
    forever #5 clk = ~clk;
  end

//=====================================================================TESTS=====================================================
  initial begin
    $display("\n=== RESET ===");
    #1;
    clk = 0;
	w_en = 0;
	en_A = 0;
	en_B = 0;
	en_C = 0;
	en_status = 0;
	wb_sel = 2'b0;
    sel_A = 0;
	sel_B = 0;
	
    outErr = 1'b0;
	
	$display("\n=== TEST SET 1 ===");
	$display("\n(normal operation of ALU and shifter)");
	begin
	  //Reset
      writeTo(3'b000,16'd0);
      writeTo(3'b001,16'd1);
      writeTo(3'b010,16'd2);
      writeTo(3'b011,16'd3);
      writeTo(3'b100,16'd4);
      writeTo(3'b101,16'd5);
      writeTo(3'b110,16'd6);
      writeTo(3'b111,16'd7);
	  
      sel_A = 1'b0;
      sel_B = 1'b0;
	  
	  //ADD: 1+2=3 into reg1 (normal addition)
	  test(`regOne, `regTwo, `regThree, 16'd3, 3'b000, 2'b00, 2'b00);
		   
	  //ADD: 3+2=5 into reg1 (memory write)
	  test(`regOne, `regOne, `regThree, 16'd5, 3'b000, 2'b00, 2'b00);

	  //SUB: 4-5=-1 into reg4 (normal substraction)
	  test(`regFour, `regFive, `regSix, -16'd1, 3'b010, 2'b01, 2'b00);
		
	  //SUB: 4-(-1)=5 into reg4 (memory write)
	  test(`regFour, `regFive, `regFour, 16'd5, 3'b000, 2'b01, 2'b00);
	  
	  //AND: 1 AND 4=0 into reg1 (bitwise AND with LSL, zero)
	  test(`regOne, `regTwo, `regThree, 16'd0, 3'b100, 2'b10, 2'b01);
	  
	  //NOT: NOT 8 into reg1 (bitwise negation with LSR)
	  writeTo(3'b000, 16'd16);
	  test(`regOne, `regTwo, `regOne, -16'd9, 3'b010, 2'b11, 2'b10);
	  
	  //NOT: NOT -9 into reg1 (bitwise negation with arithmetic right shift)
	  test(`regOne, `regTwo, `regOne, 16'd4, 3'b000, 2'b11, 2'b11);
	  
	  //ADD: 32767+1=-32768 into reg1 (overflow)
	  writeTo(3'b111, 16'd32767);
	  test(`regOne, `regTwo, `regEight, -16'd32768, 3'b011, 2'b00, 2'b00);
	  
	  //SUB: -32768-1=32767 into reg1 (underflow)
	  test(`regOne, `regOne, `regTwo, 16'd32767, 3'b001, 2'b01, 2'b00);

	end
	
	$display("\n=== TEST SET 2 ===");
	$display("\n(sel_A and sel_B = 1)");
	begin
	  writeTo(3'b000,16'd0);
      writeTo(3'b001,16'd1);
      writeTo(3'b010,16'd2);
      writeTo(3'b011,16'd3);
      writeTo(3'b100,16'd4);
      writeTo(3'b101,16'd5);
      writeTo(3'b110,16'd6);
      writeTo(3'b111,16'd7);
	  
      sel_A = 1'b1;
      sel_B = 1'b1;
	  
	  sximm5 = 16'd98;
	  test(`regOne, `regTwo, `regThree, 16'd98, 3'b000, 2'b00, 2'b00);
	  test(`regOne, `regTwo, `regThree, -16'd98, 3'b010, 2'b01, 2'b01);
	  test(`regOne, `regTwo, `regThree, 16'd0, 3'b100, 2'b10, 2'b10);
	  test(`regOne, `regTwo, `regThree, -16'd99, 3'b010, 2'b11, 2'b11);
	end
    

$display("\n\n==== TEST SUMMARY ====");
    $display("  TEST COUNT: %-5d", num_passes + num_fails);
    $display("    - PASSED: %-5d", num_passes);
    $display("    - FAILED: %-5d", num_fails);
    $display("======================\n\n");
    $stop;
    

  end

  assign err = outErr;


  
endmodule: tb_datapath
