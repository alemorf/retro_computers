#include "old_dma.h"

/* DMA registers Masks */
#define CCR_CLEAR_Mask           ((uint32_t)0xFFFF800F)

/**
  * @brief  Initializes the DMAy Channelx according to the specified
  *         parameters in the DMA_InitStruct.
  * @param  DMAy_Channelx: where y can be 1 or 2 to select the DMA and
  *   x can be 1 to 7 for DMA1 and 1 to 5 for DMA2 to select the DMA Channel.
  * @param  DMA_InitStruct: pointer to a DMA_InitTypeDef structure that
  *         contains the configuration information for the specified DMA Channel.
  * @retval None
  */
void OLD_DMA_Init(DMA_Channel_TypeDef* DMAy_Channelx, OLD_DMA_InitTypeDef* DMA_InitStruct)
{
  uint32_t tmpreg = 0;

  /* Check the parameters */
  assert_param(IS_OLD_DMA_ALL_PERIPH(DMAy_Channelx));
  assert_param(IS_OLD_DMA_DIR(DMA_InitStruct->DMA_DIR));
  assert_param(IS_OLD_DMA_BUFFER_SIZE(DMA_InitStruct->DMA_BufferSize));
  assert_param(IS_OLD_DMA_PERIPHERAL_INC_STATE(DMA_InitStruct->DMA_PeripheralInc));
  assert_param(IS_OLD_DMA_MEMORY_INC_STATE(DMA_InitStruct->DMA_MemoryInc));
  assert_param(IS_OLD_DMA_PERIPHERAL_DATA_SIZE(DMA_InitStruct->DMA_PeripheralDataSize));
  assert_param(IS_OLD_DMA_MEMORY_DATA_SIZE(DMA_InitStruct->DMA_MemoryDataSize));
  assert_param(IS_OLD_DMA_MODE(DMA_InitStruct->DMA_Mode));
  assert_param(IS_OLD_DMA_PRIORITY(DMA_InitStruct->DMA_Priority));
  assert_param(IS_OLD_DMA_M2M_STATE(DMA_InitStruct->DMA_M2M));

/*--------------------------- DMAy Channelx CCR Configuration -----------------*/
  /* Get the DMAy_Channelx CCR value */
  tmpreg = DMAy_Channelx->CCR;
  /* Clear MEM2MEM, PL, MSIZE, PSIZE, MINC, PINC, CIRC and DIR bits */
  tmpreg &= CCR_CLEAR_Mask;
  /* Configure DMAy Channelx: data transfer, data size, priority level and mode */
  /* Set DIR bit according to DMA_DIR value */
  /* Set CIRC bit according to DMA_Mode value */
  /* Set PINC bit according to DMA_PeripheralInc value */
  /* Set MINC bit according to DMA_MemoryInc value */
  /* Set PSIZE bits according to DMA_PeripheralDataSize value */
  /* Set MSIZE bits according to DMA_MemoryDataSize value */
  /* Set PL bits according to DMA_Priority value */
  /* Set the MEM2MEM bit according to DMA_M2M value */
  tmpreg |= DMA_InitStruct->DMA_DIR | DMA_InitStruct->DMA_Mode |
            DMA_InitStruct->DMA_PeripheralInc | DMA_InitStruct->DMA_MemoryInc |
            DMA_InitStruct->DMA_PeripheralDataSize | DMA_InitStruct->DMA_MemoryDataSize |
            DMA_InitStruct->DMA_Priority | DMA_InitStruct->DMA_M2M;

  /* Write to DMAy Channelx CCR */
  DMAy_Channelx->CCR = tmpreg;

/*--------------------------- DMAy Channelx CNDTR Configuration ---------------*/
  /* Write to DMAy Channelx CNDTR */
  DMAy_Channelx->CNDTR = DMA_InitStruct->DMA_BufferSize;

/*--------------------------- DMAy Channelx CPAR Configuration ----------------*/
  /* Write to DMAy Channelx CPAR */
  DMAy_Channelx->CPAR = DMA_InitStruct->DMA_PeripheralBaseAddr;

/*--------------------------- DMAy Channelx CMAR Configuration ----------------*/
  /* Write to DMAy Channelx CMAR */
  DMAy_Channelx->CMAR = DMA_InitStruct->DMA_MemoryBaseAddr;
}
