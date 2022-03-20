/*---------------------------------------------------------------------------
  VinLib  
  Парсер
 
  This Software is owned by Aleksey Morozov (vinxru) and is
  protected by copyright law and international copyright treaty.
 
  Copyright (C) 2007-2011 Aleksey Morozov <Aleksey.F.Morozov@gmail.com> 
---------------------------------------------------------------------------*/

#ifndef VINLIB_PARSER_H
#define VINLIB_PARSER_H

#include <finlib/std.h>
#include <map>
#include <functional>

//#include <finlib/type/currency.h>

//#ifndef NO_FUNCTION_ARGS
//#include <finlib/type/variantclass.h>
//#include <vinlib/type_variant.h>
//#endif

//---------------------------------------------------------------------------

class FunctionHelp;

class ParserException : public Exception {
public:
  string str1;
  int line, scol, ecol;
  inline ParserException(int _line, int _scol, int _ecol, const char_t* str, cstring _str1) : Exception(str) { str1=_str1; line=_line; scol=_scol; ecol=_ecol; };
};

class ParserBreakException : public ParserException {
public:
  inline ParserBreakException(int line, int scol, int ecol, const char_t* str, cstring str1) : ParserException(line,scol,ecol,str,str1) { }
};

class ParserLogicException : public ParserException {
public:
  inline ParserLogicException(int line, int scol, int ecol, const char_t* str, cstring str1) : ParserException(line,scol,ecol,str,str1) {}
};

class ParserSyntaxException : public ParserException {
public:
  inline ParserSyntaxException(int line, int scol, int ecol, const char_t* str, cstring str1) : ParserException(line,scol,ecol,str,str1) {}
};

//---------------------------------------------------------------------------

enum Token {
  ttEof, ttEol, ttWord, ttInteger, ttOperator, ttWords1, 
  ttString1, ttString2, ttWords2, ttWords3, ttBreak, ttFloat,
  ttComment, ttLongComment, ttLongCommentEof, ttCurrency
};

const int maxTokenText=256;

struct ParserLabel {
  const char_t* cursor;
  int line,col;
  bool breakMode;
};

class Parser {
protected:
 
  void nextToken2();
  void error(cstring text);
  void leaveMacro();

  struct Macro {
    string id, body;
    bool disabled;
    std::vector<std::string> args;

    Macro() { disabled=false; }
  };

  std::list<Macro> macro;
  

public:    
  FunctionHelp* functionHelp;
  // Настройки
  string fileName;
  bool anyChar;
  bool floatAsCurrency;
  bool numbersAsString;
  bool noIdent;
  bool caseSel;
  bool dontUnquoteCEscape;
  bool cescape; // \ - последовательности
  bool mysqlQuote; // Идентификаторы в `
  bool ignoreFloat;
  bool needEol;
  bool functionHelpMode;
  bool breakMode;
  const char_t** words1;
  const char_t** words2;
  const char_t** operators;
  const char_t** rem;
  const char_t** brem;
  const char_t** erem;
  int breakCol;
  int breakLine;

  // Результат
  char_t tokenText[maxTokenText+1];
  char_t buf[maxTokenText+1];
  int bufInt;
//  Currency bufCurrency;
  double bufDbl;
  Token token;
  std::vector<std::string> breakDetail;
  double tokenFloat;
//  Currency tokenCurrency;
  int  tokenInteger;

  // Буфер для loadFromString
  string source_;

  // Исходник
  const char_t* cursor, *prevCursor;
  int line;
  int col;
  int prevCol;
  int prevLine;
  int sigCol;
  int sigLine;

  struct MacroStack {
    const char_t* cursor, *prevCursor;
    ParserLabel pl;
    //int line;
    //int col;
    //int prevCol;
    //int prevLine;
    //int sigCol;
    //int sigLine;
    int killMacro;
    string fileName;
    string buffer;
    int disabledMacro;

    MacroStack() { disabledMacro=-1; }
  };

  std::list<MacroStack> macroStack;
  bool macroOff;

  class ParserMacroOff {
  public:
    Parser& p;
    bool oldMacroOff;
    ParserMacroOff(Parser& _p) : p(_p) { oldMacroOff=p.macroOff; p.macroOff=true; }
    ~ParserMacroOff() { p.macroOff=oldMacroOff; }
  };

  // Заполняется только breakCol breakLine

  std::function<void()> preprocessor;

  Parser();
  string addr(int,int);
  void addMacro(cstring id, cstring body, const std::vector<std::string>& args);
  void loadFromString(const char_t* s, const char_t* fileName=_T(""), bool dontCallNextToken=false);
  void loadFromString_noBuf(const char_t* s, bool dontCallNextToken=false);
  void jump(ParserLabel&, bool dontLoadNextToken=false);
  ParserLabel label();
  bool ifToken(Token token);
  bool ifToken(const char_t* str);
  bool ifToken(const char_t** str, int& n);
  bool ifToken(const std::vector<std::string>& strs, int& n);
  bool ifToken(const std::map<string,int>& hash, int& n);
  bool ifToken_pos(const std::map<string,int>& hash, int& n);  
  void syntaxError(cstring str=_T("Синтаксическая ошибка"));
  void enterMacro(int killMacro, string* buffer, int disabledMacro, bool dontCallNextToken);
  void syntaxError(int y, int x0, int x1, cstring str=_T("Синтаксическая ошибка"));
  void logicError_(const char_t* str=_T(""));
  void logicError_(cstring str) { logicError_(str.c_str()); }
  void logicError_(int y, int x0, int x1, const char_t* str=_T(""));
  void logicError_(int y, int x0, int x1, cstring str){ logicError_(y,x0,x1,str.c_str()); }
  bool waitComment(const char_t* erem, char_t combineLine=0);
  bool checkToken(const char_t* t);
  bool checkToken(Token t);
  void readComment(string& out, const char_t* term, bool cppEolDisabler=false);
  bool deleteMacro(cstring id);
  void deleteMacro();
  bool findMacro(cstring id);

