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
 
  assert (reg_sel === 2'b10)begin
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", reg_sel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
  

  assert (w_en  === 1)begin
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", w_en);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (w_en  === 1)begin
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", w_en);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (wb_sel  === 2'b10)begin
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", wb_sel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   assert (waiting  === 0)begin
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", waiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   #10;

   assert (waiting  === 1)begin
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", waiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

//MOV =========================================================================================================
opcode = 110;
ALU_op = 00;
#5;
start =1'b1;
#10;
start = 1'b0;

assert (waiting  === 1)begin
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", waiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

#10;

assert (reg_sel  === 2'b00)begin
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", reg_sel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (en_B  === 1)begin
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", en_B);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (waiting  === 0)begin
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", waiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   #10;

   assert (sel_B===0)begin
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", sel_B);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

    assert (sel_A===1)begin
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", sel_A);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

    assert (en_C===1)begin
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", en_C);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   #10; //=================================================================write Rd

    assert (wb_sel===2'b00)begin
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", wb_sel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
    assert (w_en===1)begin
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", w_en);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

    assert (reg_sel===2'b01)begin
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", sel_B);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
 
assert (waiting  === 1)begin               //might not be correct timing
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", waiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   #10;

//ADD ==================================================================================================

   opcode = 3'b101; ALU_op = 2'b00;
   #5;
start =1'b1;
#10;
start = 1'b0;

assert (waiting  === 1)begin              
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", waiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

  #10;

  assert (reg_sel  === 2'b00)begin               
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", reg_sel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (en_B  === 1)begin             
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", en_B);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (en_A  === 0)begin            
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", en_A);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (waiting  === 0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", waiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   #10;

   assert (reg_sel  === 2'b10)begin             
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", reg_sel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (en_A  === 1)begin             
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", en_A);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (en_B  === 0)begin             
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", en_B);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   #10;

   assert ({sel_A,sel_B}  === {0,0})begin          
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: values are %-d %d (expected 1)", sel_A, sel_B);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (en_C  === 1)begin            
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", en_C);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (en_status  === 0)begin   //check w implementation         
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", waiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   #10;

    assert (wb_sel===2'b00)begin
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", wb_sel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
    assert (w_en===1)begin
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", w_en);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

    assert (reg_sel===2'b01)begin
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", reg_sel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
 
assert (waiting  === 1)begin               //might not be correct timing
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", waiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   #10;

   //AND ==========================================================================================================================
 opcode = 3'b101; ALU_op = 2'b10;
   #5;
start =1'b1;
#10;
start = 1'b0;

assert (waiting  === 1)begin              
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", waiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

  #10;

  assert (reg_sel  === 2'b00)begin               
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", reg_sel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (en_B  === 1)begin             
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", en_B);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (en_A  === 0)begin            
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", en_A);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (waiting  === 0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", waiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   #10;

   assert (reg_sel  === 2'b10)begin             
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", reg_sel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (en_A  === 1)begin             
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", en_A);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (en_B  === 0)begin             
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", en_B);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   #10;

   assert ({sel_A,sel_B}  === {0,0})begin          
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: values are %-d %d (expected 1)", sel_A, sel_B);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (en_C  === 1)begin            
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", en_C);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (en_status  === 0)begin   //check w implementation         
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", waiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   #10;

    assert (wb_sel===2'b00)begin
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", wb_sel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
    assert (w_en===1)begin
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", w_en);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

    assert (reg_sel===2'b01)begin
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", reg_sel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
 
assert (waiting  === 1)begin               //might not be correct timing
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", waiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   #10;

   //CMP ====================================================================
   opcode = 3'b101; ALU_op = 2'b01;
   #5;
start =1'b1;
#10;
start = 1'b0;

//Load B

assert (waiting  === 1)begin              
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", waiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

  #10;

  assert (reg_sel  === 2'b00)begin               
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", reg_sel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (en_B  === 1)begin             
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", en_B);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (en_A  === 0)begin            
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", en_A);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (waiting  === 0)begin           
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", waiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   #10;// Load A

   assert (reg_sel  === 2'b10)begin             
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", reg_sel);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (en_A  === 1)begin             
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", en_A);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (en_B  === 0)begin             
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", en_B);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   #10; // operation

   assert ({sel_A,sel_B}  === {0,0})begin          
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: values are %-d %d (expected 1)", sel_A, sel_B);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   assert (en_status  === 1)begin   //check w implementation         
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", en_status);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
assert (waiting  === 1)begin              
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", waiting);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end

   #10;

   
//done 


   assert (en_status  === 0)begin        
    $display("[PASS]: value is true");
    num_passes = num_passes+1;
    end else begin
        $error("[FAIL]: value is %-d (expected 1)", en_status);
        outErr = 1'b1;
        num_fails = num_fails+1;
   end
   #10;



  $display("\n\n==== TEST SUMMARY ====");
    $display("  TEST COUNT: %-5d", num_passes + num_fails);
    $display("    - PASSED: %-5d", num_passes);
    $display("    - FAILED: %-5d", num_fails);
    $display("======================\n\n");
    $stop;
    

  end

  assign err = outErr;


endmodule: tb_controller
