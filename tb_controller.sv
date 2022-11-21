module tb_controller(output err);
  
reg clk;
reg rst_n;
reg start;
reg [2:0] opcode;
reg[1:0] ALU_op;
reg[1:0] shift_op;
reg waiting;
reg [1:0] reg_sel;
reg[1:0] wb_sel;
reg w_en;
reg en_A;
reg en_B;
reg en_C;
reg en_status;
reg sel_A;
reg sel_B;

reg outErr;

  integer num_passes = 0;
  integer num_fails = 0;

  integer iwaiting =0;
  integer iregsel =0;
    // integer iRn=0;
    // integer iRd=0;
    // integer iRm=0;
  integer iwbsel =0;
  integer iwen =0;
  integer iena=0;
  integer ienb=0;
  integer ienc=0;
  integer ienstatus=0;
  integer isela=0;
  integer iselb=0;

  controller DUT(.clk(clk), .rst_n(rst_n), .start(start), .opcode(opcode), .ALU_op(ALU_op), .shift_op(shift_op), .waiting(waiting),.reg_sel(reg_sel), .wb_sel(wb_sel),.w_en(w_en), .en_A(en_A), 
                  .en_B(en_B), .en_C(en_C), .en_status(en_status), .sel_A(sel_A), .sel_B(sel_B), .Z(Z), .V(V),.N(N));

                  //define
                  //tasks

    initial begin
    clk = 1'b1;
    forever #5 clk = ~clk;
  end
always @ (edge reg_sel[0])begin
    iregsel = iregsel +1;
end
always @ (edge reg_sel[1])begin
    iregsel = iregsel +1;
end
    
 always @ (edge waiting) begin
     iwaiting = iwaiting + 1;
 end
always @(edge wb_sel) iwbsel = iwbsel + 1;
    always @(edge w_en) iwen = iwen + 1;
 
always @(edge en_A)
     iena = iena + 1;
  
always @(edge en_B)
     ienb = ienb + 1;
  
always @(edge en_C)
     ienc = ienc + 1;


    always @(edge en_status)
     ienstatus = ienstatus + 1;

  
    always @(edge sel_A)
     isela = isela + 1;


    always @(edge sel_B)
     iselb = iselb + 1;

  
  


  initial begin
     $display("\n=== RESET ===");
  #1;
  outErr = 1'b0;

  rst_n = 1'b1;
  start =1'b0;
  opcode = 3'b000;
  ALU_op = 2'b00;
  shift_op = 2'b00;
//================================================================================================GOOD BEHAVIOUR==================================================================
//================================================================================================GOOD BEHAVIOUR==================================================================
//move immediate =============================================
  opcode = 3'b110; ALU_op = 2'b10; 
  #9;
  start = 1'b1;
  #10;
