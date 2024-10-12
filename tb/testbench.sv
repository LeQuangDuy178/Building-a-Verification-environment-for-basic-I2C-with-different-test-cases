module testbench;
  import i2c_pkg::*;
  import test_pkg::*;

  dut_if d_if();

  i2c_master_control u_dut(
    .clk(d_if.clk),
    .rst_n(d_if.rst_n),
    .slave_addr(d_if.slave_addr),
    .data_in(d_if.data_in),
    .start(d_if.start),
    .sda(d_if.sda),
    .scl(d_if.scl),
    .done(d_if.done),
    .scl_low_time(d_if.scl_low_time),
    .scl_high_time(d_if.scl_high_time),
    .sda_hold_time(d_if.sda_hold_time)
  );

  initial begin
    d_if.rst_n = 0; // Active low
    #100ns d_if.rst_n = 1; // Wait until !rst_n
  end

  initial begin
    d_if.clk = 0;
    forever begin
      #5ns; // Clock period is 100MHz
      d_if.clk = ~d_if.clk;
    end
  end

  base_test base = new();
  packet pkt = new();
  i2c_standard_test standard = new();
  i2c_fast_plus_test fast_plus = new();
  i2c_fast_test fast = new();


  initial begin
    // Instantiate base class based on test arguments
    if ($test$plusargs("12c_standard_test")) begin
      $display("[testbench] Run 12c standard test");
      base = standard; // Polymorphism works
    end else if ($test$plusargs("12c_fast_plus_test")) begin
      $display("[testbench] Run 12c_fast_plus_test");
      base = fast_plus; // call the new() constructor in fast_plus and assign it to base 
    end else if ($test$plusargs("12c_fast_test")) begin
      $display("[testbench] Run 12c_fast test");
      base = fast;
    end

    // Connect interface to DUT only when base is assigned
    base.dut_vif = d_if;
    base.run_test(); // Run test based on scenario
  end

endmodule