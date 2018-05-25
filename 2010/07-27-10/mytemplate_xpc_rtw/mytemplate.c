/*
 * mytemplate.c
 *
 * Real-Time Workshop code generation for Simulink model "mytemplate.mdl".
 *
 * Model Version              : 1.20
 * Real-Time Workshop version : 7.1  (R2008a)  23-Jan-2008
 * C source code generated on : Tue Jul 07 16:31:21 2009
 */

#include "rt_logging_mmi.h"
#include "mytemplate_capi.h"
#include "mytemplate.h"
#include "mytemplate_private.h"
#include <stdio.h>
#include "mytemplate_dt.h"

/* Block signals (auto storage) */
BlockIO_mytemplate mytemplate_B;

/* Block states (auto storage) */
D_Work_mytemplate mytemplate_DWork;

/* External outputs (root outports fed by signals with auto storage) */
ExternalOutputs_mytemplate mytemplate_Y;

/* Real-time model */
rtModel_mytemplate mytemplate_rtM_;
rtModel_mytemplate *mytemplate_rtM = &mytemplate_rtM_;

/* Model output function */
void mytemplate_output(int_T tid)
{
  /* Level2 S-Function Block: '<Root>/PCI-DAS1602 12 ' (adcbpcidas1600) */
  {
    SimStruct *rts = mytemplate_rtM->childSfunctions[0];
    sfcnOutputs(rts, 0);
  }

  /* Sin: '<Root>/Sine Wave' */
  if (mytemplate_DWork.systemEnable == 1) {
    mytemplate_DWork.lastSin = sin(mytemplate_P.SineWave_Freq *
      mytemplate_rtM->Timing.t[0]);
    mytemplate_DWork.lastCos = cos(mytemplate_P.SineWave_Freq *
      mytemplate_rtM->Timing.t[0]);
    mytemplate_DWork.systemEnable = 0;
  }

  mytemplate_B.SineWave = ((mytemplate_DWork.lastSin *
    mytemplate_P.SineWave_PCos + mytemplate_DWork.lastCos *
    mytemplate_P.SineWave_PSin) * mytemplate_P.SineWave_HCos +
    (mytemplate_DWork.lastCos * mytemplate_P.SineWave_PCos -
     mytemplate_DWork.lastSin * mytemplate_P.SineWave_PSin) *
    mytemplate_P.SineWave_Hsin) * mytemplate_P.SineWave_Amp +
    mytemplate_P.SineWave_Bias;

  /* Sin: '<Root>/Sine Wave1' */
  if (mytemplate_DWork.systemEnable_e == 1) {
    mytemplate_DWork.lastSin_o = sin(mytemplate_P.SineWave1_Freq *
      mytemplate_rtM->Timing.t[0]);
    mytemplate_DWork.lastCos_c = cos(mytemplate_P.SineWave1_Freq *
      mytemplate_rtM->Timing.t[0]);
    mytemplate_DWork.systemEnable_e = 0;
  }

  mytemplate_B.SineWave1 = ((mytemplate_DWork.lastSin_o *
    mytemplate_P.SineWave1_PCos + mytemplate_DWork.lastCos_c *
    mytemplate_P.SineWave1_PSin) * mytemplate_P.SineWave1_HCos +
    (mytemplate_DWork.lastCos_c * mytemplate_P.SineWave1_PCos -
     mytemplate_DWork.lastSin_o * mytemplate_P.SineWave1_PSin) *
    mytemplate_P.SineWave1_Hsin) * mytemplate_P.SineWave1_Amp +
    mytemplate_P.SineWave1_Bias;

  /* Sin: '<Root>/Sine Wave2' */
  if (mytemplate_DWork.systemEnable_b == 1) {
    mytemplate_DWork.lastSin_oj = sin(mytemplate_P.SineWave2_Freq *
      mytemplate_rtM->Timing.t[0]);
    mytemplate_DWork.lastCos_j = cos(mytemplate_P.SineWave2_Freq *
      mytemplate_rtM->Timing.t[0]);
    mytemplate_DWork.systemEnable_b = 0;
  }

  mytemplate_B.SineWave2 = ((mytemplate_DWork.lastSin_oj *
    mytemplate_P.SineWave2_PCos + mytemplate_DWork.lastCos_j *
    mytemplate_P.SineWave2_PSin) * mytemplate_P.SineWave2_HCos +
    (mytemplate_DWork.lastCos_j * mytemplate_P.SineWave2_PCos -
     mytemplate_DWork.lastSin_oj * mytemplate_P.SineWave2_PSin) *
    mytemplate_P.SineWave2_Hsin) * mytemplate_P.SineWave2_Amp +
    mytemplate_P.SineWave2_Bias;

  /* Sin: '<Root>/Sine Wave3' */
  if (mytemplate_DWork.systemEnable_p == 1) {
    mytemplate_DWork.lastSin_l = sin(mytemplate_P.SineWave3_Freq *
      mytemplate_rtM->Timing.t[0]);
    mytemplate_DWork.lastCos_h = cos(mytemplate_P.SineWave3_Freq *
      mytemplate_rtM->Timing.t[0]);
    mytemplate_DWork.systemEnable_p = 0;
  }

  mytemplate_B.SineWave3 = ((mytemplate_DWork.lastSin_l *
    mytemplate_P.SineWave3_PCos + mytemplate_DWork.lastCos_h *
    mytemplate_P.SineWave3_PSin) * mytemplate_P.SineWave3_HCos +
    (mytemplate_DWork.lastCos_h * mytemplate_P.SineWave3_PCos -
     mytemplate_DWork.lastSin_l * mytemplate_P.SineWave3_PSin) *
    mytemplate_P.SineWave3_Hsin) * mytemplate_P.SineWave3_Amp +
    mytemplate_P.SineWave3_Bias;

  /* Sin: '<Root>/Sine Wave4' */
  if (mytemplate_DWork.systemEnable_l == 1) {
    mytemplate_DWork.lastSin_i = sin(mytemplate_P.SineWave4_Freq *
      mytemplate_rtM->Timing.t[0]);
    mytemplate_DWork.lastCos_b = cos(mytemplate_P.SineWave4_Freq *
      mytemplate_rtM->Timing.t[0]);
    mytemplate_DWork.systemEnable_l = 0;
  }

  mytemplate_B.SineWave4 = ((mytemplate_DWork.lastSin_i *
    mytemplate_P.SineWave4_PCos + mytemplate_DWork.lastCos_b *
    mytemplate_P.SineWave4_PSin) * mytemplate_P.SineWave4_HCos +
    (mytemplate_DWork.lastCos_b * mytemplate_P.SineWave4_PCos -
     mytemplate_DWork.lastSin_i * mytemplate_P.SineWave4_PSin) *
    mytemplate_P.SineWave4_Hsin) * mytemplate_P.SineWave4_Amp +
    mytemplate_P.SineWave4_Bias;

  /* Sin: '<Root>/Sine Wave5' */
  if (mytemplate_DWork.systemEnable_c == 1) {
    mytemplate_DWork.lastSin_e = sin(mytemplate_P.SineWave5_Freq *
      mytemplate_rtM->Timing.t[0]);
    mytemplate_DWork.lastCos_bn = cos(mytemplate_P.SineWave5_Freq *
      mytemplate_rtM->Timing.t[0]);
    mytemplate_DWork.systemEnable_c = 0;
  }

  mytemplate_B.SineWave5 = ((mytemplate_DWork.lastSin_e *
    mytemplate_P.SineWave5_PCos + mytemplate_DWork.lastCos_bn *
    mytemplate_P.SineWave5_PSin) * mytemplate_P.SineWave5_HCos +
    (mytemplate_DWork.lastCos_bn * mytemplate_P.SineWave5_PCos -
     mytemplate_DWork.lastSin_e * mytemplate_P.SineWave5_PSin) *
    mytemplate_P.SineWave5_Hsin) * mytemplate_P.SineWave5_Amp +
    mytemplate_P.SineWave5_Bias;

  /* Level2 S-Function Block: '<Root>/PCI-DDA08 12 ' (dacbpcidda0x12) */
  {
    SimStruct *rts = mytemplate_rtM->childSfunctions[1];
    sfcnOutputs(rts, 0);
  }

  /* Outport: '<Root>/Out1' */
  mytemplate_Y.Out1[0] = mytemplate_B.PCIDAS160212_o1;
  mytemplate_Y.Out1[1] = mytemplate_B.PCIDAS160212_o2;
  mytemplate_Y.Out1[2] = mytemplate_B.PCIDAS160212_o3;
  mytemplate_Y.Out1[3] = mytemplate_B.PCIDAS160212_o4;
  mytemplate_Y.Out1[4] = mytemplate_B.PCIDAS160212_o5;
  mytemplate_Y.Out1[5] = mytemplate_B.PCIDAS160212_o6;
  mytemplate_Y.Out1[6] = mytemplate_B.PCIDAS160212_o7;
  mytemplate_Y.Out1[7] = mytemplate_B.PCIDAS160212_o8;
  mytemplate_Y.Out1[8] = mytemplate_B.PCIDAS160212_o9;
  mytemplate_Y.Out1[9] = mytemplate_B.PCIDAS160212_o10;
  mytemplate_Y.Out1[10] = mytemplate_B.PCIDAS160212_o11;
  mytemplate_Y.Out1[11] = mytemplate_B.PCIDAS160212_o12;
  mytemplate_Y.Out1[12] = mytemplate_B.PCIDAS160212_o13;
  mytemplate_Y.Out1[13] = mytemplate_B.PCIDAS160212_o14;
  UNUSED_PARAMETER(tid);
}

