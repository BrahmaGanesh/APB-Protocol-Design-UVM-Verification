interface apb_interface #(
    parameter WIDTH = 32,
    parameter ADDR_WIDTH = 8
);
    logic   pclk,
    logic   presetn,
    logic   [ADDR_WIDTH-1:0] paddr,
    logic   [WIDTH-1:0] pwdata,
    logic   [WIDTH-1:0] prdata,
    logic   psel,
    logic   penable,
    logic   pready,
    logic   pwrite,
    logic   pslverr

endinterface