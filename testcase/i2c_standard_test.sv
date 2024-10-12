class i2c_standard_test extends base_test;

  // Refer to base constructor so it can also be called
  function new();
    super.new();
  endfunction

  // User scenario when STANDARD test is run
  // Applying polymorphism
  bit i2c_standard; // Boolean
  packet pkt;

  virtual task run_scenario();
    // In-line randomization with constraint
    pkt = new(); // New packet obj
    i2c_standard = pkt.randomize() with {pkt.i2c_mode == packet::STANDARD};
    $display("[test_i2c_standard] Packet generated: %s", pkt.display());

    // randomize() actually a method returning Boolean value

    // Asserting if randomization success or not
    assert(i2c_standard) begin
      $display("[test case] Run 12c standard test");
    end else begin
      $error("[test case] Randomization failed!");
    end

    // Call function create pkt with pkt randomize in this class
    env.stim.create_pkt(pkt);
  endtask
endclass