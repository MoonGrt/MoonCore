`ifndef PARAM
`define PARAM

//*****************************************************
//**                   ISA opcode
//*****************************************************
`define ADD 5'b00000
`define SUB 5'b00001
`define AND 5'b00010
`define OR 5'b00011
`define XOR 5'b00100
`define SLL 5'b00101
`define SRL 5'b00110

`define BEQ 5'b10111
`define BLE 5'b11000

`define ADDI 5'b10000
`define SUBI 5'b10001
`define ANDI 5'b10010
`define ORI 5'b10011
`define XORI 5'b10100
`define SLLI 5'b10101
`define SRLI 5'b10110

`define LI 5'b11001
`define LW 5'b11010
`define SW 5'b11011


//*****************************************************
//**                    Function
//*****************************************************
// `define TUBE
`define UART
`define TIMER
// `define DDR
// `define HDMI


//*****************************************************
//**                 CPU Parameter
//*****************************************************
`define CPU_WIDTH 16
`define DATABUS `CPU_WIDTH-1:0
`define ADDRBUS `CPU_WIDTH-1:0
`define INTWIDTH 8


//*****************************************************
//**                 Hold Parameter
//*****************************************************
`define HOLDBUS 2:0
`define Hold_None 3'b000
`define Hold_PPL 3'b001
`define Hold_PC 3'b001  // Hold_IF
`define Hold_ID 3'b010
`define Hold_EX 3'b011


//*****************************************************
//**                 INT Parameter
//*****************************************************
`define INT_WIDTH 8
`define INT_BUS `INT_WIDTH-1:0
`define INT_NONE 8'h0
`define INT_TIMER 8'b00000001
`define INT_TIMER_ENTRY_ADDR 32'h4
`define INT_UART 8'b00000010
`define INT_UART_ENTRY_ADDR 32'h8

`define CSR_CYCLE 12'hc00
`define CSR_CYCLEH 12'hc80
`define CSR_MTVEC 12'h305
`define CSR_MCAUSE 12'h342
`define CSR_MEPC 12'h341
`define CSR_MIE 12'h304
`define CSR_MSTATUS 12'h300
`define CSR_MSCRATCH 12'h340


//*****************************************************
//**                   CPU control
//*****************************************************
`define REGWE_READ 1'b0
`define REGWE_WRITE 1'b1


//*****************************************************
//**                  ALU Parameter
//*****************************************************
`define ADD_op 3'b001
`define SUB_op 3'b010
`define AND_op 3'b011
`define OR_op 3'b100
`define XOR_op 3'b101
`define SLL_op 3'b110
`define SRL_op 3'b111


//*****************************************************
//**                  CMP Parameter
//*****************************************************
`define BEQ_op 2'b01
`define BLE_op 2'b10

`define CMP_EQ 2'b00
`define CMP_L 2'b01
`define CMP_G 2'b10

//*****************************************************
//**                   BUS control
//*****************************************************
`define IO_CTRL_READ 1'b0
`define IO_CTRL_WRITE 1'b1


//*****************************************************
//**              Peripheral Configuration
//*****************************************************
`define LED_NUM 4
`define LEDBUS `LED_NUM-1:0
`define SWITCH_NUM 4
`define SWITCHBUS `SWITCH_NUM-1:0
`define BUTTOM_NUM 4
`define BUTTOMBUS `BUTTOM_NUM-1:0
`define TUBE_NUM 4
`define TUBEBUS `TUBE_NUM-1:0

`endif
