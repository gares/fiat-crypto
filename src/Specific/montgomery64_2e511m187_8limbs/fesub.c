static void fesub(uint64_t out[8], const uint64_t in1[8], const uint64_t in2[8]) {
  { const uint64_t x16 = in1[7];
  { const uint64_t x17 = in1[6];
  { const uint64_t x15 = in1[5];
  { const uint64_t x13 = in1[4];
  { const uint64_t x11 = in1[3];
  { const uint64_t x9 = in1[2];
  { const uint64_t x7 = in1[1];
  { const uint64_t x5 = in1[0];
  { const uint64_t x30 = in2[7];
  { const uint64_t x31 = in2[6];
  { const uint64_t x29 = in2[5];
  { const uint64_t x27 = in2[4];
  { const uint64_t x25 = in2[3];
  { const uint64_t x23 = in2[2];
  { const uint64_t x21 = in2[1];
  { const uint64_t x19 = in2[0];
  { uint64_t x33; uint8_t/*bool*/ x34 = _subborrow_u64(0x0, x5, x19, &x33);
  { uint64_t x36; uint8_t/*bool*/ x37 = _subborrow_u64(x34, x7, x21, &x36);
  { uint64_t x39; uint8_t/*bool*/ x40 = _subborrow_u64(x37, x9, x23, &x39);
  { uint64_t x42; uint8_t/*bool*/ x43 = _subborrow_u64(x40, x11, x25, &x42);
  { uint64_t x45; uint8_t/*bool*/ x46 = _subborrow_u64(x43, x13, x27, &x45);
  { uint64_t x48; uint8_t/*bool*/ x49 = _subborrow_u64(x46, x15, x29, &x48);
  { uint64_t x51; uint8_t/*bool*/ x52 = _subborrow_u64(x49, x17, x31, &x51);
  { uint64_t x54; uint8_t/*bool*/ x55 = _subborrow_u64(x52, x16, x30, &x54);
  { uint64_t x56 = cmovznz64(x55, 0x0, 0xffffffffffffffffL);
  { uint64_t x57 = (x56 & 0xffffffffffffff45L);
  { uint64_t x59; uint8_t/*bool*/ x60 = _addcarryx_u64(0x0, x33, x57, &x59);
  { uint64_t x61 = (x56 & 0xffffffffffffffffL);
  { uint64_t x63; uint8_t/*bool*/ x64 = _addcarryx_u64(x60, x36, x61, &x63);
  { uint64_t x65 = (x56 & 0xffffffffffffffffL);
  { uint64_t x67; uint8_t/*bool*/ x68 = _addcarryx_u64(x64, x39, x65, &x67);
  { uint64_t x69 = (x56 & 0xffffffffffffffffL);
  { uint64_t x71; uint8_t/*bool*/ x72 = _addcarryx_u64(x68, x42, x69, &x71);
  { uint64_t x73 = (x56 & 0xffffffffffffffffL);
  { uint64_t x75; uint8_t/*bool*/ x76 = _addcarryx_u64(x72, x45, x73, &x75);
  { uint64_t x77 = (x56 & 0xffffffffffffffffL);
  { uint64_t x79; uint8_t/*bool*/ x80 = _addcarryx_u64(x76, x48, x77, &x79);
  { uint64_t x81 = (x56 & 0xffffffffffffffffL);
  { uint64_t x83; uint8_t/*bool*/ x84 = _addcarryx_u64(x80, x51, x81, &x83);
  { uint64_t x85 = (x56 & 0x7fffffffffffffffL);
  { uint64_t x87; uint8_t/*bool*/ _ = _addcarryx_u64(x84, x54, x85, &x87);
  out[0] = x59;
  out[1] = x63;
  out[2] = x67;
  out[3] = x71;
  out[4] = x75;
  out[5] = x79;
  out[6] = x83;
  out[7] = x87;
  }}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}
}
