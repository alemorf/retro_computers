/*---------------------------------------------------------------------------
  VinLib  
  Парсер
 
  This Software is owned by Aleksey Morozov (vinxru) and is
  protected by copyright law and international copyright treaty.
 
  Copyright (C) 2007-2011 Aleksey Morozov <Aleksey.F.Morozov@gmail.com> 
---------------------------------------------------------------------------*/

#include <stdafx.h>
#include "c_parser.h"
#include <finlib/string.h>
#include <limits.h>
//#include <vinlib/type/dynobject.h>

string replace(cstring, cstring, cstring);

#pragma warning(disable:4996)

bool tryMulAddI(int& a, int b, int c) {
  __int64 x =__int64(a)*__int64(b);
  if(x < INT_MIN || x > INT_MAX) return false;
  x += c;
  if(x < INT_MIN || x > INT_MAX) return false;
  a = int(x);
  return true;
}

Parser::Parser() {
  functionHelp=0;
  noIdent=false;
  caseSel=false;
  macroOff=false;
  floatAsCurrency=false;
  numbersAsString=false;
  mysqlQuote=false;
  cescape=false;
  anyChar=false;
  ignoreFloat=false;
  //wordsInLower=false;
  token=ttEof;
  tokenText[0]=0;
  prevCursor=cursor=0;
  needEol=false;
  breakMode=false;
  dontUnquoteCEscape=false;
#ifndef NO_FUNCTION_ARGS
  functionHelpMode=false;
#endif
  words1=0;
  words2=0;
  operators=0;
  line=1;
  col=1;
  prevCol=1;
  prevLine=1;
  rem=0;
  brem=0;
  erem=0;
}

void Parser::loadFromString(const char_t* s, const char_t* _fileName, bool dontCallNextToken) {
  // Копирование в буфер
  source_  = s;
  fileName = _fileName;
  loadFromString_noBuf(source_.c_str(), dontCallNextToken);
}

void Parser::loadFromString_noBuf(const char_t* buf, bool dontCallNextToken) {
  // Переменные
  //fastLine=1;
  line=1;
  //fastCol=1;
  col=1;
  prevCursor=cursor=buf;
  breakDetail.clear();
  token=ttEof;   
  if(!dontCallNextToken) nextToken();
}

ParserLabel Parser::label() {
  ParserLabel label;
  label.col=prevCol;
  label.line=prevLine;
  label.cursor=prevCursor;
  label.breakMode=breakMode;
  return label;
}

//---------------------------------------------------------------------------
// Перейти на метку и установить breakMode

void Parser::jump(ParserLabel& label, bool dontLoadNextToken) {
  prevCursor = label.cursor;
  cursor     = label.cursor;
  line       = label.line;
  col        = label.col;
  breakMode  = label.breakMode;
  if(!dontLoadNextToken) nextToken();
}

//---------------------------------------------------------------------------

void Parser::syntaxError(int y, int x0, int x1, cstring str) {
  if(token==ttBreak) {
    int c=col;
    if(prevCol<col) c--;
    throw ParserBreakException(breakLine,line==breakLine && sigCol<breakCol 
        ? sigCol : breakCol, c, _T("Программная остановка"), _T("Программная остановка"));
  }

  string s=fileName+_T("(")+i2s(y)+_T(",")+i2s(x0)+_T("): ")+str;
  throw ParserLogicException(y,x0,x1,s.c_str(), str);
}

void Parser::syntaxError(cstring str) {
  if(prevCol>col) { line=prevLine, col=prevCol+1; }
  string s = fileName + _T("(") + i2s(prevLine) + _T(",") + i2s(prevCol) + _T("): ") + str + _T(" (") + tokenText + _T(")");
  int c=col;
  if(prevCol<col) c--;
  if(token==ttBreak) throw ParserBreakException(breakLine,line==breakLine && prevCol<breakCol ? prevCol : breakCol,c,(s+_T("Программная остановка")).c_str(), _T("Программная остановка"));
                else throw ParserSyntaxException(line,prevCol,c,s.c_str(), (string)_T("Синтаксическая ошибка, ")+tokenText);
}
  
