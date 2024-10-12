class stimulus;
  mailbox #(packet) s2d_mb;

  packet pkt_q[$];
  packet pkt = new();

  function new(mailbox #(packet) s2d_mb);
    this.s2d_mb = s2d_mb;
  endfunction

  function void create_pkt(packet pkt_pass); // Argument is randomized pkt
    //assert(pkt.randomize()) else $error("Randomization failed");

    //pkt = new();
    //pkt = pkt_pass;

    $display("%0t: [stimulus] Packet generated: %s", $time, pkt.display());
    $display("Check packet from stimulus");

    pkt_q.push_back(pkt_pass); // 1 element = randomized packet data of all signals in packet
    $display("[stimulus] Packet on queue: %d", pkt_q[0].scl_low_time); // Works
  endfunction

  task run();
  //pkt = new();

  // Generate random packet
//   #100ns;
//   for (int i = 0; i < 10; i++) begin
//     assert(pkt.randomize()) else $error("Randomization failed");
//     pkt_q.push_back(pkt);
//     $display("%0t: [stimulus] Packet generated: %s", $time, pkt.display());
//   end

  // Send packet to driver
  #100ns;

  while (1) begin
    //pkt = new();

        wait(pkt_q.size > 0); // Pop out data until queue is empty
        pkt = pkt_q.pop_front();

        $display("[stimulus] Check pop out to pkt: %d", pkt.scl_low_time);
        s2d_mb.put(pkt);
    end

    $display("%0t: [stimulus] Sent packet to driver", $time);
  endtask

endclass