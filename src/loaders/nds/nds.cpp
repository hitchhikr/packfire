// --------------------------------------------------
// Loader for Nintendo DS files

// --------------------------------------------------
// Includes
#include "../loaders.h"
#include "nds.h"

namespace NDS
{

#include "../../depackers/arm/nds/depacker_NDS.h"

const unsigned short crc16tab[] =
{
    0x0000, 0xC0C1, 0xC181, 0x0140, 0xC301, 0x03C0, 0x0280, 0xC241,
    0xC601, 0x06C0, 0x0780, 0xC741, 0x0500, 0xC5C1, 0xC481, 0x0440,
    0xCC01, 0x0CC0, 0x0D80, 0xCD41, 0x0F00, 0xCFC1, 0xCE81, 0x0E40,
    0x0A00, 0xCAC1, 0xCB81, 0x0B40, 0xC901, 0x09C0, 0x0880, 0xC841,
    0xD801, 0x18C0, 0x1980, 0xD941, 0x1B00, 0xDBC1, 0xDA81, 0x1A40,
    0x1E00, 0xDEC1, 0xDF81, 0x1F40, 0xDD01, 0x1DC0, 0x1C80, 0xDC41,
    0x1400, 0xD4C1, 0xD581, 0x1540, 0xD701, 0x17C0, 0x1680, 0xD641,
    0xD201, 0x12C0, 0x1380, 0xD341, 0x1100, 0xD1C1, 0xD081, 0x1040,
    0xF001, 0x30C0, 0x3180, 0xF141, 0x3300, 0xF3C1, 0xF281, 0x3240,
    0x3600, 0xF6C1, 0xF781, 0x3740, 0xF501, 0x35C0, 0x3480, 0xF441,
    0x3C00, 0xFCC1, 0xFD81, 0x3D40, 0xFF01, 0x3FC0, 0x3E80, 0xFE41,
    0xFA01, 0x3AC0, 0x3B80, 0xFB41, 0x3900, 0xF9C1, 0xF881, 0x3840,
    0x2800, 0xE8C1, 0xE981, 0x2940, 0xEB01, 0x2BC0, 0x2A80, 0xEA41,
    0xEE01, 0x2EC0, 0x2F80, 0xEF41, 0x2D00, 0xEDC1, 0xEC81, 0x2C40,
    0xE401, 0x24C0, 0x2580, 0xE541, 0x2700, 0xE7C1, 0xE681, 0x2640,
    0x2200, 0xE2C1, 0xE381, 0x2340, 0xE101, 0x21C0, 0x2080, 0xE041,
    0xA001, 0x60C0, 0x6180, 0xA141, 0x6300, 0xA3C1, 0xA281, 0x6240,
    0x6600, 0xA6C1, 0xA781, 0x6740, 0xA501, 0x65C0, 0x6480, 0xA441,
    0x6C00, 0xACC1, 0xAD81, 0x6D40, 0xAF01, 0x6FC0, 0x6E80, 0xAE41,
    0xAA01, 0x6AC0, 0x6B80, 0xAB41, 0x6900, 0xA9C1, 0xA881, 0x6840,
    0x7800, 0xB8C1, 0xB981, 0x7940, 0xBB01, 0x7BC0, 0x7A80, 0xBA41,
    0xBE01, 0x7EC0, 0x7F80, 0xBF41, 0x7D00, 0xBDC1, 0xBC81, 0x7C40,
    0xB401, 0x74C0, 0x7580, 0xB541, 0x7700, 0xB7C1, 0xB681, 0x7640,
    0x7200, 0xB2C1, 0xB381, 0x7340, 0xB101, 0x71C0, 0x7080, 0xB041,
    0x5000, 0x90C1, 0x9181, 0x5140, 0x9301, 0x53C0, 0x5280, 0x9241,
    0x9601, 0x56C0, 0x5780, 0x9741, 0x5500, 0x95C1, 0x9481, 0x5440,
    0x9C01, 0x5CC0, 0x5D80, 0x9D41, 0x5F00, 0x9FC1, 0x9E81, 0x5E40,
    0x5A00, 0x9AC1, 0x9B81, 0x5B40, 0x9901, 0x59C0, 0x5880, 0x9841,
    0x8801, 0x48C0, 0x4980, 0x8941, 0x4B00, 0x8BC1, 0x8A81, 0x4A40,
    0x4E00, 0x8EC1, 0x8F81, 0x4F40, 0x8D01, 0x4DC0, 0x4C80, 0x8C41,
    0x4400, 0x84C1, 0x8581, 0x4540, 0x8701, 0x47C0, 0x4680, 0x8641,
    0x8201, 0x42C0, 0x4380, 0x8341, 0x4100, 0x81C1, 0x8081, 0x4040
};

#pragma pack(push)
#pragma pack(1)
struct nds_header
{
    char title[0xC];
    char game_code[0x4];                // 0xc(12)

