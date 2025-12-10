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
    logic access_pending;
  	logic pready_reg;

    always_ff @(posedge pclk or negedge presetn) begin
        if(!presetn) begin
            state           <= IDLE;
            access_pending  <= 1'b0;
            pready_reg      <= 1'b0;
            prdata          <= '0;
            foreach(mem[i]) mem[i] <= '0;
        end
        else begin
            state   <= next_state;
            if (state == SETUP) begin
                access_pending  <= 1'b1;
                pready_reg      <= 1'b0;
            end
            else if (state == ACCESS && access_pending) begin
                    access_pending <= 1'b0;
                    if (psel && penable) begin
                        pready_reg <= 1'b1;
                        if (pwrite)
                            mem[paddr] <= pwdata;
                        else 
                            prdata <= mem[paddr];
                    end
                    else
                        pready_reg <= 1'b0;
                end
                else begin
                    pready_reg <= 1'b0;
                    if (state != ACCESS && state != SETUP)
                        access_pending <= 1'b0;
                end
            end
        end

    always_comb begin
        next_state = state;
        case(state)
            IDLE   : if(psel && !penable) next_state = SETUP;
            SETUP  : next_state = ACCESS;
            ACCESS : if(pready) next_state = IDLE;
        endcase
    end

    assign pready   = pready_reg;
    assign pslverr  =  (psel && penable && pready_reg && (paddr >= 8'd128));

endmodule 


