%scanner                Scanner.h
%scanner-token-function d_scanner.lex()
//%print-tokens
%baseclass-preinclude ParserPreinclude.h

%polymorphic
    CString: const char*;
    String: std::string;
    Compare: Compare;
    Unsigned: unsigned;
    Number: long long int;
    CStringArray: std::shared_ptr<std::vector<const char*>>;
    StringArray: std::shared_ptr<std::vector<std::string>>;

%token CALC
%token EXTERN VOID INT INT8 INT16 INT32 INT64 UINT8 UINT16 UINT32 UINT64
%token FLAG_Z, FLAG_NZ, FLAG_C, FLAG_NC, FLAG_PO, FLAG_PE, FLAG_P, FLAG_M

%token ';' '(' '{' '}' ')' '~'
%token REG_A REG_B REG_C REG_D REG_E REG_H REG_L REG_BC REG_DE REG_HL REG_IX REG_IY REG_IXL REG_IXH REG_IYL REG_IYH REG_SP
%token IF WHILE DO PUSH POP RETURN NORETURN RST CONST ELSE GOTO CONTINUE BREAK SCF CCF NEG
%token INVERT EI DI IN OUT NOP EX DAA LDI CPI INI OUTI LDD CPD IND OUTD LDIR CPIR INIR OTIR LDDR CPDR INDR OTDR HALT ASM

%token M_COUNTER M_INCLUDE M_EOL M_ORG

%right '=' // стандарт Си
%left OP_SADD OP_SSUB OP_SOR OP_SAND OP_SXOR OP_SADC OP_SSBC OP_SSHL OP_SSHR OP_SROL OP_SROR OP_SCSHL OP_SCSHR; // Немного не по стандарту.
%left OP_LOR // стандарт Си
%left OP_LAND // стандарт Си
%left '|' // стандарт Си
%left '^' // стандарт Си
%left '&' // стандарт Си
%left OP_EQ OP_NE OP_LE OP_GE '?' '<' '>' // стандарт Си
%left OP_SHL OP_SHR // стандарт Си
%left '+' '-' // стандарт Си
%left '/' '*' '%' // стандарт Си
%left '!' // стандарт Си.
%left OP_INC OP_DEC // стандарт Си. Наивысший приоритет
%left '[' // стандарт Си. Наивысший приоритет

%type <Compare> compare shift
%type <CString> regPush reg16 reg8 while_do_args
%type <String> CALC ID STRING const addr alu alu_arg com8 com16 reg8phl return_call scalc string2
%type <Number> NUMBER number icalc
%type <Unsigned> write_label alloc_label init_array type
%type <CStringArray> reg_push_array
%type <StringArray> init_values init_values_1 init_values_2

%%

startrule:
    /* Empty */
    | startrule decl
;

preprocessor:
     M_COUNTER icalc M_EOL { lc = stringCounter = $2; }
     | M_ORG scalc M_EOL { out << "    org " << $2 << "\n"; }
     | M_INCLUDE STRING M_EOL { d_scanner.include($2); }
;

init_array:
    /*empty*/ { $$(1); }
    | '[' ']'       { $$(UINT_MAX); }
    | '[' icalc ']' { $$($2); }
;

init_values:
    init_values_1           { $$($1); }
    | /* empty */           { auto a = std::make_shared<std::vector<std::string>>(); $$(a); }
;

init_values_1:
    init_values_1 ',' init_values_2 { $1->insert($1->end(), $3->begin(), $3->end()); $$($1); }
    | init_values_2                 { $$($1); }
;

init_values_2:
    '@' string2 { std::string str; if (!cp1251ToUtf8(str, $2)) throw("Unsupported unicode char"); auto a = std::make_shared<std::vector<std::string>>(); quoteStringEx(*a, str); $$(a); }
    | scalc { auto a = std::make_shared<std::vector<std::string>>(); a->push_back($1); $$(a); }
;

