class i2c_fast_test extends base_test;

  function new();
    super.new();
  endfunction

  // Properties
  packet pkt;

  bit i2c_fast; // Boolean for randomization assertion

  // User scenario when STANDARD test is run
  // Applying polymorphism

  //bit i2c_standard;                                                                                                                                            // Boolean
  virtual task run_scenario();

    // In-line randomization with constraint
    //i2c_standard

    // In-line randomization with constraint
    pkt new(); // New packet obj

    i2c_fast = pkt.randomize() with {pkt.i2c_mode == packet::FAST;};
    $display("[test_i2c_fast] Packet generated: %s", pkt.display());

    // randomize() actually a method returning Boolean value

    // Asserting if randomization success or not
    assert(i2c_fast) begin
        $display("[test case] Run 12c fast test");
    end      
    else begin                                                       
         $error("[test case] Randomization failed!");
    end

    // Call function create_pkt with pkt randomize in this class
    env.stim.create_pkt(pkt);

    endtask

endclass