    unsigned char maker_code[2];        // 0x10(16)
    unsigned char unit_code;            // 0x12(18)
    unsigned char device_type;          // 0x13(19) type of device in the game card
    unsigned char device_size;          // 0x14(20) capacity
    unsigned char reserved1[0x9];       // 0x15(21)
    unsigned char rom_version;          // 0x1e(30)
    unsigned char flags;                // 0x1f(31)

    unsigned int arm9_rom_offset;       // 0x20(32)
    unsigned int arm9_entry_address;    // 0x24(36)
    unsigned int arm9_ram_address;      // 0x28(40)
    unsigned int arm9_size;             // 0x2c(44)

    unsigned int arm7_rom_offset;       // 0x30(48)
    unsigned int arm7_entry_address;    // 0x34(52)
    unsigned int arm7_ram_address;      // 0x38(56)
    unsigned int arm7_size;             // 0x3c(60)

    unsigned int filename_source;       // 0x40(64)
    unsigned int filename_size;         // 0x44(68)
    unsigned int fat_source;            // 0x48(72)
    unsigned int fat_size;              // 0x4c(76)
    
    unsigned int arm9_overlay_source;   // 0x50(80)
    unsigned int arm9_overlay_size;     // 0x54(84)
    unsigned int arm7_overlay_source;   // 0x58(88)
    unsigned int arm7_overlay_size;     // 0x5c(92)
    
    unsigned int card_control_13;       // 0x60(96) used in modes 1 and 3
    unsigned int card_control_BF;       // 0x64(100) used in mode 2
    unsigned int banner_offset;         // 0x68(104)

    unsigned short secure_CRC16;        // 0x6c(108)

    unsigned short read_timeout;        // 0x6e(110)

    unsigned int unknown_RAM1;          // 0x70(112)
    unsigned int unknown_RAM2;          // 0x74(116)

    unsigned int bf_prime1;             // 0x78(120)
    unsigned int bf_prime2;             // 0x7c(124)
    
    unsigned int rom_size;              // 0x80(128)

    unsigned int header_size;           // 0x84(132)
    unsigned int zeros_88[14];          // 0x88(136)
    unsigned char gba_logo[156];        // 0xc0(192)
    unsigned short logo_CRC16;          // 0x15c(348)
    unsigned short header_CRC16;        // 0x15e(350)

    unsigned int debug_rom_source;      // 0x160(352)
    unsigned int debug_rom_size;        // 0x164(356)
    unsigned int debug_rom_destination; // 0x168(360)
    unsigned int offset_0x16C;          // 0x16c(364)

