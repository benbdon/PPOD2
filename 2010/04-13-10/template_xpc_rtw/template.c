/*
 * template.c
 *
 * Real-Time Workshop code generation for Simulink model "template.mdl".
 *
 * Model Version              : 1.9
 * Real-Time Workshop version : 7.1  (R2008a)  23-Jan-2008
 * C source code generated on : Mon Jul 06 14:23:13 2009
 */

#include "rt_logging_mmi.h"
#include "template_capi.h"
#include "template.h"
#include "template_private.h"
#include <stdio.h>
#include "template_dt.h"

/* Block signals (auto storage) */
BlockIO_template template_B;

/* Block states (auto storage) */
D_Work_template template_DWork;

/* Real-time model */
rtModel_template template_rtM_;
rtModel_template *template_rtM = &template_rtM_;

/* Model output function */
void template_output(int_T tid)
{
  /* Level2 S-Function Block: '<Root>/PCI-DAS1602 12 ' (adcbpcidas1600) */
  {
    SimStruct *rts = template_rtM->childSfunctions[0];
    sfcnOutputs(rts, 0);
  }

  /* Sin: '<Root>/Sine Wave' */
  if (template_DWork.systemEnable == 1) {
    template_DWork.lastSin = sin(template_P.SineWave_Freq *
      template_rtM->Timing.t[0]);
    template_DWork.lastCos = cos(template_P.SineWave_Freq *
      template_rtM->Timing.t[0]);
    template_DWork.systemEnable = 0;
  }

  template_B.SineWave = ((template_DWork.lastSin * template_P.SineWave_PCos +
    template_DWork.lastCos * template_P.SineWave_PSin) *
    template_P.SineWave_HCos + (template_DWork.lastCos *
    template_P.SineWave_PCos - template_DWork.lastSin * template_P.SineWave_PSin)
    * template_P.SineWave_Hsin) * template_P.SineWave_Amp +
    template_P.SineWave_Bias;

  /* Level2 S-Function Block: '<Root>/PCI-DDA08 12 ' (dacbpcidda0x12) */
  {
    SimStruct *rts = template_rtM->childSfunctions[1];
    sfcnOutputs(rts, 0);
  }

  UNUSED_PARAMETER(tid);
}

/* Model update function */
void template_update(int_T tid)
{
  {
    real_T HoldSine;
    real_T HoldCosine;

    /* Update for Sin: '<Root>/Sine Wave' */
    HoldSine = template_DWork.lastSin;
    HoldCosine = template_DWork.lastCos;
    template_DWork.lastSin = HoldSine * template_P.SineWave_HCos + HoldCosine *
      template_P.SineWave_Hsin;
    template_DWork.lastCos = HoldCosine * template_P.SineWave_HCos - HoldSine *
      template_P.SineWave_Hsin;
  }

  /* Update absolute time for base rate */
  if (!(++template_rtM->Timing.clockTick0))
    ++template_rtM->Timing.clockTickH0;
  template_rtM->Timing.t[0] = template_rtM->Timing.clockTick0 *
    template_rtM->Timing.stepSize0 + template_rtM->Timing.clockTickH0 *
    template_rtM->Timing.stepSize0 * 4294967296.0;
  UNUSED_PARAMETER(tid);
}

