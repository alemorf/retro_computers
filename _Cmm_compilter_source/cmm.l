%x COMMENT
%x CHAR
%x STRING

%%

// Типы
"extern" { return Parser::EXTERN; }
"void" { return Parser::VOID; }
"int" { return Parser::INT; }
"int8_t" { return Parser::INT8; }
"int16_t" { return Parser::INT16; }
"int32_t" { return Parser::INT32; }
"int64_t" { return Parser::INT64; }
"uint8_t" { return Parser::UINT8; }
"uint16_t" { return Parser::UINT16; }
"uint32_t" { return Parser::UINT32; }
"uint64_t" { return Parser::UINT64; }

// Условия перехода
"flag_z"  {  return Parser::FLAG_Z; }
"flag_nz" {  return Parser::FLAG_NZ; }
"flag_c"  {  return Parser::FLAG_C; }
"flag_nc" {  return Parser::FLAG_NC; }
"flag_po" {  return Parser::FLAG_PO; }
"flag_pe" {  return Parser::FLAG_PE; }
"flag_p"  {  return Parser::FLAG_P; }
"flag_m"  {  return Parser::FLAG_M; }

// Команды процессора
"nop"   { return Parser::NOP; }
"daa"   { return Parser::DAA; }
"ldi"   { return Parser::LDI; }
"cpi"   { return Parser::CPI; }
"ini"   { return Parser::INI; }
"outi"  { return Parser::OUTI; }
"ldd"   { return Parser::LDD; }
"cpd"   { return Parser::CPD; }
"ind"   { return Parser::IND; }
"outd"  { return Parser::OUTD; }
"ldir"  { return Parser::LDIR; }
"cpir"  { return Parser::CPIR; }
"inir"  { return Parser::INIR; }
"otir"  { return Parser::OTIR; }
"lddr"  { return Parser::LDDR; }
"cpdr"  { return Parser::CPDR; }
"indr"  { return Parser::INDR; }
"otdr"  { return Parser::OTDR; }
"in"    { return Parser::IN; }
"out"   { return Parser::OUT; }
"halt"  { return Parser::HALT; }
"neg"   { return Parser::NEG; }

// Команды
"if"                 { return Parser::IF; }
"while"              { return Parser::WHILE; }
"do"                 { return Parser::DO; }
"swap"               { return Parser::EX; }
"push"               { return Parser::PUSH; }
"pop"                { return Parser::POP; }
"return"             { return Parser::RETURN; }
"noreturn"           { return Parser::NORETURN; }
"const"              { return Parser::CONST; }
"else"               { return Parser::ELSE; }
"goto"               { return Parser::GOTO; }
"rst"                { return Parser::RST; }
"continue"           { return Parser::CONTINUE; }
"break"              { return Parser::BREAK; }
"set_flag_c"         { return Parser::SCF; }
"invert_flag_c"      { return Parser::CCF; }
"ei"                 { return Parser::EI; }
"enable_interrupts"  { return Parser::EI; }
"enableInterrupts"   { return Parser::EI; }
"di"                 { return Parser::DI; }
"disable_interrupts" { return Parser::DI; }
"disableInterrupts"  { return Parser::DI; }
"invert"             { return Parser::INVERT; }
"asm"                { return Parser::ASM; }

// Регистры
"a"   { return Parser::REG_A; }
"a`"  { return Parser::REG_A; }
"b"   { return Parser::REG_B; }
"b`"  { return Parser::REG_B; }
"c"   { return Parser::REG_C; }
"c`"  { return Parser::REG_C; }
"d"   { return Parser::REG_D; }
"d`"  { return Parser::REG_D; }
"e"   { return Parser::REG_E; }
"e`"  { return Parser::REG_E; }
"h"   { return Parser::REG_H; }
"h`"  { return Parser::REG_H; }
"l"   { return Parser::REG_L; }
"l`"  { return Parser::REG_L; }
"ixl" { return Parser::REG_IXL; }
"ixh" { return Parser::REG_IXH; }
"iyl" { return Parser::REG_IYL; }
"iyh" { return Parser::REG_IYH; }
"bc`" { return Parser::REG_BC; }
"bc"  { return Parser::REG_BC; }
"de`" { return Parser::REG_DE; }
"de"  { return Parser::REG_DE; }
"hl`" { return Parser::REG_HL; }
"hl"  { return Parser::REG_HL; }
"ix"  { return Parser::REG_IX; }
"iy"  { return Parser::REG_IY; }
"sp"  { return Parser::REG_SP; }

// Числа и идентификаторы
[A-Za-z_][A-Za-z0-9_]* {
    std::string s = matched();
    if (preprocessor)
    {
        if (s == "counter") return Parser::M_COUNTER;
        if (s == "include") return Parser::M_INCLUDE;
        if (s == "org") return Parser::M_ORG;
        *d_val = s;
        return Parser::ID;
    }
    auto c = consts->find(s);
    if (c != consts->end())
    {
        const Const& co = c->second; // Без const значение в map уничтожается
        switch(co.type)
        {
            case Const::ctNumber:
                *d_val = co.n;
                return Parser::NUMBER;
                break;
            case Const::ctString:
                *d_val = co.s;                
                return Parser::CALC;
                break;
            default:
                throw "Unkown constant type";
        }
    }
    *d_val = s;
    return Parser::ID;
}

