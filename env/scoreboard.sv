class scoreboard extends uvm_component;
    `uvm_component_utils(scoreboard)

    uvm_analysis_imp #(transaction, scoreboard) sb_export;
    logic [31:0] expected_mem [0:255];

    function new(string name="scoreboard", uvm_component parent);
        super.new(name, parent);
        sb_export = new("sb_export", this);
        foreach (expected_mem[i])   expected_mem[i] = '0;
    endfunction

    function void write(transaction tr);
        if (tr.pwrite) begin
            expected_mem[tr.paddr] = tr.pwdata;
            `uvm_info("APB_SCB",$sformatf("WRITE: addr=%0d data=%0h",tr.paddr, tr.pwdata),UVM_LOW)
        end 
        else begin
            logic [31:0] exp = expected_mem[tr.paddr];
            if (exp !== tr.prdata) begin
                `uvm_error("APB_SCB",
                $sformatf("READ MISMATCH: addr=%0d expected=%0h actual=%0h",tr.paddr, exp, tr.prdata))
            end 
            else begin
                `uvm_info("APB_SCB",
                $sformatf("READ MATCH: addr=%0d expected=%0h actual=%0h",tr.paddr, exp, tr.prdata),UVM_LOW)
            end
        end
    endfunction
endclass
