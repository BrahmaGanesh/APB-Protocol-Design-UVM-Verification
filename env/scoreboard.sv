class scoreboard extends uvm_component;
    `uvm_component_utils(scoreboard)

    uvm_analysis_imp #(transaction, scoreboard) sb_export;
    logic [31:0] expected_mem [0:255];

    int total_reads         = 0;
    int matched_reads       = 0;
    int mismatched_reads    = 0;

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
             total_reads++;
            if (exp !== tr.prdata) begin
                mismatched_reads++;
                `uvm_error("APB_SCB",
                $sformatf("READ MISMATCH: addr=%0d expected=%0h actual=%0h",tr.paddr, exp, tr.prdata))
            end 
            else begin
                matched_reads++;
                `uvm_info("APB_SCB",
                $sformatf("READ MATCH: addr=%0d expected=%0h actual=%0h",tr.paddr, exp, tr.prdata),UVM_LOW)
            end
        end
    endfunction

     function void report_phase(uvm_phase phase);
        super.report_phase(phase);

        `uvm_info("APB_SCB_REPORT",
                  $sformatf("Total Reads      : %0d", total_reads),UVM_NONE)

        `uvm_info("APB_SCB_REPORT",
                  $sformatf("Matched Reads    : %0d", matched_reads),UVM_NONE)

        `uvm_info("APB_SCB_REPORT",
                  $sformatf("Mismatched Reads : %0d", mismatched_reads),UVM_NONE)

        if (mismatched_reads == 0)
            `uvm_info("APB_SCB_SUMMARY", "SCOREBOARD STATUS: PASS", UVM_NONE)
        else
            `uvm_error("APB_SCB_SUMMARY", "SCOREBOARD STATUS: FAIL")
    endfunction
endclass