string Parser::addr(int x0, int y) {
  string s;
  for(int i=macroStack.size()-1; i>=0; i--) {
    MacroStack& x = get(macroStack, i);
    s += x.fileName + _T("(") + i2s(x.pl.line) + _T(",") + i2s(x.pl.col) + _T(")");
  }    
  return s += fileName + _T("(") + i2s(y) + _T(",") + i2s(x0) + _T("): ");
}

void Parser::logicError_(int y, int x0, int x1, const char_t* str) {
  string s = addr(x0, y) + str;
  throw ParserLogicException(y,x0,x1,s.c_str(), str);
}

void Parser::logicError_(const char_t* str) {
  string s = addr(prevCol, line) + str;
  int c=col;
  if(prevCol<col) c--;
  throw ParserLogicException(line,prevCol,c,s.c_str(), str);
}

void Parser::error(cstring str) {
  string s = i2s(line) + _T(",") + i2s(col) + _T(": ") + str;
  int c=col;
  if(prevCol<col) c--;
  throw ParserException(line,prevCol,c,s.c_str(), str);
}

void Parser::nextToken() {
  // Точка останова
  if(functionHelpMode && breakMode && (line>breakLine || (line==breakLine && col>=breakCol))) {
    // Справка по функциям
#ifndef NO_FUNCTION_ARGS
    if(functionHelp) {
      string x = methodDescr(functionHelp->name, *functionHelp->args, false);
      if(functionHelp->help[0]!=0) x += _T("\n"), x += functionHelp->help; //! 3ий аргумент
      if(breakDetail.find(x)==0) breakDetail.push_back(x); 
      throw ParserBreakException(functionHelp->y,functionHelp->x,functionHelp->x,_T("Парсинг остановлен по условию"),_T("Парсинг остановлен по условию"));
    }
#endif
    throw ParserBreakException(line,col,col,_T("Парсинг остановлен по условию"),_T("Парсинг остановлен по условию"));
  }

  // Точка останова
  if(token==ttBreak) {
    if(breakCol-col==1 && 0==strcmpi(tokenText, _T("."))) 
      goto ignoreBreak;
    throw ParserBreakException(line,prevCol,col,_T("Парсинг остановлен по условию"),_T("Парсинг остановлен по условию"));
  }
ignoreBreak:

  // sig - это до пробелов
  sigCol=col-1;
  sigLine=line;

  do {
    for(;*cursor==32 || *cursor==13 || (!needEol && *cursor==10) || *cursor==9; cursor++)
      if(*cursor==10) { line++; col=1; } else
      if(*cursor!=13) col++;

    // Парсим
    tokenText[0]=0;

    // Пропускаем пробелы, обрабатываем выход из макроса
retry:
    // Пропускаем пробелы
    prevLine=line;
    prevCol =col;
    prevCursor=cursor;

    while(true) {
      char_t c=*cursor;    
      if(c==0) {
        if(macroStack.size()>0) { leaveMacro(); goto retry; }
        token=ttEof;
        return;
      }
      if(c!=' ' && c!=10 && c!=13 && c!=9) break;    
      cursor++;
      if(c==10) line++, col=1;
      if(needEol && c==10) {
        token=ttEol;          
        return;
      }
    }

    //
    const char_t* s=cursor;
    nextToken2();

    // Увеличиваем курсор
    for(;s<cursor;s++)
      if(*s==10) { line++; col=1; } else
      if(*s!=13) col++;

    while(!macroOff && preprocessor && token==ttOperator && tokenText[0]=='#') {
      Parser::ParserMacroOff md(*this);
      needToken("#");
      preprocessor();
      //goto retry2;
    }
  } while(!anyChar && (token==ttComment || token==ttLongComment || token==ttLongCommentEof));

  // Точка останова
  if(breakMode && !functionHelpMode && (line>breakLine || (line==breakLine && (token==ttEof || col>=breakCol)))) {
    if(token==ttEof) prevCol=col=breakCol;
    // Точка останова
    token=ttBreak;    
    return;
  }

  // Обработка макросов, только для C++
  if(token==ttWord  && !macroOff) {
    int i=0;
    for(std::list<Macro>::iterator m = macro.begin(); m != macro.end(); m++, i++) {
      if(!m->disabled && 0==_tcscmp(m->id.c_str(), tokenText)) {          
        nextToken();
        if(m->args.size()>0) {
          if(token!=ttOperator || 0!=_tcscmp(tokenText, _T("("))) syntaxError();            
          std::vector<std::string> noArgs;
          for(unsigned int j=0; j<m->args.size(); j++) {
            string out;
            readComment(out, j+1 < m->args.size() ? _T(",") : _T(")"));
            addMacro(m->args[j], out, noArgs);
          }
          prevCursor = cursor; prevLine = line; prevCol = col;
        }
        m->disabled = true;
        enterMacro(m->args.size(), 0, i, false);
        loadFromString_noBuf(m->body.c_str());
        return;
      }
    }
  }
}

