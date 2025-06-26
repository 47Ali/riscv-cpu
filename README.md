# RISC-V CPU (RV32I)

This repository hosts a simple 32‑bit RISC‑V processor written in Verilog. The core was created as part of a master's dissertation project and is verified with Icarus Verilog and Surfer.

---

## Features

- Program counter
- Instruction and data memory
- Register file
- ALU with control logic
- Load/store operations (`lw`, `sw`)
- Branch and jump support
- Immediate arithmetic (`addi`)

---

## Directory Layout

```
riscv-cpu/
├── src/         # Verilog source files
├── testbench/   # Testbenches for the modules
├── sim/         # Simulation scripts and VCD output
├── program.mem  # Instruction memory contents
└── README.md
```

---

## Tools

- **Icarus Verilog** – simulation
- **Surfer** – waveform viewer
- **Vivado** – synthesis for the Basys3 board

---

## Running Tests

Use `sim/run.sh` to compile and execute the testbenches. Example:

```bash
bash sim/run.sh pc_tb            # Program counter test
bash sim/run.sh cpu_integration_tb  # Full CPU integration test
```

Make sure Icarus Verilog and Surfer are installed and available in your `PATH`.

---

## Next Steps

- Add machine learning related instructions
- Benchmark the processor implementation
- Deploy to FPGA hardware

---

## Author

**Ali Alsarraf**
[alialsarraf22@gmail.com](mailto:alialsarraf22@gmail.com)
[github.com/47Ali](https://github.com/47Ali)
