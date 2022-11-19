module tb_cpu(output err);
  // your implementation here
  
  reg clk, rst_n, load, start, waiting, N, V, Z;
  reg [15:0] instr, out;
  
  reg outErr;
  
  integer num_passes = 0;
  integer num_fails = 0;
  
  cpu DUT(.clk(clk), .rst_n(rst_n), .load(load), .start(start), .instr(instr),
        .waiting(waiting), .out(out), .N(N), .V(V), .Z(Z));
		
  `define reg1 3'b000
  `define reg2 3'b001
  `define reg3 3'b010
  `define reg4 3'b011
  `define reg5 3'b100
  `define reg6 3'b101
  `define reg7 3'b110
  `define reg8 3'b111
  
  `define MOV 5'b11010
  `define MOVr 5'b11000
  `define ADD 5'b10100
  `define CMP 5'b10101
  `define AND 5'b10110
  `define MVN 5'b10111
  
  //===== TASK =====
  task startf();
    start = 1'b1;#5;
	start = 1'b0;#5;
  endtask
  
  task restartf();
    rst_n = 1'b0;#5;
	rst_n = 1'b1;#5;
  endtask
  
  task loadf();
    load = 1'b1;#5;
	load = 1'b0;#5;
  endtask
  
  task run(input [15:0] in);
	instr = in;
	loadf();
	startf();
  endtask
  
  task init();
    restartf();
    run({`MOV, `reg1, 8'd0});#10; // 1 clock cycle for MOV
	run({`MOV, `reg2, 8'd1});#10;
	run({`MOV, `reg3, 8'd2});#10;
	run({`MOV, `reg4, 8'd3});#10;
	run({`MOV, `reg5, 8'd4});#10;
	run({`MOV, `reg6, 8'd5});#10;
	run({`MOV, `reg7, 8'd6});#10;
	run({`MOV, `reg8, 8'd7});#10;
  endtask
  
  task test(input [15:0] in, input signed [15:0] exp);
    run(in);#50; // 5 clock cycle for running any instruction
	assert(out == exp && waiting == 1'b0) begin
	  $display("[PASS]: val is $-d", exp);
	  num_passes = num_passes + 1;
	end else begin
	  $error("[FAIL] val is $-d (expected $-d), and waiting is $-b (expected $-b)", out, exp, waiting, 1'b0);
	  outErr = 1'b1;
	  num_fails = num_fails+1;
	end
  endtask
  
  task testCMP(input [15:0] in, input signed [15:0] exp, input [2:0] exp_f);
    run(in);#50; // 5 clock cycle for running any instruction
	assert(out == exp && {Z,N,V} == exp_f && waiting == 1'b0) begin
	  $display("[PASS]: val is $-d and flag[ZNV] is  $-b", exp, exp_f);
	  num_passes = num_passes + 1;
	end else begin
	  $error("[FAIL] val is $-d (expected $-d), flag[ZNV] is $-b (expected $-b), and waiting is $-b (expected $-b)", out, exp, {Z,N,V}, exp_f, waiting, 1'b0);
	  outErr = 1'b1;
	  num_fails = num_fails+1;
	end
  endtask
  
  initial begin
    clk = 1'b1;
    forever #5 clk = ~clk;
  end
  
  //===== TEST =====
  initial begin
    #1; // offset timing
	
	$display("\n=== TEST SET 1 ===");
	$display("\n(MOV immediate val)");
	begin
	  init();
	  test({`MOVr, 3'b000, `reg1, 2'b00, `reg1}, 16'd4);
	  test({`MOVr, 3'b000, `reg5, 2'b00, `reg5}, 16'd4);
	  test({`MOVr, 3'b000, `reg7, 2'b00, `reg7}, 16'd6);
	end
	
	$display("\n=== TEST SET 2 ===");
	$display("\n(MOV reg val");
	begin
	  init();
	  
	  // MOVr (no shift) (0 = 0 -> reg2)
	  test({`MOVr, 3'b000, `reg2, 2'b00, `reg1}, 16'd0);
	  test({`MOVr, 3'b000, `reg2, 2'b00, `reg2}, 16'd0);
	  
	  // MOVr (LSL) (2 = 4 -> reg4)
	  test({`MOVr, 3'b000, `reg4, 2'b01, `reg3}, 16'd4);
	  test({`MOVr, 3'b000, `reg4, 2'b00, `reg4}, 16'd4);
	  
	  // MOVr (LSR) (4 = 2 -> reg5)
	  test({`MOVr, 3'b000, `reg6, 2'b10, `reg5}, 16'd2);
	  test({`MOVr, 3'b000, `reg6, 2'b00, `reg6}, 16'd2);
	  
	  // MOVr (arithmetic right shift) (-3 = -2 -> reg8)
	  run({`MOV, `reg7, -8'd3});
	  test({`MOVr, 3'b000, `reg8, 2'b11, `reg7}, -16'd2);
	  test({`MOVr, 3'b000, `reg8, 2'b00, `reg8}, -16'd2);
	end
	
	$display("\n=== TEST SET 3 ===");
	$display("\n(ADD)");
	begin
	  init();
	  
	  // ADD (no shift) (0 + 1 = 1 -> reg3)
	  test({`ADD, `reg1, `reg3, 2'b00, `reg2}, 16'd1);
	  test({`MOVr, 3'b000, `reg3, 2'b00, `reg3}, 16'd1);
	  
	  // ADD (LSL) (3 + 8 = 11 -> reg6)
	  test({`ADD, `reg4, `reg6, 2'b01, `reg5}, 16'd11);
	  test({`MOVr, 3'b000, `reg6, 2'b00, `reg6}, 16'd11);
	end
	
	$display("\n=== TEST SET 4 ===");
	$display("\n(AND)");
	begin
	  init();
	  
	  // AND (LSR) (-2 & 1 = 0 -> reg3)
	  run({`MOV, `reg1, -8'd2});
	  test({`AND, `reg1, `reg3, 2'b01, `reg4}, 16'd0);
	  test({`MOVr, 3'b000, `reg3, 2'b00, `reg3}, 16'd0);
	  
	  // AND (no shift) (255 AND 69 = 69 -> reg6)
	  run({`MOV, `reg4, -8'd1});
	  run({`MOV, `reg5, 8'd69});
	  test({`AND, `reg4, `reg6, 2'b00, `reg5}, 16'd69);
	  test({`MOVr, 3'b000, `reg6, 2'b00, `reg6}, 16'd69);
	end
	
	$display("\n=== TEST SET5 ===");
	$display("\n(MVN)");
	begin
	  init();
	  
	  // MVN (no shift) (3 = -4 -> reg1)
	  test({`MVN, 3'b000, `reg1, 2'b00, `reg4}, -16'd4);
	  test({`MOVr, 3'b000, `reg1, 2'b00, `reg1}, -16'd4);
	  
	  // MVN (LSR) (93 = -47 -> reg2)
	  run({`MOV, `reg2, 8'd93});
	  test({`MVN, 3'b000, `reg2, 2'b10, `reg2}, -16'd47);
	  test({`MOVr, 3'b000, `reg2, 2'b00, `reg2}, -16'd47);
	  
	end
	
	$display("\n=== TEST SET 6 ===");
	$display("\n(CMP)");
	begin
	  init();
	  
	  // CMP (no shift) (3 - 1 = 2) status = 000
	  testCMP({`CMP, `reg4, 3'b000, 2'b00, `reg2}, 16'd2, 3'b000);
	  
	  // CMP (no shift) (1 - 3 = -2) status = 010
	  testCMP({`CMP, `reg2, 3'b000, 2'b00, `reg4}, -16'd2, 3'b010);
	  
	  // CMP (LSR) (2 - 4 = 0) status = 100
	  testCMP({`CMP, `reg3, 3'b000, 2'b10, `reg5}, 16'd0, 3'b100);
	  
	  // CMP (overflow)
	  // -19 -> 32758 -> reg1 (MOVr & LSR)
	  // -178 -> reg2
	  // 32758 - (-178) = 32936 (overflow -> -32600)
	  run({`MOV, `reg1, -8'd19});
	  run({`MOVr, 3'b000, `reg1, 2'b10, `reg1});
	  run({`MOV, `reg2, -8'd178});
	  testCMP({`CMP, `reg1, 3'b000, 2'b00, `reg2}, -16'd32600, 3'b011);
	end
  end
  
endmodule: tb_cpu
