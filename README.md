/*
# High-Speed UART with Fractional Baud Rate Generator

## Overview
Implements a Universal Asynchronous Receiver-Transmitter (UART) supporting up to 12 Mbps with:
- Custom fractional baud rate generator
- Integrated TX and RX
- Full RTL design in Verilog
- Verified with simulation testbench

## Folder Structure
- `rtl/`: HDL sources
- `sim/`: Simulation testbench and waveforms
- `docs/`: Logs or test outputs

## Features
- <10⁻¹² Bit Error Rate
- Framing, parity, overrun error detection
- Loopback test verified

## How to Simulate
```sh
# Using Icarus Verilog
iverilog -g2012 rtl/*.v sim/tb_uart.v -o uart_tb
vvp uart_tb
```

## Waveforms
Use GTKWave to open `uart.vcd`:
```sh
gtkwave sim/uart.vcd
```
Inspect signals: `TXD`, `RXD`, `tx_data`, `rx_data`
*/
