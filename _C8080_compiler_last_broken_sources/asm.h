#include "common.h"
#include <FinLib\fillbuffer.h>

enum Opcode { 
  c_start,

  c_ld_r_r,
  c_ld_r_HL,
  c_ld_r,
  c_inc_r, c_dec_r,

  c_ld_hl_bc,c_ld_bc_hl,

  c_ld_a_flags,
  c_ld_HL, 
  c_ld_BC_a, c_ld_HL_r, c_ld_a_BC, c_ld_a_DE,
  c_ld_a_ref, c_ld_ref_a,
  c_dec_HL, c_inc_HL,

  c_or_r, c_and_r, c_xor_r, c_sub_r, c_sbc_r, c_add_r, c_adc_r, c_cp_r, c_cpz_r,
  c_or_HL, c_and_HL, c_xor_HL, c_sub_HL, c_sbc_HL, c_add_HL, c_adc_HL, c_cp_HL, c_cpz_HL,
  c_or, c_and, c_xor, c_sub, c_sbc, c_add, c_adc, c_cp, c_cpz,

  c_clcf,
  c_cpl,
  c_rra,
  c_push_af, c_pop_af, c_push_bc, c_pop_bc, c_push_hl, c_pop_hl, c_pop_de,
  c_dec_bc,c_inc_bc,c_dec_hl,c_inc_hl,c_dec_sp,c_inc_sp,c_deaddr,
  c_ld_de,c_ld_hl,c_ld_bc,c_ld_hl_ref,c_ld_ref_hl,
  c_add_hl_bc,c_add_hl_de,c_add_hl_hl,
  c_ex_hl_de,

  c_call,c_label,c_jp,c_jp_z,c_jp_nz,c_jp_c,c_jp_nc,c_retPopBC,c_asm,c_labelProc,

  c_call_z,c_call_nz,c_call_c,c_call_nc,

  c_jp_long,
  c_label_forw,c_jp_forw,c_jp_z_forw,c_jp_nz_forw,c_jp_c_forw,c_jp_nc_forw,
  c_label_loop,c_jp_loop,c_jp_z_loop,c_jp_nz_loop,c_jp_c_loop,c_jp_nc_loop  
};

struct Opcode1 {
  Opcode o;
  int i;
  string s;
  int m, alu, reg, reg2;
  bool disabled;
  string remark;

  string get() const { 
    if(m==1) return i2s(i); 
    if(m==2) return s; 
    raise("Opcode1.get"); 
  }
};

class Writer {
public:
  std::vector<Opcode1> l;
  string declb;

  Writer() { put(c_start); }
  void optimize();
  Writer& decl3(cstring name, int additional, FillBuffer* init=0, int ptr2=0, int ptrStep=0);
  Writer& decl4(cstring name, const char* ptr, int len);
  Writer& call(cstring name) { put(c_call, name); return *this; }
  Writer& call(int n) { put(c_call, n); return *this; }
  Writer& callFile(cstring name) { needFile(name.c_str()); put(c_call, name); return *this; }
  Writer& label(int l) { put(c_label, l); return *this; } 

  Writer& label_forward(int lbl) { 
    int fi=-1, fc=0;
    for(unsigned int i=0; i<l.size(); i++) {
      Opcode1& o = l[i];
      if(o.i==lbl && (o.o==c_jp || o.o==c_jp_nz || o.o==c_jp_z || o.o==c_jp_nc || o.o==c_jp_c)) {
        fi = i, fc++;
        if(fc==2) break;
      }
    }
    if(fc==1) {
      Opcode1& o = l[fi];
      switch(o.o) {
        case c_jp:    o.o=c_jp_forw; break;
        case c_jp_nz: o.o=c_jp_nz_forw; break;
        case c_jp_z:  o.o=c_jp_z_forw; break;
        case c_jp_nc: o.o=c_jp_nc_forw; break;
        case c_jp_c:  o.o=c_jp_c_forw; break;
      }
      put(c_label_forw, lbl); 
      return *this; 
    }
    put(c_label, lbl); return *this; 
  } 

