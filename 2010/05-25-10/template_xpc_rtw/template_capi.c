/*
 * template_capi.c
 *
 * Real-Time Workshop code generation for Simulink model "template.mdl".
 *
 * Model Version              : 1.9
 * Real-Time Workshop version : 7.1  (R2008a)  23-Jan-2008
 * C source code generated on : Mon Jul 06 14:23:13 2009
 */

#include "template.h"
#include "rtw_capi.h"
#include "template_private.h"

/* Block output signal information */
static const rtwCAPI_Signals rtBlockSignals[] = {
  /* addrMapIndex, sysNum, blockPath,
   * signalName, portNumber, dataTypeIndex, dimIndex, fxpIndex, sTimeIndex
   */
  { 0, 0, "PCI-DAS1602 12 ",
    "", 0, 0, 0, 0, 0 },

  { 1, 0, "Sine Wave",
    "", 0, 0, 0, 0, 0 },

  {
    0, 0, NULL, NULL, 0, 0, 0, 0, 0
  }
};

/* Tunable block parameters */
static const rtwCAPI_BlockParameters rtBlockParameters[] = {
  /* addrMapIndex, blockPath,
   * paramName, dataTypeIndex, dimIndex, fixPtIdx
   */
  { 2, "PCI-DAS1602 12 ",
    "P1", 0, 0, 0 },

  { 3, "PCI-DAS1602 12 ",
    "P2", 0, 0, 0 },

  { 4, "PCI-DAS1602 12 ",
    "P3", 0, 0, 0 },

  { 5, "PCI-DAS1602 12 ",
    "P4", 0, 0, 0 },

  { 6, "PCI-DAS1602 12 ",
    "P5", 0, 0, 0 },

  { 7, "PCI-DAS1602 12 ",
    "P6", 0, 0, 0 },

  { 8, "PCI-DAS1602 12 ",
    "P7", 0, 0, 0 },

  { 9, "PCI-DAS1602 12 ",
    "P8", 0, 0, 0 },

  { 10, "PCI-DAS1602 12 ",
    "P9", 0, 0, 0 },

  { 11, "PCI-DDA08 12 ",
    "P1", 0, 0, 0 },

  { 12, "PCI-DDA08 12 ",
    "P2", 0, 0, 0 },

  { 13, "PCI-DDA08 12 ",
    "P3", 0, 0, 0 },

  { 14, "PCI-DDA08 12 ",
    "P4", 0, 0, 0 },

  { 15, "PCI-DDA08 12 ",
    "P5", 0, 0, 0 },

  { 16, "PCI-DDA08 12 ",
    "P6", 0, 0, 0 },

  { 17, "PCI-DDA08 12 ",
    "P7", 0, 0, 0 },

  { 18, "Sine Wave",
    "Amplitude", 0, 0, 0 },

  { 19, "Sine Wave",
    "Bias", 0, 0, 0 },

  { 20, "Sine Wave",
    "Frequency", 0, 0, 0 },

  { 21, "Sine Wave",
    "SinH", 0, 0, 0 },

  { 22, "Sine Wave",
    "CosH", 0, 0, 0 },

  { 23, "Sine Wave",
    "SinPhi", 0, 0, 0 },

  { 24, "Sine Wave",
    "CosPhi", 0, 0, 0 },

  {
    0, NULL, NULL, 0, 0, 0
  }
};

/* Tunable variable parameters */
static const rtwCAPI_ModelParameters rtModelParameters[] = {
  /* addrMapIndex, varName, dataTypeIndex, dimIndex, fixPtIndex */
  { 0, NULL, 0, 0, 0 }
};

/* Declare Data Addresses statically */
static void* rtDataAddrMap[] = {
  &template_B.PCIDAS160212,            /* 0: Signal */
  &template_B.SineWave,                /* 1: Signal */
  &template_P.PCIDAS160212_P1,         /* 2: Block Parameter */
  &template_P.PCIDAS160212_P2,         /* 3: Block Parameter */
  &template_P.PCIDAS160212_P3,         /* 4: Block Parameter */
  &template_P.PCIDAS160212_P4,         /* 5: Block Parameter */
  &template_P.PCIDAS160212_P5,         /* 6: Block Parameter */
  &template_P.PCIDAS160212_P6,         /* 7: Block Parameter */
  &template_P.PCIDAS160212_P7,         /* 8: Block Parameter */
  &template_P.PCIDAS160212_P8,         /* 9: Block Parameter */
  &template_P.PCIDAS160212_P9,         /* 10: Block Parameter */
  &template_P.PCIDDA0812_P1,           /* 11: Block Parameter */
  &template_P.PCIDDA0812_P2,           /* 12: Block Parameter */
  &template_P.PCIDDA0812_P3,           /* 13: Block Parameter */
  &template_P.PCIDDA0812_P4,           /* 14: Block Parameter */
  &template_P.PCIDDA0812_P5,           /* 15: Block Parameter */
  &template_P.PCIDDA0812_P6,           /* 16: Block Parameter */
  &template_P.PCIDDA0812_P7,           /* 17: Block Parameter */
  &template_P.SineWave_Amp,            /* 18: Block Parameter */
  &template_P.SineWave_Bias,           /* 19: Block Parameter */
  &template_P.SineWave_Freq,           /* 20: Block Parameter */
  &template_P.SineWave_Hsin,           /* 21: Block Parameter */
  &template_P.SineWave_HCos,           /* 22: Block Parameter */
  &template_P.SineWave_PSin,           /* 23: Block Parameter */
  &template_P.SineWave_PCos            /* 24: Block Parameter */
};