decl:
    VOID proto_args_0 ID '(' proto_args ')' { noreturn = false; out << $3 << ":\n"; } '{' function_body '}' { if (!noreturn) out << "    ret\n"; }

    | EXTERN type ID '=' scalc ';' {
        out << $3 << "=" << $5 << "\n";
    }

    | ASM '(' STRING ')' ';' { out << $3 << "\n"; }

    | type ID init_array ';' {
        unsigned ic = $3;
        if (ic == UINT_MAX) throw "Не указан размер";
        out << $2 << " ";
        if (ic != 1) out << "ds " << ($1 * $3) << "\n";
                else out << asmTypeDecl($1) << " 0" << "\n";
    }

    | type ID init_array '=' '{' init_values '}' ';' {
        out << $2 << ":\n";
        auto& a = *$6;
        unsigned rc = a.size(), ic = $3;
        if (ic == UINT_MAX) ic = rc;
        if (rc > ic) throw "Incorrect size " + std::to_string(rc) + " > " + std::to_string(ic);
        const char* d = asmTypeDecl($1);
        for(auto& v : a)
            out << "    " << d << " " << v << "\n";
        unsigned zs = (ic - rc);
        if (zs != 0) out << "    ds " << (zs * $1) << "\n";
    }

    | type ID '=' const ';' { out << $2 << " " << asmTypeDecl($1) << " " << $4 << "\n"; }
    | CONST INT ID '=' icalc ';' { consts[$3] = $5; }
    | CONST INT ID '=' scalc ';' { consts[$3] = $5; }
    | ID ':'                             { out << $1 << ":\n"; }
    | '#' { d_scanner.preprocessor = true; } preprocessor { d_scanner.preprocessor = false; }
;

type:
      INT8   { $$(1); }
    | INT16  { $$(2); }
    | INT32  { $$(4); }
    | INT64  { $$(8); }
    | UINT8  { $$(1); }
    | UINT16 { $$(2); }
    | UINT32 { $$(4); }
    | UINT64 { $$(8); }
;

function_body:
    /* Empty */
    | function_body cmd
;

proto_args_0:
    /* empty */
    | '(' proto_args_1 ')';

proto_args:
    /* empty */
    | proto_args_1;

proto_args_1:
    reg8
    | reg16
    | proto_args_1 ',' reg8
    | proto_args_1 ',' reg16
;

call_args:
    /* empty */
    | call_args_1
;

call_args_1:
    com
    | call_args_1 ',' com
;

alloc_label: { $$(lc); lc++; };

write_label: { $$(lc); out << "l" << lc << ":\n"; lc++; };

reg_push_array:
    regPush                       { auto a = std::make_shared<std::vector<const char*>>(); a->push_back($1); $$(a); }
    | reg_push_array ',' regPush  { $1->push_back($3); $$($1); }
;

else_block:
    ELSE alloc_label {
        out << "    jp   l" << $2 << "\n";
        out << "l" << hack_else << ":\n";
    } cmd {
        out << "l" << $2 << ":\n";
    }
    | /* no else */ {
        out << "l" << hack_else << ":\n";
    }
;

else_call:
    ELSE { throw("Оберните вызов функции в {}"); }
    | /* Empty*/
;

else_return:
    ELSE { throw("Удалить else из конструкции if(...) return ...; else ..."); }
    | /* Empty*/
;

return_call:
    RETURN ID '(' call_args ')' { $$($2); }
    | GOTO ID { $$($2); }
;

while_do_args:
    OP_DEC REG_B { $$(nullptr); }
    | compare    { $$($1.t);    }
;

