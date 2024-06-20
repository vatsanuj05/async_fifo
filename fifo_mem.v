module fifo_memory #(parameter ADDR_WIDTH = 4, parameter DATA_WIDTH = 8) (
    input wire clk,
    input wire wr_en,
    input wire rd_en,
    input wire [DATA_WIDTH-1:0] wr_data,
    output reg [DATA_WIDTH-1:0] rd_data,
    input wire [ADDR_WIDTH-1:0] waddr,
    input wire [ADDR_WIDTH-1:0] raddr
);

    // Memory array declaration
    reg [DATA_WIDTH-1:0] mem [2**ADDR_WIDTH-1:0];

    always @(posedge clk) begin
        if (wr_en) begin
            mem[waddr] <= wr_data;  // Write data to memory
        end
        if (rd_en) begin
            rd_data <= mem[raddr];  // Read data from memory
        end
    end

endmodule
