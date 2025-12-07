class sequence extends uvm_sequence #(transaction);
    `uvm_object_utils(sequence)
    
    transaction tr;
    
    function new(string name="sequence");
        super.new(name);
    endfunction
    
    virtual task body()
        repeat(10)begin
            tr=transaction::type_id::create("tr");
            start_item(tr);
            if(!tr.randomize())
                `uvm_info(get_type_name(),"Randomization failed",UVM_LOW);
            finish_item(tr);
        end
    endtask
  
  endclass
    
    
    