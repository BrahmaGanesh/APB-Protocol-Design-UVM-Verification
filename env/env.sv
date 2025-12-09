class  env extends uvm_env;
    `uvm_component_utils(env)

    agent	m_agent;
    scoreboard sb;

    function new(string name="env", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_agent = agent::type_id::create("m_agent", this);
        sb    = scoreboard::type_id::create("sb", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        m_agent.mon.mon_ap.connect(sb.sb_export);
    endfunction

endclass