    unsigned char zero[0x90];           // 0x170(368)
};
#pragma pack(pop)

struct nds_header Header;
int arm7_offset;
int arm7_address;
int arm7_size;
int arm9_address;
int device_size;

unsigned short CalcCRC16(unsigned char *ndshdr, int size)
{
    int i;
    unsigned char data;
    unsigned short crc16 = 0xFFFF;

    for(i = 0; i < size; i++)
    {
        data = *((unsigned char *) ndshdr + i);
        crc16 = (crc16 >> 8) ^ crc16tab[(crc16 ^ data) & 0xFF];
    }
    return crc16;
}

// --------------------------------------------------
// Return the name of the file type
char *GetName()
{
    return "Nintendo DS ROM";
}

// --------------------------------------------------
// Check if the file is a NDS executable
unsigned char *Check(unsigned char *Mem,
                     int *Size
                     )
{
    unsigned char *dest_mem;

    if(*Size < sizeof(nds_header))
    {
        return(NULL);
    }

    memcpy(&Header, Mem, sizeof(nds_header));

    // check validity of CRC16 value of header
    // this is used to determine if this file is an NDS file
    // (May not be mandatory)
    if(CalcCRC16((unsigned char *) &Header, 350) != Header.header_CRC16)
    {
        if(Header.flags != 4 && Header.header_size != 0x200)
        {
            return(NULL);
        }
    }

    dest_mem = (unsigned char *) malloc(Header.arm9_size + Header.arm7_size);

    memcpy(dest_mem, Mem + Header.arm9_rom_offset, Header.arm9_size);
    arm9_address = Header.arm9_entry_address;
    arm7_address = Header.arm7_entry_address;
    arm7_size = Header.arm7_size;
    
    memcpy(dest_mem + Header.arm9_size, Mem + Header.arm7_rom_offset, Header.arm7_size);
    arm7_offset = Header.arm9_size;
    device_size = Header.device_size;

    *Size = Header.arm9_size + Header.arm7_size;

    return(dest_mem);
}

// --------------------------------------------------
// Save NDS file
// --------------------------------------------------
void Save_Lzma(FILE *out,
               unsigned char *mem_block,
               int unpacked_size,
               int packed_size,
               unsigned int code,
               int Raw_Datas
              )
{
    int pointers = 17 * 4;

    unsigned int *packed_size_arm9 = (unsigned int *) (((unsigned int *) depacker)[0] + (int) depacker);
    unsigned int *packed_size_arm7 = (unsigned int *) (((unsigned int *) depacker)[1] + (int) depacker);

    unsigned int *arm9_depacked_address = (unsigned int *) (((unsigned int *) depacker)[2] + (int) depacker);
    unsigned int *arm9_load = (unsigned int *) (((unsigned int *) depacker)[3] + (int) depacker);
    unsigned int *arm9_entry = (unsigned int *) (((unsigned int *) depacker)[4] + (int) depacker);
    unsigned int *arm9_length = (unsigned int *) (((unsigned int *) depacker)[5] + (int) depacker);

    // address to copy the depacked arm7 data
    unsigned int *arm7_depacked_address = (unsigned int *) (((unsigned int *) depacker)[6] + (int) depacker);
    // depacker offset of the arm7 data
    unsigned int *arm7_depacked_offset = (unsigned int *) (((unsigned int *) depacker)[7] + (int) depacker);
    // original length of the arm7 data
    unsigned int *arm7_depacked_length = (unsigned int *) (((unsigned int *) depacker)[8] + (int) depacker);

    unsigned int *arm7_load = (unsigned int *) (((unsigned int *) depacker)[9] + (int) depacker);
    unsigned int *arm7_entry = (unsigned int *) (((unsigned int *) depacker)[10] + (int) depacker);
    
    unsigned int *rom_size = (unsigned int *) (((unsigned int *) depacker)[11] + (int) depacker);
    unsigned short *crc16 = (unsigned short *) (((unsigned int *) depacker)[12] + (int) depacker);

    unsigned int *fat_source = (unsigned int *) (((unsigned int *) depacker)[13] + (int) depacker);

    unsigned int arm9_offset = (unsigned int) (((unsigned int *) depacker)[14]);

    unsigned short *secure_crc16 = (unsigned short *) (((unsigned int *) depacker)[15] + (int) depacker);

    unsigned int *probe_arm7_address = (unsigned int *) (((unsigned int *) depacker)[16] + (int) depacker);

    depacker[pointers + 20] = device_size;

    *arm7_load = get_aligned_size(arm7_address + arm7_size, 3);
    *arm7_entry = *arm7_load;

    packed_size = get_aligned_size(packed_size, 15);

    // +8 for the unpacked size and the code
    *arm9_depacked_address = arm9_address;
    *arm9_length = (packed_size + 8) + (size_depacker - arm9_offset);
    *arm9_load = get_aligned_size(arm9_address + unpacked_size, 3);
    *arm9_entry = *arm9_load;

    *packed_size_arm9 = *arm9_length;
    *packed_size_arm7 = *packed_size_arm9;

    *probe_arm7_address = arm9_address;
    *arm7_depacked_address = arm7_address;
    *arm7_depacked_offset = arm7_offset;
    *arm7_depacked_length = arm7_size;

    *rom_size = (packed_size + 8) + (size_depacker - pointers);
    *fat_source = *rom_size;

    memcpy(&Header, depacker + pointers, sizeof(nds_header));

    *crc16 = CalcCRC16(depacker + pointers, 350);

    if(!Raw_Datas)
    {
        fwrite(depacker + pointers, 1, (size_depacker - pointers), out);
    }
    fwrite(&unpacked_size, 1, 4, out);
    code = swap_dword(code);
	fwrite(&code, 1, 4, out);
    // Write the compressed datas
    fwrite(mem_block, 1, packed_size, out);
}

}
