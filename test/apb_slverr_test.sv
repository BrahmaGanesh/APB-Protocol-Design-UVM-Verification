class apb_slverr_sequence extends apb_sequence;
    `uvm_object_utils(apb_slverr_sequence)
    transaction tr;

    function new(string name="apb_slverr_sequence");
        super.new(name);
    endfunction

    task body();
      for (int i = 0; i <= 6; i++) begin
        tr = transaction::type_id::create("tr");
        if (i <= 3) begin
          if (!tr.randomize() with { tr.pwrite == 1'b1;tr.paddr == 8'd128; }) begin
            `uvm_error("SEQ", "Randomization failed for write transaction")
            end
        end 
        else begin
          if (!tr.randomize() with { tr.pwrite == 1'b0; tr.paddr == 8'd128; }) begin
            `uvm_error("SEQ", "Randomization failed for read transaction")
            end
        end
        start_item(tr);
        finish_item(tr);
        end
    endtask
endclass

class apb_slverr_test extends apb_base_test;
    `uvm_component_utils(apb_slverr_test)

    apb_slverr_sequence a_r;

    function new(string name="apb_slverr_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        a_r = apb_slverr_sequence::type_id::create("a_r");
        a_r.start(en.m_agent.seqr);

        phase.drop_objection(this);
    endtask
endclass
