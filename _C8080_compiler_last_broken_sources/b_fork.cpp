#include <stdafx.h>
#include "b.h"

int deepLimit;
int cmdLimit;

class SetDeepLimit1 {
public:
  int old_deepLimit;
  int old_cmdLimit;

  inline SetDeepLimit1() { 
    old_deepLimit=deepLimit; 
    old_cmdLimit=cmdLimit; 
    if(deepLimit>0) {
      deepLimit--;
    } else {
      deepLimit = 5;  //!
      cmdLimit = 3;  //!
    }
  }
  inline ~SetDeepLimit1() { 
    deepLimit=old_deepLimit; 
    cmdLimit = old_cmdLimit;
  }
};


bool fork(int n, const std::function<bool(int)>& variant) {
#ifndef DISABLE_FORK
  if(deepLimit != 0) {
    int bi=-1, br=INT_MAX;  
    SaveState ss;
    for(int i=0; i<n; i++)  {
      SetDeepLimit1 sdl;      
      if(variant(i)) {
        if(out.t < br && out.incorrectFork==0) {
          bi = i;
          br = out.t;
        }
      } else {
        int y=1;
      }
      ss.restore();
    }
    if(bi==-1) return false;      

    if(variant(bi)) return true;

    // Мы могли не добраться до обрыва!    
/*    for(int i=n-1; i>=0; i--) {
      ss.restore();
      if(variant(i))
        return true;
    }*/

    return false;

  }  
#endif
  return variant(n-1);
}