/* Model initialize function */
void template_initialize(boolean_T firstTime)
{
  (void)firstTime;

  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  /* initialize real-time model */
  (void) memset((char_T *)template_rtM,0,
                sizeof(rtModel_template));
  rtsiSetSolverName(&template_rtM->solverInfo,"FixedStepDiscrete");
  template_rtM->solverInfoPtr = (&template_rtM->solverInfo);

  /* Initialize timing info */
  {
    int_T *mdlTsMap = template_rtM->Timing.sampleTimeTaskIDArray;
    mdlTsMap[0] = 0;
    template_rtM->Timing.sampleTimeTaskIDPtr = (&mdlTsMap[0]);
    template_rtM->Timing.sampleTimes = (&template_rtM->Timing.sampleTimesArray[0]);
    template_rtM->Timing.offsetTimes = (&template_rtM->Timing.offsetTimesArray[0]);

    /* task periods */
    template_rtM->Timing.sampleTimes[0] = (0.002);

    /* task offsets */
    template_rtM->Timing.offsetTimes[0] = (0.0);
  }

  rtmSetTPtr(template_rtM, &template_rtM->Timing.tArray[0]);

  {
    int_T *mdlSampleHits = template_rtM->Timing.sampleHitArray;
    mdlSampleHits[0] = 1;
    template_rtM->Timing.sampleHits = (&mdlSampleHits[0]);
  }

  rtmSetTFinal(template_rtM, 5.0);
  template_rtM->Timing.stepSize0 = 0.002;

  /* Setup for data logging */
  {
    static RTWLogInfo rt_DataLoggingInfo;
    template_rtM->rtwLogInfo = &rt_DataLoggingInfo;
    rtliSetLogXSignalInfo(template_rtM->rtwLogInfo, NULL);
    rtliSetLogXSignalPtrs(template_rtM->rtwLogInfo, NULL);
    rtliSetLogT(template_rtM->rtwLogInfo, "tout");
    rtliSetLogX(template_rtM->rtwLogInfo, "");
    rtliSetLogXFinal(template_rtM->rtwLogInfo, "");
    rtliSetSigLog(template_rtM->rtwLogInfo, "");
    rtliSetLogVarNameModifier(template_rtM->rtwLogInfo, "rt_");
    rtliSetLogFormat(template_rtM->rtwLogInfo, 0);
    rtliSetLogMaxRows(template_rtM->rtwLogInfo, 1000);
    rtliSetLogDecimation(template_rtM->rtwLogInfo, 1);
    rtliSetLogY(template_rtM->rtwLogInfo, "");
    rtliSetLogYSignalInfo(template_rtM->rtwLogInfo, NULL);
    rtliSetLogYSignalPtrs(template_rtM->rtwLogInfo, NULL);
  }

  /* external mode info */
  template_rtM->Sizes.checksums[0] = (1024089038U);
  template_rtM->Sizes.checksums[1] = (1952189153U);
  template_rtM->Sizes.checksums[2] = (1839206764U);
  template_rtM->Sizes.checksums[3] = (158257114U);

  {
    static const sysRanDType rtAlwaysEnabled = SUBSYS_RAN_BC_ENABLE;
    static RTWExtModeInfo rt_ExtModeInfo;
    static const sysRanDType *systemRan[1];
    template_rtM->extModeInfo = (&rt_ExtModeInfo);
    rteiSetSubSystemActiveVectorAddresses(&rt_ExtModeInfo, systemRan);
    systemRan[0] = &rtAlwaysEnabled;
    rteiSetModelMappingInfoPtr(&rt_ExtModeInfo,
      &template_rtM->SpecialInfo.mappingInfo);
    rteiSetChecksumsPtr(&rt_ExtModeInfo, template_rtM->Sizes.checksums);
    rteiSetTPtr(&rt_ExtModeInfo, rtmGetTPtr(template_rtM));
  }

  template_rtM->solverInfoPtr = (&template_rtM->solverInfo);
  template_rtM->Timing.stepSize = (0.002);
  rtsiSetFixedStepSize(&template_rtM->solverInfo, 0.002);
  rtsiSetSolverMode(&template_rtM->solverInfo, SOLVER_MODE_SINGLETASKING);

  /* block I/O */
  template_rtM->ModelData.blockIO = ((void *) &template_B);

  {
    int_T i;
    void *pVoidBlockIORegion;
    pVoidBlockIORegion = (void *)(&template_B.PCIDAS160212);
    for (i = 0; i < 2; i++) {
      ((real_T*)pVoidBlockIORegion)[i] = 0.0;
    }
  }

  /* parameters */
  template_rtM->ModelData.defaultParam = ((real_T *) &template_P);

  /* states (dwork) */
  template_rtM->Work.dwork = ((void *) &template_DWork);
  (void) memset((char_T *) &template_DWork,0,
                sizeof(D_Work_template));

  {
    int_T i;
    real_T *dwork_ptr = (real_T *) &template_DWork.lastSin;
    for (i = 0; i < 18; i++) {
      dwork_ptr[i] = 0.0;
    }
  }

  /* data type transition information */
  {
    static DataTypeTransInfo dtInfo;
    (void) memset((char_T *) &dtInfo,0,
                  sizeof(dtInfo));
    template_rtM->SpecialInfo.mappingInfo = (&dtInfo);
    template_rtM->SpecialInfo.xpcData = ((void*) &dtInfo);
    dtInfo.numDataTypes = 14;
    dtInfo.dataTypeSizes = &rtDataTypeSizes[0];
    dtInfo.dataTypeNames = &rtDataTypeNames[0];

    /* Block I/O transition table */
    dtInfo.B = &rtBTransTable;

    /* Parameters transition table */
    dtInfo.P = &rtPTransTable;
  }

  /* Initialize DataMapInfo substructure containing ModelMap for C API */
  template_InitializeDataMapInfo(template_rtM);

  /* child S-Function registration */
  {
    RTWSfcnInfo *sfcnInfo = &template_rtM->NonInlinedSFcns.sfcnInfo;
    template_rtM->sfcnInfo = (sfcnInfo);
    rtssSetErrorStatusPtr(sfcnInfo, (&rtmGetErrorStatus(template_rtM)));
    rtssSetNumRootSampTimesPtr(sfcnInfo, &template_rtM->Sizes.numSampTimes);
    rtssSetTPtrPtr(sfcnInfo, &rtmGetTPtr(template_rtM));
    rtssSetTStartPtr(sfcnInfo, &rtmGetTStart(template_rtM));
    rtssSetTFinalPtr(sfcnInfo, &rtmGetTFinal(template_rtM));
    rtssSetTimeOfLastOutputPtr(sfcnInfo, &rtmGetTimeOfLastOutput(template_rtM));
    rtssSetStepSizePtr(sfcnInfo, &template_rtM->Timing.stepSize);
    rtssSetStopRequestedPtr(sfcnInfo, &rtmGetStopRequested(template_rtM));
    rtssSetDerivCacheNeedsResetPtr(sfcnInfo,
      &template_rtM->ModelData.derivCacheNeedsReset);
    rtssSetZCCacheNeedsResetPtr(sfcnInfo,
      &template_rtM->ModelData.zCCacheNeedsReset);
    rtssSetBlkStateChangePtr(sfcnInfo, &template_rtM->ModelData.blkStateChange);
    rtssSetSampleHitsPtr(sfcnInfo, &template_rtM->Timing.sampleHits);
    rtssSetPerTaskSampleHitsPtr(sfcnInfo,
      &template_rtM->Timing.perTaskSampleHits);
    rtssSetSimModePtr(sfcnInfo, &template_rtM->simMode);
    rtssSetSolverInfoPtr(sfcnInfo, &template_rtM->solverInfoPtr);
  }

  template_rtM->Sizes.numSFcns = (2);

  /* register each child */
  {
    (void) memset((void *)&template_rtM->NonInlinedSFcns.childSFunctions[0],0,
                  2*sizeof(SimStruct));
    template_rtM->childSfunctions =
      (&template_rtM->NonInlinedSFcns.childSFunctionPtrs[0]);
    template_rtM->childSfunctions[0] =
      (&template_rtM->NonInlinedSFcns.childSFunctions[0]);
    template_rtM->childSfunctions[1] =
      (&template_rtM->NonInlinedSFcns.childSFunctions[1]);

    /* Level2 S-Function Block: template/<Root>/PCI-DAS1602 12  (adcbpcidas1600) */
    {
      SimStruct *rts = template_rtM->childSfunctions[0];

      /* timing info */
      time_T *sfcnPeriod = template_rtM->NonInlinedSFcns.Sfcn0.sfcnPeriod;
      time_T *sfcnOffset = template_rtM->NonInlinedSFcns.Sfcn0.sfcnOffset;
      int_T *sfcnTsMap = template_rtM->NonInlinedSFcns.Sfcn0.sfcnTsMap;
      (void) memset((void*)sfcnPeriod,0,
                    sizeof(time_T)*1);
      (void) memset((void*)sfcnOffset,0,
                    sizeof(time_T)*1);
      ssSetSampleTimePtr(rts, &sfcnPeriod[0]);
      ssSetOffsetTimePtr(rts, &sfcnOffset[0]);
      ssSetSampleTimeTaskIDPtr(rts, sfcnTsMap);

      /* Set up the mdlInfo pointer */
      {
        ssSetBlkInfo2Ptr(rts, &template_rtM->NonInlinedSFcns.blkInfo2[0]);
        ssSetRTWSfcnInfo(rts, template_rtM->sfcnInfo);
      }

      /* Allocate memory of model methods 2 */
      {
        ssSetModelMethods2(rts, &template_rtM->NonInlinedSFcns.methods2[0]);
      }

      /* outputs */
      {
        ssSetPortInfoForOutputs(rts,
          &template_rtM->NonInlinedSFcns.Sfcn0.outputPortInfo[0]);
        _ssSetNumOutputPorts(rts, 1);

        /* port 0 */
        {
          _ssSetOutputPortNumDimensions(rts, 0, 1);
          ssSetOutputPortWidth(rts, 0, 1);
          ssSetOutputPortSignal(rts, 0, ((real_T *) &template_B.PCIDAS160212));
        }
      }

      /* path info */
      ssSetModelName(rts, "PCI-DAS1602 12 ");
      ssSetPath(rts, "template/PCI-DAS1602 12 ");
      ssSetRTModel(rts,template_rtM);
      ssSetParentSS(rts, NULL);
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* parameters */
      {
        mxArray **sfcnParams = (mxArray **)
          &template_rtM->NonInlinedSFcns.Sfcn0.params;
        ssSetSFcnParamsCount(rts, 9);
        ssSetSFcnParamsPtr(rts, &sfcnParams[0]);
        ssSetSFcnParam(rts, 0, (mxArray*)&template_P.PCIDAS160212_P1_Size[0]);
        ssSetSFcnParam(rts, 1, (mxArray*)&template_P.PCIDAS160212_P2_Size[0]);
        ssSetSFcnParam(rts, 2, (mxArray*)&template_P.PCIDAS160212_P3_Size[0]);
        ssSetSFcnParam(rts, 3, (mxArray*)&template_P.PCIDAS160212_P4_Size[0]);
        ssSetSFcnParam(rts, 4, (mxArray*)&template_P.PCIDAS160212_P5_Size[0]);
        ssSetSFcnParam(rts, 5, (mxArray*)&template_P.PCIDAS160212_P6_Size[0]);
        ssSetSFcnParam(rts, 6, (mxArray*)&template_P.PCIDAS160212_P7_Size[0]);
        ssSetSFcnParam(rts, 7, (mxArray*)&template_P.PCIDAS160212_P8_Size[0]);
        ssSetSFcnParam(rts, 8, (mxArray*)&template_P.PCIDAS160212_P9_Size[0]);
      }

      /* work vectors */
      ssSetIWork(rts, (int_T *) &template_DWork.PCIDAS160212_IWORK[0]);

      {
        struct _ssDWorkRecord *dWorkRecord = (struct _ssDWorkRecord *)
          &template_rtM->NonInlinedSFcns.Sfcn0.dWork;
        struct _ssDWorkAuxRecord *dWorkAuxRecord = (struct _ssDWorkAuxRecord *)
          &template_rtM->NonInlinedSFcns.Sfcn0.dWorkAux;
        ssSetSFcnDWork(rts, dWorkRecord);
        ssSetSFcnDWorkAux(rts, dWorkAuxRecord);
        _ssSetNumDWork(rts, 1);

        /* IWORK */
        ssSetDWorkWidth(rts, 0, 2);
        ssSetDWorkDataType(rts, 0,SS_INTEGER);
        ssSetDWorkComplexSignal(rts, 0, 0);
        ssSetDWork(rts, 0, &template_DWork.PCIDAS160212_IWORK[0]);
      }

      /* registration */
      adcbpcidas1600(rts);
      sfcnInitializeSizes(rts);
      sfcnInitializeSampleTimes(rts);

      /* adjust sample time */
      ssSetSampleTime(rts, 0, 0.002);
      ssSetOffsetTime(rts, 0, 0.0);
      sfcnTsMap[0] = 0;

      /* set compiled values of dynamic vector attributes */
      ssSetNumNonsampledZCs(rts, 0);

      /* Update connectivity flags for each port */
      _ssSetOutputPortConnected(rts, 0, 1);
      _ssSetOutputPortBeingMerged(rts, 0, 0);

      /* Update the BufferDstPort flags for each input port */
    }

    /* Level2 S-Function Block: template/<Root>/PCI-DDA08 12  (dacbpcidda0x12) */
    {
      SimStruct *rts = template_rtM->childSfunctions[1];

      /* timing info */
      time_T *sfcnPeriod = template_rtM->NonInlinedSFcns.Sfcn1.sfcnPeriod;
      time_T *sfcnOffset = template_rtM->NonInlinedSFcns.Sfcn1.sfcnOffset;
      int_T *sfcnTsMap = template_rtM->NonInlinedSFcns.Sfcn1.sfcnTsMap;
      (void) memset((void*)sfcnPeriod,0,
                    sizeof(time_T)*1);
      (void) memset((void*)sfcnOffset,0,
                    sizeof(time_T)*1);
      ssSetSampleTimePtr(rts, &sfcnPeriod[0]);
      ssSetOffsetTimePtr(rts, &sfcnOffset[0]);
      ssSetSampleTimeTaskIDPtr(rts, sfcnTsMap);

      /* Set up the mdlInfo pointer */
      {
        ssSetBlkInfo2Ptr(rts, &template_rtM->NonInlinedSFcns.blkInfo2[1]);
        ssSetRTWSfcnInfo(rts, template_rtM->sfcnInfo);
      }

      /* Allocate memory of model methods 2 */
      {
        ssSetModelMethods2(rts, &template_rtM->NonInlinedSFcns.methods2[1]);
      }

      /* inputs */
      {
        _ssSetNumInputPorts(rts, 1);
        ssSetPortInfoForInputs(rts,
          &template_rtM->NonInlinedSFcns.Sfcn1.inputPortInfo[0]);

        /* port 0 */
        {
          real_T const **sfcnUPtrs = (real_T const **)
            &template_rtM->NonInlinedSFcns.Sfcn1.UPtrs0;
          sfcnUPtrs[0] = &template_B.SineWave;
          ssSetInputPortSignalPtrs(rts, 0, (InputPtrsType)&sfcnUPtrs[0]);
          _ssSetInputPortNumDimensions(rts, 0, 1);
          ssSetInputPortWidth(rts, 0, 1);
        }
      }

      /* path info */
      ssSetModelName(rts, "PCI-DDA08 12 ");
      ssSetPath(rts, "template/PCI-DDA08 12 ");
      ssSetRTModel(rts,template_rtM);
      ssSetParentSS(rts, NULL);
      ssSetRootSS(rts, rts);
      ssSetVersion(rts, SIMSTRUCT_VERSION_LEVEL2);

      /* parameters */
      {
        mxArray **sfcnParams = (mxArray **)
          &template_rtM->NonInlinedSFcns.Sfcn1.params;
        ssSetSFcnParamsCount(rts, 7);
        ssSetSFcnParamsPtr(rts, &sfcnParams[0]);
        ssSetSFcnParam(rts, 0, (mxArray*)&template_P.PCIDDA0812_P1_Size[0]);
        ssSetSFcnParam(rts, 1, (mxArray*)&template_P.PCIDDA0812_P2_Size[0]);
        ssSetSFcnParam(rts, 2, (mxArray*)&template_P.PCIDDA0812_P3_Size[0]);
        ssSetSFcnParam(rts, 3, (mxArray*)&template_P.PCIDDA0812_P4_Size[0]);
        ssSetSFcnParam(rts, 4, (mxArray*)&template_P.PCIDDA0812_P5_Size[0]);
        ssSetSFcnParam(rts, 5, (mxArray*)&template_P.PCIDDA0812_P6_Size[0]);
        ssSetSFcnParam(rts, 6, (mxArray*)&template_P.PCIDDA0812_P7_Size[0]);
      }

      /* work vectors */
      ssSetRWork(rts, (real_T *) &template_DWork.PCIDDA0812_RWORK[0]);
      ssSetIWork(rts, (int_T *) &template_DWork.PCIDDA0812_IWORK[0]);

      {
        struct _ssDWorkRecord *dWorkRecord = (struct _ssDWorkRecord *)
          &template_rtM->NonInlinedSFcns.Sfcn1.dWork;
        struct _ssDWorkAuxRecord *dWorkAuxRecord = (struct _ssDWorkAuxRecord *)
          &template_rtM->NonInlinedSFcns.Sfcn1.dWorkAux;
        ssSetSFcnDWork(rts, dWorkRecord);
        ssSetSFcnDWorkAux(rts, dWorkAuxRecord);
        _ssSetNumDWork(rts, 2);

        /* RWORK */
        ssSetDWorkWidth(rts, 0, 16);
        ssSetDWorkDataType(rts, 0,SS_DOUBLE);
        ssSetDWorkComplexSignal(rts, 0, 0);
        ssSetDWork(rts, 0, &template_DWork.PCIDDA0812_RWORK[0]);

        /* IWORK */
        ssSetDWorkWidth(rts, 1, 4);
        ssSetDWorkDataType(rts, 1,SS_INTEGER);
        ssSetDWorkComplexSignal(rts, 1, 0);
        ssSetDWork(rts, 1, &template_DWork.PCIDDA0812_IWORK[0]);
      }

      /* registration */
      dacbpcidda0x12(rts);
      sfcnInitializeSizes(rts);
      sfcnInitializeSampleTimes(rts);

      /* adjust sample time */
      ssSetSampleTime(rts, 0, 0.002);
      ssSetOffsetTime(rts, 0, 0.0);
      sfcnTsMap[0] = 0;

      /* set compiled values of dynamic vector attributes */
      ssSetNumNonsampledZCs(rts, 0);

      /* Update connectivity flags for each port */
      _ssSetInputPortConnected(rts, 0, 1);

      /* Update the BufferDstPort flags for each input port */
      ssSetInputPortBufferDstPort(rts, 0, -1);
    }
  }
}

