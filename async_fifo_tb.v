`include "top_module.v"
module async_fifo_tb;

    parameter ADDR_WIDTH = 4;
    parameter DATA_WIDTH = 8;

    reg wr_clk;
    reg rd_clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [DATA_WIDTH-1:0] wr_data;
    wire [DATA_WIDTH-1:0] rd_data;
    wire full, empty;

    // Instantiate the asynchronous FIFO
    async_fifo #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) uut (
        .wr_clk(wr_clk),
        .rd_clk(rd_clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .wr_data(wr_data),
        .rd_data(rd_data),
        .full(full),
        .empty(empty)
    );

    // Define clock periods
    parameter WR_CLK_PERIOD = 10; // Write clock period in time units
    parameter RD_CLK_PERIOD = 15; // Read clock period in time units

    // Clock generation
    initial begin
        wr_clk = 0;
        rd_clk = 0;
        forever begin
            #5 wr_clk = ~wr_clk; // Toggle write clock every 5 time units
            #10;
        end
    end

    initial begin
        forever begin
            #7.5 rd_clk = ~rd_clk; // Toggle read clock every 7.5 time units
            #15;
        end
    end

    // Testbench stimulus
    initial begin
        // VCD dumping setup
        $dumpfile("dump.vcd");
        $dumpvars(0, async_fifo_tb);

        // Reset
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        wr_data = 0;
        #20;
        rst = 0;

        // Write and read operations for 50 time units
        repeat (50) begin
            // Write data to FIFO if not full
            if (!full) begin
                wr_en = 1;
                wr_data = $random % 256; // Random data within 8-bit range
                #30;
                wr_en = 0;
                $display("Time = %0t, Write Data = %h", $time, wr_data);
            end

            // Read data from FIFO if not empty
            if (!empty) begin
                rd_en = 1;
                #30;
                rd_en = 0;
                $display("Time = %0t, Read Data = %h", $time, rd_data);
            end else if (rd_en) begin
                $display("Time = %0t, Read Data = No data available (FIFO empty)", $time);
            end
        end

        // Stop simulation
        #100;
        $finish;
    end

endmodule