  ParserLabel disableBreak();

  const char_t* needString2();
  void nextToken();
  const char_t* needIdent();  
  void enableBreak(ParserLabel& l);
  string readDirective();

  inline void needToken(Token token) {
    if(!ifToken(token)) syntaxError();
  }
  inline int needToken(const std::map<string, int>& hash) {
    int n;
    if(!ifToken(hash,n)) syntaxError();
    return n;
  }  
  inline void needToken(const std::vector<std::string>& strs, int& n) {
    if(!ifToken(strs, n)) syntaxError();
  }
  inline int needToken(const std::vector<string>& strs) {
    int tmp;
    if(!ifToken(strs, tmp)) syntaxError();
    return tmp;
  }
  inline void needToken(const char_t** strs, int& n) {
    if(!ifToken(strs, n)) syntaxError();
  }
  inline void needToken(const char_t* str) {
    if(!ifToken(str)) syntaxError();
  }
  inline void needToken(cstring str) {
    if(!ifToken(str)) syntaxError();
  }
  inline void needToken(Token t1, Token t2, const char_t* t3) {
    if(ifToken(t1)) return;
    if(ifToken(t2)) return;
    if(ifToken(t3)) return;
    syntaxError();
  }
  inline bool ifToken(Token t1, Token t2, const char_t* t3) {
    if(ifToken(t1)) return true;
    if(ifToken(t2)) return true;
    if(ifToken(t3)) return true;
    return false;
  }
  inline int needInteger() {
    if(token!=ttInteger) syntaxError();
    int i=tokenInteger;
    nextToken();
    return i;
  }
  inline double needFloat() {
    if(token!=ttFloat) syntaxError();
    double i=tokenFloat;
    nextToken();
    return i;
  }
  inline string needString1() {
    if(token!=ttString1) syntaxError();
    string s=tokenText;
    nextToken();
    return s;
  }
  inline bool ifInteger(int& i) {
    if(token!=ttInteger) return false;
    i=tokenInteger;
    nextToken();
    return true;
  }
/*  inline bool ifCurrency(Currency& c) {
    if(token!=ttCurrency) return false;
    c=tokenCurrency;
    nextToken();
    return true;
  }*/
  inline bool ifFloat(double& i) {
    if(token!=ttFloat) return false;
    i=tokenFloat;
    nextToken();
    return true;
  }
  inline bool ifString1(string& s) {
    if(token!=ttString1) return false;
    s=tokenText;
    nextToken();
    return true;
  }
  inline bool ifString2(string& s) {
    if(token!=ttString2) return false;
    s=tokenText;
    nextToken();
    return true;
  }
  inline bool ifIdent(string& s) {
    if(token!=ttWord) return false;
    s=tokenText;
    nextToken();
    return true;
  }
  bool ifToken(cstring str) 
    { return ifToken(str.c_str()); }
//  void loadFromFile(cstring fileName) 
//    { loadFromFile(fileName.c_str()); }
//  void loadFromString(cstring str, cstring fileName=_T("?"), bool x=false)
//    { loadFromString(str.c_str(), fileName.c_str(), x); }
};

#ifndef NO_FUNCTION_ARGS
class FunctionHelp {
public:
  FunctionHelp* oldFunctionHelp;
  Parser* p;
  int x, y;
  const char_t* name;
  const vector<VariantArg>* args;
  const char_t* help;

  inline FunctionHelp(Parser& _p, int _x, int _y, const char_t* _name, const vector<VariantArg>& _args, const char_t* _help) {
    p=&_p, x=_x, y=_y, name=_name, args=&_args, help=_help;
    oldFunctionHelp = p->functionHelp;
    p->functionHelp = this;
  }

  inline ~FunctionHelp() {
    p->functionHelp = oldFunctionHelp;
  }
};
#endif

class ParserLogicError {
public:
  int startLine, startCol, a, b, c;
  bool fixed;
  Parser& p;

  inline ParserLogicError(Parser& _p) : p(_p) { 
    a = b = c = 0; // Делаем CppCheck счастливым
    startLine = p.prevLine;
    startCol = p.prevCol; 
    fixed = false; 
  }

  inline void fix() {
    fixed = true;
    if(startLine != p.sigLine) startCol = 0;
    a = p.sigLine; b = startCol; c = p.sigCol;
  }

  inline void go(cstring str) {
    if(!fixed) fix(); 
    p.logicError_(a,b,c,str); 
  }
};

#endif