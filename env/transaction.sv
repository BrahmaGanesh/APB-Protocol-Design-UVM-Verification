class transaction #(
    parameter WIDTH = 32,
    parameter ADDR_WIDTH = 8
    ) extends uvm_sequence_item;
    rand bit     pwrite;
    rand bit     [ADDR_WIDTH-1:0] paddr;
    rand bit     [WIDTH-1:0] pwdata;
         bit     [WIDTH-1:0] prdata;
         bit     psel;
         bit     penable;
         bit     pready;
         bit     pslverr;

    function new(string name = "transaction");
        super.new(name);
    endfunction

    `uvm_object_utils_begin (transaction)
        `uvm_field_int(pwrite, UVM_ALL_ON)
        `uvm_field_int(paddr, UVM_ALL_ON)
        `uvm_field_int(pwdata, UVM_ALL_ON)
        `uvm_field_int(prdata, UVM_ALL_ON)
        `uvm_field_int(psel, UVM_ALL_ON)
        `uvm_field_int(penable, UVM_ALL_ON)
        `uvm_field_int(pready, UVM_ALL_ON)
        `uvm_field_int(pslverr, UVM_ALL_ON)
    `uvm_object_utils_end

endclass