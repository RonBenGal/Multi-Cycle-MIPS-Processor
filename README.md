# Multi-Cycle MIPS Processor
## The VHDL design in this repository implements the following MIPS architecture:
![architecture](https://github.com/RonBenGal/Multi-Cycle-MIPS-Processor/blob/master/MIPS_Architecture.png)

### The design currently supports these instructions: 

| Instruction | Description |
| ----------- | ------------- |
| AND         | R-Type - Bitwise AND  |
| OR          | R-Type - Bitwise OR  |
| ADD         | R-Type - Addition |
| SUB         | R-Type - Subtraction | 
| SLT         | R-Type - Set Less Than |
| SW          | Store Word |
| LW          | Load Word |
| BEQ         | Branch On Equal   |
| JUMP        | Branch Unconditionaly to an address  |

Branches are finished in 3 cycles, R-type & SW instructions in 4, LW in 5.

#### For further understandsing of the control unit refer to this image :
![FSM](https://github.com/RonBenGal/Multi-Cycle-MIPS-Processor/blob/master/FSM.png)

* Modelsim was used for simulation

* MIPS instructions convertor [MIPS Converter](https://www.eg.bucknell.edu/~csci320/mips_web/index.html)
