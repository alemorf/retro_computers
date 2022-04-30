//! Добавить H числа
// PDP11 Assembler (c) 15-01-2015 vinxru

#include "stdafx.h"
#include "parser.h"
#include <stdio.h>
#include <string.h>
#include <stdexcept>

static std::string i2s(size_t i) {
  char buf[32];
  sprintf_s(buf, sizeof(buf), "%i", int(i)); // а х.з.
  return buf;
}

//-----------------------------------------------------------------------------

static int findx(const char** a, const char* s, size_t si) {
  for(int i=0; *a; a++, i++)
    if(0==strncmp(*a, s, si))
      return i;
  for(int i=0; *a; a++, i++)
    if(0==strcmp(*a, s))
      return i;
  return -1;
}

//-----------------------------------------------------------------------------

Parser::Parser() {
  cfg_caseSel=false;
  cfg_cescape=false;
  cfg_remark = 0;
  cfg_operators = 0;
  cfg_decimalnumbers = false;

  sigCursor = prevCursor = cursor = 0;
  sigLine = prevLine = line = 1;
  sigCol = prevCol = col = 1;

  token = ttEof;
  tokenNum = 0;
  tokenText[0] = 0;

  loadedNum = 0;
  loadedText[0] = 0;

  init("");
}

//-----------------------------------------------------------------------------

void Parser::getLabel(Label& label) {
  label.col = prevCol;
  label.line = prevLine;
  label.cursor = prevCursor;
}

//-----------------------------------------------------------------------------

void Parser::init(const char* buf) {
  line = col = 1;
  prevCursor = cursor = buf;
  token = ttEof;   
  altstring = 0;
  nextToken();
}

//-----------------------------------------------------------------------------

void Parser::nextToken() {
  // Сохраняем прошлый токен
  switch(token) {
    case ttWord:
    case ttString1:
    case ttString2:
      strcpy_s(loadedText, tokenText);
      break;
    case ttInteger:
      loadedNum = tokenNum;
  }

  // sig - это до пробелов
  sigCol=col-1;
  sigLine=line;
  sigCursor = cursor;

  do {
    for(;*cursor==32 || *cursor==13 || (!cfg_eol && *cursor==10) || *cursor==9; cursor++)
      if(*cursor==10) { line++; col=1; } else
      if(*cursor!=13) col++;

    // Парсим
    tokenText[0]=0;

    // Пропускаем пробелы
    prevLine=line;
    prevCol =col;
    prevCursor=cursor;

    for(;;) {
      char c=*cursor;    
      if(c==0) {
        token=ttEof;
        return;
      }
      if(c!=' ' && c!=10 && c!=13 && c!=9) break;    
      cursor++;
      if(c==10) line++, col=1;
      if(cfg_eol && c==10) {
        token=ttEol;          
        return;
      }
    }

    //
    const char* s=cursor;
    nextToken2();

    // Увеличиваем курсор
    for(;s<cursor;s++)
      if(*s==10) { line++; col=1; } else
      if(*s!=13) col++;
  } while(token==ttComment);
}

//-----------------------------------------------------------------------------

bool Parser::ifToken(const char* t) {
  if(token==ttWord || token==ttOperator) { 
    if(cfg_caseSel) {
      if(0 == strcmp(tokenText, t)) { nextToken(); return true; }
    } else {
      if(0 == _strcmpi(tokenText, t)) { nextToken(); return true; }
    }    
  }
  return false;
}

//-----------------------------------------------------------------------------