/* Declare Data Run-Time Dimension Buffer Addresses statically */
static int32_T* rtVarDimsAddrMap[] = {
  NULL
};

/* Data Type Map - use dataTypeMapIndex to access this structure */
static const rtwCAPI_DataTypeMap rtDataTypeMap[] = {
  /* cName, mwName, numElements, elemMapIndex, dataSize, slDataId, *
   * isComplex, isPointer */
  { "double", "real_T", 0, 0, sizeof(real_T), SS_DOUBLE, 0, 0 }
};

/* Structure Element Map - use elemMapIndex to access this structure */
static const rtwCAPI_ElementMap rtElementMap[] = {
  /* elementName, elementOffset, dataTypeIndex, dimIndex, fxpIndex */
  { NULL, 0, 0, 0, 0 },
};

/* Dimension Map - use dimensionMapIndex to access elements of ths structure*/
static const rtwCAPI_DimensionMap rtDimensionMap[] = {
  /* dataOrientation, dimArrayIndex, numDims*/
  { rtwCAPI_SCALAR, 0, 2, 0 }
};

/* Dimension Array- use dimArrayIndex to access elements of this array */
static const uint_T rtDimensionArray[] = {
  1,                                   /* 0 */
  1                                    /* 1 */
};

/* C-API stores floating point values in an array. The elements of this  *
 * are unique. This ensures that values which are shared across the model*
 * are stored in the most efficient way. These values are referenced by  *
 *           - rtwCAPI_FixPtMap.fracSlopePtr,                            *
 *           - rtwCAPI_FixPtMap.biasPtr,                                 *
 *           - rtwCAPI_SampleTimeMap.samplePeriodPtr,                    *
 *           - rtwCAPI_SampleTimeMap.sampleOffsetPtr                     */
static const real_T rtcapiStoredFloats[] = {
  0.002, 0.0
};

/* Fixed Point Map */
static const rtwCAPI_FixPtMap rtFixPtMap[] = {
  /* fracSlopePtr, biasPtr, scaleType, wordLength, exponent, isSigned */
  { NULL, NULL, rtwCAPI_FIX_RESERVED, 0, 0, 0 },
};

/* Sample Time Map - use sTimeIndex to access elements of ths structure */
static const rtwCAPI_SampleTimeMap rtSampleTimeMap[] = {
  /* samplePeriodPtr, sampleOffsetPtr, tid, samplingMode */
  { (const void *) &rtcapiStoredFloats[0], (const void *) &rtcapiStoredFloats[1],
    0, 0 }
};

static rtwCAPI_ModelMappingStaticInfo mmiStatic = {
  /* Signals:{signals, numSignals},
   * Params: {blockParameters, numBlockParameters,
   *          modelParameters, numModelParameters},
   * States: {states, numStates},
   * Maps:   {dataTypeMap, dimensionMap, fixPtMap,
   *          elementMap, sampleTimeMap, dimensionArray},
   * TargetType: targetType
   */
  { rtBlockSignals, 2 },

  { rtBlockParameters, 23,
    rtModelParameters, 0 },

  { NULL, 0 },

  { rtDataTypeMap, rtDimensionMap, rtFixPtMap,
    rtElementMap, rtSampleTimeMap, rtDimensionArray },
  "float", NULL
};

/* Cache pointers into DataMapInfo substructure of RTModel */
void template_InitializeDataMapInfo(rtModel_template *template_rtM
  )
{
  /* Set C-API version */
  rtwCAPI_SetVersion(template_rtM->DataMapInfo.mmi, 1);

  /* Cache static C-API data into the Real-time Model Data structure */
  rtwCAPI_SetStaticMap(template_rtM->DataMapInfo.mmi, &mmiStatic);

  /* Cache static C-API logging data into the Real-time Model Data structure */
  rtwCAPI_SetLoggingStaticMap(template_rtM->DataMapInfo.mmi, NULL);

  /* Cache C-API Data Addresses into the Real-Time Model Data structure */
  rtwCAPI_SetDataAddressMap(template_rtM->DataMapInfo.mmi, rtDataAddrMap);

  /* Cache C-API Data Run-Time Dimension Buffer Addresses into the Real-Time Model Data structure */
  rtwCAPI_SetVarDimsAddressMap(template_rtM->DataMapInfo.mmi, rtVarDimsAddrMap);

  /* Cache the instance C-API logging pointer */
  rtwCAPI_SetInstanceLoggingInfo(template_rtM->DataMapInfo.mmi, NULL);

  /* Set Reference to submodels */
  rtwCAPI_SetChildMMIArray(template_rtM->DataMapInfo.mmi, NULL);
  rtwCAPI_SetChildMMIArrayLen(template_rtM->DataMapInfo.mmi, 0);
}

/* EOF: template_capi.c */
