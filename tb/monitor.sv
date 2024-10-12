class monitor;
  virtual dut_if dut_vif;

  // Timing properties will have time datatype
  time tscl_high;
  time tscl_low;
  time tsda_hold;

  function new(virtual dut_if dut_vif);
    this.dut_vif = dut_vif;
  endfunction

  task run();
    forever begin
      @(negedge dut_vif.sda);

      while (!(dut_vif.sda == 1'b0 && dut_vif.scl == 1'b1));
      $display("%0t: [monitor] Start condition detect", $time);

      fork
        detect_scl();
        detect_sda_hold();
      join

      $display("%0t: [monitor] TSCL Low = %0t, TSCL High = %0t", $time, tscl_low, tscl_high);
      $display("%0t: [monitor] TSDA Hold = %0t, TSCL Setup = %0t", $time, tsda_hold, tscl_low - tsda_hold);
    end
  endtask

  // Detect scl low/high
  task detect_scl();
    time tscl_1, tscl_2;

    @(posedge dut_vif.scl);
    tscl_1 = $time;

    @(negedge dut_vif.scl);
    tscl_high = ($time - tscl_1) / 10;

    tscl_2 = $time;
    @(posedge dut_vif.scl);
    tscl_low = ($time - tscl_2) / 10;
  endtask


  task detect_sda_hold();
    time tsda_hold_start;

    repeat (2) @(negedge dut_vif.scl);

    do begin
      @(negedge dut_vif.scl);
      tsda_hold_start = $time;

      fork begin
        @(dut_vif.sda);
        tsda_hold = ($time - tsda_hold_start) / 10;
      end
      begin
        @(dut_vif.scl);
      end
      join_any;
      disable fork;
    end while (tsda_hold == 0);
  endtask
endclass