void Parser::nextToken2() {
  size_t tokenText_ptr = 0;
  tokenText[0] = 0; //! important

  char c=*cursor++;

  if(c=='_' || (c>='a' && c<='z') || (c>='A' && c<='Z')) {
    for(;;) {
      if(tokenText_ptr == maxTokenText) syntaxError("Too large word");
      tokenText[tokenText_ptr++]=c;
      c = *cursor;
      if(!(c=='_' || (c>='0' && c<='9') || (c>='a' && c<='z') || (c>='A' && c<='Z'))) break;
      cursor++;
    }
    tokenText[tokenText_ptr]=0;
    token=ttWord;

    if(!cfg_caseSel)
      for(char* p = tokenText, *pe = tokenText + tokenText_ptr; p < pe; p++)
        *p = (char)toupper(*p);
    return;
  }

  if(c=='\'' || c=='"' || c==altstring) {
    char quoter=c;
    for(;;) {
      c=*cursor;
      if(c==0 || c==10 || c==13) syntaxError("Unterminated string");
      cursor++; 
      if(!cfg_cescape) {
        if(c==quoter) {
          if(*cursor!=quoter) break;
          cursor++; 
        } else 
        if(c==quoter) break;
      } else {
        if(c=='\\') { 
          c=*cursor++;
          if(c==0 || c==10) syntaxError("Unterminated string"); else
          if(c=='n') c='\n'; else
          if(c=='r') c='\r'; else
          if(c=='\\') c='\\'; else
          if(c=='\'') c='\''; else
          if(c=='"') c='"'; else
          if(c=='x') {
            char c1=*cursor++;
            if(c1==0 || c1==10) syntaxError("Unterminated string");
            if(c1>='0' && c1<='9') c1-='0'; else
            if(c1>='a' && c1<='f') c1-='a'-10; else
            if(c1>='A' && c1<='F') c1-='A'-10; else
              syntaxError("Unknown esc");
            char c2=*cursor++;
            if(c2==0 || c2==10) syntaxError("Unterminated string");
            if(c2>='0' && c2<='9') c2-='0'; else
            if(c2>='a' && c2<='f') c2-='a'-10; else
            if(c2>='A' && c2<='F') c2-='A'-10; else
              syntaxError("Unknown esc");
            c=(c1<<4)+c2;
          } else {
            syntaxError("Unknown esc");
          }
        } else 
        if(c==quoter) break;
      }
      if(tokenText_ptr==maxTokenText) syntaxError("Too large string");
      tokenText[tokenText_ptr++]=c;
    }        
    tokenText[tokenText_ptr]=0;
    token=quoter=='\'' ? ttString1 : ttString2;
    return;
  }

  if(c>='0' && c<='9') {
    int radix = 0;
    bool neg = (c=='-');
    if(neg) c = *cursor++;

    // Если число начинается с 0x - то читаем 16-ричное    
    if(c=='0' && radix==0) {
      if(cursor[0]=='x' || cursor[0]=='X') {
        cursor+=2; // Пропускаем X
        radix = 16;
      } else {
        // Если число начинается с 0 - то читаем 8-ричное    
        radix = 8;
      }
    }

    // Ищем конец числа и определяем возможныцй тип
    bool cb=true, co=true, cd=true;
    cursor--;
    const char* e = cursor; 
    for(;;) {
      c = *e;
      if(!((c>='0' && c<='9') || (c>='A' && c<='F') || (c>='a' && c<='f'))) break;
      e++;
      if(c=='0' || c=='1') continue; cb = false;
      if(c>='0' && c<='7') continue; co = false;
      if(c>='0' && c<='9') continue; cd = false;
    }

    // Постфикс определяет тип числа    
    const char* pe = e;    
    switch(c) {
      case 'b': case 'B': if(radix==16) syntaxError("Incorrect number"); radix = 2; pe++; break;
      case 'o': case 'O': if(radix==16) syntaxError("Incorrect number"); radix = 8; pe++; break;
      case 'h': case 'H': if(radix==16) syntaxError("Incorrect number"); radix = 16; pe++; break;
      case '.':           if(radix==16) syntaxError("Incorrect number"); radix = 10; pe++; break;
      default: if(radix==0) radix = cfg_decimalnumbers ? 10 : 8;
    }

    // Контроль
    switch(radix) {
      case 2: if(!cb) syntaxError("Incorrect number");
      case 8: if(!co) syntaxError("Incorrect number");
      case 10: if(!cd) syntaxError("Incorrect number");
    }

    // Преобразуем
    num_t n = 0;
    for(;cursor < e; cursor++) {
      c = *cursor;      
      n *= radix;
      if(c>='a' && c<='f') n+=(c-'a'+10); else
      if(c>='A' && c<='F') n+=(c-'A'+10); else n+=(c-'0');
    }
    cursor = pe;
    token = ttInteger;
    if(neg) n = 0-n;
    tokenNum = n; 
    return;
  }
 
  // Одиночный символ
  token = ttOperator;
  tokenText[0] = c;
  tokenText[1] = 0;

  // Составной оператор
  if(cfg_operators) {
    // Добавляем остальные символы
    tokenText_ptr = 1;
    for(;;) {
      c = *cursor;
      if(c==0) break;
      tokenText[tokenText_ptr] = c;
      tokenText[tokenText_ptr+1] = 0;
      if(findx(cfg_operators, tokenText, tokenText_ptr+1)==-1) break;
      cursor++;
      tokenText_ptr++;
      if(tokenText_ptr==maxTokenText) syntaxError("Too large operator");
    }
    tokenText[tokenText_ptr]=0;
  }
  // Комментарии
  if(cfg_remark) {
    for(int j=0; cfg_remark[j]; j++) {
      if(0==strcmp(tokenText,cfg_remark[j])) {
        for(;;) {
          c=*cursor;
          if(c==0 || c==10) break;
          cursor++;
        }
        token=ttComment;
        return;
      }
    }
  }
}

//-----------------------------------------------------------------------------

void Parser::syntaxError(const char* text) {    
  throw std::runtime_error((fileName + "(" + i2s(prevLine) + "," + i2s(prevCol) + "): " + (text ? text : "Syntax error")).c_str());
}

//-----------------------------------------------------------------------------

void Parser::jump(Label& label) {
  sigCursor = cursor = prevCursor = label.cursor;
  sigLine = prevLine = line = label.line;
  sigCol = prevCol = col = label.col;
  nextToken();
}

//-----------------------------------------------------------------------------

bool Parser::ifToken(const char** a, int& n) {
  for(const char** i = a; *i; i++) {
    if(ifToken(*i)) {
      n = i - a;
      return true;
    }
  }
  return false;
}