int findx(const char_t** a, const string& s, int si) {
  for(int i=0; *a; a++, i++)
    if(0==_tcsncmp(*a, s.c_str(), si))
      return i;
  {for(int i=0; *a; a++, i++)
    if(*a==s)
      return i;}
  return -1;
}

bool Parser::waitComment(const char_t* erem, char_t combineLine) {
  const char_t* s=cursor;
  // Пропуск комментария
  char_t c=0;
  bool eof;
  while(true) {
    char_t c1=c;
    c=*cursor;
    if(c==0) { eof=true; break; } //syntaxError((string)T"Не найден конец комментария "+erem[j]);
  //  if(c==10) line++;
    cursor++;
    if(c==combineLine && cursor[0]=='\r') {
      cursor++;
      if(cursor[0]=='\n') cursor++;
      continue;
    }
    if(erem[1]==0) {
      if(c==erem[0]) { eof=false; break; }
    } else {
      if(c1==erem[0] && c==erem[1]) { eof=false; break; }
    }
  }
  // Увеличиваем курсор
  for(;s<cursor;s++)
    if(*s==10) { line++; col=1; } else
    if(*s!=13) col++;
  //
  return eof;
}

void Parser::leaveMacro() {
  MacroStack& m = get(macroStack, macroStack.size()-1);
  //cursor    =m.cursor;
  //prevCursor=m.prevCursor;
  //line      =m.line;
  //col       =m.col;
  //prevCol   =m.prevCol;
  //prevLine  =m.prevLine;
  fileName  =m.fileName;
  //sigCol    =m.sigCol;
  //sigLine   =m.sigLine;
  jump(m.pl, true);
  for(int i=0; i<m.killMacro; i++)
    macro.pop_back();
  if(m.disabledMacro!=-1) {
    //assert(macro[m.disabledMacro].disabled);
    get(macro, m.disabledMacro).disabled = false;
  }
  macroStack.pop_back();
};

void Parser::enterMacro(int killMacro, string* buf, int disabledMacro, bool dontCallNextToken) {
  MacroStack& m = add(macroStack);
  m.pl = label();
  m.disabledMacro = disabledMacro;
  //m.cursor    =cursor;
  //m.prevCursor=prevCursor;
  //m.line      =line;
  //m.col       =col;
  //m.prevCol   =prevCol;
  //m.prevLine  =prevLine;
  //m.sigCol    =sigCol;
  //m.sigLine   =sigLine;  
  m.killMacro =killMacro;
  m.fileName  = fileName;
  fileName = "DEFINE";
  if(buf) {
    m.buffer.swap(*buf);
    loadFromString_noBuf(m.buffer.c_str(), dontCallNextToken);          
  }
};