start = 1'b0;
  #1;
  #50;
   assert (iregsel  === 2)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iregsel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (iwen  === 2)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iwen);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (iwbsel  === 1)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iwbsel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (waiting  === 1'b1)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", waiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   #10;

   iregsel = 0;
   iwen =0;
   iwbsel =0;
   
//MOV (1 reg to another) =============================================================================
   $display("\n=== MOV(1 to another) ===");
   opcode = 3'b110; ALU_op = 2'b00;
   start = 1'b1;
   #10;
      start = 1'b0;
   #10;
    assert (waiting  === 1'b0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", waiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   #40;
    assert (waiting  === 1'b1)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", waiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
    assert (iregsel  === 2)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iregsel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
    assert (waiting  === 1'b1)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", waiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
    assert (ienb  === 2)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", ienb);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
    assert (waiting  === 1'b1)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", waiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
    assert (iwaiting  === 4)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iwaiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
    assert (isela  === 1)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", isela);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
    assert (iselb  === 1)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iselb);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (ienc  === 2)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", ienc);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (iregsel  === 2)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iregsel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   #10;

   iwaiting =0;
   iregsel =0;
   iwbsel =0;
   iwen =0;
   iena=0;
   ienb=0;
   ienc=0;
   ienstatus=0;
   isela=0;
   iselb=0;
//ADD ========================================================================
$display("\n=== ADD===");
   opcode = 3'b101; ALU_op = 2'b00;
   start = 1'b1;
   #10;
      start = 1'b0;
   #10;
    assert (waiting  === 1'b0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", waiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   #40;
   assert (iregsel  === 4)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iregsel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (ienb  === 2)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", ienb);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (iena  === 3)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iena);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (iwaiting  === 2)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iwaiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (isela  === 1)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", isela);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (iselb  === 0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iselb);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (ienc  === 2)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", ienc);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (iwbsel  === 0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iwbsel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   #10;
   iwaiting =0;
   iregsel =0;
   iwbsel =0;
   iwen =0;
   iena=0;
   ienb=0;
   ienc=0;
   ienstatus=0;
   isela=0;
   iselb=0;
//AND ========================================================================
$display("\n=== AND===");
   opcode = 3'b101; ALU_op = 2'b10;
   start = 1'b1;
   #10;
      start = 1'b0;
   #10;
    assert (waiting  === 1'b0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", waiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   #40;
   assert (iregsel  === 4)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iregsel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (ienb  === 2)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", ienb);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (iena  === 2)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iena);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (iwaiting  === 2)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iwaiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (isela  === 0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", isela);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (iselb  === 0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iselb);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (ienc  === 2)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", ienc);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (iwbsel  === 0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iwbsel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   #10;


 iwaiting =0;
   iregsel =0;
   iwbsel =0;
   iwen =0;
   iena=0;
   ienb=0;
   ienc=0;
   ienstatus=0;
   isela=0;
   iselb=0;
//CMP ========================================================================
$display("\n=== CMP===");
   opcode = 3'b101; ALU_op = 2'b01;
   start = 1'b1;
   #10;
      start = 1'b0;
   #50;
   assert (iregsel  === 2)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iregsel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (iena  === 2)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iena);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (ienb  === 2)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", ienb);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (iwaiting  === 2)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iwaiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (isela  === 0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", isela);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (iselb  === 0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iselb);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (ienstatus  === 2)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", ienstatus);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   #10;

iwaiting =0;
   iregsel =0;
   iwbsel =0;
   iwen =0;
   iena=0;
   ienb=0;
   ienc=0;
   ienstatus=0;
   isela=0;
   iselb=0;

   //MVN ========================================================================
$display("\n=== MVN===");
   opcode = 3'b101; ALU_op = 2'b11;
   start = 1'b1;
   #10;
      start = 1'b0;
   #50;

    assert (waiting  === 1'b1 )begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", waiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   #40;
   assert (iregsel  === 2)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iregsel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (ienb  === 2)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", ienb);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (iwaiting  === 2)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iwaiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   
   assert (iselb  === 0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iselb);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (iwbsel  === 0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iwbsel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (iwen  === 2)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iwen);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   #10;


  iwaiting =0;
   iregsel =0;
   iwbsel =0;
   iwen =0;
   iena=0;
   ienb=0;
   ienc=0;
   ienstatus=0;
   isela=0;
   iselb=0;

   //reset and start situations ============================================================================
    #10;
    rst_n = 1'b0;
    #10;
    rst_n=1'b1;


$display("\n=== reset and no start hit===");
   
    assert (waiting  === 1'b1)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", waiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   #40;
   assert (iregsel  === 0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iregsel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (ienb  === 0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", ienb);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (iena  === 0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iena);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (iwaiting  === 0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iwaiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (isela  === 0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", isela);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (iselb  === 0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iselb);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (ienc  === 0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", ienc);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (iwbsel  === 0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iwbsel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (iwen  === 0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iwbsel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   #10;

   iwaiting =0;
   iregsel =0;
   iwbsel =0;
   iwen =0;
   iena=0;
   ienb=0;
   ienc=0;
   ienstatus=0;
   isela=0;
   iselb=0;

   #10;
    rst_n = 1'b0;
    #10;
    rst_n=1'b1;

//reset hit midway through
$display("\n=== reset hit midway through===");

   opcode = 3'b101; ALU_op = 2'b10;
   start = 1'b1;
   #10;
      start = 1'b0;
   #10;
    assert (waiting  === 1'b0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", waiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   #30;
   rst_n = 1'b0;
   #10;
   rst_n = 1'b1;
   #5;

   assert (en_B  === 1'b0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", ienb);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (en_A  === 1'b0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iena);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (waiting  === 1'b1)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iwaiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (sel_A  === 1'b0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", isela);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (sel_B  === 1'b0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iselb);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (en_C  === 1'b0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", ienc);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (wb_sel  === 2'b0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iwbsel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (w_en  === 1'b0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", iwbsel);
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


endmodule: tb_controller
