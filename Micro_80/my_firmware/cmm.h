#pragma once

#ifndef __CMM__

#include <stdint.h>
#include <assert.h>
#include <algorithm>

// languagea extensions

#define noreturn
#define __address(X)
#define asm(X)
#define push_pop(X...) for (bool _cmmExit = ({ push(X), true; }); _cmmExit; _cmmExit = false, pop(X))

// Flags

inline uint8_t _cmmFlags = 0;
inline bool _cmmI = false;

static constexpr uint8_t _CMM_FLAGS_S = 1 << 7;
static constexpr uint8_t _CMM_FLAGS_Z = 1 << 6;
static constexpr uint8_t _CMM_FLAGS_5 = 1 << 5;
static constexpr uint8_t _CMM_FLAGS_AC = 1 << 4;
static constexpr uint8_t _CMM_FLAGS_3 = 1 << 3;
static constexpr uint8_t _CMM_FLAGS_P = 1 << 2;
static constexpr uint8_t _CMM_FLAGS_1 = 1 << 1;
static constexpr uint8_t _CMM_FLAGS_C = 1 << 0;

template <uint8_t X, uint8_t Y>
class _CmmFlag {
public:
    operator bool() {
        return ((_cmmFlags & X) ^ Y) == 0;
    }
    bool operator()(...) {
        return ((_cmmFlags & X) ^ Y) == 0;
    }
};

inline _CmmFlag<_CMM_FLAGS_Z, 0> flag_nz;
inline _CmmFlag<_CMM_FLAGS_Z, _CMM_FLAGS_Z> flag_z;
inline _CmmFlag<_CMM_FLAGS_C, 0> flag_nc;
inline _CmmFlag<_CMM_FLAGS_C, _CMM_FLAGS_C> flag_c;
inline _CmmFlag<_CMM_FLAGS_P, 0> flag_po;
inline _CmmFlag<_CMM_FLAGS_P, _CMM_FLAGS_P> flag_pe;
inline _CmmFlag<_CMM_FLAGS_S, 0> flag_p;
inline _CmmFlag<_CMM_FLAGS_S, _CMM_FLAGS_S> flag_m;

// Registers

class Register8;
class RegisterA;
class Register16;
class RegisterHl;

extern RegisterA a;
extern Register8 b, c, d, e, h, l;
extern Register16 bc, de, sp;
extern RegisterHl hl;

class Register16 {
public:
    uint16_t value_ = 0;

    class Address {
    public:
        RegisterA& operator=(RegisterA& value);  // stax
    };

    Address address_;

    Address& operator*() {
        return address_;
    }
    Register16& operator=(int value) {
        value = value_;
        return *this;
    }  // lxi
    Register16& operator=(uint16_t value) {
        value = value_;
        return *this;
    }  // lxi
    template <class T>
    Register16& operator=(T* ptr) {
        assert(false);
        return *this;
    }  // lxi
    operator uint16_t() {
        return value_;
    }  // ldax
    void operator++() {
        value_++;
    }  // inx
    void operator--() {
        value_++;
    }  // dcx
    void operator++(int) {
        value_++;
    }  // inx
    void operator--(int) {
        value_++;
    }  // dcx
};

class RegisterHl : public Register16 {
public:
    class HlAddress {
    public:
        Register8& operator=(Register8& value);  // mov m, b/c/d/e/h/l/a
        uint8_t operator=(uint8_t value);        // mvi m, 1
    };

    HlAddress address_;

    RegisterHl& operator=(int value) {
        value = value_;
        return *this;
    }  // lxi
    RegisterHl& operator=(uint16_t value) {
        value = value_;
        return *this;
    }  // lxi
    template <class T>
    RegisterHl& operator=(T* ptr) {
        assert(false);
        return *this;
    }  // lxi
    HlAddress& operator*() {
        return address_;
    }
};

class Register8 {
public:
    uint8_t value_ = 0;

    class InResult {
    private:
        uint8_t port_ = 0;

    public:
        InResult(uint8_t port) {
            port_ = port;
        }
    };

public:
    Register8& operator=(uint8_t value) {
        value_ = value;
        return *this;
    }
    Register8& operator=(RegisterHl::HlAddress& value) {
        assert(false);
        return *this;
    }  // mov b/c/d/e/h/l, m
    Register8& operator=(InResult value) {
        assert(false);
        return *this;
    }

