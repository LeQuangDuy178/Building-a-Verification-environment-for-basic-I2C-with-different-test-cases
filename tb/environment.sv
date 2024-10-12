class environment;
  stimulus stim;
  driver drv;
  monitor mon;

  mailbox #(packet) s2d_mb;

  virtual dut_if dut_vif;

  function new(virtual dut_if dut_vif);
    this.dut_vif = dut_vif;
  endfunction

  function void build();
    $display("%0t: [environment] build", $time);

    s2d_mb = new();
    stim = new(s2d_mb);
    drv = new(dut_vif, s2d_mb);
    mon = new(dut_vif);
  endfunction

  task run();
    $display("%0t: [environment] run", $time);

    fork
      stim.run();
      drv.run();
      mon.run();
    join
  endtask
endclass