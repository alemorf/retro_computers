#include "nodes.h"
#include <functional>
#include "assembler.h"

extern bool retWithBC;

bool compile(Node* n, const std::function<bool()>& result);
bool compileOperator(NodeOperator* no, const std::function<bool(bool, int)>& result);
bool compileCondOperator(int falseLabel, bool neg, NodeVar* cond_, bool dontSaveRegsBeforeJmp, const std::function<bool()>& result);
bool compileConvert(NodeConvert* nc, int canRegs, const std::function<bool(int)>& result);
bool compileConstI(NodeConst* nc, const std::function<bool(int)>& result);
bool compileConstS(NodeConst* nc, int canRegs, const std::function<bool(int)>& result);
bool compileDeaddr(NodeDeaddr* nd, int canRegs, const std::function<bool(int)>& result);
bool compileIncDecOperator(NodeMonoOperator* no, const std::function<bool(int)>& result);
bool compileMonoOperator(NodeMonoOperator* no, const std::function<bool(int)>& result);
bool compileOperator2_8_checkAnyReg(NodeOperator* no);
bool compileOperator2_8(NodeOperator* no, bool swap, Assembler::Reg8 second, const std::function<bool(bool, int)>& result);
bool compileOperatorV2_8_const(NodeOperator* o, bool swap, NodeConst* bc, const std::function<bool(bool, int)>& result);
bool compileOperator2_16(NodeOperator* no, bool swap, Assembler::Reg16 second, const std::function<bool(bool, int)>& result);
bool compileOperatorV2_16_const_add(NodeOperator* o, bool swap, NodeConst* bc, const std::function<bool(bool, int)>& result);
bool compileVar(NodeVar* n, int canRegs, const std::function<bool(int)>& result);
bool compileSaveA(NodeVar* b, bool noResult, const std::function<bool(bool,int)>& result);
bool compileSaveHL(NodeVar* b, bool noResult, const std::function<bool(bool,int)>& result);
bool compileSet(NodeOperator* no, const std::function<bool(bool,int)>& result);
bool compileSetV2_nswap(NodeVar* a, NodeVar* b, NodeOperator* no, const std::function<bool(bool,int)>& result);
bool compileSetV2_swap(NodeVar* a, NodeVar* b, NodeOperator* no, const std::function<bool(bool,int)>& result);
bool compileOperatorV2_8(NodeOperator* o, bool swap, NodeVar* a, NodeVar* b, const std::function<bool(bool, int)>& result);
bool compileOperatorV2_16_const(NodeOperator* o, bool swap, NodeConst* bc, const std::function<bool(bool, int)>& result);
bool compileOperatorV2_16(NodeOperator* o, bool swap, NodeVar* a, NodeVar* b, const std::function<bool(bool, int)>& result);

