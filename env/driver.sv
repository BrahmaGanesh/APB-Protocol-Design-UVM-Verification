class driver extends uvm_driver#(transaction);
    `uvm_component_utils(driver)
    
    function new(string name="driver",uvm_component parent=null);
        super.new(name,parent);
    endfunction
    
    virtual apb_interface vif;
    transaction tr;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        if(!uvm_config_db#(virtual apb_interface)::get(this,"","vif",vif))
        `uvm_fatal(get_type_name(),"Virtual interface not set in driver");
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        
        @(negedge vif.presetn);
        @(posedge vif.presetn);

        vif.psel    <= 0;
        vif.penable <= 0;
        vif.pwrite  <= 0;
        vif.paddr   <= '0;
        vif.pwdata  <= '0;
        
        forever begin
            seq_item_port.get_next_item(tr);

            @(posedge vif.pclk);
            
            vif.psel <= 1'b1;
            vif.penable <= 1'b0;
            vif.paddr <= tr.paddr;
            vif.pwdata <= tr.pwdata;
            vif.pwrite <= tr.pwrite;
           
            @(posedge vif.pclk);
            vif.penable <= 1'b1;
        
            wait(vif.pready);
            
            @(posedge vif.pclk);
            vif.psel <= 1'b0;
            vif.penable <= 1'b0;
            
            seq_item_port.item_done();
        end
    endtask
endclass
    