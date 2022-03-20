#pragma once

class Const {
public:
    enum ConstType { ctNumber, ctString };

    ConstType type;
    long long int n;
    std::string s;

    Const() : type(ctNumber), n(0) {};
    Const(const Const& c) : type(c.type), n(c.n), s(c.s) {};
    Const(long long int n) : type(ctNumber), n(n) {};
    Const(const std::string& s) : type(ctString), s(s) {};
    Const& operator = (const Const& c) { type=c.type; n=c.n; s=c.s; return *this; }
};
