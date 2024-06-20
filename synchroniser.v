module synchronizer #(parameter ADDR_WIDTH = 4) (
    input wire clk,
    input wire rst,
    input wire [ADDR_WIDTH:0] async_ptr,
    output reg [ADDR_WIDTH:0] sync_ptr
);

    // Two-stage synchronizer to mitigate metastability
    reg [ADDR_WIDTH:0] sync_stage1;
    reg [ADDR_WIDTH:0] sync_stage2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sync_stage1 <= 0;
            sync_stage2 <= 0;
            sync_ptr <= 0;
        end else begin
            sync_stage1 <= async_ptr;
            sync_stage2 <= sync_stage1;
            sync_ptr <= sync_stage2;
        end
    end

endmodule