  void changeLabelLoop(int lbl) { 
    int li=-1, fi=-1, fc=0, lc=0;
    for(unsigned int i=0; i<l.size(); i++) {
      Opcode1& o = l[i];
      if(o.i==lbl) {
        if(o.o==c_label) {
          li = i, lc++;
          if(lc==2) break;
        }
        if(o.i==lbl && (o.o==c_jp || o.o==c_jp_nz || o.o==c_jp_z || o.o==c_jp_nc || o.o==c_jp_c)) {
          fi = i, fc++;
          if(fc==2) break;
        }
      }
    }
    if(fc==1 && lc==1 && li<fi) {
      l[li].o = c_label_loop;
      Opcode1& o = l[fi];
      switch(o.o) {
        case c_jp:    o.o=c_jp_loop; break;
        case c_jp_nz: o.o=c_jp_nz_loop; break;
        case c_jp_z:  o.o=c_jp_z_loop; break;
        case c_jp_nc: o.o=c_jp_nc_loop; break;
        case c_jp_c:  o.o=c_jp_c_loop; break;
      }
    }
  } 

  Writer& label(cstring n) { put(c_labelProc, n); return *this; }
  Writer& ret(bool popBC) { put(c_retPopBC, popBC ? 1 : 0); return *this; }
  Writer& jp(int l) { put(c_jp, l); return *this; }
  Writer& jp_nz(int l) { put(c_jp_nz, l); return *this; }
  Writer& jp_z(int l) { put(c_jp_z, l); return *this; }
  Writer& jp_ccc(Opcode o, int l) { put(o, l); return *this; }
  Writer& remark(cstring text) { if(!l.back().remark.empty()) l.back().remark += "\r\n"; l.back().remark += text; return *this; }
  Writer& asm_(cstring text) { put(c_asm, text); return *this; }

  //---

  Writer& ld_de_bc() { ld_d_b(); ld_e_c(); return* this; }
  Writer& ld_de_hl() { ld_d_h(); ld_e_l(); return* this; }
  Writer& ld_bc_hl() { put(c_ld_bc_hl); return* this; }

  void put(Opcode o);
  void put(Opcode o, int n, int reg=0);
  void putr(Opcode o, int reg, int reg2=0);
  void put(Opcode o, cstring n, int reg=0);

  Writer& ld_a_b() { putr(c_ld_r_r,0,1); return* this; }
  Writer& ld_a_c() { putr(c_ld_r_r,0,2); return* this; }
  Writer& ld_a_d() { putr(c_ld_r_r,0,3); return* this; }
  Writer& ld_a_e() { putr(c_ld_r_r,0,4); return* this; }
  Writer& ld_a_h() { putr(c_ld_r_r,0,5); return* this; }
  Writer& ld_a_l() { putr(c_ld_r_r,0,6); return* this; }
  Writer& ld_b_a() { putr(c_ld_r_r,1,0); return* this; }
  Writer& ld_b_c() { putr(c_ld_r_r,1,2); return* this; }
  Writer& ld_b_d() { putr(c_ld_r_r,1,3); return* this; }
  Writer& ld_b_e() { putr(c_ld_r_r,1,4); return* this; }
  Writer& ld_b_h() { putr(c_ld_r_r,1,5); return* this; }
  Writer& ld_b_l() { putr(c_ld_r_r,1,6); return* this; }
  Writer& ld_c_a() { putr(c_ld_r_r,2,0); return* this; }
  Writer& ld_c_b() { putr(c_ld_r_r,2,1); return* this; }
  Writer& ld_c_d() { putr(c_ld_r_r,2,3); return* this; }
  Writer& ld_c_e() { putr(c_ld_r_r,2,4); return* this; }
  Writer& ld_c_h() { putr(c_ld_r_r,2,5); return* this; }
  Writer& ld_c_l() { putr(c_ld_r_r,2,6); return* this; }
  Writer& ld_d_a() { putr(c_ld_r_r,3,0); return* this; }
  Writer& ld_d_b() { putr(c_ld_r_r,3,1); return* this; }
  Writer& ld_d_c() { putr(c_ld_r_r,3,2); return* this; }
  Writer& ld_d_e() { putr(c_ld_r_r,3,4); return* this; }
  Writer& ld_d_h() { putr(c_ld_r_r,3,5); return* this; }
  Writer& ld_d_l() { putr(c_ld_r_r,3,6); return* this; }
  Writer& ld_e_a() { putr(c_ld_r_r,4,0); return* this; }
  Writer& ld_e_b() { putr(c_ld_r_r,4,1); return* this; }
  Writer& ld_e_c() { putr(c_ld_r_r,4,2); return* this; }
  Writer& ld_e_d() { putr(c_ld_r_r,4,3); return* this; }
  Writer& ld_e_h() { putr(c_ld_r_r,4,5); return* this; }
  Writer& ld_e_l() { putr(c_ld_r_r,4,6); return* this; }
  Writer& ld_h_a() { putr(c_ld_r_r,5,0); return* this; }
  Writer& ld_h_b() { putr(c_ld_r_r,5,1); return* this; }
  Writer& ld_h_c() { putr(c_ld_r_r,5,2); return* this; }
  Writer& ld_h_d() { putr(c_ld_r_r,5,3); return* this; }
  Writer& ld_h_e() { putr(c_ld_r_r,5,4); return* this; }
  Writer& ld_h_l() { putr(c_ld_r_r,5,6); return* this; }
  Writer& ld_l_a() { putr(c_ld_r_r,6,0); return* this; }
  Writer& ld_l_b() { putr(c_ld_r_r,6,1); return* this; }
  Writer& ld_l_c() { putr(c_ld_r_r,6,2); return* this; }
  Writer& ld_l_d() { putr(c_ld_r_r,6,3); return* this; }
  Writer& ld_l_e() { putr(c_ld_r_r,6,4); return* this; }
  Writer& ld_l_h() { putr(c_ld_r_r,6,5); return* this; }

