class packet;
  typedef enum {STANDARD, FAST, FAST_PLUS} i2c_mode_enum;

  rand bit [6:0] slave_addr; // No need constraint
  rand bit [7:0] data_in; // No need constraint

  rand bit [15:0] scl_low_time;
  rand bit [15:0] scl_high_time;

  rand bit [15:0] sda_hold_time;
  rand i2c_mode_enum i2c_mode; // Maybe add some distribution constraint

  // Custom rand sda_setup_time
  rand bit [15:0] sda_setup_time;

  function new();
  endfunction

  /* Apply Constraint to all of the rand signal
   * scl low_time

   * scl_high_time
   * sda hold time

   * If value is 16'h5 = then the signal will have a 5 clk cycle timing tick
   */

   constraint i2c_data_c {
  // First case - standard mode
    if (i2c_mode == STANDARD) {
        scl_low_time > 4700; // SCL low min 4700
        scl_high_time > 4000; // SCL high min 4000

        scl_low_time + scl_high_time < 10000; // SCL max 10000
        sda_hold_time > 300; // SDA hold min 300

        sda_setup_time == scl_low_time - sda_hold_time;
        sda_setup_time > 250; // SDA setup min 250
        sda_hold_time < scl_low_time; // SDA hold must in range of SCL low
    }

    // Second case - fast mode
    else if (i2c_mode == FAST) {
        scl_low_time > 1300; // SCL low min 1300
        scl_high_time > 600; // SCL high min 600

        scl_low_time + scl_high_time < 2500; // SCL max 2500
        sda_hold_time > 300; // SDA hold min 300

        sda_setup_time == scl_low_time - sda_hold_time;
        sda_setup_time > 100; // SDA setup min 100
        sda_hold_time < scl_low_time;
    }

    // Third case - fast plus mode
    else if (i2c_mode == FAST_PLUS) {
        scl_low_time > 500;
        scl_high_time > 260;

        scl_low_time + scl_high_time < 1000;
        sda_hold_time > 300;

        sda_setup_time == scl_low_time - sda_hold_time;
        sda_setup_time > 50; // SDA setup (unit ns for all)
        sda_hold_time < scl_low_time;
    }
    }

    // Constraint for 12c mode distribution
    constraint i2c_mode_dist_c {
        i2c_mode dist {STANDARD :/ 50, [FAST:FAST_PLUS] := 30}; // STANDARD probability 50/(50+30+30), FAST/FAST PLUS is 30/(50+30+30)
    }

    // Display packet data
    function string display(); // Use built-in func $sformatf to create string with scanf is
        return $sformatf("Slave addr 7'h%h, data in 8'h%h, scl low time %d, scl high time %d, sda hold time %d, sda setup time %d, with 12c mode %s", slave_addr, data_in, scl_low_time, scl_high_time, sda_hold_time, sda_setup_time, i2c_mode);
    endfunction

endclass