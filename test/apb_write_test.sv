class apb_write_sequence extends apb_sequence;
    `uvm_object_utils(apb_write_sequence)
    transaction tr;

    function new(string name="apb_write_sequence");
        super.new(name);
    endfunction

    task body();
      for (int i = 0; i <= 10; i++) begin
        tr = transaction::type_id::create("tr");
            if (!tr.randomize() with { tr.pwrite == 1'b1; }) begin
            `uvm_error("SEQ", "Randomization failed for write transaction")
            end
        start_item(tr);
        finish_item(tr);
        end
    endtask
endclass

class apb_write_test extends apb_base_test;
    `uvm_component_utils(apb_write_test)

    apb_write_sequence a_w;

    function new(string name="apb_write_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        a_w = apb_write_sequence::type_id::create("a_w");
        a_w.start(en.m_agent.seqr);

        phase.drop_objection(this);
    endtask
endclass