cmd:
    '{' function_body '}'

    | ASM '(' STRING ')' ';' { out << $3 << "\n"; }

    | IF '(' compare ')' ID '(' call_args ')' ';' { // 53. CALL ССС, [nn]
        out << "    call " << $3.t << ", " << $5 << "\n";
    } else_call // Это правило блокирует правило if else, поэтому обрабатывает else тут

    | IF '(' OP_DEC REG_B ')' return_call ';' {
        out << "    djnz " << $6 << "\n";
    } else_return // Это правило блокирует правило if else, поэтому обрабатывает else тут

    | IF '(' compare ')' return_call ';' { // 45. JP CCC, nn
        out << "    jp   " << $3.t << ", " << $5 << "\n";
    } else_return // Это правило блокирует правило if else, поэтому обрабатывает else тут

    | IF '(' compare ')' CONTINUE ';' { // 45. JP CCC, nn
        out << "    jp   " << $3.t << ", l" << getContinue() << "\n";
    } else_return // Это правило блокирует правило if else, поэтому обрабатывает else тут

    | IF '(' compare ')' BREAK ';' { // 45. JP CCC, nn
        out << "    jp   " << $3.t << ", l" << getBreak() << "\n";
    } else_return // Это правило блокирует правило if else, поэтому обрабатывает else тут

    | IF '(' compare ')' RETURN ';' { // 39. RET CCC
        out << "    ret  " << $3.t << "\n";
    } else_return // Это правило блокирует правило if else, поэтому обрабатывает else тут

    | IF '(' compare ')' alloc_label { // Для удобства
        out << "    jp   " << $3.f << ", l" << $5 << "\n";
    } cmd { hack_else = $5; } else_block

    | WHILE write_label '(' compare ')' alloc_label { // Для удобства
        pushBreak($6);
        pushContinue($2);
        out << "    jp   " << $4.f << ", l" << $6 << "\n";
    } cmd {
        out << "    jp   l" << $2 << "\n";
        out << "l" << $6 << ":\n";
        popBreak();
        popContinue();
    }

    | WHILE write_label '(' ')' alloc_label {
        pushContinue($2);
        pushBreak($5);
    } cmd {
        out << "    jp   l" << $2 << "\n";
        out << "l" << $5 << ":\n";
        popBreak();
        popContinue();
    }

    | DO write_label alloc_label {
        pushBreak($3);
        pushContinue($2);
    } '{' function_body '}' WHILE '(' while_do_args ')' ';' {
        if ($10) out << "    jp   " << $10 << ", l" << $2 << "\n";
            else out << "    djnz l" << $2 << "\n"; // 3. DJNZ d
        out << "l" << $3 << ":\n";
        popBreak();
        popContinue();
    }

    | PUSH '(' reg_push_array ')' { // Для удобства
        auto& a = *$3;
        for(auto i = a.begin(); i != a.end(); i++)
            out << "    push " << *i << "\n";
    } '{' function_body '}' {
        auto& a = *$3;
        for(auto i = a.rbegin(); i != a.rend(); i++)
            out << "    pop  " << *i << "\n";
    }

    | PUSH '(' reg_push_array ')' ';' {  // 54. PUSH RP
        auto& a = *$3;
        for(auto i = a.begin(); i != a.end(); i++)
            out << "    push " << *i << "\n";
    }

    | POP '(' reg_push_array ')' ';' { // 40. POP RP
        auto& a = *$3;
        for(auto i = a.rbegin(); i != a.rend(); i++)
            out << "    pop  " << *i << "\n";
    }

    | CONTINUE ';'                       { out << "    jp l" << getContinue() << "\n"; }
    | BREAK ';'                          { out << "    jp l" << getBreak() << "\n"; }

    | DAA  '(' call_args ')' ';'         { out << "    daa\n"; } // 23. DAA
    | LDI  '(' call_args ')' ';'         { out << "    ldi\n"; } // 96. LDI
    | CPI  '(' call_args ')' ';'         { out << "    cpi\n"; } // 97. CPI
    | INI  '(' call_args ')' ';'         { out << "    ini\n"; } // 98. INI
    | OUTI '(' call_args ')' ';'         { out << "    outi\n"; } // 99. OUTI
    | LDD  '(' call_args ')' ';'         { out << "    ldd\n"; } // 100. LDD
    | CPD  '(' call_args ')' ';'         { out << "    cpd\n"; } // 101. CPD
    | IND  '(' call_args ')' ';'         { out << "    ind\n"; } // 102. IND
    | OUTD '(' call_args ')' ';'         { out << "    outd\n"; } // 103. OUTD
    | LDIR '(' call_args ')' ';'         { out << "    ldir\n"; } // 104. LDIR
    | CPIR '(' call_args ')' ';'         { out << "    cpir\n"; } // 105. CPIR
    | INIR '(' call_args ')' ';'         { out << "    inir\n"; } // 106. INIR
    | OTIR '(' call_args ')' ';'         { out << "    otir\n"; } // 107. OTIR
    | LDDR '(' call_args ')' ';'         { out << "    lddr\n"; } // 108. LDDR
    | CPDR '(' call_args ')' ';'         { out << "    cpdr\n"; } // 109. CPDR
    | INDR '(' call_args ')' ';'         { out << "    indr\n"; } // 110. INDR
    | OTDR '(' call_args ')' ';'         { out << "  4  otdr\n"; } // 111. OTDR
    | OUT  '(' com16 ',' com8 ')' ';'    { onlyBc($3); out << "    out  (c), " << $5 << "\n"; } // 79. OUT [C], SSS
    | OUT  '(' const ',' com8 ')' ';'    { out << "    out  (" << $3 << "), " << $5 << "\n"; }
    | HALT '(' ')' ';'                   { out << "    halt\n"; } // 27. HALT
    | RST  '(' const ')' ';'             { out << "    rst " << $3 << "\n"; } // 64. RST NNN
    | NORETURN ';'                       { noreturn = true; }
    | GOTO REG_HL ';'                    { out << "    jp   hl\n"; } // 43. JP HL
    | RETURN ';'                         { out << "    ret\n"; } // 41. RET
    | return_call ';'                    { out << "    jp   " << $1 << "\n"; } // 46. JP nn
    | ID '(' call_args ')' ';'           { out << "    call " << $1 << "\n"; } // 55. CALL [nn]
    | NOP '(' ')' ';'                    { out << "    nop\n"; } // 1. NOP
    | NOP '(' number ')' ';'             { for (auto i = $3; i > 0; i--) out << "    nop\n"; } // 1. NOP
    | EX '(' '*' REG_SP ',' REG_HL ')' ';' { out << "    ex   (sp), hl\n"; }
    | EX '(' REG_A ')' ';'               { out << "    ex   af, af\n"; } // 2. EX AF, AF'
    | EX '(' REG_A ',' REG_A ')' ';'     { out << "    ex   af, af\n"; } // 2. EX AF, AF'
    | EX '(' REG_BC ',' REG_DE ',' REG_HL ')' ';' { out << "    exx\n"; } // 42. EXX
    | EX '(' REG_BC ',' REG_HL ',' REG_DE ')' ';' { out << "    exx\n"; } // 42. EXX
    | EX '(' REG_DE ',' REG_BC ',' REG_HL ')' ';' { out << "    exx\n"; } // 42. EXX
    | EX '(' REG_DE ',' REG_HL ',' REG_BC ')' ';' { out << "    exx\n"; } // 42. EXX
    | EX '(' REG_HL ',' REG_BC ',' REG_DE ')' ';' { out << "    exx\n"; } // 42. EXX
    | EX '(' REG_HL ',' REG_DE ',' REG_BC ')' ';' { out << "    exx\n"; } // 42. EXX
    | EX '(' REG_DE ',' REG_HL ')' ';'   { out << "    ex de, hl\n"; } // 50. EX DE,HL
    | EX '(' REG_HL ',' REG_DE ')' ';'   { out << "    ex de, hl\n"; } // 50. EX DE,HL
    | ID ':'                             { out << $1 << ":\n"; }
    | com ';'
    | SCF '(' ')' ';'                    { out << "    scf\n"; } // 25. SCF
    | CCF '(' ')' ';'                    { out << "    ccf\n"; } // 26. CCF
    | EI '(' ')' ';'                     { out << "    ei\n"; }
    | DI '(' ')' ';'                     { out << "    di\n"; }
    | INVERT '(' REG_A ')' ';'           { out << "    cpl\n"; }
    | ';'
