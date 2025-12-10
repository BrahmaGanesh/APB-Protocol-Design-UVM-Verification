# APB Protocol – RTL Design & UVM Verification

APB slave RTL with a UVM-based verification environment and coverage-driven testing.

---

## Quick Start

### Compile
```bash
vcs -full64 -sverilog +acc -f filelist.f -l compile.log
```

### Run
```bash
./simv +UVM_TEST_NAME=apb_write_read_test -l sim.log
./simv +UVM_TEST_NAME=apb_write_test
./simv +UVM_TEST_NAME=apb_read_test
./simv +UVM_TEST_NAME=apb_slverr_test
```

---

## Overview

**What:** APB slave RTL (256×32 memory) with a UVM-based verification environment (driver, monitor, sequencer, scoreboard, coverage).

**Why:** Demonstrates protocol-compliant verification flows, constrained-random stimulus, and coverage-driven verification techniques used in ASIC design verification.

**Status:** Functional coverage: 100% of defined coverage model | 4/4 tests PASS | 0 assertion failures

---

## Repository Structure

```
apb_uvm_project/
├── rtl/
│   └── slave.sv
├── tb/
│   ├── interface/apb_interface.sv
│   └── top_tb.sv
├── env/
│   ├── transaction.sv
│   ├── sequence.sv
│   ├── sequencer.sv
│   ├── driver.sv
│   ├── monitor.sv
│   ├── scoreboard.sv
│   ├── coverage.sv
│   ├── agent.sv
│   └── env.sv 
│   
├── test/
│   ├── base_test.sv
│   ├── apb_write_test.sv
│   ├── apb_read_test.sv
│   ├── apb_read_write_test.sv
│   ├── apb_slverr_test.sv
│   └── package.sv
│   
├── doc/
│   ├── waveform.png
│   ├── sim_log.txt
│   └── coverage_summary.png
│
├── waves/
│   ├── apb_write_read_test_waveform.png
│   ├── apb_write_test_waveform.png
│   ├── apb_read_test_waveform.png
│   └── apb_slverr_test_waveform.png
│
└── README.md
```

---

## Architecture

### Component Hierarchy

```
UVM Environment
├── Agent (Active)
│   ├── Sequencer
│   ├── Driver
│   └── Monitor
├── Scoreboard
└── Coverage Collector
```

### Data Flow

```
Sequence → Sequencer → Driver → APB Bus → DUT
                         ↓
                      Monitor → Scoreboard + Coverage
```

---

## DUT Specifications

| Specification | Value |
|---------------|-------|
| Memory Size | 256 × 32-bit |
| Address Width | 8-bit (0–255) |
| Write | mem[paddr] ≤ pwdata (on ACCESS) |
| Read | prdata ≤ mem[paddr] (on ACCESS) |
| PREADY | Single-cycle acknowledgment |
| PSLVERR | Assert for addresses ≥ 128 |

**APB Handshake:**
- **SETUP:** PSEL=1, PENABLE=0, set address/control (1 cycle)
- **ACCESS:** PSEL=1, PENABLE=1, wait PREADY (variable cycles)
- **IDLE:** PSEL=0, PENABLE=0

---

## Test Cases

| Test | Purpose | Status |
|------|---------|--------|
| apb_write_test | 10 random writes | ✓ PASS |
| apb_read_test | 10 random reads | ✓ PASS |
| apb_write_read_test | 10 writes + 10 reads + coverage closure | ✓ PASS |
| apb_slverr_test | Error handling (addr ≥ 0x80) | ✓ PASS |

---

## Coverage

### Functional Coverage Results

| Covergroup | Coverage | Status |
|------------|----------|--------|
| Address (low/mid/high) | 3/3 bins hit | 100% |
| Read/Write | 2/2 bins hit | 100% |
| PSLVERR | 2/2 bins hit | 100% |
| Data patterns | All defined bins hit | 100% |
| Cross coverage (RW × PSLVERR) | All combinations hit | 100% |

Total coverage is 100% of the defined functional coverage model.

### Coverage Closure Strategy

Hybrid approach was used to close coverage efficiently:

- Directed transactions were used for low-probability and corner-case bins.
- Constrained-random stimulus was used for broader space exploration.
- Directed and random tests were combined to achieve full coverage of the defined model.

---

## Simulation Results

**Scoreboard Output:**
```
Total Reads:      10
Matched Reads:    10/10 ✓
Mismatched:       0
Status:           PASS
```

**Coverage Report:**
```
Total Coverage:   100.00% ✓
Assertion Violations: 0
```

Full log: [doc/sim_log.txt](doc/sim_log.txt)

---

## UVM Components

