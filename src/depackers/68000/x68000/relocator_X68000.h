#ifndef __relocator__
#define __relocator__

unsigned int size_relocator = 42;
unsigned char relocator[] = {
	0x20, 0x3c, 0x00, 0x00, 0x00, 0x00, 0x41, 0xf4, 0x08, 0x00, 0x47, 0xec, 0x00, 0x32, 0x26, 0x0b, 
	0x20, 0x18, 0x43, 0xf0, 0x08, 0x00, 0x74, 0x00, 0x34, 0x18, 0xb4, 0x7c, 0x00, 0x01, 0x66, 0x02, 
	0x24, 0x18, 0xd7, 0xc2, 0xd7, 0x93, 0xb1, 0xc9, 0x66, 0xec, 
};

#endif