;

alu_arg:
    const                           { $$($1); }
    | com8                          { $$($1); }
    | '*' com16                     { onlyHl($2); $$("(" + $2 + ")"); }
    | com16 '[' number ']'          { onlyIxIy($1); $$("(" + $1 + " + " + std::to_string($3) + ")"); }
;

reg8phl:
    | com8                          { $$($1); }
    | '*' com16                     { onlyHl($2); $$("(" + $2 + ")"); }
    | com16 '[' number ']'          { onlyIxIy($1); $$("(" + $1 + " + " + std::to_string($3) + ")"); }
;

compare_com:
    /* empty*/
    | com
;

compare:
      com8 OP_EQ alu_arg            { onlyA($1); if (std::string($3) == "0") out << "    or   a\n"; else out << "    cp   " << $3 << "\n"; $$ = Compare("z", "nz"); }
    | com8 OP_NE alu_arg            { onlyA($1); if (std::string($3) == "0") out << "    or   a\n"; else out << "    cp   " << $3 << "\n";                 $$ = Compare("nz", "z"); }
    | com8 OP_GE alu_arg            { onlyA($1); out << "    cp   " << $3 << "\n";                 $$ = Compare("nc", "c"); }
    | com8 '<'  alu_arg             { onlyA($1); out << "    cp   " << $3 << "\n";                 $$ = Compare("c", "nc"); }
    | reg8phl '&' number            {            out << "    bit  " << getBit($3) << ", " << $1 << "\n";   $$ = Compare("nz", "z"); } // 73. BIT bit, SSS
    | FLAG_Z  compare_com           { $$ = Compare("z", "nz"); }
    | FLAG_NZ compare_com           { $$ = Compare("nz", "z"); }
    | FLAG_C  compare_com           { $$ = Compare("c", "nc"); }
    | FLAG_NC compare_com           { $$ = Compare("nc", "c"); }
    | FLAG_PO compare_com           { $$ = Compare("po", "pe"); }
    | FLAG_PE compare_com           { $$ = Compare("pe", "po"); }
    | FLAG_P  compare_com           { $$ = Compare("p", "m"); }
    | FLAG_M  compare_com           { $$ = Compare("m", "p"); }
