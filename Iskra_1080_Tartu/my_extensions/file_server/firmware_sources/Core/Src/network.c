/*
 * Iskra 1080 Tartu floppy interface
 * Copyright (c) 2023 Aleksey Morozov aleksey.f.morozov@gmail.com aleksey.f.morozov@yandex.ru
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include "network.h"
#include <stdint.h>
#include <stdbool.h>
#include <assert.h>
#include "dwt.h"
#include "my.h"

static const uint16_t NETWORK_CU3 = 1 << 8;   /* Connected to A8 */
static const uint16_t NETWORK_CU4 = 1 << 15;  /* Connected to A15 */
static const uint16_t NETWORK_CU2 = 1 << 12;  /* Connected to B12 */
static const uint16_t NETWORK_ID6_2 = 1 << 8; /* Connected to B8 */
static const uint16_t NETWORK_ID7_2 = 1 << 9; /* Connected to B9 */
static const uint16_t NETWORK_ADDRESS = 15;
static const uint32_t NETWORK_INVITATION_PERIOD_US = 1000;
static const uint32_t NETWORK_SEND_PERIOD_US = 50;
static const uint32_t NETWORK_TIMEOUT_US = 1000;
static const uint16_t NETWORK_GPIOB_INVERT = 0x00FF;

static inline bool NetworkWaitCu2Low() {
    static const uint32_t timeout = US_TO_DWT(NETWORK_TIMEOUT_US);
    const uint32_t start = DWT->CYCCNT;
    while ((GPIOB->IDR & NETWORK_CU2) != 0)
        if (DWT->CYCCNT - start > timeout)
            return false;
    return true;
}

static inline bool NetworkWaitCu2High() {
    static const uint32_t timeout = US_TO_DWT(NETWORK_TIMEOUT_US);
    const uint32_t start = DWT->CYCCNT;
    while ((GPIOB->IDR & NETWORK_CU2) == 0)
        if (DWT->CYCCNT - start > timeout)
            return false;
    return true;
}

static inline bool NetworkWaitCu3Low() {
    static const uint32_t timeout = US_TO_DWT(NETWORK_TIMEOUT_US);
    const uint32_t start = DWT->CYCCNT;
    while ((GPIOA->IDR & NETWORK_CU3) != 0)
        if (DWT->CYCCNT - start > timeout)
            return false;
    return true;
}

static inline bool NetworkWaitCu3High() {
    static const uint32_t timeout = US_TO_DWT(NETWORK_TIMEOUT_US);
    const uint32_t start = DWT->CYCCNT;
    while ((GPIOA->IDR & NETWORK_CU3) == 0)
        if (DWT->CYCCNT - start > timeout)
            return false;
    return true;
}

static inline bool NetworkWaitCu4Low() {
    static const uint32_t timeout = US_TO_DWT(NETWORK_TIMEOUT_US);
    const uint32_t start = DWT->CYCCNT;
    while ((GPIOA->IDR & NETWORK_CU4) != 0)
        if (DWT->CYCCNT - start > timeout)
            return false;
    return true;
}

static inline bool NetworkWaitCu4High() {
    static const uint32_t timeout = US_TO_DWT(NETWORK_TIMEOUT_US);
    const uint32_t start = DWT->CYCCNT;
    while ((GPIOA->IDR & NETWORK_CU4) == 0)
        if (DWT->CYCCNT - start > timeout)
            return false;
    return true;
}

static inline bool NetworkRecvByte(uint8_t *out_byte) {
    assert(out_byte != NULL);

    if (!NetworkWaitCu4Low())
        return false;
    *out_byte = (uint8_t)~GPIOA->IDR;
    return NetworkWaitCu4High();
}

static bool NetworkReceivePacket(void *packet, uint8_t max_packet_size) {
    assert(packet != NULL);
    assert(max_packet_size > 0u);

    uint8_t *const packet_bytes = packet;

    if (!NetworkRecvByte(packet_bytes)) /* Packet size with out CRC */
        return false;
    if (packet_bytes[0] == 0 || packet_bytes[0] > max_packet_size)
        return false;
    uint8_t i;
    for (i = 1u; i < packet_bytes[0]; i++)
        if (!NetworkRecvByte(&packet_bytes[i]))
            return false;
    // TODO: CRC
    return true;
}

