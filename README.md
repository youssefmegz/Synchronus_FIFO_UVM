@@ -1 +1,36 @@
# UVM-Verification-of-a-Synchronous-FIFO-
# FIFO Design Verification using UVM
## Project Overview
This project verifies a **Synchronous FIFO** design using **UVM (Universal Verification Methodology)**. The FIFO is a critical component in digital systems, ensuring data is read and written in the same sequential order, particularly useful for timing-sensitive applications like data pipelines and communication protocols.
## Key Features of the FIFO
- **FIFO_WIDTH**: 16-bit (default)
- **FIFO_DEPTH**: 8 entries (default)
- **Signals Verified**:
  - `data_in`: Input data bus
  - `wr_en`: Write enable signal
  - `rd_en`: Read enable signal
  - `clk`: Clock signal for synchronization
  - `rst_n`: Asynchronous reset
  - `data_out`: Output data bus
  - `full`, `almostfull`: FIFO status indicators (full/near full)
  - `empty`, `almostempty`: FIFO status indicators (empty/near empty)
  - `overflow`, `underflow`: Handling of write/read errors
  - `wr_ack`: Acknowledge successful writes
## UVM-based Verification Flow
The verification was structured around the UVM methodology, with a focus on constrained random stimulus and coverage-driven verification.
### UVM Components:
- **Driver**: Interacts with the DUT (Design Under Test) to drive stimulus.
- **Monitor**: Observes the signals in the design and generates transactions for checking.
- **Agent**: Contains driver and monitor for handling the communication between the DUT and the verification environment.
- **Scoreboard**: Compares the DUT output against a reference model to ensure correctness.
- **Sequences**: Define the stimulus for the DUT, with constraints to verify various operational modes.
- **Coverage**: Functional coverage ensures all important scenarios are tested, including edge cases like overflow and underflow.
## Functional Coverage
The verification process involved monitoring and sampling critical states like:
- **Overflow/Underflow Conditions**
- **Almost Full/Almost Empty States**
- **Correct Operation of Read/Write Commands**
