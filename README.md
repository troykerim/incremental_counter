# Incremental Counter using Seven Segment Display

## Project Overview

A manual incremental counter developed on the Zybo Z7-10 FPGA using a seven segment display. This is an up/down counter that uses buttons and a switch to control behavior.

When the counter is in **up mode** (switch set to low), the seven segment display will start at `00`. Each time the increment button is pressed, the counter will increase by 1 and update the display: `00 → 01 → 02 → ... → 99 → 00`.

When the **switch is set to high** (down mode), the counter will start at `99`. Each press of the button will decrement the count: `99 → 98 → 97 → ... → 00 → 99`.

A second button is used to **reset the counter**. When pressed:
- In **up mode**, the counter resets to `00`.
- In **down mode**, the counter resets to `99`.

## Features
- Manual counting by button press (one step per press)
- Two-digit seven segment display 
- Up/Down mode controlled by a physical switch
- Synchronous reset functionality
- Button input is debounced to ensure clean operation

## Hardware Requirements
- Zybo Z7-10 FPGA board
- 2-digit seven segment display (connected to PMOD JE and JD)
- 2 pushbuttons (start and reset)
- 1 switch (mode select: up or down)

## File Summary
- `updown_top.v`: Top-level Verilog module
- `ssd_driver.v`: Seven segment decoder
- `DeBounce.v`: Button debouncing module
- `zyboZ7.xdc`: Constraint file for pin mapping