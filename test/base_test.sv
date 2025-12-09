class apb_base_test extends uvm_test;
    `uvm_component_utils(apb_base_test)

    env en;

    function new(string name="apb_base_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        en = env::type_id::create("en", this);
    endfunction

endclass