0x[0-9A-Fa-f]+ |
0b[01]+ |
[0-9]+ {
    std::string str = matched();
    const char* end = "";
    *d_val = std::strtoll(str.c_str(), (char**)&end, 0);
    if (*end != 0) throw "Incorrect number";
    return Parser::NUMBER;
}

// ******************** Operators ********************
"++" { return Parser::OP_INC; }
"--" { return Parser::OP_DEC; }
"+=" { return Parser::OP_SADD; }
"+@=" { return Parser::OP_SADC; }
"?" { return '?'; }
"-=" { return Parser::OP_SSUB; }
"-@=" { return Parser::OP_SSBC; }
"|=" { return Parser::OP_SOR; }
"&=" { return Parser::OP_SAND; }
"^=" { return Parser::OP_SXOR; }
"==" { return Parser::OP_EQ; }
"!=" { return Parser::OP_NE; }
"<=" { return Parser::OP_LE; }
">=" { return Parser::OP_GE; }
"<"  { return '<'; }
">"  { return '>'; }
"<<" { return Parser::OP_SHL; }
">>" { return Parser::OP_SHR; }
"||" { return Parser::OP_LOR; }
"&&" { return Parser::OP_LAND; }
"!"  { return '!'; }
";" { return ';'; }
"(" { return '('; }
")" { return ')'; }
"{" { return '{'; }
"}" { return '}'; }
"[" { return '['; }
"]" { return ']'; }
"=" { return '='; }
"*" { return '*'; }
"+" { return '+'; }
"-" { return '-'; }
"/" { return '/'; }
"~" { return '~'; }
"," { return ','; }
"&" { return '&'; }
"|" { return '|'; }
"^" { return '^'; }
"%" { return '%'; }
"#" { return '#'; }
"@" { return '@'; }
":" { return ':'; }

"<<=" { return Parser::OP_SSHL; }
">>=" { return Parser::OP_SSHR; }
"<<r=" { return Parser::OP_SROL; }
">>r=" { return Parser::OP_SROR; }
"<<@=" { return Parser::OP_SCSHL; }
">>@=" { return Parser::OP_SCSHR; }

// ******************** Comment ********************
\/\/.*$ {
    // Ignore single-line comment.
}

\/\* {
    more();
    begin(StartCondition_::COMMENT);
}
<COMMENT> {
    \*\/ {
        // Ignore multi-line comment.
        begin(StartCondition_::INITIAL);
    }
    
    .|\n {
        more();
    }
}


// ******************** Char ********************
\' {
    more();
    begin(StartCondition_::CHAR);
}
<CHAR> {
    \' {
        begin(StartCondition_::INITIAL);
        std::string s = matched();
        if (s.size() != 3) throw "Некорректная константа";
        *d_val = (long long int)(uint8_t)s[1];
        return Parser::NUMBER;
    }
    
    \\.|. {
        more();
    }
    
    \n {
        throw "Константа не закрыта по перевода строки";
    }
}


// ******************** String ********************
\" {
    more();
    begin(StartCondition_::STRING);
}
<STRING> {
    \" {
        begin(StartCondition_::INITIAL);
        std::string str = matched();

        if (str.size() >= 2)
        {
            char* s = (char*)str.data() + 1;
            char* se = (char*)str.data() + (str.size() - 1);
            char* d = (char*)str.data();
            while(s != se)
            {
                char c = *s++;
                if (c == '\\')
                {
                if (s == se) throw "Unterminated string";
                    c = *s++;
                    if (c == 'n') c = '\n';
                    else if(c == 'r') c = '\r';
                    else if(c == '\\') c = '\\';
                    else if(c == '\'') c = '\'';
                    else if(c == '"') c = '"';
                    else if(c == 'x')
                    {
                        if (s == se) throw "Unterminated string";
                        char c1 = *s++;
                        if (c1 >= '0' && c1 <= '9') c1 -= '0';
                        else if (c1 >= 'a' && c1 <= 'f') c1 -= 'a' - 10;
                        else if (c1 >= 'A' && c1 <= 'F') c1 -= 'A' - 10;
                        else throw "Unknown esc";
                        if (s == se) throw "Unterminated string";
                        char c2 = *s++;
                        if (c2>='0' && c2<='9') c2-='0';
                        else if (c2 >= 'a' && c2 <= 'f') c2 -= 'a' - 10;
                        else if (c2 >= 'A' && c2 <= 'F') c2 -= 'A' - 10;
                        else throw "Unknown esc";
                        c = (c1 << 4) + c2;
                    }
                    else
                    {
                        throw "Unknown esc";
                    }
                }
                *d++ = c;
            }
            str.resize(d - str.data());
        }
        *d_val = str;
        return Parser::STRING;
    }

    \\.|. {
        more();
    }
    
    \n {
        throw "Строка не закрыта по перевода строки";
    }
}

<<EOF>> { if(!unclude()) return 0; }
[ \t]+ {}
\n {
    onNextLine(lineNr(), getLine(lineNr()));
    if (preprocessor) return Parser::M_EOL;
}
. { throw "Некорректный символ"; }