  Writer& ld_a_HL() { putr(c_ld_r_HL,0); return *this; }
  Writer& ld_b_HL() { putr(c_ld_r_HL,1); return *this; }
  Writer& ld_c_HL() { putr(c_ld_r_HL,2); return *this; }
  Writer& ld_d_HL() { putr(c_ld_r_HL,3); return *this; }
  Writer& ld_e_HL() { putr(c_ld_r_HL,4); return *this; }
  Writer& ld_h_HL() { putr(c_ld_r_HL,5); return *this; }
  Writer& ld_l_HL() { putr(c_ld_r_HL,6); return *this; }

  Writer& ld_a(unsigned char n) { put(c_ld_r, n, 0); return *this; } 
  Writer& ld_b(unsigned char n) { put(c_ld_r, n, 1); return *this; }  
  Writer& ld_c(unsigned char n) { put(c_ld_r, n, 2); return *this; }  
  Writer& ld_d(unsigned char n) { put(c_ld_r, n, 3); return *this; }  
  Writer& ld_e(unsigned char n) { put(c_ld_r, n, 4); return *this; }  
  Writer& ld_h(unsigned char n) { put(c_ld_r, n, 5); return *this; }    
  Writer& ld_l(unsigned char n) { put(c_ld_r, n, 6); return *this; }  

  Writer& inc_a() { putr(c_inc_r,0); return *this; } 
  Writer& dec_a() { putr(c_dec_r,0); return *this; } 
  Writer& inc_b() { putr(c_inc_r,1); return *this; } 
  Writer& dec_b() { putr(c_dec_r,1); return *this; } 
  Writer& inc_c() { putr(c_inc_r,2); return *this; } 
  Writer& dec_c() { putr(c_dec_r,2); return *this; } 
  Writer& dec_l() { putr(c_dec_r,6); return *this; } 
  Writer& inc_l() { putr(c_inc_r,6); return *this; } 

  Writer& ld_a(cstring n) { put(c_ld_r, n, 0); return *this; };
  Writer& ld_d(cstring n) { put(c_ld_r, n, 3); return *this; }  

  //***

  Writer& ld_hl_bc() { put(c_ld_hl_bc); return* this; }

  #define AUT(N) Writer& N(Stack& s) { if(s.place==pConst || s.place==pConstRef8 || s.place==pConstRef16) return N(s.uvalue); if(s.place==pConstStr || s.place==pConstStrRef8 || s.place==pConstStrRef16 || s.place==pConstStrRefRef8 || s.place==pConstStrRefRef16) return N(s.name); raise(#N); throw; }

