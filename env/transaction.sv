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

    constraint write  {pwrite inside {0,1};}
    constraint ready  {pready inside {0,1};}
    constraint slverr {pslverr inside {0,1};}
    constraint addr {soft paddr inside {
        [0:31],
        [32:127],
        [128:191],
        [192:255]
    };}
    constraint wdata {if(pwrite){
        pwdata inside {
            32'h0000_0000,
            32'hFFFF_FFFF,
            [0:255],
            [32'h0000_FF00 : 32'h0000_FFFF]
        };
    }else
    pwdata == '0;
    }

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