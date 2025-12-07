 module slave #(
    parameter WIDTH=32,
    parameter ADDR_WIDTH = 8
    )(
    input   logic               pclk,
    input   logic               presetn,
    input   logic               psel,
    input   logic               penable,
    input   logic               pwrite,
    input   logic [ADDR_WIDTH-1 : 0] paddr,
    input   logic [WIDTH-1 : 0] pwdata,
    output  logic [WIDTH-1 : 0] prdata,
    output  logic               pready,
    output  logic               pslverr
 );

    logic [WIDTH-1 : 0] mem [0:255];

    typedef enum logic [1:0] {IDLE,SETUP,ACCESS} state_t;
    state_t state,next_state;
    logic [1:0] wait_counter;

    always_ff @(posedge pclk or negedge presetn) begin
        if(!presetn) begin
            state   <= IDLE;
            foreach(mem[i]) mem[i] <= '0;
            prdata  <= '0;
            wait_counter <= 2'd0;
        end
        else
            state   <= next_state;
    end

    always_comb begin
        next_state = state;
        case(state)
            IDLE   : if(psel && !penable) next_state = SETUP;
            SETUP  : next_state = ACCESS;
            ACCESS : if(pready) next_state = IDLE;
        endcase
    end

    assign pready   = (wait_counter == 2'd1);
    assign pslverr  = (paddr [ADDR_WIDTH-1:0] > 8'd255);

    always_ff @(posedge pclk) begin
        if(!presetn)
            wait_counter <= 2'd0;
        else begin
            if(state == ACCESS) begin
                wait_counter  <= wait_counter + 1'b1;
                if(pwrite)
                    mem[paddr[ADDR_WIDTH-1:0]] <= pwdata;
                else
                    prdata <= mem[paddr[ADDR_WIDTH-1:0]];
                end
            else 
                wait_counter <= 2'd0;
        end
    end

endmodule 


