#pragma once

#include "../i1080.h"

extern uint8_t stack __address(0x100);

void main();
void InterruptHandler();
void CpmWBoot();
void CpmConst();
void CpmConin();
void CpmConout();
void CpmList();
void CpmPunch();
void CpmReader();
void CpmSelDsk();
void CpmSetTrk();
void CpmSetSec();
void CpmRead();
void CpmWrite();
void CpmPrSta();

extern uint16_t entry_cpm_conout_address __address(EntryCpmConout + 1);

extern uint8_t cpm_dph_a __address(0xFF60);
extern uint8_t cpm_dph_b __address(0xFF70);
extern uint8_t cpm_dma_buffer __address(0xFF80);