;

addr:
    '*' const                       { $$($2); }
    | ID                            { $$($1); }
;

com:
      com8
    | com16
    | reg8 OP_INC                   {                        out << "    inc  " << $1 << "\n"; } // 16. INC SSS - нельзя com8, иначе рабоатет a=b++ как a=b, b++
    | reg8 OP_DEC                   {                        out << "    dec  " << $1 << "\n"; } // 17. INC SSS - нельзя com8, иначе рабоатет a=b++ как a=b, b++
    | '(' '*' com16 ')' OP_INC      { onlyHl($3);            out << "    inc  (" << $3 << ")\n"; } // 16. INC (HL)
    | com16 '[' number ']' OP_INC   { onlyIxIy($1);          out << "    inc  (" << $1 << " + " << $3 << ")\n"; } // 16. INC (HL)
    | '(' '*' com16 ')' OP_DEC      { onlyHl($3);            out << "    dec  (" << $3 << ")\n"; } // 17. DEC (HL)
    | com16 '[' number ']' OP_DEC   { onlyIxIy($1);          out << "    dec  (" << $1 << " + " << $3 << ")\n"; } // 17. DEC (HL)
    | OP_INC '*' com16              { onlyHl($3);            out << "    inc  (" << $3 << ")\n"; } // 16. INC (HL)
    | OP_INC com16 '[' number ']'   { onlyIxIy($2);          out << "    inc  (" << $2 << " + " << $4 << ")\n"; } // 16. INC (IX/IY+CONST)
    | OP_DEC '*' com16              { onlyHl($3);            out << "    dec  (" << $3 << ")\n"; } // 17. DEC (HL)
    | OP_DEC com16 '[' number ']'   { onlyIxIy($2);          out << "    dec  (" << $2 << " + " << $4 << ")\n"; } // 17. DEC (IX/IY+CONST)
    | reg16 OP_INC                  {                        out << "    inc  " << $1 << "\n"; } // 14. INC RP - нельзя com16
    | reg16 OP_DEC                  {                        out << "    dec  " << $1 << "\n"; } // 15. INC RP - нельзя com16
    | '*' com16 '=' com8            { if (isBcDe($2)) onlyA($4); else onlyHl($2);
                                                             out << "    ld   (" << $2 << "), " << $4 << "\n"; } // 8. LD [BC/DE], A; 29. LD [HL], SSS
    | com16 '[' number ']' '=' com8 { onlyIxIy($1);          out << "    ld   (" << $1 << " + " << $3 << "), " << $6 << "\n"; } // 8. LD [BC/DE], A; 29. LD [HL], SSS
    | addr '=' com16                {                        out << "    ld   (" << $1 << "), " << $3 << "\n"; } // 10. LD [nn], HL; // 82. LD [nn], RP
    | addr '=' com8                 { onlyA($3);             out << "    ld   (" << $1 << "), " << $3 << "\n"; } // 12. LD [nn], A
    | '*' com16 '=' const           { onlyHl($2);            out << "    ld   (" << $2 << "), " << $4 << "\n"; } // 18. LD DDD, d    
    | com16 '[' number ']' '=' const{ onlyIxIy($1);          out << "    ld   (" << $1 << " + " << $3 << "), " << $6 << "\n"; } // 18. LD DDD, d
    | '*' com16 OP_SOR number       { onlyHl($2);            out << "    set  " << getBit($4) << ", (" << $2 << ")\n"; return; } // 75. SET bit, (HL)
    // ix[]
    | '*' com16 OP_SAND number      { onlyHl($2);            out << "    res  " << getBit($4 ^ 0xFF) << ", (" << $2 << ")\n"; return; } // 74. RES bit, (HL)
    // ix[]
    | reg8phl '&' number            {                        out << "    bit  " << getBit($3) << ", " << $1 << "\n"; } // 73. BIT bit, SSS