void Parser::nextToken2() {
  int tokenText_ptr=0;

  char_t c=*cursor++;

  if(!noIdent)
  if(c=='_' || (c>='a' && c<='z') || (c>='A' && c<='Z') || (c>=_T('а') && c<=_T('я')) || (c>=_T('А') && c<=_T('Я'))) {
    while(true) {
      if(tokenText_ptr==maxTokenText) error(_T("Слишком длинный идентификатор"));
      tokenText[tokenText_ptr++]=c;
      c=*cursor;
      if(!(c=='_' || (c>='0' && c<='9') || (c>='a' && c<='z') || (c>='A' && c<='Z') || (c>=_T('а') && c<=_T('я')) || (c>=_T('А') && c<=_T('Я')))) break;
      cursor++;
    }

    //if(wordsInLower)
//      for(int i=0; i<tokenText_ptr; i++) {
        //if(tokenText[i]>='A' && tokenText[i]<='Z') tokenText[i] -= 'A'-'a';
        //if(tokenText[i]>='А' && tokenText[i]<='Я') tokenText[i] -= 'А'-'а';
      //}
    tokenText[tokenText_ptr]=0;
    token=ttWord;
    return;
  }

  if(mysqlQuote && c=='`') {
    while(true) {
      c=*cursor;
      if(c==0) error(_T("Незавершенная строковая константа"));
      cursor++;
      if(c=='`') break;
      if(tokenText_ptr==maxTokenText) error(_T("Слишком длинная строковая константа"));
      tokenText[tokenText_ptr++]=c;
    }        
    tokenText[tokenText_ptr]=0;
    token=ttWord;
    return;
  }

  if(c=='\'' || c=='"') {
    char_t quoter=c;
    while(true) {
      c=*cursor;
      if(c==0 || c==10) error(_T("Незавершенная строковая константа"));
      cursor++; 
      if(!cescape) {
        if(c==quoter) {
          if(*cursor!=quoter) break;
          cursor++; 
        } else 
        if(c==quoter) break;
      } else {
        if(c=='\\') { 
          if(dontUnquoteCEscape) {
            if(tokenText_ptr==maxTokenText) error(_T("Слишком длинная строковая константа"));
            tokenText[tokenText_ptr++]=c;
            c=*cursor++;
            if(c==0)
              error(_T("Незавершенная строковая константа"));
          } else {
            c=*cursor++;
            if(c==0 || c==10) error(_T("Незавершенная строковая константа")); else
            if(c=='n') c='\n'; else
            if(c=='r') c='\r'; else
            if(c=='\\') c='\\'; else
            if(c=='\'') c='\''; else
            if(c=='"') c='"'; else
            if(c=='x') {
              char_t c1=*cursor++;
              if(c1==0 || c1==10) error(_T("Незавершенная строковая константа"));
              if(c1>='0' && c1<='9') c1-='0'; else
              if(c1>='a' && c1<='f') c1-='a'-10; else
              if(c1>='A' && c1<='F') c1-='A'-10; else
                error(_T("Неизвестная ESC-последовательность"));
              char_t c2=*cursor++;
              if(c2==0 || c2==10) error(_T("Незавершенная строковая константа"));
              if(c2>='0' && c2<='9') c2-='0'; else
              if(c2>='a' && c2<='f') c2-='a'-10; else
              if(c2>='A' && c2<='F') c2-='A'-10; else
                error(_T("Неизвестная ESC-последовательность"));
              c=(c1<<4)+c2;
            } else {
              error((string)_T("Неизвестная ESC-последовательность '")+c+_T("'"));
            }
          }
        } else 
        if(c==quoter) break;
      }
      if(tokenText_ptr==maxTokenText) error(_T("Слишком длинная строковая константа"));
      tokenText[tokenText_ptr++]=c;
    }        
    tokenText[tokenText_ptr]=0;
    token=quoter=='\'' ? ttString1 : ttString2;
    return;
  }

  if(c>='0' && c<='9') {
    //! Недоработано, но пусть будет
    if(numbersAsString) {
      int tokenText_ptr =0;
      while(true) {
        if(tokenText_ptr==maxTokenText) error(_T("Слишком длинная строковая константа"));
        tokenText[tokenText_ptr++]=c;
        c=*cursor;
        bool isGoodChar=(c>='A' && c<='F') || (c>='a' && c<='f') || (c=='x') || (c=='.') || (c>='0' && c<='9');
        if(!isGoodChar) break;
        cursor++; 
      }
      tokenText[tokenText_ptr]=0;      
      token=ttString1;
      return;
    }

    // Если число начинается с 0x - то читаем 16-ричное
    if(c=='0' && (cursor[0]=='x' || cursor[0]=='X')) {
      cursor++; // Пропускаем X
      int n=0;
      while(true) {        
        c=*cursor;      
        int e;
        if(c>='0' && c<='9') e=c-'0';    else
        if(c>='a' && c<='f') e=c-'a'+10; else
        if(c>='A' && c<='F') e=c-'A'+10; else break;
        if(!tryMulAddI(n,16,e)) syntaxError(_T("Слишком длинное число")); 
        cursor++;
      }
      tokenInteger=n;
      token=ttInteger;
      return;
    }
    // Читаем целое, плавающе и двоичное число 
    bool   canBits=(c=='0' || c=='1'); // Удалось посчитать Bits (нет переполнения, алфавит)
    bool   canInt =true; // Удалось посчитать Integer (нет переполнения)
    bool   canCurrency=true;
    bool   needFloat=false; 
    int    b=(c-'0');
    int    n=(c-'0');
    double fn=(c-'0');
//    Currency fc; fc.setInteger(n);
    while(true) {
      c=*cursor;
      if(c<'0' || c>'9') break;
      c-='0';
      if(canInt && !tryMulAddI(n,10,c)) canInt=false;      
//      if(canCurrency && !tryMulAdd64(fc.val,10,int(c)*10000)) canCurrency=false;      
      fn=fn*10 + c; // Плавающее
      canBits &= (c=='0' || c=='1');
      if(canBits) { if(b&0x80000000) canBits=false; else { b<<=2; if(c=='1') b|=1; } }
      cursor++;
    }
    // Здесь прочитано целое число (ну и дробное тоже)
    if(!ignoreFloat) {
      if(c=='.') {
        int di=0;
        double dx=0.1;
        while(true) {
          cursor++;
          c=*cursor;
          if(c<'0' || c>'9') break;
          // Расчет FLOAT 
          fn=fn+(c-'0')*dx;
          dx=dx/10;
          // Расчет CURRENCY
/*          if(canCurrency) {
            int v=(c-'0');
            if(di==0) v*=1000; else
            if(di==1) v*=100; else
            if(di==2) v*=10; else
            if(di==3) ; else canCurrency=false;
            if(!tryAdd64(fc.val, v)) canCurrency=false;
            di++;
          }*/
        }
        needFloat=true;
        canInt=false;
        canBits=false;
      }
      // Режим floatAsCurrency
/*      if(floatAsCurrency) {
        if(!canCurrency) error(_T("Это число не может быть CURRENCY"));
        tokenCurrency=fc;
        token=ttCurrency;
        return;
      }
      // Если идет постфикс C, то отправляем как CURRENCY
      if(c=='c' || c=='C') {
        if(!canCurrency) error(_T("Это число не может быть CURRENCY"));
        cursor++; // Пропускаем C
        tokenCurrency=fc;
        token=ttCurrency;
        return;
      }*/
      // Если идет постфикс E, то парсим дальше как FLOAT
      if(c=='e' || c=='E') {  
        cursor++; // Пропускаем E
        c=*cursor;
        bool neg=(c=='-');
        if(neg) { cursor++; c=*cursor; }
           else if(c=='+') { cursor++; c=*cursor; }
        if(c<'0' || c>'9') error(_T("Ожидается число"));
        int n=0;
        do {
          if(!tryMulAddI(n,10,c-'0')) canInt=false;      
          cursor++;
          c=*cursor;
        } while(c>='0' && c<='9');
        if(neg) n=-n; //!!!! Переполнение
        tokenFloat=fn*pow(10.0, double(n));
        token=ttFloat; // В режиме floatAsCurrency выполнение сюда дойти не должно
        return;
      }
      if(c=='b' || c=='B') { 
        if(!canBits) syntaxError(_T("Слишком длинное число"));
        cursor++; tokenInteger=b; token=ttInteger; return; 
      }
      if(needFloat) {
        tokenFloat=fn;
        token=ttFloat; // В режиме floatAsCurrency выполнение сюда дойти не должно
        return;
      }
    }
    if(!canInt) syntaxError(_T("Слишком длинное число"));
    tokenInteger=n; 
    token=ttInteger;    
    return;
  }
 
  // Одиночный символ
  token=ttOperator;
  tokenText[0]=c;
  tokenText[1]=0;

  // Составной оператор
  if(operators) {
    // Добавляем остальные символы
    tokenText_ptr=1;
    while(true) {
      c=*cursor;
      if(c==0) break;
      tokenText[tokenText_ptr]=c;
      tokenText[tokenText_ptr+1]=0;
      if(findx(operators, tokenText, tokenText_ptr+1)==-1) break;
      cursor++;
      tokenText_ptr++;
      if(tokenText_ptr==maxTokenText) error(_T("Слишком длинный оператор"));
    }
    tokenText[tokenText_ptr]=0;
  }
  // Комментарии
  if(brem) {
    for(int j=0; brem[j]; j++) 
      if(0==strcmpi(tokenText,brem[j])) {
        while(true) {
          char_t c1=c;
          c=*cursor;
          if(c==0) break;
         // if(c==10) line++;
          cursor++;
          if(erem[j][1]==0)
            { if(c==erem[j][0]) break; }
          else
            { if(c1==erem[j][0] && c==erem[j][1]) break; }
        }
        token=c==0 ? ttLongCommentEof : ttLongComment;
        return;
      }
  }
  // Комментарии
  if(rem)
    for(int j=0; rem[j]; j++)
      if(0==strcmpi(tokenText,rem[j])) {
        while(true) {
          c=*cursor;
          if(c==0 || c==10) break;
          cursor++;
        }
        token=ttComment;
        return;
     }
}