/* Model update function */
void mytemplate_update(int_T tid)
{
  {
    real_T HoldSine;
    real_T HoldCosine;

    /* Update for Sin: '<Root>/Sine Wave' */
    HoldSine = mytemplate_DWork.lastSin;
    HoldCosine = mytemplate_DWork.lastCos;
    mytemplate_DWork.lastSin = HoldSine * mytemplate_P.SineWave_HCos +
      HoldCosine * mytemplate_P.SineWave_Hsin;
    mytemplate_DWork.lastCos = HoldCosine * mytemplate_P.SineWave_HCos -
      HoldSine * mytemplate_P.SineWave_Hsin;

    /* Update for Sin: '<Root>/Sine Wave1' */
    HoldSine = mytemplate_DWork.lastSin_o;
    HoldCosine = mytemplate_DWork.lastCos_c;
    mytemplate_DWork.lastSin_o = HoldSine * mytemplate_P.SineWave1_HCos +
      HoldCosine * mytemplate_P.SineWave1_Hsin;
    mytemplate_DWork.lastCos_c = HoldCosine * mytemplate_P.SineWave1_HCos -
      HoldSine * mytemplate_P.SineWave1_Hsin;

    /* Update for Sin: '<Root>/Sine Wave2' */
    HoldSine = mytemplate_DWork.lastSin_oj;
    HoldCosine = mytemplate_DWork.lastCos_j;
    mytemplate_DWork.lastSin_oj = HoldSine * mytemplate_P.SineWave2_HCos +
      HoldCosine * mytemplate_P.SineWave2_Hsin;
    mytemplate_DWork.lastCos_j = HoldCosine * mytemplate_P.SineWave2_HCos -
      HoldSine * mytemplate_P.SineWave2_Hsin;

    /* Update for Sin: '<Root>/Sine Wave3' */
    HoldSine = mytemplate_DWork.lastSin_l;
    HoldCosine = mytemplate_DWork.lastCos_h;
    mytemplate_DWork.lastSin_l = HoldSine * mytemplate_P.SineWave3_HCos +
      HoldCosine * mytemplate_P.SineWave3_Hsin;
    mytemplate_DWork.lastCos_h = HoldCosine * mytemplate_P.SineWave3_HCos -
      HoldSine * mytemplate_P.SineWave3_Hsin;

    /* Update for Sin: '<Root>/Sine Wave4' */
    HoldSine = mytemplate_DWork.lastSin_i;
    HoldCosine = mytemplate_DWork.lastCos_b;
    mytemplate_DWork.lastSin_i = HoldSine * mytemplate_P.SineWave4_HCos +
      HoldCosine * mytemplate_P.SineWave4_Hsin;
    mytemplate_DWork.lastCos_b = HoldCosine * mytemplate_P.SineWave4_HCos -
      HoldSine * mytemplate_P.SineWave4_Hsin;

    /* Update for Sin: '<Root>/Sine Wave5' */
    HoldSine = mytemplate_DWork.lastSin_e;
    HoldCosine = mytemplate_DWork.lastCos_bn;
    mytemplate_DWork.lastSin_e = HoldSine * mytemplate_P.SineWave5_HCos +
      HoldCosine * mytemplate_P.SineWave5_Hsin;
    mytemplate_DWork.lastCos_bn = HoldCosine * mytemplate_P.SineWave5_HCos -
      HoldSine * mytemplate_P.SineWave5_Hsin;
  }

  /* Update absolute time for base rate */
  if (!(++mytemplate_rtM->Timing.clockTick0))
    ++mytemplate_rtM->Timing.clockTickH0;
  mytemplate_rtM->Timing.t[0] = mytemplate_rtM->Timing.clockTick0 *
    mytemplate_rtM->Timing.stepSize0 + mytemplate_rtM->Timing.clockTickH0 *
    mytemplate_rtM->Timing.stepSize0 * 4294967296.0;
  UNUSED_PARAMETER(tid);
}

