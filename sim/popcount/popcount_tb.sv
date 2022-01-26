
module popcount_tb();

  logic             rst;
  logic             clk;
  logic      [63:0] stream_i;
  logic       [7:0] stream_o;
  logic             i_val;
  logic             o_val;

  //--------------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------------
  // Clock
  initial begin
    clk = 1'b0;
    forever begin
      #1ns; clk = ~clk;
    end
  end

  // Reset
  initial begin
    rst = 1'b1;
    repeat(4)@(posedge clk);
    rst = 1'b0;
  end

  localparam int N_TEST_WORDS = 1024;

  //--------------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------------
  // 2*popcount(word) - size(word)
  function logic [7:0] pcnt_2p_n (input logic [63:0] word);
      automatic logic [11:0] res = 0;
      for (int i = 0; i < $size(word); i++) begin
        if (word[i]) begin
          res++;
        end
      end

      res = 2*res - $size(word);

      return res;
  endfunction

  //--------------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------------
  logic       [7:0] ref_q[$];
  logic       [7:0] out_q[$];

  // Output thread
  initial begin
    @(negedge rst);
    // Save module's output to the output queue
    forever @(posedge clk) begin
      if (o_val) begin
        out_q.push_front(stream_o);
      end
    end
  end

  // Input data thread
  initial begin
    i_val = 1'b0;
    stream_i = 1'b0;
    @(negedge rst);
    repeat(2)@(posedge clk);

    repeat(N_TEST_WORDS) begin
      @(posedge clk);
      i_val = $random(); // set random valid signal

      // If there is the valid signal - put random value and save it to the input queue
      if (i_val) begin
        stream_i = {$urandom(), $urandom()};
        ref_q.push_front(pcnt_2p_n(stream_i));
      end
    end

    @(posedge clk);
    i_val = 1'b0;

    // Wait for finish
    repeat(32)@(posedge clk);

    // Check the outputs and print some statistic
    if (out_q != ref_q) begin
      $display("There is an errors");
      $display("Dump:");
      foreach (ref_q[i]) begin
        if (ref_q[i] != out_q[i])
          $display("REFERENCE: [0x%02X] MODULE RESP.: [0x%02X] <-", ref_q[i], out_q[i]);
        else
          $display("REFERENCE: [0x%02X] MODULE RESP.: [0x%02X]", ref_q[i], out_q[i]);
      end
    end else begin
      $display("****** Test passed:");
    end
    $display("****** input words: %d", ref_q.size());
    $display("****** processed words: %d", out_q.size());

    $stop();
  end

  // DUT instance
  popcount
  pcnt
  (.*);

endmodule
