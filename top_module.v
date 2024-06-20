`include "synchroniser.v"
`include "wptr_handler.v"
`include "rptr_handler.v"
`include "fifo_mem.v"

module async_fifo #(parameter ADDR_WIDTH = 4, DATA_WIDTH = 8) (
    input wr_clk,
    input rd_clk,
    input rst,
    input wr_en,
    input rd_en,
    input [DATA_WIDTH-1:0] wr_data,
    output reg [DATA_WIDTH-1:0] rd_data,
    output full,
    output empty
);
    reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1]; // Memory array
    reg [ADDR_WIDTH:0] wr_ptr, rd_ptr; // Write and read pointers
    reg [ADDR_WIDTH:0] wr_ptr_gray, rd_ptr_gray; // Gray-coded pointers
    reg [ADDR_WIDTH:0] wr_ptr_gray_sync, rd_ptr_gray_sync; // Synchronized pointers

    wire [ADDR_WIDTH:0] wr_ptr_next, rd_ptr_next; // Next pointers

    // Write pointer logic
    always @(posedge wr_clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;
            wr_ptr_gray <= 0;
        end else if (wr_en && !full) begin
            mem[wr_ptr[ADDR_WIDTH-1:0]] <= wr_data;
            wr_ptr <= wr_ptr_next;
            wr_ptr_gray <= wr_ptr_next ^ (wr_ptr_next >> 1);
        end
    end

    assign wr_ptr_next = wr_ptr + 1;

    // Read pointer logic
    always @(posedge rd_clk or posedge rst) begin
        if (rst) begin
            rd_ptr <= 0;
            rd_ptr_gray <= 0;
            rd_data <= 0;
        end else if (rd_en && !empty) begin
            rd_data <= mem[rd_ptr[ADDR_WIDTH-1:0]];
            rd_ptr <= rd_ptr_next;
            rd_ptr_gray <= rd_ptr_next ^ (rd_ptr_next >> 1);
        end
    end

    assign rd_ptr_next = rd_ptr + 1;

    // Synchronize write pointer to read clock domain
    always @(posedge rd_clk or posedge rst) begin
        if (rst) begin
            wr_ptr_gray_sync <= 0;
        end else begin
            wr_ptr_gray_sync <= wr_ptr_gray;
        end
    end

    // Synchronize read pointer to write clock domain
    always @(posedge wr_clk or posedge rst) begin
        if (rst) begin
            rd_ptr_gray_sync <= 0;
        end else begin
            rd_ptr_gray_sync <= rd_ptr_gray;
        end
    end

    // Convert synchronized gray-coded pointers to binary
    function [ADDR_WIDTH:0] gray_to_bin;
        input [ADDR_WIDTH:0] gray;
        integer i;
        begin
            gray_to_bin[ADDR_WIDTH] = gray[ADDR_WIDTH];
            for (i = ADDR_WIDTH-1; i >= 0; i = i - 1) begin
                gray_to_bin[i] = gray[i] ^ gray_to_bin[i+1];
            end
        end
    endfunction

    wire [ADDR_WIDTH:0] wr_ptr_sync_bin = gray_to_bin(wr_ptr_gray_sync);
    wire [ADDR_WIDTH:0] rd_ptr_sync_bin = gray_to_bin(rd_ptr_gray_sync);

    // Full and empty flags
    assign full = (wr_ptr[ADDR_WIDTH] != rd_ptr_sync_bin[ADDR_WIDTH]) &&
                  (wr_ptr[ADDR_WIDTH-1:0] == rd_ptr_sync_bin[ADDR_WIDTH-1:0]);
    assign empty = (wr_ptr_gray_sync == rd_ptr_gray);

endmodule
