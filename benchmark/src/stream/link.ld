SECTIONS
{
	. = 0x00000000;
	.text : { *(.text) }
	.data : { *(.data) }
	 __bss_start__ = .;
	.bss : { *(.bss) }
	__bss_end__ = .;
	. = ALIGN(8);
	heap_low = .; /* for _sbrk */
	. = . + 0x00010000;
	heap_top = .; /* for _sbrk */
	. =  . + 0x00010000;
	stack_top = .; /* for Boot.S */
}