static bool NetworkSendPacket(const void *packet) {
    assert(packet != NULL);    

    const uint8_t *const packet_bytes = packet;
    const uint8_t packet_size = packet_bytes[0];
    assert(packet_size > 0);
    uint8_t i;
    uint8_t checksum = 0;
    for (i = 0; i < packet_size; i++) {
        const uint8_t byte = packet_bytes[i];
        GPIOB->ODR = byte ^ NETWORK_GPIOB_INVERT;
        DWT_DELAY_US(NETWORK_SEND_PERIOD_US);
        GPIOB->ODR = (byte | NETWORK_ID7_2) ^ NETWORK_GPIOB_INVERT;
        DWT_DELAY_US(NETWORK_SEND_PERIOD_US); /* Client read */
        checksum ^= byte;
    }
    GPIOB->ODR = checksum ^ NETWORK_GPIOB_INVERT;
    DWT_DELAY_US(NETWORK_SEND_PERIOD_US);
    GPIOB->ODR = (checksum | NETWORK_ID7_2) ^ NETWORK_GPIOB_INVERT;
    DWT_DELAY_US(NETWORK_SEND_PERIOD_US); /* Client read */
    GPIOB->ODR = NETWORK_GPIOB_INVERT;

    return true;
}

void NetworkLoop() {
    for (;;) {
        /* Server sends an invitation */
        GPIOB->ODR = (NETWORK_ADDRESS | NETWORK_ID6_2 | NETWORK_ID7_2) ^ NETWORK_GPIOB_INVERT;
        DWT_DELAY_US(NETWORK_INVITATION_PERIOD_US);
        GPIOB->ODR = NETWORK_ADDRESS ^ NETWORK_GPIOB_INVERT;

        /* Сomputer responds */
        if (!NetworkWaitCu2Low())
            continue;
        if (!NetworkWaitCu2High()) {
            DebugOutput("Failed to receive CU2 high\r\n");
            continue;
        }

        iskra_read_write_packet_t packet;
        if (!NetworkReceivePacket(&packet, sizeof(packet))) {
            DebugOutput("Failed to receive packet\r\n");
            continue;
        }
        if (packet.header.from != ISKRA_PACKET_FROM_CLIENT) {
            DebugOutput("Failed to parse received packet, field \"from\" = %u\r\n", (unsigned)packet.header.from);
            continue;
        }
        if (packet.header.address != NETWORK_ADDRESS) {
            DebugOutput("Failed to parse received packet, field \"address\" = %u\r\n", (unsigned)packet.header.address);
            continue;
        }

        switch (packet.header.command_result) {
            case ISKRA_PACKET_COMMAND_WRITE:
                if (packet.header.packet_size != sizeof(iskra_read_write_packet_t)) {
                    DebugOutput("Failed to parse received packet, field \"packet_size\" = %u\r\n", (unsigned)packet.header.packet_size);
                    continue;
                }
                packet.header.command_result = NetworkProcessReadWrite(&packet);
                packet.header.packet_size = sizeof(iskra_packet_header_t);
                break;
            case ISKRA_PACKET_COMMAND_READ:
                if (packet.header.packet_size != sizeof(iskra_packet_header_t)) {
                    DebugOutput("Failed to parse received packet, field \"packet_size\" = %u\r\n", (unsigned)packet.header.packet_size);
                    continue;
                }
                packet.header.command_result = NetworkProcessReadWrite(&packet);
                packet.header.packet_size = sizeof(iskra_read_write_packet_t);
                break;
            default:
                DebugOutput("Failed to parse received packet, field \"command\" = %u\r\n",
                        (unsigned)packet.header.command_result);
                continue;
        }

        packet.header.from = ISKRA_PACKET_FROM_SERVER;
        if (!NetworkSendPacket(&packet))
            DebugOutput("Failed to send packet\r\n");
    }
}
