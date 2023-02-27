ENTRY(bootstrap)

SECTIONS
{
	. = 1M;

	.boot :
	{
		KEEP(*(.mbh))
	}

	.text :
	{
		*(.text)
	}
}