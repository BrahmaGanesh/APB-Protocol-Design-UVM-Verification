class coverage extends uvm_component;
    `uvm_component_utils(coverage)
    transaction tr;

    uvm_analysis_imp #(transaction, coverage) co_export;
        
    function new(string name="coverage", uvm_component parent=null);
        super.new(name, parent);
        co_export = new("co_export", this);
        cg = new();
    endfunction
    
    covergroup cg; 
        addr : coverpoint tr.paddr {
        bins low  = {[0:31]};
        bins Mid  = {[32:127]};
        bins high = {[128:255]};
        }
        rw : coverpoint tr.pwrite {
        bins write = {1};
        bins read  = {0};
        }
        slverr : coverpoint tr.pslverr {
        bins no_error = {0};
        bins error    = {1};
        }
        pready_cp : coverpoint tr.pready {
        bins ready = {1};
        }
        data_cp : coverpoint tr.pwdata iff (tr.pwrite) {
        bins zero      = {32'h0000_0000};
        bins all_ones  = {32'hFFFF_FFFF};
        bins Small     = {[0:255]};
        bins Large     = {[16'hFF00:16'hFFFF]};
        }

        addr_rw_err : cross rw, slverr;

    endgroup

    function void write(transaction tr);
        this.tr = tr;
        cg.sample();
    endfunction


    function void report_phase(uvm_phase phase);
        `uvm_info("COVERAGE", $sformatf("Total Coverage: %0.2f%%", $get_coverage()), UVM_LOW)
    endfunction

endclass
