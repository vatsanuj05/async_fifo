module read_pointer #(parameter ADDR_WIDTH = 4) (
    input wire clk,
    input wire rst,
    input wire rd_en,
    output reg [ADDR_WIDTH:0] rptr
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rptr <= 0;
        end else if (rd_en) begin
            rptr <= rptr + 1;
        end
    end

endmodule