/* Model initialize function */
void mytemplate_initialize(boolean_T firstTime)
{
  (void)firstTime;

  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  /* initialize real-time model */
  (void) memset((char_T *)mytemplate_rtM,0,
                sizeof(rtModel_mytemplate));
  rtsiSetSolverName(&mytemplate_rtM->solverInfo,"FixedStepDiscrete");
  mytemplate_rtM->solverInfoPtr = (&mytemplate_rtM->solverInfo);

  /* Initialize timing info */
  {
    int_T *mdlTsMap = mytemplate_rtM->Timing.sampleTimeTaskIDArray;
    mdlTsMap[0] = 0;
    mytemplate_rtM->Timing.sampleTimeTaskIDPtr = (&mdlTsMap[0]);
    mytemplate_rtM->Timing.sampleTimes =
      (&mytemplate_rtM->Timing.sampleTimesArray[0]);
    mytemplate_rtM->Timing.offsetTimes =
      (&mytemplate_rtM->Timing.offsetTimesArray[0]);

    /* task periods */
    mytemplate_rtM->Timing.sampleTimes[0] = (0.0005);

    /* task offsets */
    mytemplate_rtM->Timing.offsetTimes[0] = (0.0);
  }

  rtmSetTPtr(mytemplate_rtM, &mytemplate_rtM->Timing.tArray[0]);

  {
    int_T *mdlSampleHits = mytemplate_rtM->Timing.sampleHitArray;
    mdlSampleHits[0] = 1;
    mytemplate_rtM->Timing.sampleHits = (&mdlSampleHits[0]);
  }

  rtmSetTFinal(mytemplate_rtM, 100.0);
  mytemplate_rtM->Timing.stepSize0 = 0.0005;

  /* Setup for data logging */
  {
    static RTWLogInfo rt_DataLoggingInfo;
    mytemplate_rtM->rtwLogInfo = &rt_DataLoggingInfo;
    rtliSetLogXSignalInfo(mytemplate_rtM->rtwLogInfo, NULL);
    rtliSetLogXSignalPtrs(mytemplate_rtM->rtwLogInfo, NULL);
    rtliSetLogT(mytemplate_rtM->rtwLogInfo, "tout");
    rtliSetLogX(mytemplate_rtM->rtwLogInfo, "");
    rtliSetLogXFinal(mytemplate_rtM->rtwLogInfo, "");
    rtliSetSigLog(mytemplate_rtM->rtwLogInfo, "");
    rtliSetLogVarNameModifier(mytemplate_rtM->rtwLogInfo, "rt_");
    rtliSetLogFormat(mytemplate_rtM->rtwLogInfo, 0);
    rtliSetLogMaxRows(mytemplate_rtM->rtwLogInfo, 1000);
    rtliSetLogDecimation(mytemplate_rtM->rtwLogInfo, 1);

    /*
     * Set pointers to the data and signal info for each output
     */
    {
      static void * rt_LoggedOutputSignalPtrs[] = {
        &mytemplate_Y.Out1[0]
      };

      rtliSetLogYSignalPtrs(mytemplate_rtM->rtwLogInfo, ((LogSignalPtrsType)
        rt_LoggedOutputSignalPtrs));
    }

    {
      static int_T rt_LoggedOutputWidths[] = {
        14
      };

      static int_T rt_LoggedOutputNumDimensions[] = {
        1
      };

      static int_T rt_LoggedOutputDimensions[] = {
        14
      };

      static boolean_T rt_LoggedOutputIsVarDims[] = {
        0
      };

      static int_T* rt_LoggedCurrentSignalDimensions[] = {
        NULL
      };

      static BuiltInDTypeId rt_LoggedOutputDataTypeIds[] = {
        SS_DOUBLE
      };

      static int_T rt_LoggedOutputComplexSignals[] = {
        0
      };

      static const char_T *rt_LoggedOutputLabels[] = {
        "" };

      static const char_T *rt_LoggedOutputBlockNames[] = {
        "mytemplate/Out1" };

      static RTWLogDataTypeConvert rt_RTWLogDataTypeConvert[] = {
        { 0, SS_DOUBLE, SS_DOUBLE, 0, 0, 0, 1.0, 0, 0.0 }
      };

      static RTWLogSignalInfo rt_LoggedOutputSignalInfo[] = {
        {
          1,
          rt_LoggedOutputWidths,
          rt_LoggedOutputNumDimensions,
          rt_LoggedOutputDimensions,
          rt_LoggedOutputIsVarDims,
          rt_LoggedCurrentSignalDimensions,
          rt_LoggedOutputDataTypeIds,
          rt_LoggedOutputComplexSignals,
          NULL,

          { rt_LoggedOutputLabels },
          NULL,
          NULL,
          NULL,

          { rt_LoggedOutputBlockNames },

          { NULL },
          NULL,
          rt_RTWLogDataTypeConvert
        }
      };

      rtliSetLogYSignalInfo(mytemplate_rtM->rtwLogInfo,
                            rt_LoggedOutputSignalInfo);

      /* set currSigDims field */
      rt_LoggedCurrentSignalDimensions[0] = &rt_LoggedOutputWidths[0];
    }

    rtliSetLogY(mytemplate_rtM->rtwLogInfo, "yout");
  }

  /* external mode info */
  mytemplate_rtM->Sizes.checksums[0] = (3045967463U);
  mytemplate_rtM->Sizes.checksums[1] = (1564323053U);
  mytemplate_rtM->Sizes.checksums[2] = (445448437U);
  mytemplate_rtM->Sizes.checksums[3] = (320842124U);

  {
    static const sysRanDType rtAlwaysEnabled = SUBSYS_RAN_BC_ENABLE;
    static RTWExtModeInfo rt_ExtModeInfo;
    static const sysRanDType *systemRan[1];
    mytemplate_rtM->extModeInfo = (&rt_ExtModeInfo);
    rteiSetSubSystemActiveVectorAddresses(&rt_ExtModeInfo, systemRan);
    systemRan[0] = &rtAlwaysEnabled;
    rteiSetModelMappingInfoPtr(&rt_ExtModeInfo,
      &mytemplate_rtM->SpecialInfo.mappingInfo);
    rteiSetChecksumsPtr(&rt_ExtModeInfo, mytemplate_rtM->Sizes.checksums);
    rteiSetTPtr(&rt_ExtModeInfo, rtmGetTPtr(mytemplate_rtM));
  }

  mytemplate_rtM->solverInfoPtr = (&mytemplate_rtM->solverInfo);
  mytemplate_rtM->Timing.stepSize = (0.0005);
  rtsiSetFixedStepSize(&mytemplate_rtM->solverInfo, 0.0005);
  rtsiSetSolverMode(&mytemplate_rtM->solverInfo, SOLVER_MODE_SINGLETASKING);

  /* block I/O */
  mytemplate_rtM->ModelData.blockIO = ((void *) &mytemplate_B);

  {
    int_T i;
    void *pVoidBlockIORegion;
    pVoidBlockIORegion = (void *)(&mytemplate_B.PCIDAS160212_o1);
    for (i = 0; i < 20; i++) {
      ((real_T*)pVoidBlockIORegion)[i] = 0.0;
    }
  }

  /* parameters */
  mytemplate_rtM->ModelData.defaultParam = ((real_T *) &mytemplate_P);

  /* states (dwork) */
  mytemplate_rtM->Work.dwork = ((void *) &mytemplate_DWork);
  (void) memset((char_T *) &mytemplate_DWork,0,
                sizeof(D_Work_mytemplate));

  {
    int_T i;
    real_T *dwork_ptr = (real_T *) &mytemplate_DWork.lastSin;
    for (i = 0; i < 28; i++) {
      dwork_ptr[i] = 0.0;
    }
  }

  /* external outputs */
  mytemplate_rtM->ModelData.outputs = (&mytemplate_Y);

  {
    int_T i;
    for (i = 0; i < 14; i++) {
      mytemplate_Y.Out1[i] = 0.0;
    }
  }

  /* data type transition information */
  {
    static DataTypeTransInfo dtInfo;
    (void) memset((char_T *) &dtInfo,0,
                  sizeof(dtInfo));
    mytemplate_rtM->SpecialInfo.mappingInfo = (&dtInfo);
    mytemplate_rtM->SpecialInfo.xpcData = ((void*) &dtInfo);
    dtInfo.numDataTypes = 14;
    dtInfo.dataTypeSizes = &rtDataTypeSizes[0];
    dtInfo.dataTypeNames = &rtDataTypeNames[0];

    /* Block I/O transition table */
    dtInfo.B = &rtBTransTable;

    /* Parameters transition table */
    dtInfo.P = &rtPTransTable;
  }

  /* Initialize DataMapInfo substructure containing ModelMap for C API */
  mytemplate_InitializeDataMapInfo(mytemplate_rtM);

  /* child S-Function registration */
  {
    RTWSfcnInfo *sfcnInfo = &mytemplate_rtM->NonInlinedSFcns.sfcnInfo;
    mytemplate_rtM->sfcnInfo = (sfcnInfo);
    rtssSetErrorStatusPtr(sfcnInfo, (&rtmGetErrorStatus(mytemplate_rtM)));
    rtssSetNumRootSampTimesPtr(sfcnInfo, &mytemplate_rtM->Sizes.numSampTimes);
    rtssSetTPtrPtr(sfcnInfo, &rtmGetTPtr(mytemplate_rtM));
    rtssSetTStartPtr(sfcnInfo, &rtmGetTStart(mytemplate_rtM));
    rtssSetTFinalPtr(sfcnInfo, &rtmGetTFinal(mytemplate_rtM));
    rtssSetTimeOfLastOutputPtr(sfcnInfo, &rtmGetTimeOfLastOutput(mytemplate_rtM));
    rtssSetStepSizePtr(sfcnInfo, &mytemplate_rtM->Timing.stepSize);
    rtssSetStopRequestedPtr(sfcnInfo, &rtmGetStopRequested(mytemplate_rtM));
    rtssSetDerivCacheNeedsResetPtr(sfcnInfo,
      &mytemplate_rtM->ModelData.derivCacheNeedsReset);
    rtssSetZCCacheNeedsResetPtr(sfcnInfo,
      &mytemplate_rtM->ModelData.zCCacheNeedsReset);
    rtssSetBlkStateChangePtr(sfcnInfo, &mytemplate_rtM->ModelData.blkStateChange);
    rtssSetSampleHitsPtr(sfcnInfo, &mytemplate_rtM->Timing.sampleHits);
    rtssSetPerTaskSampleHitsPtr(sfcnInfo,
      &mytemplate_rtM->Timing.perTaskSampleHits);
    rtssSetSimModePtr(sfcnInfo, &mytemplate_rtM->simMode);
    rtssSetSolverInfoPtr(sfcnInfo, &mytemplate_rtM->solverInfoPtr);
  }

  mytemplate_rtM->Sizes.numSFcns = (2);

  /* register each child */
  {
    (void) memset((void *)&mytemplate_rtM->NonInlinedSFcns.childSFunctions[0],0,
                  2*sizeof(SimStruct));
    mytemplate_rtM->childSfunctions =
      (&mytemplate_rtM->NonInlinedSFcns.childSFunctionPtrs[0]);
    mytemplate_rtM->childSfunctions[0] =
      (&mytemplate_rtM->NonInlinedSFcns.childSFunctions[0]);
    mytemplate_rtM->childSfunctions[1] =
      (&mytemplate_rtM->NonInlinedSFcns.childSFunctions[1]);

    /* Level2 S-Function Block: mytemplate/<Root>/PCI-DAS1602 12  (adcbpcidas1600) */
    {
      SimStruct *rts = mytemplate_rtM->childSfunctions[0];

      /* timing info */
      time_T *sfcnPeriod = mytemplate_rtM->NonInlinedSFcns.Sfcn0.sfcnPeriod;
      time_T *sfcnOffset = mytemplate_rtM->NonInlinedSFcns.Sfcn0.sfcnOffset;
      int_T *sfcnTsMap = mytemplate_rtM->NonInlinedSFcns.Sfcn0.sfcnTsMap;
      (void) memset((void*)sfcnPeriod,0,
                    sizeof(time_T)*1);
      (void) memset((void*)sfcnOffset,0,
                    sizeof(time_T)*1);
      ssSetSampleTimePtr(rts, &sfcnPeriod[0]);
      ssSetOffsetTimePtr(rts, &sfcnOffset[0]);
      ssSetSampleTimeTaskIDPtr(rts, sfcnTsMap);

      /* Set up the mdlInfo pointer */
      {
        ssSetBlkInfo2Ptr(rts, &mytemplate_rtM->NonInlinedSFcns.blkInfo2[0]);
        ssSetRTWSfcnInfo(rts, mytemplate_rtM->sfcnInfo);
      }

      /* Allocate memory of model methods 2 */
      {
        ssSetModelMethods2(rts, &mytemplate_rtM->NonInlinedSFcns.methods2[0]);
      }

      /* outputs */
      {
        ssSetPortInfoForOutputs(rts,
          &mytemplate_rtM->NonInlinedSFcns.Sfcn0.outputPortInfo[0]);
        _ssSetNumOutputPorts(rts, 14);

        /* port 0 */
        {
          _ssSetOutputPortNumDimensions(rts, 0, 1);
          ssSetOutputPortWidth(rts, 0, 1);
          ssSetOutputPortSignal(rts, 0, ((real_T *)
            &mytemplate_B.PCIDAS160212_o1));
        }

        /* port 1 */
        {
          _ssSetOutputPortNumDimensions(rts, 1, 1);
          ssSetOutputPortWidth(rts, 1, 1);
          ssSetOutputPortSignal(rts, 1, ((real_T *)
            &mytemplate_B.PCIDAS160212_o2));
        }

        /* port 2 */
        {
          _ssSetOutputPortNumDimensions(rts, 2, 1);
          ssSetOutputPortWidth(rts, 2, 1);
          ssSetOutputPortSignal(rts, 2, ((real_T *)
            &mytemplate_B.PCIDAS160212_o3));
        }

        /* port 3 */
        {
          _ssSetOutputPortNumDimensions(rts, 3, 1);
          ssSetOutputPortWidth(rts, 3, 1);
          ssSetOutputPortSignal(rts, 3, ((real_T *)
            &mytemplate_B.PCIDAS160212_o4));
        }

        /* port 4 */
        {
          _ssSetOutputPortNumDimensions(rts, 4, 1);
          ssSetOutputPortWidth(rts, 4, 1);
          ssSetOutputPortSignal(rts, 4, ((real_T *)
            &mytemplate_B.PCIDAS160212_o5));
        }

        /* port 5 */
        {
          _ssSetOutputPortNumDimensions(rts, 5, 1);
          ssSetOutputPortWidth(rts, 5, 1);
          ssSetOutputPortSignal(rts, 5, ((real_T *)
            &mytemplate_B.PCIDAS160212_o6));
        }

        /* port 6 */
        {
          _ssSetOutputPortNumDimensions(rts, 6, 1);
          ssSetOutputPortWidth(rts, 6, 1);
          ssSetOutputPortSignal(rts, 6, ((real_T *)
            &mytemplate_B.PCIDAS160212_o7));
        }

        /* port 7 */
        {
          _ssSetOutputPortNumDimensions(rts, 7, 1);
          ssSetOutputPortWidth(rts, 7, 1);
          ssSetOutputPortSignal(rts, 7, ((real_T *)
            &mytemplate_B.PCIDAS160212_o8));
        }

        /* port 8 */
        {
          _ssSetOutputPortNumDimensions(rts, 8, 1);
          ssSetOutputPortWidth(rts, 8, 1);
          ssSetOutputPortSignal(rts, 8, ((real_T *)
            &mytemplate_B.PCIDAS160212_o9));
        }

        /* port 9 */
        {
          _ssSetOutputPortNumDimensions(rts, 9, 1);
          ssSetOutputPortWidth(rts, 9, 1);
          ssSetOutputPortSignal(rts, 9, ((real_T *)
            &mytemplate_B.PCIDAS160212_o10));
        }

        /* port 10 */
        {
          _ssSetOutputPortNumDimensions(rts, 10, 1);
          ssSetOutputPortWidth(rts, 10, 1);
          ssSetOutputPortSignal(rts, 10, ((real_T *)
            &mytemplate_B.PCIDAS160212_o11));
        }

        /* port 11 */
        {
          _ssSetOutputPortNumDimensions(rts, 11, 1);
          ssSetOutputPortWidth(rts, 11, 1);
          ssSetOutputPortSignal(rts, 11, ((real_T *)
            &mytemplate_B.PCIDAS160212_o12));
        }

        /* port 12 */
        {
          _ssSetOutputPortNumDimensions(rts, 12, 1);
          ssSetOutputPortWidth(rts, 12, 1);
          ssSetOutputPortSignal(rts, 12, ((real_T *)
            &mytemplate_B.PCIDAS160212_o13));
        }

        /* port 13 */
        {
          _ssSetOutputPortNumDimensions(rts, 13, 1);
          ssSetOutputPortWidth(rts, 13, 1);
          ssSetOutputPortSignal(rts, 13, ((real_T *)
            &mytemplate_B.PCIDAS160212_o14));
        }
      }

      /* path info */
      ssSetModelName(rts, "PCI-DAS1602 12 ");
      ssSetPath(rts, "mytemplate/PCI-DAS1602 12 ");
      ssSetRTModel(rts,mytemplate_rtM);
      ssSetParentSS(rts, NULL);
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* parameters */
      {
        mxArray **sfcnParams = (mxArray **)
          &mytemplate_rtM->NonInlinedSFcns.Sfcn0.params;
        ssSetSFcnParamsCount(rts, 9);
        ssSetSFcnParamsPtr(rts, &sfcnParams[0]);
        ssSetSFcnParam(rts, 0, (mxArray*)&mytemplate_P.PCIDAS160212_P1_Size[0]);
        ssSetSFcnParam(rts, 1, (mxArray*)&mytemplate_P.PCIDAS160212_P2_Size[0]);
        ssSetSFcnParam(rts, 2, (mxArray*)&mytemplate_P.PCIDAS160212_P3_Size[0]);
        ssSetSFcnParam(rts, 3, (mxArray*)&mytemplate_P.PCIDAS160212_P4_Size[0]);
        ssSetSFcnParam(rts, 4, (mxArray*)&mytemplate_P.PCIDAS160212_P5_Size[0]);
        ssSetSFcnParam(rts, 5, (mxArray*)&mytemplate_P.PCIDAS160212_P6_Size[0]);
        ssSetSFcnParam(rts, 6, (mxArray*)&mytemplate_P.PCIDAS160212_P7_Size[0]);
        ssSetSFcnParam(rts, 7, (mxArray*)&mytemplate_P.PCIDAS160212_P8_Size[0]);
        ssSetSFcnParam(rts, 8, (mxArray*)&mytemplate_P.PCIDAS160212_P9_Size[0]);
      }

      /* work vectors */
      ssSetIWork(rts, (int_T *) &mytemplate_DWork.PCIDAS160212_IWORK[0]);

      {
        struct _ssDWorkRecord *dWorkRecord = (struct _ssDWorkRecord *)
          &mytemplate_rtM->NonInlinedSFcns.Sfcn0.dWork;
        struct _ssDWorkAuxRecord *dWorkAuxRecord = (struct _ssDWorkAuxRecord *)
          &mytemplate_rtM->NonInlinedSFcns.Sfcn0.dWorkAux;
        ssSetSFcnDWork(rts, dWorkRecord);
        ssSetSFcnDWorkAux(rts, dWorkAuxRecord);
        _ssSetNumDWork(rts, 1);

        /* IWORK */
        ssSetDWorkWidth(rts, 0, 2);
        ssSetDWorkDataType(rts, 0,SS_INTEGER);
        ssSetDWorkComplexSignal(rts, 0, 0);
        ssSetDWork(rts, 0, &mytemplate_DWork.PCIDAS160212_IWORK[0]);
      }

      /* registration */
      adcbpcidas1600(rts);
      sfcnInitializeSizes(rts);
      sfcnInitializeSampleTimes(rts);

      /* adjust sample time */
      ssSetSampleTime(rts, 0, 0.0005);
      ssSetOffsetTime(rts, 0, 0.0);
      sfcnTsMap[0] = 0;

      /* set compiled values of dynamic vector attributes */
      ssSetNumNonsampledZCs(rts, 0);

      /* Update connectivity flags for each port */
      _ssSetOutputPortConnected(rts, 0, 1);
      _ssSetOutputPortConnected(rts, 1, 1);
      _ssSetOutputPortConnected(rts, 2, 1);
      _ssSetOutputPortConnected(rts, 3, 1);
      _ssSetOutputPortConnected(rts, 4, 1);
      _ssSetOutputPortConnected(rts, 5, 1);
      _ssSetOutputPortConnected(rts, 6, 1);
      _ssSetOutputPortConnected(rts, 7, 1);
      _ssSetOutputPortConnected(rts, 8, 1);
      _ssSetOutputPortConnected(rts, 9, 1);
      _ssSetOutputPortConnected(rts, 10, 1);
      _ssSetOutputPortConnected(rts, 11, 1);
      _ssSetOutputPortConnected(rts, 12, 1);
      _ssSetOutputPortConnected(rts, 13, 1);
      _ssSetOutputPortBeingMerged(rts, 0, 0);
      _ssSetOutputPortBeingMerged(rts, 1, 0);
      _ssSetOutputPortBeingMerged(rts, 2, 0);
      _ssSetOutputPortBeingMerged(rts, 3, 0);
      _ssSetOutputPortBeingMerged(rts, 4, 0);
      _ssSetOutputPortBeingMerged(rts, 5, 0);
      _ssSetOutputPortBeingMerged(rts, 6, 0);
      _ssSetOutputPortBeingMerged(rts, 7, 0);
      _ssSetOutputPortBeingMerged(rts, 8, 0);
      _ssSetOutputPortBeingMerged(rts, 9, 0);
      _ssSetOutputPortBeingMerged(rts, 10, 0);
      _ssSetOutputPortBeingMerged(rts, 11, 0);
      _ssSetOutputPortBeingMerged(rts, 12, 0);
      _ssSetOutputPortBeingMerged(rts, 13, 0);

      /* Update the BufferDstPort flags for each input port */
    }

    /* Level2 S-Function Block: mytemplate/<Root>/PCI-DDA08 12  (dacbpcidda0x12) */
    {
      SimStruct *rts = mytemplate_rtM->childSfunctions[1];

      /* timing info */
      time_T *sfcnPeriod = mytemplate_rtM->NonInlinedSFcns.Sfcn1.sfcnPeriod;
      time_T *sfcnOffset = mytemplate_rtM->NonInlinedSFcns.Sfcn1.sfcnOffset;
      int_T *sfcnTsMap = mytemplate_rtM->NonInlinedSFcns.Sfcn1.sfcnTsMap;
      (void) memset((void*)sfcnPeriod,0,
                    sizeof(time_T)*1);
      (void) memset((void*)sfcnOffset,0,
                    sizeof(time_T)*1);
      ssSetSampleTimePtr(rts, &sfcnPeriod[0]);
      ssSetOffsetTimePtr(rts, &sfcnOffset[0]);
      ssSetSampleTimeTaskIDPtr(rts, sfcnTsMap);

      /* Set up the mdlInfo pointer */
      {
        ssSetBlkInfo2Ptr(rts, &mytemplate_rtM->NonInlinedSFcns.blkInfo2[1]);
        ssSetRTWSfcnInfo(rts, mytemplate_rtM->sfcnInfo);
      }

      /* Allocate memory of model methods 2 */
      {
        ssSetModelMethods2(rts, &mytemplate_rtM->NonInlinedSFcns.methods2[1]);
      }

      /* inputs */
      {
        _ssSetNumInputPorts(rts, 6);
        ssSetPortInfoForInputs(rts,
          &mytemplate_rtM->NonInlinedSFcns.Sfcn1.inputPortInfo[0]);

        /* port 0 */
        {
          real_T const **sfcnUPtrs = (real_T const **)
            &mytemplate_rtM->NonInlinedSFcns.Sfcn1.UPtrs0;
          sfcnUPtrs[0] = &mytemplate_B.SineWave;
          ssSetInputPortSignalPtrs(rts, 0, (InputPtrsType)&sfcnUPtrs[0]);
          _ssSetInputPortNumDimensions(rts, 0, 1);
          ssSetInputPortWidth(rts, 0, 1);
        }

        /* port 1 */
        {
          real_T const **sfcnUPtrs = (real_T const **)
            &mytemplate_rtM->NonInlinedSFcns.Sfcn1.UPtrs1;
          sfcnUPtrs[0] = &mytemplate_B.SineWave1;
          ssSetInputPortSignalPtrs(rts, 1, (InputPtrsType)&sfcnUPtrs[0]);
          _ssSetInputPortNumDimensions(rts, 1, 1);
          ssSetInputPortWidth(rts, 1, 1);
        }

        /* port 2 */
        {
          real_T const **sfcnUPtrs = (real_T const **)
            &mytemplate_rtM->NonInlinedSFcns.Sfcn1.UPtrs2;
          sfcnUPtrs[0] = &mytemplate_B.SineWave2;
          ssSetInputPortSignalPtrs(rts, 2, (InputPtrsType)&sfcnUPtrs[0]);
          _ssSetInputPortNumDimensions(rts, 2, 1);
          ssSetInputPortWidth(rts, 2, 1);
        }

        /* port 3 */
        {
          real_T const **sfcnUPtrs = (real_T const **)
            &mytemplate_rtM->NonInlinedSFcns.Sfcn1.UPtrs3;
          sfcnUPtrs[0] = &mytemplate_B.SineWave3;
          ssSetInputPortSignalPtrs(rts, 3, (InputPtrsType)&sfcnUPtrs[0]);
          _ssSetInputPortNumDimensions(rts, 3, 1);
          ssSetInputPortWidth(rts, 3, 1);
        }

        /* port 4 */
        {
          real_T const **sfcnUPtrs = (real_T const **)
            &mytemplate_rtM->NonInlinedSFcns.Sfcn1.UPtrs4;
          sfcnUPtrs[0] = &mytemplate_B.SineWave4;
          ssSetInputPortSignalPtrs(rts, 4, (InputPtrsType)&sfcnUPtrs[0]);
          _ssSetInputPortNumDimensions(rts, 4, 1);
          ssSetInputPortWidth(rts, 4, 1);
        }

        /* port 5 */
        {
          real_T const **sfcnUPtrs = (real_T const **)
            &mytemplate_rtM->NonInlinedSFcns.Sfcn1.UPtrs5;
          sfcnUPtrs[0] = &mytemplate_B.SineWave5;
          ssSetInputPortSignalPtrs(rts, 5, (InputPtrsType)&sfcnUPtrs[0]);
          _ssSetInputPortNumDimensions(rts, 5, 1);
          ssSetInputPortWidth(rts, 5, 1);
        }
      }

      /* path info */
      ssSetModelName(rts, "PCI-DDA08 12 ");
      ssSetPath(rts, "mytemplate/PCI-DDA08 12 ");
      ssSetRTModel(rts,mytemplate_rtM);
      ssSetParentSS(rts, NULL);
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* parameters */
      {
        mxArray **sfcnParams = (mxArray **)
          &mytemplate_rtM->NonInlinedSFcns.Sfcn1.params;
        ssSetSFcnParamsCount(rts, 7);
        ssSetSFcnParamsPtr(rts, &sfcnParams[0]);
        ssSetSFcnParam(rts, 0, (mxArray*)&mytemplate_P.PCIDDA0812_P1_Size[0]);
        ssSetSFcnParam(rts, 1, (mxArray*)&mytemplate_P.PCIDDA0812_P2_Size[0]);
        ssSetSFcnParam(rts, 2, (mxArray*)&mytemplate_P.PCIDDA0812_P3_Size[0]);
        ssSetSFcnParam(rts, 3, (mxArray*)&mytemplate_P.PCIDDA0812_P4_Size[0]);
        ssSetSFcnParam(rts, 4, (mxArray*)&mytemplate_P.PCIDDA0812_P5_Size[0]);
        ssSetSFcnParam(rts, 5, (mxArray*)&mytemplate_P.PCIDDA0812_P6_Size[0]);
        ssSetSFcnParam(rts, 6, (mxArray*)&mytemplate_P.PCIDDA0812_P7_Size[0]);
      }

      /* work vectors */
      ssSetRWork(rts, (real_T *) &mytemplate_DWork.PCIDDA0812_RWORK[0]);
      ssSetIWork(rts, (int_T *) &mytemplate_DWork.PCIDDA0812_IWORK[0]);

      {
        struct _ssDWorkRecord *dWorkRecord = (struct _ssDWorkRecord *)
          &mytemplate_rtM->NonInlinedSFcns.Sfcn1.dWork;
        struct _ssDWorkAuxRecord *dWorkAuxRecord = (struct _ssDWorkAuxRecord *)
          &mytemplate_rtM->NonInlinedSFcns.Sfcn1.dWorkAux;
        ssSetSFcnDWork(rts, dWorkRecord);
        ssSetSFcnDWorkAux(rts, dWorkAuxRecord);
        _ssSetNumDWork(rts, 2);

        /* RWORK */
        ssSetDWorkWidth(rts, 0, 16);
        ssSetDWorkDataType(rts, 0,SS_DOUBLE);
        ssSetDWorkComplexSignal(rts, 0, 0);
        ssSetDWork(rts, 0, &mytemplate_DWork.PCIDDA0812_RWORK[0]);

        /* IWORK */
        ssSetDWorkWidth(rts, 1, 4);
        ssSetDWorkDataType(rts, 1,SS_INTEGER);
        ssSetDWorkComplexSignal(rts, 1, 0);
        ssSetDWork(rts, 1, &mytemplate_DWork.PCIDDA0812_IWORK[0]);
      }

      /* registration */
      dacbpcidda0x12(rts);
      sfcnInitializeSizes(rts);
      sfcnInitializeSampleTimes(rts);

      /* adjust sample time */
      ssSetSampleTime(rts, 0, 0.0005);
      ssSetOffsetTime(rts, 0, 0.0);
      sfcnTsMap[0] = 0;

      /* set compiled values of dynamic vector attributes */
      ssSetNumNonsampledZCs(rts, 0);

      /* Update connectivity flags for each port */
      _ssSetInputPortConnected(rts, 0, 1);
      _ssSetInputPortConnected(rts, 1, 1);
      _ssSetInputPortConnected(rts, 2, 1);
      _ssSetInputPortConnected(rts, 3, 1);
      _ssSetInputPortConnected(rts, 4, 1);
      _ssSetInputPortConnected(rts, 5, 1);

      /* Update the BufferDstPort flags for each input port */
      ssSetInputPortBufferDstPort(rts, 0, -1);
      ssSetInputPortBufferDstPort(rts, 1, -1);
      ssSetInputPortBufferDstPort(rts, 2, -1);
      ssSetInputPortBufferDstPort(rts, 3, -1);
      ssSetInputPortBufferDstPort(rts, 4, -1);
      ssSetInputPortBufferDstPort(rts, 5, -1);
    }
  }
}

