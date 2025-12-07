class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)
    
    virtual apb_interface vif;
    transaction tr;
    uvm_analysis_port #(transaction) mon_ap;
    
    function new(string name="monitor",uvm_component parent=null);
        super.new(name,parent);
        mon_ap = new("mon_ap",this);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        if(!uvm_config_db#(virtual apb_interface)::get(this,"","vif",vif))
        `uvm_fatal(get_type_name(),"Virtual interface not set in monitor");
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        forever begin
            @(posedge vif.pclk);
            if(vif.psel && vif.penable && vif.pready)begin
                tr = transaction::type_id::create("tr", this);
                tr.pwdata = vif.pwdata;
                tr.prdata = vif.prdata;
                tr.paddr = vif.paddr;
                tr.pwrite = vif.pwrite;
                tr.psel    = vif.psel;
                tr.penable = vif.penable;
                tr.pready  = vif.pready;
                tr.pslverr = vif.pslverr;
                mon_ap.write(tr);
            end
        end
    endtask
endclass
        
    