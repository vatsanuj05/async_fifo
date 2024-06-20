# async_fifo

Overview

This project involves the design and simulation of an Asynchronous FIFO (First-In-First-Out) buffer using Verilog HDL. The FIFO is designed to handle independent read and write clocks, making it suitable for applications involving different clock domains. The primary goal is to ensure reliable data storage and retrieval in a first-in-first-out manner.

Project Structure

The project consists of the following main components:

Main Module (top_module.v)

FIFO Memory Module (fifo_mem.v)

Write Pointer Module (wptr_sync.v)

Read Pointer Module (rptr_sync.v)

Testbench Module (async_fifo_tb.v)

Main Module: top_module.v

The main module integrates the FIFO memory, write pointer, read pointer, and synchronizer modules. It manages the overall functionality of the asynchronous FIFO, ensuring proper data storage and retrieval, and handling full and empty status flags.

Features:

Manages read and write operations.

Synchronizes write and read pointers across different clock domains.

Provides status signals for full and empty FIFO conditions.

FIFO Memory Module: fifo_mem.v
This module implements the memory array for the FIFO, supporting simultaneous read and write operations. It stores the data written into the FIFO and provides it during read operations based on the pointers.

Features:

Memory array implementation.

Write operation controlled by the write pointer.

Read operation controlled by the read pointer.

Write Pointer Module: wptr_sync.v

The write pointer module manages the write operations to the FIFO. It increments the write pointer on each write operation and ensures synchronization with the write clock.

Features:

Increments write pointer on write enable signal.

Synchronizes with the write clock.

Resets write pointer on reset signal.

Read Pointer Module: rptr_sync.v

The read pointer module manages the read operations from the FIFO. It increments the read pointer on each read operation and ensures synchronization with the read clock.

Features:

Increments read pointer on read enable signal.

Synchronizes with the read clock.

Resets read pointer on reset signal.

Testbench Module: async_fifo_tb.v

The testbench module verifies the functionality of the asynchronous FIFO. It simulates various scenarios to test the FIFO's response to different read and write conditions, ensuring data integrity and correct status flag operations.

Features:

Simulates write and read operations with different clock domains.

Verifies FIFO functionality under various conditions.

Observes and displays read and write operations during simulation.

Simulation and Verification

The design was simulated using Icarus Verilog, and the results were verified using GTKWave. The simulation confirmed that the asynchronous FIFO operates correctly, handling independent read and write operations, and maintaining data integrity.
