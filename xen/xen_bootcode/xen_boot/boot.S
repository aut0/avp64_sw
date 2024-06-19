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
    ldr x4, =0x7ea00000
    ldr x0, =0x7ec00000
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

.set spin_addr, 0x00000090
