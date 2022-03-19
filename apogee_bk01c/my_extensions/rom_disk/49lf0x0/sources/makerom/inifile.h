// ROM-диск Апогей БК01 на основе 49LF040/49LF020/49LF010
// (с) 5-12-2011 vinxru

class IniFile {
protected:
  virtual void setDefault();
  virtual void loadParam(const char* n, const char* v) = 0;
public:  
  IniFile();
  void load(const char* fileName);
  ~IniFile();
};
