#include <stdafx.h>
#include "b.h"

std::vector<string> needFunctions;
std::map<string, int> needFunctionsIdx;

void needFunction(string name) {
  if(needFunctionsIdx.find(name) != needFunctionsIdx.end()) return;
  needFunctionsIdx[name] = 1;
  needFunctions.push_back(name);
}
