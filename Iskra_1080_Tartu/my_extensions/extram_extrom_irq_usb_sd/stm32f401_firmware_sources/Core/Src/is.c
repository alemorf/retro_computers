#include <stdint.h>
#include <stdbool.h>
#include "is_protocol.h"
#include "main.h"
#include "array_size.h"
#include "commands.h"

/* Configuration */

#define IS_PORT_INPUT (GPIOA->IDR)
#define IS_PORT_OUTPUT(X) do { GPIOB->BSRR = 0xFF << 16; GPIOB->BSRR = (X); } while(false)
#define IS_PIN_A0 (GPIOB->IDR & GPIO_PIN_8)
#define IS_RD_IRQ_HANDLER EXTI9_5_IRQHandler
#define IS_RD_IRQ GPIO_PIN_8
#define IS_WR_IRQ_HANDLER EXTI15_10_IRQHandler
#define IS_WR_IRQ GPIO_PIN_15

/* State */

static volatile uint8_t is_result;
static volatile union IsRx is_rx;
static volatile union IsTx is_tx;
static volatile uint8_t* is_tx_ptr = is_tx.bytes;
static volatile size_t is_tx_remain;
static volatile size_t is_rx_ptr;
static volatile size_t is_rx_size;

/* Iskra -> STM */

void IS_RD_IRQ_HANDLER() {
    if (!__HAL_GPIO_EXTI_GET_IT(IS_RD_IRQ))
        return;
    __HAL_GPIO_EXTI_CLEAR_IT(IS_RD_IRQ);
    const uint8_t byte = IS_PORT_INPUT;
    if (is_result != IS_ERROR_BUSY) {
        if (IS_PIN_A0) {
            if (byte > sizeof(is_rx) - 1) {
                is_result = IS_ERROR_SIZE;
            } else {
                is_rx_size = byte + 1;
                is_rx_ptr = 0;
                is_result = IS_ERROR_RX;
            }
        } else {
            size_t ptr = is_rx_ptr;
            if (ptr < is_rx_size) {
                is_rx.bytes[ptr] = byte;
                ptr++;
                is_rx_ptr = ptr;
                if (ptr == is_rx_size)
                    is_result = IS_ERROR_BUSY;
            }
        }
    }
}

/* STM -> Iskra */

void IS_WR_IRQ_HANDLER() {
    if (IS_PIN_A0) {
        IS_PORT_OUTPUT(is_result);
        if (!__HAL_GPIO_EXTI_GET_IT(IS_WR_IRQ))
            return;
    } else {
        IS_PORT_OUTPUT(*is_tx_ptr);
        if (!__HAL_GPIO_EXTI_GET_IT(IS_WR_IRQ))
            return;
        if (is_tx_remain > 0) {
            is_tx_remain--;
            is_tx_ptr++;
        }
    }
    __HAL_GPIO_EXTI_CLEAR_IT(IS_WR_IRQ);
}

static void IsDone(uint8_t result, size_t tx_size) {
    is_tx_ptr = is_tx.bytes;
    is_tx_remain = tx_size == 0 ? 0 : tx_size - 1;
    is_result = result;
}

void IsStart() {
    is_result = 0;
    is_tx_remain = sizeof(union IsTx) - 1;
    for (uint8_t i = 0; i < sizeof(is_tx); i++)
        is_tx.bytes[i] = i;
}

static uint16_t test_counter = 0;

void IsProcessCommand() {
    if (is_result == IS_ERROR_BUSY) {
        switch (is_rx.command) {
            case IS_COMMAND_TEST:
                if (is_rx_size == sizeof(is_rx.test)) {
                    test_counter = is_rx.test.value;
                } else if (is_rx_size == 1) {
                    test_counter++;
                } else {
                    is_result = IS_ERROR_SIZE;
                    break;
                }
                DebugOutput("Test %u %u\r\n", test_counter, is_rx_size);
                memcpy(&is_tx.test.value, &test_counter, 2);
                IsDone(0, sizeof(is_tx.test));
                break;
            case IS_COMMAND_READ:
                if (is_rx_size != sizeof(is_rx.read)) {
                    is_result = IS_ERROR_SIZE;
                    break;
                }
                IsDone(IsProcessRead(is_rx.read.device, is_rx.read.offset, (uint8_t*)is_tx.read.data), sizeof(is_tx.read));
                break;
            case IS_COMMAND_WRITE:
                is_result = IsProcessWrite(is_rx.write.device, is_rx.write.offset, (uint8_t*)is_rx.write.data);
                break;
            default:
                DebugOutput("Unknown command %u\r\n", is_rx.command);
                is_result = IS_ERROR_UNSUPPORTED;
        }
    }
}