;

com8:
    '(' com8 ')'                    { $$($2); }
    | NEG '(' com8 ')'              { onlyA($3);             out << "    neg\n"; $$($3); } // 84. NEG
    | OP_INC com8                   {                        out << "    inc  " << $2 << "\n"; $$($2); } // 16. INC SSS
    | OP_DEC com8                   {                        out << "    dec  " << $2 << "\n"; $$($2); } // 17. DEC SSS
    | com8 '=' IN '(' const ')'     {                        out << "    in   " << $1 << ", (" << $5 << ")\n"; $$($1); }
    | com8 '=' IN '(' com16 ')'     { onlyBc($5);            out << "    in   " << $1 << ", (c)\n"; $$($1); } // 77. IN DDD, [BC] / IN (HL), [BC] запрещена
    | com8 '=' addr                 { onlyA($1);             out << "    ld   " << $1 << ", (" << $3 << ")\n"; $$($1); } // 13. LD A, [nn]
    | com8 '=' '*' com16            { if (isBcDe($4)) onlyA($1); else onlyHl($4);
                                                             out << "    ld   " << $1 << ", (" << $4 << ")\n";  $$($1); } // 9. LD A, [BC/DE]; 28. LD DDD, [HL]
    | com8 '=' com16 '[' const ']'  { onlyIxIy($3);          out << "    ld   " << $1 << ", (" << $3 << " + " << $5 << ")\n"; $$($1); } // 9. LD A, [BC/DE]; 28. LD DDD, [HL]
    | com8 '=' com8                 {                        out << "    ld   " << $1 << ", " << $3 << "\n"; $$($1); } // 30. LD DDD, SSS
    | com8 '=' const                {                        out << "    ld   " << $1 << ", " << $3 << "\n"; $$($1); } // 18. LD DDD, d
    // Заменить number на const
    | com8 alu const                { if ($1 != "a" && $2.compare("or  ") == 0) { out << "    set  " << getBit(strtoll_throw($3)) << ", " << $1 << "\n"; $$($1); return; } // 75. SET bit, SSS
                                      if ($1 != "a" && $2.compare("and ") == 0) { out << "    res  " << getBit(strtoll_throw($3) ^ 0xFF) << ", " << $1 << "\n"; $$($1); return; } // 74. RES bit, SSS
                                      onlyA($1);             out << "    " << $2 << " " << $3 << "\n"; $$($1); }
    | com8 alu com8                 { onlyA($1);             out << "    " << $2 << " " << $3 << "\n"; $$($1); }
    | com8 alu '*' com16            { onlyA($1); onlyHl($4); out << "    " << $2 << " (" << $4 << ")\n"; $$($1); }
    // ix[]
    | reg8                          { $$($1); }    
    | com8 shift number             { if ($3 < 1 || $3 > 8) throw("Сдвигать можно только на 1 .. 8 бит");
                                      unsigned n = (unsigned)$3;
                                      if (!$1.compare("a")) { while(n--) out << "    " << $2.f << "\n"; }
                                                       else { while(n--) out << "    " << $2.t << " " << $1 << "\n"; }
                                      $$($1); }
;

