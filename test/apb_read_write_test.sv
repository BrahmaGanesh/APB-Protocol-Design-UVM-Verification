class apb_write_read_sequence extends apb_sequence;
    `uvm_object_utils(apb_write_read_sequence)
    transaction tr;

    function new(string name="apb_write_read_sequence");
        super.new(name);
    endfunction

    task body();
        for (int i = 0; i <= 20; i++) begin
        tr = transaction::type_id::create("tr");
        if (i <= 10) begin
            if (!tr.randomize() with { tr.pwrite == 1'b1; }) begin
            `uvm_error("SEQ", "Randomization failed for write transaction")
            end
        end 
        else begin
            if (!tr.randomize() with { tr.pwrite == 1'b0; }) begin
            `uvm_error("SEQ", "Randomization failed for read transaction")
            end
        end
        start_item(tr);
        finish_item(tr);
        end
    endtask
endclass

class apb_write_read_test extends apb_base_test;
    `uvm_component_utils(apb_write_read_test)

    apb_write_read_sequence a_wr;

    function new(string name="apb_write_read_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        a_wr = apb_write_read_sequence::type_id::create("a_wr");
        a_wr.start(en.m_agent.seqr);

        phase.drop_objection(this);
    endtask
endclass
