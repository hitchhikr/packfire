// Compress/RangeCoder/RangeCoderBit.cpp

#include "RangeCoderBit.h"

namespace NCompress {
namespace NRangeCoder {

UInt32 CPriceTables::ProbPrices[kBitModelTotal >> kNumMoveReducingBits];
static CPriceTables g_PriceTables;

CPriceTables::CPriceTables() { Init(); }

void CPriceTables::Init()
{
  const int kNumBits = (kNumBitModelTotalBits - kNumMoveReducingBits);
  for(int i = kNumBits - 1; i >= 0; i--)
  {
    UInt32 start = 1 << (kNumBits - i - 1);
    UInt32 end = 1 << (kNumBits - i);
    for (UInt32 j = start; j < end; j++)
      ProbPrices[j] = (i << kNumBitPriceShiftBits) + 
          (((end - j) << kNumBitPriceShiftBits) >> (kNumBits - i - 1));
  }
}

}}