string Parser::readDirective() {
  int tokenText_ptr=0;
  char c=0,c1;
  const char* start = prevCursor;
  line = prevLine;
  col = prevCol;
  string tokenText;
  while(true) {    
    c1=c;
    c=*prevCursor;
    if(c==0) break;
    prevCursor++;
    if(c==13)  {
      if(c1=='\\') {
        line++;
        col=1;
        tokenText.append(start, prevCursor-start-2);
        start = prevCursor;
        continue;
      }
      break;
    }
    col++;
    //tokenText.str([tokenText_ptr++]=c;
  }
  tokenText.append(start, prevCursor-start);
  cursor = prevCursor;
  nextToken();
  return tokenText;
}

bool Parser::ifToken(const std::map<string,int>& hash, int& n) {
  auto vv = hash.find(tokenText);
  if(vv != hash.end()) {
    n = vv->second;
    nextToken();
    return true;
  }  
#ifndef NO_FUNCTION_ARGS
  if(!functionHelpMode)
#endif
    /*
  if(token==ttBreak && breakMode)
    for(int i=0; i<hash.size(); i++)
      if(breakDetail.find(hash.getStr(i))==0)
        breakDetail.push_back(hash.getStr(i));
        */
  return false;
}

bool Parser::ifToken(Token t) {
  if(token!=t) {
    if(token==ttBreak && breakMode) {
/*
      const char* s;
      switch(t) {
        case ttEof:      s=T"конец файла"; break;
        case ttEol:      s=T"конец строки"; break;
        case ttWord:     s=T"идентификатор"; break;
        case ttInteger:  s=T"число"; break;
        case ttOperator: s=T"оператор"; break;
        case ttString1:  s=T"'строка'"; break;
        case ttString2:  s=T"\"строка\""; break;
        default: s=T"<другой токен>";
      }
      if(breakDetail.find(s)==0)
        breakDetail.push_back(s);
*/
    }
    return false;
  }     
  if(token==ttOperator || token==ttWord || token==ttString1 || token==ttString2)
    _tcscpy_s(buf,sizeof(buf)/sizeof(char_t),tokenText);
  bufInt=tokenInteger;
//  bufCurrency=tokenCurrency;
  bufDbl=tokenFloat;
  nextToken();
  return true;
}

