/*
 * mytemplate_capi.c
 *
 * Real-Time Workshop code generation for Simulink model "mytemplate.mdl".
 *
 * Model Version              : 1.20
 * Real-Time Workshop version : 7.1  (R2008a)  23-Jan-2008
 * C source code generated on : Tue Jul 07 16:31:21 2009
 */

#include "mytemplate.h"
#include "rtw_capi.h"
#include "mytemplate_private.h"

/* Block output signal information */
static const rtwCAPI_Signals rtBlockSignals[] = {
  /* addrMapIndex, sysNum, blockPath,
   * signalName, portNumber, dataTypeIndex, dimIndex, fxpIndex, sTimeIndex
   */
  { 0, 0, "PCI-DAS1602 12 /p1",
    "", 0, 0, 0, 0, 0 },

  { 1, 0, "PCI-DAS1602 12 /p2",
    "", 1, 0, 0, 0, 0 },

  { 2, 0, "PCI-DAS1602 12 /p3",
    "", 2, 0, 0, 0, 0 },

  { 3, 0, "PCI-DAS1602 12 /p4",
    "", 3, 0, 0, 0, 0 },

  { 4, 0, "PCI-DAS1602 12 /p5",
    "", 4, 0, 0, 0, 0 },

  { 5, 0, "PCI-DAS1602 12 /p6",
    "", 5, 0, 0, 0, 0 },

  { 6, 0, "PCI-DAS1602 12 /p7",
    "", 6, 0, 0, 0, 0 },

  { 7, 0, "PCI-DAS1602 12 /p8",
    "", 7, 0, 0, 0, 0 },

  { 8, 0, "PCI-DAS1602 12 /p9",
    "", 8, 0, 0, 0, 0 },

  { 9, 0, "PCI-DAS1602 12 /p10",
    "", 9, 0, 0, 0, 0 },

  { 10, 0, "PCI-DAS1602 12 /p11",
    "", 10, 0, 0, 0, 0 },

  { 11, 0, "PCI-DAS1602 12 /p12",
    "", 11, 0, 0, 0, 0 },

  { 12, 0, "PCI-DAS1602 12 /p13",
    "", 12, 0, 0, 0, 0 },

  { 13, 0, "PCI-DAS1602 12 /p14",
    "", 13, 0, 0, 0, 0 },

  { 14, 0, "Sine Wave",
    "", 0, 0, 0, 0, 0 },

  { 15, 0, "Sine Wave1",
    "", 0, 0, 0, 0, 0 },

  { 16, 0, "Sine Wave2",
    "", 0, 0, 0, 0, 0 },

  { 17, 0, "Sine Wave3",
    "", 0, 0, 0, 0, 0 },

  { 18, 0, "Sine Wave4",
    "", 0, 0, 0, 0, 0 },

  { 19, 0, "Sine Wave5",
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
  { 20, "PCI-DAS1602 12 ",
    "P1", 0, 0, 0 },

  { 21, "PCI-DAS1602 12 ",
    "P2", 0, 0, 0 },

  { 22, "PCI-DAS1602 12 ",
    "P3", 0, 0, 0 },

  { 23, "PCI-DAS1602 12 ",
    "P4", 0, 0, 0 },

  { 24, "PCI-DAS1602 12 ",
    "P5", 0, 0, 0 },

  { 25, "PCI-DAS1602 12 ",
    "P6", 0, 0, 0 },

  { 26, "PCI-DAS1602 12 ",
    "P7", 0, 0, 0 },

  { 27, "PCI-DAS1602 12 ",
    "P8", 0, 0, 0 },

  { 28, "PCI-DAS1602 12 ",
    "P9", 0, 0, 0 },

  { 29, "PCI-DDA08 12 ",
    "P1", 0, 1, 0 },

  { 30, "PCI-DDA08 12 ",
    "P2", 0, 1, 0 },

  { 31, "PCI-DDA08 12 ",
    "P3", 0, 1, 0 },

  { 32, "PCI-DDA08 12 ",
    "P4", 0, 1, 0 },

  { 33, "PCI-DDA08 12 ",
    "P5", 0, 0, 0 },

  { 34, "PCI-DDA08 12 ",
    "P6", 0, 0, 0 },

  { 35, "PCI-DDA08 12 ",
    "P7", 0, 0, 0 },

  { 36, "Sine Wave",
    "Amplitude", 0, 0, 0 },

  { 37, "Sine Wave",
    "Bias", 0, 0, 0 },

  { 38, "Sine Wave",
    "Frequency", 0, 0, 0 },

  { 39, "Sine Wave",
    "SinH", 0, 0, 0 },

  { 40, "Sine Wave",
    "CosH", 0, 0, 0 },

  { 41, "Sine Wave",
    "SinPhi", 0, 0, 0 },

  { 42, "Sine Wave",
    "CosPhi", 0, 0, 0 },

  { 43, "Sine Wave1",
    "Amplitude", 0, 0, 0 },

  { 44, "Sine Wave1",
    "Bias", 0, 0, 0 },

  { 45, "Sine Wave1",
    "Frequency", 0, 0, 0 },

  { 46, "Sine Wave1",
    "SinH", 0, 0, 0 },

  { 47, "Sine Wave1",
    "CosH", 0, 0, 0 },

  { 48, "Sine Wave1",
    "SinPhi", 0, 0, 0 },

  { 49, "Sine Wave1",
    "CosPhi", 0, 0, 0 },

  { 50, "Sine Wave2",
    "Amplitude", 0, 0, 0 },

  { 51, "Sine Wave2",
    "Bias", 0, 0, 0 },

  { 52, "Sine Wave2",
    "Frequency", 0, 0, 0 },

  { 53, "Sine Wave2",
    "SinH", 0, 0, 0 },

  { 54, "Sine Wave2",
    "CosH", 0, 0, 0 },

  { 55, "Sine Wave2",
    "SinPhi", 0, 0, 0 },

  { 56, "Sine Wave2",
    "CosPhi", 0, 0, 0 },

  { 57, "Sine Wave3",
    "Amplitude", 0, 0, 0 },

  { 58, "Sine Wave3",
    "Bias", 0, 0, 0 },

  { 59, "Sine Wave3",
    "Frequency", 0, 0, 0 },

  { 60, "Sine Wave3",
    "SinH", 0, 0, 0 },

  { 61, "Sine Wave3",
    "CosH", 0, 0, 0 },

  { 62, "Sine Wave3",
    "SinPhi", 0, 0, 0 },

  { 63, "Sine Wave3",
    "CosPhi", 0, 0, 0 },

  { 64, "Sine Wave4",
    "Amplitude", 0, 0, 0 },

  { 65, "Sine Wave4",
    "Bias", 0, 0, 0 },

  { 66, "Sine Wave4",
    "Frequency", 0, 0, 0 },

  { 67, "Sine Wave4",
    "SinH", 0, 0, 0 },

  { 68, "Sine Wave4",
    "CosH", 0, 0, 0 },

  { 69, "Sine Wave4",
    "SinPhi", 0, 0, 0 },

  { 70, "Sine Wave4",
    "CosPhi", 0, 0, 0 },

  { 71, "Sine Wave5",
    "Amplitude", 0, 0, 0 },

  { 72, "Sine Wave5",
    "Bias", 0, 0, 0 },

  { 73, "Sine Wave5",
    "Frequency", 0, 0, 0 },

  { 74, "Sine Wave5",
    "SinH", 0, 0, 0 },

  { 75, "Sine Wave5",
    "CosH", 0, 0, 0 },

  { 76, "Sine Wave5",
    "SinPhi", 0, 0, 0 },

  { 77, "Sine Wave5",
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
  &mytemplate_B.PCIDAS160212_o1,       /* 0: Signal */
  &mytemplate_B.PCIDAS160212_o2,       /* 1: Signal */
  &mytemplate_B.PCIDAS160212_o3,       /* 2: Signal */
  &mytemplate_B.PCIDAS160212_o4,       /* 3: Signal */
  &mytemplate_B.PCIDAS160212_o5,       /* 4: Signal */
  &mytemplate_B.PCIDAS160212_o6,       /* 5: Signal */
  &mytemplate_B.PCIDAS160212_o7,       /* 6: Signal */
  &mytemplate_B.PCIDAS160212_o8,       /* 7: Signal */
  &mytemplate_B.PCIDAS160212_o9,       /* 8: Signal */
  &mytemplate_B.PCIDAS160212_o10,      /* 9: Signal */
  &mytemplate_B.PCIDAS160212_o11,      /* 10: Signal */
  &mytemplate_B.PCIDAS160212_o12,      /* 11: Signal */
  &mytemplate_B.PCIDAS160212_o13,      /* 12: Signal */
  &mytemplate_B.PCIDAS160212_o14,      /* 13: Signal */
  &mytemplate_B.SineWave,              /* 14: Signal */
  &mytemplate_B.SineWave1,             /* 15: Signal */
  &mytemplate_B.SineWave2,             /* 16: Signal */
  &mytemplate_B.SineWave3,             /* 17: Signal */
  &mytemplate_B.SineWave4,             /* 18: Signal */
  &mytemplate_B.SineWave5,             /* 19: Signal */
  &mytemplate_P.PCIDAS160212_P1,       /* 20: Block Parameter */
  &mytemplate_P.PCIDAS160212_P2,       /* 21: Block Parameter */
  &mytemplate_P.PCIDAS160212_P3,       /* 22: Block Parameter */
  &mytemplate_P.PCIDAS160212_P4,       /* 23: Block Parameter */
  &mytemplate_P.PCIDAS160212_P5,       /* 24: Block Parameter */
  &mytemplate_P.PCIDAS160212_P6,       /* 25: Block Parameter */
  &mytemplate_P.PCIDAS160212_P7,       /* 26: Block Parameter */
  &mytemplate_P.PCIDAS160212_P8,       /* 27: Block Parameter */
  &mytemplate_P.PCIDAS160212_P9,       /* 28: Block Parameter */
  &mytemplate_P.PCIDDA0812_P1[0],      /* 29: Block Parameter */
  &mytemplate_P.PCIDDA0812_P2[0],      /* 30: Block Parameter */
  &mytemplate_P.PCIDDA0812_P3[0],      /* 31: Block Parameter */
  &mytemplate_P.PCIDDA0812_P4[0],      /* 32: Block Parameter */
  &mytemplate_P.PCIDDA0812_P5,         /* 33: Block Parameter */
  &mytemplate_P.PCIDDA0812_P6,         /* 34: Block Parameter */
  &mytemplate_P.PCIDDA0812_P7,         /* 35: Block Parameter */
  &mytemplate_P.SineWave_Amp,          /* 36: Block Parameter */
  &mytemplate_P.SineWave_Bias,         /* 37: Block Parameter */
  &mytemplate_P.SineWave_Freq,         /* 38: Block Parameter */
  &mytemplate_P.SineWave_Hsin,         /* 39: Block Parameter */
  &mytemplate_P.SineWave_HCos,         /* 40: Block Parameter */
  &mytemplate_P.SineWave_PSin,         /* 41: Block Parameter */
  &mytemplate_P.SineWave_PCos,         /* 42: Block Parameter */
  &mytemplate_P.SineWave1_Amp,         /* 43: Block Parameter */
  &mytemplate_P.SineWave1_Bias,        /* 44: Block Parameter */
  &mytemplate_P.SineWave1_Freq,        /* 45: Block Parameter */
  &mytemplate_P.SineWave1_Hsin,        /* 46: Block Parameter */
  &mytemplate_P.SineWave1_HCos,        /* 47: Block Parameter */
  &mytemplate_P.SineWave1_PSin,        /* 48: Block Parameter */
  &mytemplate_P.SineWave1_PCos,        /* 49: Block Parameter */
  &mytemplate_P.SineWave2_Amp,         /* 50: Block Parameter */
  &mytemplate_P.SineWave2_Bias,        /* 51: Block Parameter */
  &mytemplate_P.SineWave2_Freq,        /* 52: Block Parameter */
  &mytemplate_P.SineWave2_Hsin,        /* 53: Block Parameter */
  &mytemplate_P.SineWave2_HCos,        /* 54: Block Parameter */
  &mytemplate_P.SineWave2_PSin,        /* 55: Block Parameter */
  &mytemplate_P.SineWave2_PCos,        /* 56: Block Parameter */
  &mytemplate_P.SineWave3_Amp,         /* 57: Block Parameter */
  &mytemplate_P.SineWave3_Bias,        /* 58: Block Parameter */
  &mytemplate_P.SineWave3_Freq,        /* 59: Block Parameter */
  &mytemplate_P.SineWave3_Hsin,        /* 60: Block Parameter */
  &mytemplate_P.SineWave3_HCos,        /* 61: Block Parameter */
  &mytemplate_P.SineWave3_PSin,        /* 62: Block Parameter */
  &mytemplate_P.SineWave3_PCos,        /* 63: Block Parameter */
  &mytemplate_P.SineWave4_Amp,         /* 64: Block Parameter */
  &mytemplate_P.SineWave4_Bias,        /* 65: Block Parameter */
  &mytemplate_P.SineWave4_Freq,        /* 66: Block Parameter */
  &mytemplate_P.SineWave4_Hsin,        /* 67: Block Parameter */
  &mytemplate_P.SineWave4_HCos,        /* 68: Block Parameter */
  &mytemplate_P.SineWave4_PSin,        /* 69: Block Parameter */
  &mytemplate_P.SineWave4_PCos,        /* 70: Block Parameter */
  &mytemplate_P.SineWave5_Amp,         /* 71: Block Parameter */
  &mytemplate_P.SineWave5_Bias,        /* 72: Block Parameter */
  &mytemplate_P.SineWave5_Freq,        /* 73: Block Parameter */
  &mytemplate_P.SineWave5_Hsin,        /* 74: Block Parameter */
  &mytemplate_P.SineWave5_HCos,        /* 75: Block Parameter */
  &mytemplate_P.SineWave5_PSin,        /* 76: Block Parameter */
  &mytemplate_P.SineWave5_PCos         /* 77: Block Parameter */
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
  { rtwCAPI_SCALAR, 0, 2, 0 },

  { rtwCAPI_VECTOR, 2, 2, 0 }
};

/* Dimension Array- use dimArrayIndex to access elements of this array */
static const uint_T rtDimensionArray[] = {
  1,                                   /* 0 */
  1,                                   /* 1 */
  1,                                   /* 2 */
  6                                    /* 3 */
};

/* C-API stores floating point values in an array. The elements of this  *
 * are unique. This ensures that values which are shared across the model*
 * are stored in the most efficient way. These values are referenced by  *
 *           - rtwCAPI_FixPtMap.fracSlopePtr,                            *
 *           - rtwCAPI_FixPtMap.biasPtr,                                 *
 *           - rtwCAPI_SampleTimeMap.samplePeriodPtr,                    *
 *           - rtwCAPI_SampleTimeMap.sampleOffsetPtr                     */
static const real_T rtcapiStoredFloats[] = {
  0.0005, 0.0
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
  { rtBlockSignals, 20 },

  { rtBlockParameters, 58,
    rtModelParameters, 0 },

  { NULL, 0 },

  { rtDataTypeMap, rtDimensionMap, rtFixPtMap,
    rtElementMap, rtSampleTimeMap, rtDimensionArray },
  "float", NULL
};

/* Cache pointers into DataMapInfo substructure of RTModel */
void mytemplate_InitializeDataMapInfo(rtModel_mytemplate *mytemplate_rtM
  )
{
  /* Set C-API version */
  rtwCAPI_SetVersion(mytemplate_rtM->DataMapInfo.mmi, 1);

  /* Cache static C-API data into the Real-time Model Data structure */
  rtwCAPI_SetStaticMap(mytemplate_rtM->DataMapInfo.mmi, &mmiStatic);

  /* Cache static C-API logging data into the Real-time Model Data structure */
  rtwCAPI_SetLoggingStaticMap(mytemplate_rtM->DataMapInfo.mmi, NULL);

  /* Cache C-API Data Addresses into the Real-Time Model Data structure */
  rtwCAPI_SetDataAddressMap(mytemplate_rtM->DataMapInfo.mmi, rtDataAddrMap);

  /* Cache C-API Data Run-Time Dimension Buffer Addresses into the Real-Time Model Data structure */
  rtwCAPI_SetVarDimsAddressMap(mytemplate_rtM->DataMapInfo.mmi, rtVarDimsAddrMap);

  /* Cache the instance C-API logging pointer */
  rtwCAPI_SetInstanceLoggingInfo(mytemplate_rtM->DataMapInfo.mmi, NULL);

  /* Set Reference to submodels */
  rtwCAPI_SetChildMMIArray(mytemplate_rtM->DataMapInfo.mmi, NULL);
  rtwCAPI_SetChildMMIArrayLen(mytemplate_rtM->DataMapInfo.mmi, 0);
}

/* EOF: mytemplate_capi.c */
