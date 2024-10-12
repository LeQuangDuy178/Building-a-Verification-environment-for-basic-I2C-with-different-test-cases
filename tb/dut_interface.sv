// DUT interface with signals from I2C RTL connections
interface dut_if;

    // Global signals
    logic clk; // 100Mhz = 10ns per cycle
    logic rst_n;

    // IO Signals
    logic [6:0] slave_addr; // 7-bit slave address
    logic [7:0] data_in; // 8-bit data input parallel to serial transferred
    logic start; // Start until SDA low and SCL high 
    wire sda; // single byte transmitted output wire (custom)
    wire scl; // single byte
    logic done; // done flag

    // Timing analysis signals (applying constraint randomization)
    logic [15:0] scl_low_time;
    logic [15:0] scl_high_time;
    logic [15:0] sda_setup_time;
    logic [15:0] sda_hold_time;

endinterface