/* Model terminate function */
void template_terminate(void)
{
  /* Level2 S-Function Block: '<Root>/PCI-DAS1602 12 ' (adcbpcidas1600) */
  {
    SimStruct *rts = template_rtM->childSfunctions[0];
    sfcnTerminate(rts);
  }

  /* Level2 S-Function Block: '<Root>/PCI-DDA08 12 ' (dacbpcidda0x12) */
  {
    SimStruct *rts = template_rtM->childSfunctions[1];
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
  template_output(tid);
}

void MdlUpdate(int_T tid)
{
  template_update(tid);
}

void MdlInitializeSizes(void)
{
  template_rtM->Sizes.numContStates = (0);/* Number of continuous states */
  template_rtM->Sizes.numY = (0);      /* Number of model outputs */
  template_rtM->Sizes.numU = (0);      /* Number of model inputs */
  template_rtM->Sizes.sysDirFeedThru = (0);/* The model is not direct feedthrough */
  template_rtM->Sizes.numSampTimes = (1);/* Number of sample times */
  template_rtM->Sizes.numBlocks = (4); /* Number of blocks */
  template_rtM->Sizes.numBlockIO = (2);/* Number of block outputs */
  template_rtM->Sizes.numBlockPrms = (55);/* Sum of parameter "widths" */
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
    SimStruct *rts = template_rtM->childSfunctions[0];
    sfcnStart(rts);
    if (ssGetErrorStatus(rts) != NULL)
      return;
  }

  /* Level2 S-Function Block: '<Root>/PCI-DDA08 12 ' (dacbpcidda0x12) */
  {
    SimStruct *rts = template_rtM->childSfunctions[1];
    sfcnStart(rts);
    if (ssGetErrorStatus(rts) != NULL)
      return;
  }

  MdlInitialize();

  /* Enable for Sin: '<Root>/Sine Wave' */
  template_DWork.systemEnable = 1;
}

rtModel_template *template(void)
{
  template_initialize(1);
  return template_rtM;
}

void MdlTerminate(void)
{
  template_terminate();
}

/*========================================================================*
 * End of GRT compatible call interface                                   *
 *========================================================================*/