com16:
    '(' com16 ')'              { $$($2); }
    | OP_INC com16             {             out << "    inc  " << $2 << "\n"; $$($2); } // 14. INC RP
    | OP_DEC com16             {             out << "    dec  " << $2 << "\n"; $$($2); } // 15. INC RP
    | com16 '=' com16          {             if (std::string($1) == "sp" && std::string($3) == "hl")
                                             {
                                                 out << "    ld   sp, hl\n"; // 44. LD SP,HL
                                             }
                                             else
                                             {
                                                out << "    ld   " << getSubRegister($1, 0) << ", " << getSubRegister($3, 0) << "\n";
                                                out << "    ld   " << getSubRegister($1, 1) << ", " << getSubRegister($3, 1) << "\n";
                                             }
                                             $$($1);
                               }
    | com16 '=' const          {             out << "    ld   " << $1 << ", " << $3 << "\n"; $$($1); } // 6. LD RP, nn
    | com16 '=' addr           {             out << "    ld   " << $1 << ", (" << $3 << ")\n"; $$($1); } // 11. LD HL, [nn]; // 83. LD RP, [nn]
    | com16 OP_SADD com16      { onlyHl($1); out << "    add  " << $1 << ", " << $3 << "\n"; $$($1); } // 7. ADD HL, RP
    | com16 OP_SADC com16      { onlyHl($1); out << "    adc  " << $1 << ", " << $3 << "\n"; $$($1); } // 81. ADC HL, RP
    | com16 OP_SSBC com16      { onlyHl($1); out << "    sbc  " << $1 << ", " << $3 << "\n"; $$($1); } // 80. SBC HL, RP
    | com16 OP_SSUB com16      { onlyHl($1); out << "    or   a\n" << "    sub  " << $1 << ", " << $3 << "\n"; $$($1); } // 80. SBC HL, RP
    | reg16                    { $$($1); }
;

string2:
    STRING                     { $$($1); }
    | string2 STRING           { $$($1 + $2); }
;

const:
      string2                  { $$ = "s" + std::to_string(allocString($1)); }
    | CALC                     { $$($1); }
    | number                   { $$(std::to_string($1)); }
    | '[' scalc ']'            { $$($2); }
    | '&' ID                   { $$($2); }
;

number:
      NUMBER          { $$($1); }
    | '-' NUMBER      { $$(-$2); }
    | '[' icalc ']'   { $$($2); }
;

scalc:
      '&' ID                   { $$($2); }
    | string2                  { $$ = "s" + std::to_string(allocString($1)); }
    | CALC                     { $$($1); }
    | '~' scalc                { $$("~(" + $2 + ")"); }
    | '(' scalc ')'            { $$("+(" + $2 + ")"); }
    | '[' scalc ']'            { $$("+(" + $2 + ")"); }
    | scalc '+'     scalc      { $$("(" + $1 + ") + (" + $3 + ")"); }
    | scalc '*'     scalc      { $$("(" + $1 + ") * (" + $3 + ")"); }
    | scalc '-'     scalc      { $$("(" + $1 + ") - (" + $3 + ")"); }
    | scalc '/'     scalc      { $$("(" + $1 + ") / (" + $3 + ")"); }
    | scalc '%'     scalc      { $$("(" + $1 + ") % (" + $3 + ")"); }
    | scalc '&'     scalc      { $$("(" + $1 + ") & (" + $3 + ")"); }
    | scalc '|'     scalc      { $$("(" + $1 + ") | (" + $3 + ")"); }
    | scalc '^'     scalc      { $$("(" + $1 + ") ^ (" + $3 + ")"); }
    | scalc OP_NE   scalc      { $$("(" + $1 + ") != (" + $3 + ")"); }
    | scalc OP_EQ   scalc      { $$("(" + $1 + ") == (" + $3 + ")"); }
    | scalc OP_GE   scalc      { $$("(" + $1 + ") >= (" + $3 + ")"); }
    | scalc OP_LE   scalc      { $$("(" + $1 + ") <= (" + $3 + ")"); }
    | scalc '>'     scalc      { $$("(" + $1 + ") > (" +  $3 + ")"); }
    | scalc '<'     scalc      { $$("(" + $1 + ") < (" +  $3 + ")"); }
    | scalc OP_SHL  scalc      { $$("(" + $1 + ") << (" + $3 + ")"); }
    | scalc OP_SHR  scalc      { $$("(" + $1 + ") >> (" + $3 + ")"); }
    | scalc OP_LAND scalc      { $$("(" + $1 + ") && (" + $3 + ")"); }
    | scalc OP_LOR  scalc      { $$("(" + $1 + ") || (" + $3 + ")"); }
    | '-' scalc                { $$("-(" + $2 + ")"); }
    | '!' scalc                { $$("!(" + $2 + ")"); }
    | icalc                    { $$(std::to_string($1)); }
;

