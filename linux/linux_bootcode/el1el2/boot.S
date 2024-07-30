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

mrs x0, mpidr_el1
and x0, x0 , #0xFF
tst x0, #15
b.ne secondary_spin_loop

primary_setup:
    ldr x4, =0x00200000
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