| Component | Purpose |
|-----------|---------|
| **transaction** | Packet (paddr, pwdata, pwrite, prdata, pslverr, pready) + constraints |
| **sequence** | Stimulus (write, read, mixed, error); hybrid directed + random |
| **sequencer** | Transaction delivery to driver |
| **driver** | APB protocol timing; SETUP → ACCESS handshake |
| **monitor** | Bus observer; captures valid transactions |
| **scoreboard** | Golden memory; verifies read correctness |
| **coverage** | Functional metrics; address/RW/data/error bins |
| **agent** | Container; active mode (driven) |

---

## Key Skills Demonstrated

- Transaction-level modeling using class-based sequence items with constraints.
- Built active UVM agents integrating sequencer, driver, and monitor.
- Implemented scoreboard with golden reference memory and end-to-end data checks.
- Designed functional covergroups with cross coverage and closure strategy.
- Applied constrained-random stimulus with targeted biasing.
- Implemented and verified APB SETUP/ACCESS protocol timing.
- Used waveforms for protocol debug and root-cause analysis.
- Performed hybrid coverage closure using directed and random testing.

---

## Waveforms & Reports

### Sample Waveform

| Phase | PSEL | PENABLE | PADDR | PWDATA | PRDATA | PREADY | PSLVERR |
|-------|------|---------|-------|--------|--------|--------|---------|
| SETUP | 1 | 0 | Driven | Driven | Don't care | 0 | 0 |
| ACCESS (Write) | 1 | 1 | Held stable | Held stable | Don't care | 1 | 0/1 (DUT-specific) |
| ACCESS (Read) | 1 | 1 | Held stable | Don't care | Valid when PREADY=1 | 1 | 0/1 (DUT-specific) |

**Key Observations:**
- Address and control signals are driven in SETUP and held stable in ACCESS.
- Write data is held stable until transfer completion.
- Read data is sampled when PREADY is asserted.
- PSLVERR behavior is DUT-implementation specific.

---

## What I Learned

### UVM Methodology
- Built layered testbenches using env/agent/driver/monitor/scoreboard architecture.
- Understood UVM phases and how objections control simulation lifetime.
- Used sequences to separate stimulus intent from protocol-level signal driving.

### Verification Strategy
- Learned why pure constrained-random is inefficient for hitting low-probability bins.
- Used directed sequences to force coverage for corner cases.
- Implemented a golden memory model for end-to-end data checking.

### Protocol Understanding
- Implemented APB SETUP and ACCESS timing correctly in the driver.
- Enforced signal stability rules during transfers.
- Verified error behavior based on DUT-specific address validity.

### Practical Engineering Skills
- Debugged race conditions using waveforms and monitor logs.
- Structured projects so tests are repeatable and scalable.
- Learned to justify verification decisions clearly instead of hiding them.

---

## Detailed Documentation

For in-depth explanations, see:
- **[Simulation Log](doc/sim_log.txt)** – Full transaction-by-transaction execution trace
- **[Coverage Report](doc/coverage_summary.png)** – Interactive coverage metrics and bin details

---

## File List (filelist.f)

```
rtl/slave.sv
tb/interface.sv
tb/top_tb.sv
env/transaction.sv
env/sequence.sv
env/sequencer.sv
env/driver.sv
env/monitor.sv
env/agent.sv
env/scoreboard.sv
env/coverage.sv
env/env.sv
test/base_test.sv
test/apb_write_read_test.sv
test/apb_write_test.sv
test/apb_read_test.sv
test/apb_slverr_test.sv
```

---

## Commands Reference

**Compile:**
```bash
vcs -full64 -sverilog +acc -f filelist.f -l compile.log
```

**Run Tests:**
```bash
./simv +UVM_TEST_NAME=apb_write_read_test -l sim.log
./simv +UVM_TEST_NAME=apb_slverr_test +UVM_VERBOSITY=UVM_HIGH
```

**Waveform:**
```bash
./simv +UVM_TEST_NAME=apb_write_read_test -gui
```

---

## Summary

A production-quality APB verification environment demonstrating core ASIC DV competencies:

✅ Complete UVM testbench (8 components)  
✅ Protocol-compliant stimulus generation  
✅ Scoreboard-based functional verification  
✅ 100% functional coverage (hybrid closure)  
✅ Professional documentation and reproducibility  
✅ Scales to larger SoC verification tasks  

---

**Status:** Feature-complete and interview-ready  
**Functional Coverage:** 100% (Constrained-Random + Directed)  
**Test Results:** 4/4 PASS (0 Violations)  
**Author:** Brahma Ganesh Katrapalli  
**Last Updated:** December 2025

---

## Badges Summary

| Badge | Value |
|-------|-------|
| UVM Version | 1.2 |
| Simulators | VCS, Questa/ModelSim |
| Functional Coverage | 100% |
| Test Status | 4/4 PASS |
| Architecture | Clean & Scalable |
| Documentation | Complete |

---

## License & References

Copyright (c) 2025 Brahma Ganesh Katrapalli
