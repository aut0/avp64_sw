/******************************************************************************
 *                                                                            *
 * Copyright 2020 Lukas Jünger                                                *
 *                                                                            *
 * Licensed under the Apache License, Version 2.0 (the "License");            *
 * you may not use this file except in compliance with the License.           *
 * You may obtain a copy of the License at                                    *
 *                                                                            *
 *     http://www.apache.org/licenses/LICENSE-2.0                             *
 *                                                                            *
 * Unless required by applicable law or agreed to in writing, software        *
 * distributed under the License is distributed on an "AS IS" BASIS,          *
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   *
 * See the License for the specific language governing permissions and        *
 * limitations under the License.                                             *
 *                                                                            *
 ******************************************************************************/

.text

// Initialize SCTLR_EL2 and HCR_EL2 to save values before entering EL2.
msr sctlr_el2, xzr
msr hcr_el2, xzr

// Determine the EL2 Execution state.
mrs x0, scr_el3
orr x0, x0, #(1<<10) // RW EL2 Execution state is AArch64.
orr x0, x0, #(1<<0) // NS EL1 is Non-secure world.
msr scr_el3, x0
mov x0, #0b01001 // DAIF=0000
msr spsr_el3, x0 // M[4:0]=01001 EL2h must match SCR_EL3.RW

// initialize gic
ldr x1, =gic_distif_addr
ldr x2, [x1, #0x04] // read GICD_TYPER register
tst x2, #(1 << 10) // if security features are not available
beq gic_init_done // skip initalization

// set all irq groups to 1
and x2, x2, #0xF // x2=GICD_TYPER.ITLinesNumber
add x2, x2, #1 // x2 hold the number of GICD_IGROUPR registers that need to be initialized
add x3, x1, #0x80 // x3 holds the address of the GICD_IGROUPR0 register
mov x4, #0xffffffff // value to write to the GICD_IGROUPR registers
gic_set_groups:
    str w4, [x3]
    add x3, x3, #0x4
    subs x2, x2, #1
    b.ne gic_set_groups

ldr x1, =gic_cpuif_addr
mov x2, #0x80
str w2, [x1, #0x04] // set pmr to 0x80

gic_init_done:

// Determine EL2 entry.
adr x0, el2_entry // el2_entry points to the first instruction of
msr elr_el3, x0 // EL2 code.
eret

el2_entry:
    mrs x0, mpidr_el1
    and x0, x0 , #0xFF
    tst x0, #15
    b.ne secondary_spin_loop

primary_setup:
    ldr x4, =0x200000
    ldr x0, =0x07f00000
    b boot_kernel

secondary_spin_loop:
    ldr x4, =spin_addr
    ldr x4, [x4]
    cbz x4, secondary_spin_loop
    mov x0, #0
    b boot_kernel

boot_kernel:
    mov x1, #0
    mov x2, #0
    mov x3, #0
    br x4

.set spin_addr, 0x00004000
.set gic_distif_addr, 0x10140000
.set gic_cpuif_addr, 0x10141000
