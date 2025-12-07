`include "interface.sv"
`include "package.sv"

module tb;
    import pkg::*;
    
    apb_interface vif();
    slave #(32,8)dut(
        vif.pclk,
        vif.presetn,
        vif.psel,
        vif.penable,
        vif.pwrite,
        vif.paddr,
        vif.pwdata,
        vif.prdata,
        vif.pready,
        vif.pslverr);
    
    initial begin
        vif.pclk = 1'b0;
        forever #5 vif.pclk = ~vif.pclk;
    end
    
    initial begin
        vif.presetn = 0;
        repeat(3) @(posedge vif.pclk);
        vif.presetn = 1;
    end
    
    initial begin
        uvm_config_db#(virtual apb_interface)::set(null,"*","vif",vif);
        run_test();
    end
endmodule