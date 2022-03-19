// ROM-диск Апогей БК01 на основе стандартных ПЗУ
// (с) 6-12-2011 vinxru

#include "vinlib/string.h"
#include <list>

class Folders {
public:
  struct FolderItem {
    string name, shortName;
    int link;
    bool pak;
  };

  struct Folder {
    int mapPtr;
    int intPtr;
    std::vector<FolderItem> items;
  };

  std::list<Folder> folders;

  void find(cstring path, int parent=-1);
  Folder& getFolder(int n);
};