    operator uint8_t() {
        return value_;
    }

    Register8& operator++() {
        value_++;
        return *this;
    }
    Register8& operator--() {
        value_++;
        return *this;
    }
    Register8& operator++(int) {
        value_++;
        return *this;
    }
    Register8& operator--(int) {
        value_++;
        return *this;
    }
};

class RegisterA : public Register8 {
public:
    RegisterA& operator=(uint8_t value) {
        value_ = value;
        return *this;
    }
    RegisterA& operator=(Register16::Address& value) {
        assert(false);
        return *this;
    }  // ldax b,d
    RegisterA& operator=(RegisterHl::HlAddress& value) {
        assert(false);
        return *this;
    }  // mov a, m
    RegisterA& operator=(InResult value) {
        assert(false);
        return *this;
    }
};

inline RegisterA a;
inline Register8 b, c, d, e, h, l;
inline RegisterHl hl;
inline Register16 bc, de, sp;

RegisterA& Register16::Address::operator=(RegisterA& a) {  // *de = a, stax
    // TODO
    assert(false);
    return a;
}

Register8& RegisterHl::HlAddress::operator=(Register8& reg) {  // *hl = reg, mov m, b/c/d/e/h/l/a
    // TODO
    assert(false);
    return reg;
}

uint8_t RegisterHl::HlAddress::operator=(uint8_t value) {  // *hl = 1, mvi m, 1
    // TODO
    assert(false);
    return value;
}

static RegisterHl& operator+=(RegisterHl& x, Register16& y) {
    x.value_ += y.value_;
    return x;
}

static void push1(Register16& x) {
    sp--;
    sp--;
}

static void pop1(Register16& x) {
    sp++;
    sp++;
}

static bool operator>(RegisterA& x, uint8_t y) {
    return x.value_ > y;
}

static bool operator<(RegisterA& x, uint8_t y) {
    return x.value_ < y;
}

static bool operator>=(RegisterA& x, uint8_t y) {
    return x.value_ >= y;
}

static bool operator>=(RegisterA& x, char y) {
    return x.value_ >= uint8_t(y);
}

static bool operator>=(RegisterA& x, int y) {
    return x.value_ >= uint8_t(y);
}

static bool operator<=(RegisterA& x, uint8_t y) {
    return x.value_ <= y;
}

static bool operator==(RegisterA& x, Register8& y) {
    return x.value_ == y.value_;
}

static bool operator==(RegisterA& x, RegisterHl::HlAddress& y) {
    assert(false);
    return false;
}

static bool operator==(RegisterA& x, uint8_t y) {
    return x.value_ == y;
}

static bool operator==(RegisterA& x, char y) {
    return x.value_ == uint8_t(y);
}

static bool operator==(RegisterA& x, int y) {
    return x.value_ == uint8_t(y);
}

static bool operator!=(RegisterA& x, Register8& y) {
    return x.value_ != y.value_;
}

static bool operator!=(RegisterA& x, RegisterHl::HlAddress& y) {
    assert(false);
    return false;
}

static bool operator!=(RegisterA& x, uint8_t y) {
    return x.value_ != y;
}

static bool operator!=(RegisterA& x, char y) {
    return x.value_ != uint8_t(y);
}

static bool operator!=(RegisterA& x, int y) {
    return x.value_ != uint8_t(y);
}

static bool operator>(RegisterA& x, Register8& y) {
    return x.value_ > y.value_;
}

static bool operator<(RegisterA& x, Register8& y) {
    return x.value_ < y.value_;
}

static bool operator>=(RegisterA& x, Register8& y) {
    return x.value_ >= y.value_;
}

static bool operator<=(RegisterA& x, Register8& y) {
    return x.value_ <= y.value_;
}

static RegisterA& operator|=(RegisterA& x, Register8& y) {
    x.value_ |= y.value_;
    return x;
}

static RegisterA& operator|=(RegisterA& x, uint8_t y) {
    x.value_ |= y;
    return x;
}

static RegisterA& operator&=(RegisterA& x, Register8& y) {
    x.value_ &= y.value_;
    return x;
}

static RegisterA& operator&=(RegisterA& x, RegisterHl::HlAddress& y) {
    assert(false);
    return x;
}