  Writer& ld_a_flags(unsigned char a) { put(c_ld_a_flags, a); return *this; }
  AUT(ld_a);

  AUT(ld_d);
  Writer& ld_HL(unsigned char n) { put(c_ld_HL, n); return *this; }  
  Writer& ld_HL(cstring n) { put(c_ld_HL, n); return *this; }
  AUT(ld_HL)

  Writer& ld_BC_a() { put(c_ld_BC_a); return *this; }
  Writer& ld_HL_a() { putr(c_ld_HL_r, 0); return *this; }
  Writer& ld_HL_b() { putr(c_ld_HL_r, 1); return *this; }
  Writer& ld_HL_c() { putr(c_ld_HL_r, 2); return *this; }
  Writer& ld_HL_d() { putr(c_ld_HL_r, 3); return *this; }
  Writer& ld_HL_e() { putr(c_ld_HL_r, 4); return *this; }

  Writer& ld_a_BC() { put(c_ld_a_BC); return *this; }
  Writer& ld_a_DE() { put(c_ld_a_DE); return *this; }
  Writer& ld_a_ref(unsigned short n) { put(c_ld_a_ref, n); return *this; } 
  Writer& ld_a_ref(cstring n) { put(c_ld_a_ref, n); return *this; } 
  AUT(ld_a_ref);
  Writer& ld_ref_a(unsigned short n) { put(c_ld_ref_a, n); return *this; } 
  Writer& ld_ref_a(cstring n) { put(c_ld_ref_a, n); return *this; } 
  AUT(ld_ref_a);
  Writer& dec_HL() { put(c_dec_HL); return *this; } 
  Writer& inc_HL() { put(c_inc_HL); return *this; } 
  Writer& sub_c() { putr(c_sub_r,2); return *this; } 
  Writer& cp(unsigned char n) { put(c_cp, n); return *this; } 
  Writer& cpz(unsigned char n) { put(c_cpz, n); return *this; } 
  Writer& sub_l() { putr(c_sub_r,6); return *this; } 
  Writer& alu_a (Opcode o) { putr(o,0); return *this; } 
  Writer& alu_b (Opcode o) { putr(o,1); return *this; } 
  Writer& alu_c (Opcode o) { putr(o,2); return *this; } 
  Writer& alu_d (Opcode o) { putr(o,3); return *this; } 
  Writer& alu_e (Opcode o) { putr(o,4); return *this; } 
  Writer& alu_h (Opcode o) { putr(o,5); return *this; } 
  Writer& alu_l (Opcode o) { putr(o,6); return *this; } 

  int calc();

  Writer& alu_HL(Opcode o) { 
    switch(o) {
      case c_or_r:  put(c_or_HL); break;
      case c_and_r: put(c_and_HL); break;
      case c_add_r: put(c_add_HL); break;
      case c_adc_r: put(c_adc_HL); break;
      case c_sub_r: put(c_sub_HL); break;
      case c_sbc_r: put(c_sbc_HL); break;
      case c_cp_r:  put(c_cp_HL); break;
      case c_cpz_r: put(c_cpz_HL); break;
      case c_xor_r: put(c_xor_HL); break;
      default: raise("alu_HL");
    }
    return *this; 
  } 

  Writer& alu(Opcode o, cstring n) {
    switch(o) {
      case c_or_r:  o=(c_or); break;
      case c_and_r: o=(c_and); break;
      case c_add_r: o=(c_add); break;
      case c_adc_r: o=(c_adc); break;
      case c_sub_r: o=(c_sub); break;
      case c_sbc_r: o=(c_sbc); break;
      case c_cp_r:  o=(c_cp); break;
      case c_cpz_r: o=(c_cpz); break;
      case c_xor_r: o=(c_xor); break;
      default: raise("alu");
    }
    put(o, n); return *this; 
  }
  Writer& alu(Opcode o, int n) {
    switch(o) {
      case c_or_r:  o=(c_or); break;
      case c_and_r: o=(c_and); break;
      case c_add_r: o=(c_add); break;
      case c_adc_r: o=(c_adc); break;
      case c_sub_r: o=(c_sub); break;
      case c_sbc_r: o=(c_sbc); break;
      case c_cp_r:  o=(c_cp); break;
      case c_cpz_r: o=(c_cpz); break;
      case c_xor_r: o=(c_xor); break;
      default: raise("alu");
    }
    put(o, n); return *this; 
  }
  Writer& alu(Opcode o, Stack& s) { 
    if(s.place==pConst || s.place==pConstRef8 || s.place==pConstRef16) { alu(o, s.uvalue); return *this; }
    if(s.place==pConstStr || s.place==pConstStrRef8 || s.place==pConstStrRef16 || s.place==pConstStrRefRef8 || s.place==pConstStrRefRef16) { alu(o, s.name); return *this; }
    raise("alu"); throw; 
  }