icalc:
      NUMBER                  { $$($1); }
    | '~' icalc               { $$(~$2); }
    | '(' icalc ')'           { $$($2); }
    | '[' icalc ']'           { $$($2); }
    | icalc '+'     icalc     { $$($1 + $3); }
    | icalc '*'     icalc     { $$($1 * $3); }
    | icalc '-'     icalc     { $$($1 - $3); }
    | icalc '/'     icalc     { $$($1 / $3); }
    | icalc '%'     icalc     { $$($1 % $3); }
    | icalc '&'     icalc     { $$($1 & $3); }
    | icalc '|'     icalc     { $$($1 | $3); }
    | icalc '^'     icalc     { $$($1 ^ $3); }
    | icalc OP_NE   icalc     { $$($1 != $3); }
    | icalc OP_EQ   icalc     { $$(!($1 != $3)); }
    | icalc OP_GE   icalc     { $$($1 >= $3); }
    | icalc OP_LE   icalc     { $$($1 <= $3); }
    | icalc '>'     icalc     { $$($1 > $3); }
    | icalc '<'     icalc     { $$($1 < $3); }
    | icalc OP_SHL  icalc     { $$($1 << $3); }
    | icalc OP_SHR  icalc     { $$($1 >> $3); }
    | icalc OP_LAND icalc     { $$($1 && $3); }
    | icalc OP_LOR  icalc     { $$($1 || $3); }
    | '-' icalc               { $$(-$2); }
    | '!' icalc               { $$(!$2); }
;

reg8: 
      REG_A   { $$("a"  ); }
    | REG_B   { $$("b"  ); }
    | REG_C   { $$("c"  ); }
    | REG_D   { $$("d"  ); }
    | REG_E   { $$("e"  ); }
    | REG_H   { $$("h"  ); }
    | REG_L   { $$("l"  ); }
    | REG_IXH { $$("ixh"); }
    | REG_IXL { $$("ixl"); }
    | REG_IYH { $$("iyh"); }
    | REG_IYL { $$("iyl"); }
;

reg16: 
      REG_BC { $$("bc"); }
    | REG_DE { $$("de"); }
    | REG_HL { $$("hl"); }
    | REG_IX { $$("ix"); }
    | REG_IY { $$("iy"); }
    | REG_SP { $$("sp"); }
;

regPush:
      REG_BC { $$("bc"); }
    | REG_DE { $$("de"); }
    | REG_HL { $$("hl"); }
    | REG_IX { $$("ix"); }
    | REG_IY { $$("iy"); }
    | REG_A  { $$("af"); }
;

alu:
      OP_SADD { $$("add "); } // 56. ADD A, d  31. ADD SSS
    | OP_SADC { $$("adc "); } // 57. ADC A, d  32. ADC SSS
    | OP_SSUB { $$("sub "); } // 58. SUB A, d  33. SUB SSS
    | OP_SSBC { $$("sbc "); } // 59. SBC A, d  34. SBC SSS
    | OP_SOR  { $$("or  "); } // 62. OR  A, d  35. OR  SSS
    | OP_SAND { $$("and "); } // 60. AND A, d  36. AND SSS
    | OP_SXOR { $$("xor "); } // 61. XOR A, d  37. XOR SSS
    | '?'     { $$("cp  "); } // 63. CP  A, d  38. CP  SSS
;

shift:
      OP_SSHL  { $$("sla ", "sla  a"); } // 69. SLA
    | OP_SSHR  { $$("srl ", "srl  a"); } // 72. SRL
    | OP_SROL  { $$("rlc ", "rlca"  ); } // 65. RLC; 19. RLCA
    | OP_SROR  { $$("rrc ", "rrca"  ); } // 66. RRC; 20. RRCA
    | OP_SCSHL { $$("rl  ", "rla"   ); } // 67. RL; 21. RLA
    | OP_SCSHR { $$("rr  ", "rra"   ); } // 68. RR; 22. RRA
;


// 3. DJNZ d в чистом виде
// 4. JR d пропущены
// 5. JR CCC, d пропущены
// 24. CPL
// 47. OUT (d),A
// 48. IN A, (d)
// 49. EX (SP),HL
// 51. DI
// 52. EI
// 71. SL1
// 70. SRA
// 76. IN F, [BC]
// 78. OUT [C], 0
// 85. RETI
// 86. RETN
// 87. IM 0
// 88. IM 1
// 89. IM 2
// 90. LD I, A
// 91. LD R, A
// 92. LD A, I
// 93. LD A, R
// 94. RRD
// 95. RLD
// 112. LD DDD, rot [IX+d]
// 113. LD DDD, RES bit, [IX+d]
// 114. LD DDD, SET bit, [IX+d]
