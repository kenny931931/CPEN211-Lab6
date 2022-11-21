module cpu(input clk, input rst_n, input load, input start, input [15:0] instr,
           output waiting, output [15:0] out, output N, output V, output Z);
  // your implementation here
  reg [15:0] f_instr;
  wire [15:0] sximm5, sximm8, d_out;
  wire [2:0] opcode, r_addr, w_addr;
  wire [1:0] reg_sel, wb_sel, op, shift_op; //op = ALU_op OR op
  wire z, n, v, w, w_en, en_A, en_B, en_C, en_status, sel_A, sel_B;
  
  assign out = d_out;
  assign Z = z;
  assign N = n;
  assign V = v;
  assign waiting = w;
  
  // Instruction decoder
  idecoder i(f_instr, reg_sel,
        opcode, op, shift_op,
		sximm5, sximm8,
		r_addr, w_addr);
		
  // Controller FSM
  controller c(clk, rst_n, start,
        opcode, op, shift_op,
		z, n, v,
		w,
		reg_sel, wb_sel, w_en,
		en_A, en_B, en_C, en_status,
		sel_A, sel_B);
		
  // Modified datapath
  datapath d(clk, 16'b0, 8'b0, wb_sel,
        w_addr, w_en, r_addr, en_A,
		en_B, shift_op, sel_A, sel_B,
		op, en_C, en_status,
		sximm8, sximm5,
		d_out, z, n, v);
  
  always_ff @(posedge clk) begin
    if (load)
	  f_instr <= instr;
  end
endmodule: cpu
