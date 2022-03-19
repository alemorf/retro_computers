// ROM-диск Апогей БК01 на основе 49LF040/49LF020/49LF010
// (с) 5-12-2011 vinxru

#include <stdafx.h>
#include "vinlib/findfiles.h"
#include "vinlib/exception.h"
#include "vinlib/types.h"
#include "folders.h"
#include <algorithm>

#pragma warning(disable:4996)

bool operator < (FindData& a, FindData& b) {
  return 0>strcmpi(a.name.c_str(), b.name.c_str()); 
}

bool operator < (FindData& a, string name) {
  return 0>strcmpi(a.name.c_str(), name.c_str()); 
}

bool operator < (string name, FindData& b) {
  return 0>strcmpi(name.c_str(), b.name.c_str()); 
}

void Folders::find(cstring path, int parent) {
  Folder& folder = add(folders);

  int cf = folders.size()-1;

  if(parent!=-1) {
    FolderItem& entry = add(folder.items);
    entry.name = "..";
    entry.link = parent;
    entry.shortName = "..";    
  }
  
  std::vector<FindData> names;
  findFiles(names, path+"\\*");
  std::sort(names.begin(), names.end());
  for(uint i=0; i<names.size(); i++) {
    if(names[i].directory) {
      FolderItem& entry = add(folder.items);
      entry.link = folders.size();
      entry.shortName = names[i].name;
      find(path+"\\"+names[i].name, cf);
    }
  }
  for(uint i=0; i<names.size(); i++) {
    FindData& f = names[i];
    if(!f.directory) {
      if(f.name.size()>4 && 0==strcmpi(f.name.c_str()+f.name.size()-4, ".RKA")) {
        FolderItem& entry = add(folder.items);
        entry.name = path+"\\"+names[i].name;
        entry.shortName = f.name.substr(0, f.name.size()-4);
        entry.link = -1;
        bool x = binary_search(names.begin(), names.end(), f.name+".pak");
        entry.pak = x;
      }
    }
  }
}

//---------------------------------------------------------------------------
// Получить папку по номеру

Folders::Folder& Folders::getFolder(int n) {
  for(std::list<Folder>::iterator f=folders.begin(); f!=folders.end(); f++, n--) 
    if(n==0)
      return *f;
  raise("Ошибка в Folders::getFolder");
  throw;
}

