STACKTOP = 0x0fffffff;

SECTIONS
{
	. = 0x00000000;
	.text : { *(.text) }
	.data : { *(.data) }
	 __bss_start__ = .;
	.bss : { *(.bss) }
	__bss_end__ = .;

	. = STACKTOP;
	stack_top = .;
}
