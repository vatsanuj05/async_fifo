module write_pointer #(parameter ADDR_WIDTH = 4) (
    input wire clk,
    input wire rst,
    input wire wr_en,
    output reg [ADDR_WIDTH:0] wptr
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wptr <= 0;
        end else if (wr_en) begin
            wptr <= wptr + 1;
        end
    end

endmodule
