#pragma once

#include <finlib/string.h>

enum CBaseType { cbtError, cbtVoid, cbtChar, cbtShort, cbtLong, cbtUChar, cbtUShort, cbtULong, cbtStruct, 
  cbtFlags
};

class CType {
public:
  CBaseType baseType;
  int addr, i, arr, arr2, arr3;
  //Place place;
  string needInclude;

  bool operator == (CType a) const {
    return baseType==a.baseType && addr==a.addr && i==a.i 
      && arr==a.arr && arr2==a.arr2 && arr3==a.arr3;
  }

  inline CType() { arr=arr2=arr3=addr=0; }
  inline CType(CBaseType _baseType) { arr=arr2=arr3=addr=0; baseType=_baseType; }
  string descr();
  int size();
  int size1();
  int sizeElement();

  bool isVoid() { return baseType==cbtVoid && addr==0; }
  bool isStackType() { return baseType==cbtChar || baseType==cbtUChar || baseType==cbtUShort || baseType==cbtShort || addr!=0; }
  bool is16() { return baseType==cbtUShort || baseType==cbtShort || addr!=0; }
  bool is8() { return (baseType==cbtChar || baseType==cbtUChar) && addr==0; }

  int getSize() {
    if(is8()) return 8;
    if(is16()) return 16;
    return 0;
  }
};
