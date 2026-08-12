# Verilog_Basic_FSM_design

A collection of **Finite State Machine (FSM) based digital design projects implemented in Verilog HDL**. This repository demonstrates the design and simulation of different **Mealy and Moore FSMs**, along with practical controller and communication-system applications such as SPI, UART, vending machines, and washing machines.

The projects are designed to strengthen understanding of **state-based digital system design, sequential logic, state transitions, control signals, and RTL simulation**.

---

## 📌 Overview

Finite State Machines are widely used in digital systems to control operations that occur through a sequence of well-defined states.

This repository contains the following FSM-based Verilog projects:

| Project                  | FSM Type             | Description                                         |
| ------------------------ | -------------------- | --------------------------------------------------- |
| `Mealy_FSM.v`            | Mealy                | FSM where output depends on present state and input |
| `Moore_FSM.v`            | Moore                | FSM where output depends only on present state      |
| `SPI_Master_FSM.v`       | Moore/Sequential FSM | Controls SPI master data transmission               |
| `UART_Transmitter_FSM.v` | FSM                  | Controls serial UART data transmission              |
| `Vending_Machine.v`      | FSM                  | Controls coin-based product vending                 |
| `Washing_Machine.v`      | FSM                  | Controls washing machine operating sequence         |

---

# 📂 Module Descriptions

## 1. Mealy FSM

**File:** `Mealy_FSM.v`

The Mealy FSM demonstrates a finite state machine in which the **output depends on both the current state and the input**.

### Key Concepts

* State register
* Next-state logic
* Output logic
* State transitions based on input
* Mealy-type output generation

### Features

* Fast output response to input changes
* Demonstrates combinational output logic
* Useful for understanding basic FSM architecture

### Simulated Output

The simulation verifies that the FSM changes states according to the applied input sequence and produces the expected output for each state-input combination.

Example:

```text
Time    Input    State    Output
--------------------------------
0 ns      0       S0        0
10 ns     1       S1        0
20 ns     1       S2        1
30 ns     0       S0        0
40 ns     1       S1        0
```

---

## 2. Moore FSM

**File:** `Moore_FSM.v`

The Moore FSM demonstrates a finite state machine where the **output depends only on the current state**.

### Key Concepts

* State register
* Next-state logic
* State-dependent output
* Synchronous state transitions

### Features

* Stable state-dependent outputs
* Clear separation between state and output logic
* Demonstrates Moore FSM architecture

### Simulated Output

```text
Time    Input    State    Output
--------------------------------
0 ns      0       S0        0
10 ns     1       S1        0
20 ns     1       S2        1
30 ns     0       S0        0
40 ns     1       S1        0
```

The simulation confirms that the output changes according to the active state rather than directly according to the input.

---

## 3. SPI Master FSM

**File:** `SPI_Master_FSM.v`

The SPI Master FSM implements the control logic required for transmitting data using the **Serial Peripheral Interface (SPI)** protocol.

The FSM divides SPI transmission into multiple states, such as loading data, generating clock phases, shifting data, and completing the transaction.

### Typical States

```text
IDLE → LOAD → CLK_HIGH → CLK_LOW → DONE
```

### Features

* SPI master control
* Sequential data transmission
* Clock phase control
* Data shifting
* FSM-based transmission control
* `DONE` indication after transmission

### Simulated Output

A typical simulation demonstrates the sequence:

```text
State       Operation
----------------------------
IDLE        Waiting for start
LOAD        Load transmission data
CLK_HIGH    Generate SPI clock HIGH
CLK_LOW     Generate SPI clock LOW
CLK_HIGH    Shift/transmit next bit
CLK_LOW     Continue clock cycle
DONE        Transmission completed
IDLE        Return to idle
```

Example waveform behavior:

```text
START   : 0 → 1
CS      : 1 → 0
SCLK    : 0 → 1 → 0 → 1 → 0 ...
MOSI    : Data bits transmitted serially
DONE    : 0 → 1
```

---

## 4. UART Transmitter FSM

**File:** `UART_Transmitter_FSM.v`

The UART Transmitter FSM controls the transmission of parallel data through a **single serial output line** using the UART protocol.

A typical UART frame consists of:

```text
START BIT → DATA BITS → STOP BIT
```

### Features

* UART transmitter control
* Start-bit generation
* Serial data transmission
* Stop-bit generation
* FSM-based transmission sequence
* Supports controlled bit-by-bit transmission

### Typical States

```text
IDLE → START → DATA → STOP → IDLE
```

### Simulated Output

For example, when a byte is transmitted:

```text
State     Operation
--------------------------
IDLE      Waiting for transmit request
START     Transmit start bit
DATA      Transmit data bits
STOP      Transmit stop bit
IDLE      Transmission completed
```

Example:

