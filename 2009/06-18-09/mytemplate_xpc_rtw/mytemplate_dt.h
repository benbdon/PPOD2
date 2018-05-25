/*
 * mytemplate_dt.h
 *
 * Real-Time Workshop code generation for Simulink model "mytemplate.mdl".
 *
 * Model Version              : 1.20
 * Real-Time Workshop version : 7.1  (R2008a)  23-Jan-2008
 * C source code generated on : Tue Jul 07 16:31:21 2009
 */

#include "ext_types.h"

/* data type size table */
static uint_T rtDataTypeSizes[] = {
  sizeof(real_T),
  sizeof(real32_T),
  sizeof(int8_T),
  sizeof(uint8_T),
  sizeof(int16_T),
  sizeof(uint16_T),
  sizeof(int32_T),
  sizeof(uint32_T),
  sizeof(boolean_T),
  sizeof(fcn_call_T),
  sizeof(int_T),
  sizeof(pointer_T),
  sizeof(action_T),
  2*sizeof(uint32_T)
};

/* data type name table */
static const char_T * rtDataTypeNames[] = {
  "real_T",
  "real32_T",
  "int8_T",
  "uint8_T",
  "int16_T",
  "uint16_T",
  "int32_T",
  "uint32_T",
  "boolean_T",
  "fcn_call_T",
  "int_T",
  "pointer_T",
  "action_T",
  "timer_uint32_pair_T"
};

/* data type transitions for block I/O structure */
static DataTypeTransition rtBTransitions[] = {
  { (char_T *)(&mytemplate_B.PCIDAS160212_o1), 0, 0, 20 }
  ,

  { (char_T *)(&mytemplate_DWork.lastSin), 0, 0, 28 },

  { (char_T *)(&mytemplate_DWork.systemEnable), 6, 0, 6 },

  { (char_T *)(&mytemplate_DWork.PCIDAS160212_IWORK[0]), 10, 0, 6 }
};

/* data type transition table for block I/O structure */
static DataTypeTransitionTable rtBTransTable = {
  4U,
  rtBTransitions
};

/* data type transitions for Parameters structure */
static DataTypeTransition rtPTransitions[] = {
  { (char_T *)(&mytemplate_P.PCIDAS160212_P1_Size[0]), 0, 0, 110 }
};

/* data type transition table for Parameters structure */
static DataTypeTransitionTable rtPTransTable = {
  1U,
  rtPTransitions
};

/* [EOF] mytemplate_dt.h */
