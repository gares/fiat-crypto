static void freeze(uint32_t out[12], const uint32_t in1[12]) {
  { const uint32_t x21 = in1[11];
  { const uint32_t x22 = in1[10];
  { const uint32_t x20 = in1[9];
  { const uint32_t x18 = in1[8];
  { const uint32_t x16 = in1[7];
  { const uint32_t x14 = in1[6];
  { const uint32_t x12 = in1[5];
  { const uint32_t x10 = in1[4];
  { const uint32_t x8 = in1[3];
  { const uint32_t x6 = in1[2];
  { const uint32_t x4 = in1[1];
  { const uint32_t x2 = in1[0];
  { uint32_t x24, uint8_t/*bool*/ x25 = Op (Syntax.SubWithGetBorrow 27 (Syntax.TWord 0) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 0)) (0x0, Return x2, 0x7fffff7);
  { uint32_t x27, uint8_t/*bool*/ x28 = Op (Syntax.SubWithGetBorrow 27 (Syntax.TWord 0) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 0)) (Return x25, Return x4, 0x7ffffff);
  { uint32_t x30, uint8_t/*bool*/ x31 = Op (Syntax.SubWithGetBorrow 27 (Syntax.TWord 0) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 0)) (Return x28, Return x6, 0x7ffffff);
  { uint32_t x33; uint8_t/*bool*/ x34 = _subborrow_u26(x31, x8, 0x3ffffff, &x33);
  { uint32_t x36, uint8_t/*bool*/ x37 = Op (Syntax.SubWithGetBorrow 27 (Syntax.TWord 0) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 0)) (Return x34, Return x10, 0x7ffffff);
  { uint32_t x39, uint8_t/*bool*/ x40 = Op (Syntax.SubWithGetBorrow 27 (Syntax.TWord 0) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 0)) (Return x37, Return x12, 0x7ffffff);
  { uint32_t x42, uint8_t/*bool*/ x43 = Op (Syntax.SubWithGetBorrow 27 (Syntax.TWord 0) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 0)) (Return x40, Return x14, 0x7ffffff);
  { uint32_t x45; uint8_t/*bool*/ x46 = _subborrow_u26(x43, x16, 0x3ffffff, &x45);
  { uint32_t x48, uint8_t/*bool*/ x49 = Op (Syntax.SubWithGetBorrow 27 (Syntax.TWord 0) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 0)) (Return x46, Return x18, 0x7ffffff);
  { uint32_t x51, uint8_t/*bool*/ x52 = Op (Syntax.SubWithGetBorrow 27 (Syntax.TWord 0) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 0)) (Return x49, Return x20, 0x7ffffff);
  { uint32_t x54, uint8_t/*bool*/ x55 = Op (Syntax.SubWithGetBorrow 27 (Syntax.TWord 0) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 0)) (Return x52, Return x22, 0x7ffffff);
  { uint32_t x57; uint8_t/*bool*/ x58 = _subborrow_u26(x55, x21, 0x3ffffff, &x57);
  { uint32_t x59 = cmovznz32(x58, 0x0, 0xffffffff);
  { uint32_t x60 = (x59 & 0x7fffff7);
  { uint32_t x62, uint8_t/*bool*/ x63 = Op (Syntax.AddWithGetCarry 27 (Syntax.TWord 0) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 0)) (0x0, Return x24, Return x60);
  { uint32_t x64 = (x59 & 0x7ffffff);
  { uint32_t x66, uint8_t/*bool*/ x67 = Op (Syntax.AddWithGetCarry 27 (Syntax.TWord 0) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 0)) (Return x63, Return x27, Return x64);
  { uint32_t x68 = (x59 & 0x7ffffff);
  { uint32_t x70, uint8_t/*bool*/ x71 = Op (Syntax.AddWithGetCarry 27 (Syntax.TWord 0) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 0)) (Return x67, Return x30, Return x68);
  { uint32_t x72 = (x59 & 0x3ffffff);
  { uint32_t x74; uint8_t/*bool*/ x75 = _addcarryx_u26(x71, x33, x72, &x74);
  { uint32_t x76 = (x59 & 0x7ffffff);
  { uint32_t x78, uint8_t/*bool*/ x79 = Op (Syntax.AddWithGetCarry 27 (Syntax.TWord 0) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 0)) (Return x75, Return x36, Return x76);
  { uint32_t x80 = (x59 & 0x7ffffff);
  { uint32_t x82, uint8_t/*bool*/ x83 = Op (Syntax.AddWithGetCarry 27 (Syntax.TWord 0) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 0)) (Return x79, Return x39, Return x80);
  { uint32_t x84 = (x59 & 0x7ffffff);
  { uint32_t x86, uint8_t/*bool*/ x87 = Op (Syntax.AddWithGetCarry 27 (Syntax.TWord 0) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 0)) (Return x83, Return x42, Return x84);
  { uint32_t x88 = (x59 & 0x3ffffff);
  { uint32_t x90; uint8_t/*bool*/ x91 = _addcarryx_u26(x87, x45, x88, &x90);
  { uint32_t x92 = (x59 & 0x7ffffff);
  { uint32_t x94, uint8_t/*bool*/ x95 = Op (Syntax.AddWithGetCarry 27 (Syntax.TWord 0) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 0)) (Return x91, Return x48, Return x92);
  { uint32_t x96 = (x59 & 0x7ffffff);
  { uint32_t x98, uint8_t/*bool*/ x99 = Op (Syntax.AddWithGetCarry 27 (Syntax.TWord 0) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 0)) (Return x95, Return x51, Return x96);
  { uint32_t x100 = (x59 & 0x7ffffff);
  { uint32_t x102, uint8_t/*bool*/ x103 = Op (Syntax.AddWithGetCarry 27 (Syntax.TWord 0) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 5) (Syntax.TWord 0)) (Return x99, Return x54, Return x100);
  { uint32_t x104 = (x59 & 0x3ffffff);
  { uint32_t x106; uint8_t/*bool*/ _ = _addcarryx_u26(x103, x57, x104, &x106);
  out[0] = x62;
  out[1] = x66;
  out[2] = x70;
  out[3] = x74;
  out[4] = x78;
  out[5] = x82;
  out[6] = x86;
  out[7] = x90;
  out[8] = x94;
  out[9] = x98;
  out[10] = x102;
  out[11] = x106;
  }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}
}