```text
TX Line:

1 ─────┐
       │
0      └── START
           │
           ├─ D0
           ├─ D1
           ├─ D2
           ├─ D3
           ├─ D4
           ├─ D5
           ├─ D6
           ├─ D7
           │
           └──────── STOP ───── 1
```

The simulation verifies that the data is transmitted sequentially according to the UART frame structure.

---

# 5. Vending Machine FSM

**File:** `Vending_Machine.v`

The Vending Machine FSM models a digital vending machine in which the machine changes state according to the amount of money inserted.

The FSM keeps track of the accumulated amount and generates a product-dispensing signal when the required amount is reached.

### Features

* Coin-based state transitions
* Product dispensing control
* Change/remaining amount handling
* Sequential state-based operation
* Demonstrates a practical FSM application

### Example State Flow

```text
IDLE
  ↓
COIN_1
  ↓
COIN_2
  ↓
DISPENSE
  ↓
CHANGE
  ↓
IDLE
```

### Simulated Output

Example simulation:

```text
Time    Coin/Input    State       Dispense
------------------------------------------
0 ns       0          IDLE           0
10 ns      1          COIN_1         0
20 ns      1          COIN_2         0
30 ns      1          DISPENSE       1
40 ns      0          IDLE           0
```

The simulation demonstrates that the product is dispensed when the required payment condition is satisfied.

---

# 6. Washing Machine FSM

**File:** `Washing_Machine.v`

The Washing Machine FSM models the sequential operation of an automated washing machine.

The controller moves through different stages of the washing process based on control inputs and timing conditions.

### Typical Sequence

```text
IDLE
 ↓
FILL
 ↓
WASH
 ↓
RINSE
 ↓
SPIN
 ↓
DONE
 ↓
IDLE
```

### Features

* Automated washing sequence
* Multiple operational states
* State-based control of machine operations
* Demonstrates real-world FSM implementation
* Suitable for RTL simulation and FPGA implementation

### Simulated Output

```text
Time    State      Operation
--------------------------------
0 ns    IDLE       Machine waiting
10 ns   FILL       Water filling
20 ns   WASH       Washing clothes
30 ns   RINSE      Rinsing
40 ns   SPIN       Spinning
50 ns   DONE       Cycle completed
60 ns   IDLE       Machine ready
```

The simulation confirms that the washing process follows the predefined sequence of operations.

---

# ⚙️ Features

* Verilog HDL-based RTL designs
* Mealy and Moore FSM implementations
* Synchronous sequential logic
* Combinational next-state and output logic
* Practical controller applications
* Communication protocol implementations
* Simulation-ready designs

---

# 🧪 Simulated Output

All projects are verified through RTL simulation using corresponding testbenches.

The simulations demonstrate:

* Correct state transitions
* Proper response to input signals
* Expected output generation
* Communication control sequences
* Controller operation sequences
* Correct reset and idle behavior

The waveforms can be observed using a Verilog-compatible simulation environment such as **ModelSim/QuestaSim** or **EDA Playground**.

---

# 🛠️ Tools Used

| Tool                     | Purpose                                     |
| ------------------------ | ------------------------------------------- |
| **Verilog HDL**          | Hardware description and RTL design         |
| **ModelSim / QuestaSim** | Functional simulation and waveform analysis |
| **EDA Playground**       | Online Verilog development and simulation   |
| **Xilinx / Vivado**      | FPGA-oriented RTL development and synthesis |
| **GitHub**               | Version control and project repository      |

---

# 🎯 Learning Outcomes

Through these projects, the following concepts are explored:

1. Understanding the fundamentals of **Finite State Machines**.
2. Differentiating between **Mealy and Moore FSM architectures**.
3. Implementing synchronous sequential circuits in Verilog.
4. Developing practical FSM-based controllers.
5. Understanding serial communication control using **SPI and UART**.
6. Writing simulation testbenches and analyzing waveforms.
7. Understanding RTL design practices.
8. Building a foundation for **FPGA and ASIC digital design**.

---

# 🚀 Applications

FSM-based designs are widely used in digital systems, including:

* **UART and SPI communication controllers**
* **Embedded systems**
* **FPGA-based systems**
* **Digital control systems**
* **Industrial automation**
* **Protocol controllers**
* **ASIC and SoC control logic**
* **Digital system sequencing**

---

# 📌 Conclusion

This repository provides a practical collection of **Verilog-based FSM designs**, ranging from fundamental Mealy and Moore machines to real-world applications such as SPI, UART, vending machine, and washing machine controllers.

The projects demonstrate how complex sequential operations can be broken down into **well-defined states and transitions**, making FSMs an essential design methodology for digital hardware.

Overall, these implementations provide hands-on experience in **RTL coding, FSM architecture, simulation, debugging, and digital system control**, forming a strong foundation for further work in **FPGA, ASIC, and VLSI design**.

---
