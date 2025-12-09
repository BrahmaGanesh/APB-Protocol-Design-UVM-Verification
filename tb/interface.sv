interface apb_interface #(parameter WIDTH=32, ADDR_WIDTH=8);
    logic pclk;
    logic presetn;
    logic [ADDR_WIDTH-1:0] paddr;
    logic [WIDTH-1:0] pwdata;
    logic [WIDTH-1:0] prdata;
    logic psel;
    logic penable;
    logic pready;
    logic pwrite;
    logic pslverr;

    clocking cb @(posedge pclk);
        output psel, penable, paddr, pwdata, pwrite;
        input  prdata, pready, pslverr;
    endclocking
  	
    sequence apb_start;
        psel && !penable;
    endsequence

    property psel_penable_order;
        @(posedge pclk) apb_start |=> penable;
    endproperty

    assert property(psel_penable_order)
    else $error("APB ERROR: penable must assert 1 cycle after psel");

    assert property (@(posedge pclk) penable |-> psel)
    else $error("APB ERROR: penable asserted without psel");
    
    assert property (@(posedge pclk)
    psel && penable |-> $stable(paddr))
    else $error("APB ERROR: address changed during transfer");
    
    assert property (@(posedge pclk)
    psel && penable |-> $stable(pwrite))
    else $error("APB ERROR: pwrite changed mid-transfer");
    
    assert property (@(posedge pclk)
    pslverr |-> (psel && penable))
    else $error("APB ERROR: PSLVERR outside valid transfer");
    
endinterface
