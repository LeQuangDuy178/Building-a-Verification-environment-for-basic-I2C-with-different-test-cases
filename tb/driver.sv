// Class driver of SystemVerilog
class driver;

    mailbox #(packet) s2d_mb; // Get mailbox from stimulus
    
    virtual dut_if dut_vif; // Virtual interface to drive signal to DUT

    packet pkt; // Handle for packet
    
    function new(virtual dut_if dut_vif, mailbox#(packet) s2d_mb)
        this.dut_vif = dut_vif;
        this.s2d_mb = s2d_mb;
    endfunction 

    task run();

        pkt = new(); // New obj to observe data from mailbox

        while (1) begin
            
            $display("Check packet from driver");
            s2d_mb.get(pkt);
            $display("[Driver] Check pkt from drv: %0d", pkt.scl_low_time); // Check if the data transfer is correct
            $display("%0t: [Driver] Get packet from stimulus", $time);

            // Drive data to DUT signals
            @(posedge dut_vif.clk);
            dut.vif.slave_addr = pkt.slave_addr;
            dut_vif.data_in = pkt.data_in;
            dut_vif.start = 1'b1;
            dut_vif.scl_low_time = pkt.scl_low_time;
            dut_vif.scl_high_time = pkt.scl_high_time;
            dut_vif.sda_hold_time = pkt.sda_hold_time;

            // Clear data after 1 clk
            @(posedge dut_vif.clk);
            dut.vif.slave_addr = 7'h00;
            dut_vif.data_in = 8'h00;
            dut_vif.start = 1'b0;
            dut_vif.scl_low_time = 16'h00;
            dut_vif.scl_high_time = 16'h00;
            dut_vif.sda_hold_time = 16'h00;
            wait(dut_vif.done == 1'b1);

        end

    endtask

    // SDA_hold and SCL_high/low will be driven

endclass