  Writer& sbc_b() { putr(c_sbc_r, 1); return *this; } 
  Writer& sbc_h() { putr(c_sbc_r, 5); return *this; } 
  Writer& or_a() { putr(c_or_r, 0); return *this; } 
  Writer& or_b() { putr(c_or_r, 1); return *this; } 
  Writer& or_c() { putr(c_or_r, 2); return *this; } 
  Writer& or_h() { putr(c_or_r, 5); return *this; } 
  Writer& and(unsigned char n) { put(c_and, n); return *this; } 
  Writer& add_a() { putr(c_add_r, 0); return *this; } 
  Writer& clcf() { put(c_clcf); return *this; } 
  Writer& cpl() { put(c_cpl); return *this; } 
  Writer& rra() { put(c_rra); return *this; } 
  Writer& pop_af() { put(c_pop_af); return *this; } 
  Writer& push_af() { put(c_push_af); return *this; } 
  Writer& push_bc() { put(c_push_bc); return *this; } 
  Writer& pop_bc() { put(c_pop_bc); return *this; } 

  Writer& push_hl() { put(c_push_hl); return *this; } 
  Writer& pop_hl() { put(c_pop_hl); return *this; } 
  Writer& pop_de() { put(c_pop_de); return *this; } 
  Writer& dec_bc() { put(c_dec_bc); return *this; } 
  Writer& inc_bc() { put(c_inc_bc); return *this; } 
  Writer& dec_hl() { put(c_dec_hl); return *this; } 
  Writer& inc_hl() { put(c_inc_hl); return *this; } 
  Writer& ld_de    (unsigned short n) { put(c_ld_de, n); return *this; } 
  Writer& ld_de(cstring n) { put(c_ld_de, n); return *this; }     
  AUT(ld_de);
  Writer& ld_hl    (unsigned short n) { put(c_ld_hl, n); return *this; } 
  Writer& ld_hl(cstring n) { put(c_ld_hl, n); return *this; } 
  AUT(ld_hl);
  Writer& ld_bc    (unsigned short n) { put(c_ld_bc, n); return *this; } 
  Writer& ld_bc(cstring n) { put(c_ld_bc, n); return *this; } 
  AUT(ld_bc);
  Writer& ld_hl_ref(unsigned short n) { put(c_ld_hl_ref, n); return *this; } 
  Writer& ld_hl_ref(cstring n) { put(c_ld_hl_ref, n); return *this; } 
  AUT(ld_hl_ref);
  Writer& ld_ref_hl(unsigned short n) { put(c_ld_ref_hl, n); return *this; }  
  Writer& ld_ref_hl(cstring n) { put(c_ld_ref_hl, n); return *this; } 
  AUT(ld_ref_hl);
  Writer& add_hl_bc() { put(c_add_hl_bc); return *this; } 
  Writer& add_hl_de() { put(c_add_hl_de); return *this; } 
  Writer& add_hl_hl() { put(c_add_hl_hl); return *this; } 
  Writer& ex_hl_de(bool ignore=false){ if(!ignore) put(c_ex_hl_de); return *this; } 

  Writer& inc_sp() { put(c_inc_sp); return *this; } 
  Writer& dec_sp() { put(c_dec_sp); return *this; } 

  void make(FillBuffer&);

  //-------
  Writer& deaddr() { put(c_deaddr); return *this; } 

};

Writer& bc(int=0);