const char_t* Parser::needString2() {
  if(token!=ttString2) {
//    if(token==ttBreak && breakMode) {
//      string x=T"\"строка\"";
//      if(breakDetail.find(x)==0) breakDetail.push_back(x);
//    }
    syntaxError();
  }         
  _tcscpy_s(buf, sizeof(buf)/sizeof(char_t), tokenText);
  nextToken();
  return buf;
}

const char_t* Parser::needIdent() {
  if(token!=ttWord) {
//    if(token==ttBreak && breakMode)
//      if(breakDetail.find("идентификатор")==0) breakDetail.push_back(T"идентификатор");
    syntaxError();
  }         
  _tcscpy_s(buf, sizeof(buf)/sizeof(char_t), tokenText);
  nextToken();
  return buf;
}

bool Parser::checkToken(const char_t* t) {
  return (token==ttWord || token==ttOperator) && 0==strcmpi(tokenText,t);
}

bool Parser::checkToken(Token t) {
  return token==t;
}

bool Parser::ifToken(const char_t* t) {
  if(token==ttWord || token==ttOperator) {
    if(caseSel) {
      if(0==_tcscmp(tokenText,t)) { nextToken(); return true; }
    } else {
      if(0==strcmpi(tokenText,t)) { nextToken(); return true; }
    }    
  }
  if(token==ttBreak && breakMode) {
    // Отмена
    if(0==strcmpi(t,_T(".")) && cursor-prevCursor==1) {
      breakDetail.clear();
      token=ttWord;
      nextToken();
      return true;
    }
#ifndef NO_FUNCTION_ARGS
    if(!functionHelpMode)
#endif
      /*
    if(breakDetail.find(t)==0)
      breakDetail.push_back(t);
      */
  }
  return false;
}