static RegisterA& operator&=(RegisterA& x, uint8_t y) {
    x.value_ &= y;
    return x;
}

static RegisterA& operator^=(RegisterA& x, Register8& y) {
    x.value_ ^= y.value_;
    return x;
}

static RegisterA& operator^=(RegisterA& x, uint8_t y) {
    x.value_ ^= y;
    return x;
}

static RegisterA& operator+=(RegisterA& x, Register8& y) {
    x.value_ += y.value_;
    return x;
}

static Register8& operator+=(RegisterA& x, uint8_t y) {
    x.value_ += y;
    return x;
}

static Register8& operator-=(RegisterA& x, Register8& y) {
    x.value_ -= y.value_;
    return x;
}

static Register8& operator-=(RegisterA& x, uint8_t y) {
    x.value_ -= y;
    return x;
}

static void push1(RegisterA& x) {
    sp--;
    sp--;
}

static void pop1(RegisterA& x) {
    sp++;
    sp++;
}

static void disable_interrupts() {
    _cmmI = false;
}

static void DisableInterrupts() {
    disable_interrupts();
}

static void enable_interrupts() {
    _cmmI = true;
}

static void EnableInterrupts() {
    enable_interrupts();
}

static void swap(Register16& x, Register16& y) {
    assert((&x == &hl && &y == &de) || (&x == &de && &y == &hl));
    std::swap(a.value_, b.value_);
}

static void swap(Register16::Address& x, Register16& y) {
    assert(&x == &sp.address_ && &y == &de);
}

static void swap(Register16& x, Register16::Address& y) {
    assert(&x == &hl && &y == &sp.address_);
}

template <class X, class Y>
static void Swap(X& x, Y& y) {
    swap(x, y);
}

static void Out(uint8_t port, RegisterA& x) {
    assert(false);
}

static void out(uint8_t port, RegisterA& x) {
    Out(port, x);
}

static Register8::InResult In(uint8_t port) {
    return Register8::InResult(port);
}

static RegisterA& CyclicRotateRight(RegisterA& x, size_t count = 1) {
    x.value_ = (x.value_ >> (count % 8)) | (x.value_ << (8 - (count % 8)));
    return x;
}

static RegisterA& CyclicRotateLeft(RegisterA& x, size_t count = 1) {
    x.value_ = (x.value_ << (count % 8)) | (x.value_ >> (8 - (count % 8)));
    return x;
}

static RegisterA& CarryRotateRight(RegisterA& x, size_t count = 1) {
    assert(false);  // TODO
    return x;
}

static RegisterA& CarryRotateLeft(RegisterA& x, size_t count = 1) {
    assert(false);  // TODO
    return x;
}

static RegisterA& Invert(RegisterA& x) {
    x.value_ ^= 0xFF;
    return x;
}

static RegisterA& invert(RegisterA& x) {
    return Invert(x);
}

static void InvertFlagC() {
    _cmmFlags ^= _CMM_FLAGS_C;
}

static void invert_flag_c() {
    InvertFlagC();
}

static void Nop() {
}

static void nop() {
    Nop();
}

static void Halt() {
}

static void halt() {
    Nop();
}

static void GotoHl(...) {
    assert(false);
}

static void goto_hl(...) {
    GotoHl();
}

static RegisterA& Compare(RegisterA& x, uint8_t value) {
    uint8_t temp = x.value_ - value;
    assert(false);  // TODO
    return x;
}

static RegisterA& Compare(RegisterA& x, Register8& y) {
    uint8_t temp = x.value_ - y.value_;
    assert(false);  // TODO
    return x;
}

static RegisterA& Compare(RegisterA& x, RegisterHl::HlAddress& y) {
    assert(false);  // TODO
    return x;
}

inline static void SetFlagC() {
    _cmmFlags |= _CMM_FLAGS_C;
}

inline static void set_flag_c() {
    SetFlagC();
}

inline static void Rst(uint8_t value) {
    assert((value & 0x38) == 0x38);
    assert(false);
}

inline static void rst(uint8_t value) {
    Rst(value);
}

template <typename... T>
void push(T... registers) {
    (push1(registers), ...);
}

template <typename... T>
void pop(T... registers) {
    (pop1(registers), ...);  // TODO: Обратынй порядок
}

#endif
