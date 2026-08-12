# Verilog_Basic_FSM_projects

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

|  Time | Reset |  In | State | Output |
| ----: | :---: | :-: | :---: | :----: |
|     0 |   1   |  0  |   0   |    0   |
| 10000 |   0   |  0  |   0   |    0   |
| 20000 |   0   |  1  |   0   |    0   |
| 45000 |   0   |  1  |   1   |    1   |
| 60000 |   0   |  0  |   1   |    1   |
| 65000 |   0   |  0  |   0   |    0   |
| 70000 |   0   |  1  |   0   |    0   |
| 90000 |   0   |  0  |   0   |    0   |


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

|  Time | State_Input | Output |
| ----: | :---------: | :----: |
|     0 |      0      |    0   |
| 10000 |      1      |    0   |
| 20000 |      0      |    0   |
| 30000 |      1      |    0   |
| 35000 |      1      |    1   |
| 45000 |      1      |    0   |
| 50000 |      0      |    0   |
| 60000 |      1      |    0   |
| 65000 |      1      |    1   |
| 70000 |      0      |    0   |
| 80000 |      1      |    0   |
| 85000 |      1      |    1   |
| 95000 |      1      |    0   |


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

| Parameter   | Value      |
| ----------- | ---------- |
| **TX DATA** | `10101010` |
| **RX DATA** | `11001100` |
| **MOSI**    | `0`        |
| **MISO**    | `0`        |
| **CS**      | `1`        |
| **SCLK**    | `0`        |
| **BUSY**    | `0`        |
| **DONE**    | `1`        |


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

| State          |  TX | BUSY | Transition / Description                |
| -------------- | --: | ---: | --------------------------------------- |
| **IDLE**       | `1` |  `0` | Waiting for `tx_start`                  |
| **START**      | `0` |  `1` | `tx_start` detected; transmit start bit |
| **DATA BIT 0** | `0` |  `1` | Transmit data bit 0                     |
| **DATA BIT 1** | `1` |  `1` | Transmit data bit 1                     |
| **DATA BIT 2** | `0` |  `1` | Transmit data bit 2                     |
| **DATA BIT 3** | `1` |  `1` | Transmit data bit 3                     |
| **DATA BIT 4** | `0` |  `1` | Transmit data bit 4                     |
| **DATA BIT 5** | `1` |  `1` | Transmit data bit 5                     |
| **DATA BIT 6** | `0` |  `1` | Transmit data bit 6                     |
| **DATA BIT 7** | `1` |  `1` | Transmit data bit 7                     |
| **STOP**       | `1` |  `1` | Transmit stop bit                       |
| **IDLE**       | `1` |  `0` | Transmission completed; return to idle  |


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

| Current State | Coin Inserted | Next State | Dispense |
| ------------- | ------------- | ---------- | -------- |
| S0 (₹0)       | ₹5            | S5         | No       |
| S0 (₹0)       | ₹10           | S10        | No       |
| S5 (₹5)       | ₹5            | S10        | No       |
| S5 (₹5)       | ₹10           | S15        | Yes      |
| S10 (₹10)     | ₹5            | S15        | Yes      |
| S10 (₹10)     | ₹10           | S15        | Yes      |
| S15           | Any           | S0         | No       |

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

| Clock | State | Water | Wash | Drain | Spin | Done |
| ----: | ----- | ----: | ---: | ----: | ---: | ---: |
|     1 | IDLE  |     0 |    0 |     0 |    0 |    0 |
|     2 | FILL  |     1 |    0 |     0 |    0 |    0 |
|     3 | WASH  |     0 |    1 |     0 |    0 |    0 |
|     4 | DRAIN |     0 |    0 |     1 |    0 |    0 |
|     5 | SPIN  |     0 |    0 |     0 |    1 |    0 |
|     6 | DONE  |     0 |    0 |     0 |    0 |    1 |
|     7 | IDLE  |     0 |    0 |     0 |    0 |    0 |

---

## 7. ATM Controller FSM

**File:** `ATM_Controller.v`

The ATM Controller FSM demonstrates a finite state machine designed to control the sequence of operations in an **Automated Teller Machine (ATM)**, including card insertion, PIN verification, transaction selection, cash withdrawal, and card ejection.

### Key Concepts

- State register
- Next-state logic
- Card insertion and ejection
- PIN verification
- Transaction selection
- Withdrawal control
- Balance inquiry
- FSM-based transaction sequencing

### Features

- Automated ATM transaction control
- PIN verification sequence
- Withdrawal operation
- Balance checking
- Card insertion and ejection
- Transaction completion control
- Reset and idle-state handling

### State Sequence

| State | Operation |
|---|---|
| **IDLE** | Waiting for card insertion |
| **CARD_INSERTED** | Card detected |
| **PIN_ENTRY** | Waiting for PIN |
| **PIN_VERIFY** | Verifying PIN |
| **MENU** | Selecting transaction |
| **WITHDRAW** | Processing withdrawal |
| **DEPOSIT** | Processing deposit |
| **BALANCE** | Checking account balance |
| **TRANSACTION_DONE** | Transaction completed |
| **EJECT_CARD** | Ejecting card |
| **IDLE** | Ready for next transaction |

### Simulated Output

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