/* Model terminate function */
void mytemplate_terminate(void)
{
  /* Level2 S-Function Block: '<Root>/PCI-DAS1602 12 ' (adcbpcidas1600) */
  {
    SimStruct *rts = mytemplate_rtM->childSfunctions[0];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<Root>/PCI-DDA08 12 ' (dacbpcidda0x12) */
  {
    SimStruct *rts = mytemplate_rtM->childSfunctions[1];
    sfcnTerminate(rts);
  }

  /* External mode */
  rtExtModeShutdown(1);
}

/*========================================================================*
 * Start of GRT compatible call interface                                 *
 *========================================================================*/
void MdlOutputs(int_T tid)
{
  mytemplate_output(tid);
}

void MdlUpdate(int_T tid)
{
  mytemplate_update(tid);
}

void MdlInitializeSizes(void)
{
  mytemplate_rtM->Sizes.numContStates = (0);/* Number of continuous states */
  mytemplate_rtM->Sizes.numY = (14);   /* Number of model outputs */
  mytemplate_rtM->Sizes.numU = (0);    /* Number of model inputs */
  mytemplate_rtM->Sizes.sysDirFeedThru = (0);/* The model is not direct feedthrough */
  mytemplate_rtM->Sizes.numSampTimes = (1);/* Number of sample times */
  mytemplate_rtM->Sizes.numBlocks = (9);/* Number of blocks */
  mytemplate_rtM->Sizes.numBlockIO = (20);/* Number of block outputs */
  mytemplate_rtM->Sizes.numBlockPrms = (110);/* Sum of parameter "widths" */
}

void MdlInitializeSampleTimes(void)
{
}

void MdlInitialize(void)
{
}

void MdlStart(void)
{
  /* Level2 S-Function Block: '<Root>/PCI-DAS1602 12 ' (adcbpcidas1600) */
  {
    SimStruct *rts = mytemplate_rtM->childSfunctions[0];
    sfcnStart(rts);
    if (ssGetErrorStatus(rts) != NULL)
      return;
  }

  /* Level2 S-Function Block: '<Root>/PCI-DDA08 12 ' (dacbpcidda0x12) */
  {
    SimStruct *rts = mytemplate_rtM->childSfunctions[1];
    sfcnStart(rts);
    if (ssGetErrorStatus(rts) != NULL)
      return;
  }

  MdlInitialize();

  /* Enable for Sin: '<Root>/Sine Wave' */
  mytemplate_DWork.systemEnable = 1;

  /* Enable for Sin: '<Root>/Sine Wave1' */
  mytemplate_DWork.systemEnable_e = 1;

  /* Enable for Sin: '<Root>/Sine Wave2' */
  mytemplate_DWork.systemEnable_b = 1;

  /* Enable for Sin: '<Root>/Sine Wave3' */
  mytemplate_DWork.systemEnable_p = 1;

  /* Enable for Sin: '<Root>/Sine Wave4' */
  mytemplate_DWork.systemEnable_l = 1;

  /* Enable for Sin: '<Root>/Sine Wave5' */
  mytemplate_DWork.systemEnable_c = 1;
}

rtModel_mytemplate *mytemplate(void)
{
  mytemplate_initialize(1);
  return mytemplate_rtM;
}

void MdlTerminate(void)
{
  mytemplate_terminate();
}

/*========================================================================*
 * End of GRT compatible call interface                                   *
 *========================================================================*/