bool Parser::ifToken(const char_t** strs, int& n) {
  for(int i=0; strs[i]!=0; i++)
    if(ifToken(strs[i])) {
      n=i;
      return true;
    }
  return false;
}

bool Parser::ifToken(const std::vector<std::string>& strs, int& o) {
  for(unsigned int i=0; i<strs.size(); i++)
    if(ifToken(strs[i].c_str())) {
      o=i;
      return true;
    }
  return false;
}

void Parser::enableBreak(ParserLabel& l) {
  bool  f=!(line>breakLine || (line==breakLine && col>=breakCol));
  breakMode=l.breakMode && f;
}

ParserLabel Parser::disableBreak() {
  ParserLabel l=label();
  l.breakMode=breakMode;
  bool b=breakMode;
  breakMode=false;
  if(token==ttBreak && b) {
    cursor=prevCursor;
    col=prevCol;
    line=prevLine;
    token=ttInteger;
    nextToken();
  }
  return l;
}

//---------------------------------------------------------------------------

void Parser::readComment(string& out, const char_t* term, bool cppEolDisabler) {
  const char_t* t=cursor;        
  waitComment(term, cppEolDisabler ? '\\' : 0);
  out.assign(t, cursor-t);
  if(cppEolDisabler)
    out = replace(_T("\\\r\n"),_T("\r\n"),out);
  int termLen=_tcslen(term);
  if(0==_tcscmp(out.c_str()+out.size()-termLen, term)) out.resize(out.size()-termLen);
}

//---------------------------------------------------------------------------
// Зарегистрировать макрос

void Parser::addMacro(cstring id, cstring body, const std::vector<string>& args) {
  Macro& m = add(macro);
  m.id   = id;
  m.body = body;
  m.args = args;
}

bool Parser::deleteMacro(cstring id) {  
  for(std::list<Macro>::iterator m = macro.begin(); m != macro.end(); m++) {
    if(m->id == id) {
      macro.erase(m);
      return true;
    }
  }
  return false;
}

void Parser::deleteMacro() {  
  macro.clear();
}

bool Parser::findMacro(cstring id) {  
  for(std::list<Macro>::iterator m = macro.begin(); m != macro.end(); m++) {
    if(m->id == id) {
      return true;
    }
  }
  return false;
}
