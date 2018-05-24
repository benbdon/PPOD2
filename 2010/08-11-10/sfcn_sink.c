/*
 *   sfcn_sink.c Simple C-MEX S-function for function call.
 *
 *   ABSTRACT:
 *     The purpose of this sfunction is to call a simple legacy
 *     function during simulation:
 *
 *        sinkOutput(double u1[1], double p1[1], uint16 work1[1], double work2[1])
 *
 *   Simulink version           : 7.1 (R2008a) 23-Jan-2008
 *   C source code generated on : 10-Jul-2009 10:58:51
 */

/*
   %%%-MATLAB_Construction_Commands_Start
   def = legacy_code('initialize');
   def.SFunctionName = 'sfcn_sink';
   def.OutputFcnSpec = 'sinkOutput(double u1[1], double p1[1], uint16 work1[1], double work2[1])';
   def.StartFcnSpec = 'sinkStart(uint16 work1[1], double work2[1])';
   def.TerminateFcnSpec = 'sinkTerminate(uint16 work1[1])';
   def.HeaderFiles = {'sink.h'};
   def.SourceFiles = {'sink.c'};
   def.IncPaths = {'C:\Documents and Settings\LIMS\Desktop\PPOD_6D\06-18-09'};
   legacy_code('sfcn_cmex_generate', def);
   legacy_code('compile', def);
   %%%-MATLAB_Construction_Commands_End
 */

/*
 * Must specify the S_FUNCTION_NAME as the name of the S-function.
 */
#define S_FUNCTION_NAME                sfcn_sink
#define S_FUNCTION_LEVEL               2

/*
 * Need to include simstruc.h for the definition of the SimStruct and
 * its associated macro definitions.
 */
#include "simstruc.h"

/*
 * Specific header file(s) required by the legacy code function.
 */
#include "sink.h"
#define EDIT_OK(S, P_IDX) \
 (!((ssGetSimMode(S)==SS_SIMMODE_SIZES_CALL_ONLY) && mxIsEmpty(ssGetSFcnParam(S, P_IDX))))
#define MDL_CHECK_PARAMETERS
#if defined(MDL_CHECK_PARAMETERS) && defined(MATLAB_MEX_FILE)

/* Function: mdlCheckParameters ===========================================
 * Abstract:
 *    mdlCheckParameters verifies new parameter settings whenever parameter
 *    change or are re-evaluated during a simulation. When a simulation is
 *    running, changes to S-function parameters can occur at any time during
 *    the simulation loop.
 */
static void mdlCheckParameters(SimStruct *S)
{
  /*
   * Check the parameter 1
   */
  if EDIT_OK(S, 0) {
    int_T dimsArray[2] = { 1, 1 };

    /* Check the parameter attributes */
    ssCheckSFcnParamValueAttribs(S, 0, "P1", DYNAMICALLY_TYPED, 2, dimsArray, 0);
  }
}

#endif

/* Function: mdlInitializeSizes ===========================================
 * Abstract:
 *    The sizes information is used by Simulink to determine the S-function
 *    block's characteristics (number of inputs, outputs, states, etc.).
 */
static void mdlInitializeSizes(SimStruct *S)
{
  /* Number of expected parameters */
  ssSetNumSFcnParams(S, 1);

#if defined(MATLAB_MEX_FILE)

  if (ssGetNumSFcnParams(S) == ssGetSFcnParamsCount(S)) {
    /*
     * If the the number of expected input parameters is not equal
     * to the number of parameters entered in the dialog box return.
     * Simulink will generate an error indicating that there is a
     * parameter mismatch.
     */
    mdlCheckParameters(S);
    if (ssGetErrorStatus(S) != NULL) {
      return;
    }
  } else {
    /* Return if number of expected != number of actual parameters */
    return;
  }

#endif

  /* Set the parameter's tunability */
  ssSetSFcnParamTunable(S, 0, 1);

  /*
   * Set the number of pworks.
   */
  ssSetNumPWork(S, 0);

  /*
   * Set the number of dworks.
   */
  if (! ssSetNumDWork(S, 2))
    return;

  /*
   * Configure the dwork 1 (work1)
   */
  ssSetDWorkDataType(S, 0, SS_UINT16);
  ssSetDWorkUsageType(S, 0, SS_DWORK_USED_AS_DWORK);
  ssSetDWorkName(S, 0, "work1");
  ssSetDWorkWidth(S, 0, 1);
  ssSetDWorkComplexSignal(S, 0, COMPLEX_NO);

  /*
   * Configure the dwork 2 (work2)
   */
  ssSetDWorkDataType(S, 1, SS_DOUBLE);
  ssSetDWorkUsageType(S, 1, SS_DWORK_USED_AS_DWORK);
  ssSetDWorkName(S, 1, "work2");
  ssSetDWorkWidth(S, 1, 1);
  ssSetDWorkComplexSignal(S, 1, COMPLEX_NO);

  /*
   * Set the number of input ports.
   */
  if (!ssSetNumInputPorts(S, 1))
    return;

  /*
   * Configure the input port 1
   */
  ssSetInputPortDataType(S, 0, SS_DOUBLE);
  ssSetInputPortWidth(S, 0, 1);
  ssSetInputPortComplexSignal(S, 0, COMPLEX_NO);
  ssSetInputPortDirectFeedThrough(S, 0, 1);
  ssSetInputPortAcceptExprInRTW(S, 0, 0);
  ssSetInputPortOverWritable(S, 0, 0);
  ssSetInputPortOptimOpts(S, 0, SS_REUSABLE_AND_LOCAL);
  ssSetInputPortRequiredContiguous(S, 0, 1);

  /*
   * Set the number of output ports.
   */
  if (!ssSetNumOutputPorts(S, 0))
    return;

  /*
   * Register reserved identifiers to avoid name conflict
   */
  if (ssGetSimMode(S) == SS_SIMMODE_RTWGEN) {
    /*
     * Register reserved identifier for StartFcnSpec
     */
    ssRegMdlInfo(S, "sinkStart", MDL_INFO_ID_RESERVED, 0, 0, (void*) ssGetPath(S));

    /*
     * Register reserved identifier for OutputFcnSpec
     */
    ssRegMdlInfo(S, "sinkOutput", MDL_INFO_ID_RESERVED, 0, 0, (void*) ssGetPath
                 (S));

    /*
     * Register reserved identifier for TerminateFcnSpec
     */
    ssRegMdlInfo(S, "sinkTerminate", MDL_INFO_ID_RESERVED, 0, 0, (void*)
                 ssGetPath(S));
  }

  /*
   * Set the number of sample time.
   */
  ssSetNumSampleTimes(S, 1);

  /*
   * All options have the form SS_OPTION_<name> and are documented in
   * matlabroot/simulink/include/simstruc.h. The options should be
   * bitwise or'd together as in
   *   ssSetOptions(S, (SS_OPTION_name1 | SS_OPTION_name2))
   */
  ssSetOptions(S,
               SS_OPTION_USE_TLC_WITH_ACCELERATOR |
               SS_OPTION_CAN_BE_CALLED_CONDITIONALLY |
               SS_OPTION_EXCEPTION_FREE_CODE |
               SS_OPTION_WORKS_WITH_CODE_REUSE |
               SS_OPTION_SFUNCTION_INLINED_FOR_RTW |
               SS_OPTION_DISALLOW_CONSTANT_SAMPLE_TIME);
}

/* Function: mdlInitializeSampleTimes =====================================
 * Abstract:
 *    This function is used to specify the sample time(s) for your
 *    S-function. You must register the same number of sample times as
 *    specified in ssSetNumSampleTimes.
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
  ssSetSampleTime(S, 0, INHERITED_SAMPLE_TIME);
  ssSetOffsetTime(S, 0, FIXED_IN_MINOR_STEP_OFFSET);

#if defined(ssSetModelReferenceSampleTimeDefaultInheritance)

  ssSetModelReferenceSampleTimeDefaultInheritance(S);

#endif

}

#define MDL_SET_WORK_WIDTHS
#if defined(MDL_SET_WORK_WIDTHS) && defined(MATLAB_MEX_FILE)

/* Function: mdlSetWorkWidths =============================================
 * Abstract:
 *      The optional method, mdlSetWorkWidths is called after input port
 *      width, output port width, and sample times of the S-function have
 *      been determined to set any state and work vector sizes which are
 *      a function of the input, output, and/or sample times.
 *
 *      Run-time parameters are registered in this method using methods
 *      ssSetNumRunTimeParams, ssSetRunTimeParamInfo, and related methods.
 */
static void mdlSetWorkWidths(SimStruct *S)
{
  /* Set number of run-time parameters */
  if (!ssSetNumRunTimeParams(S, 1))
    return;

  /*
   * Register the run-time parameter 1
   */
  ssRegDlgParamAsRunTimeParam(S, 0, 0, "p1", ssGetDataTypeId(S, "double"));
}

#endif

#define MDL_START
#if defined(MDL_START)

/* Function: mdlStart =====================================================
 * Abstract:
 *    This function is called once at start of model execution. If you
 *    have states that should be initialized once, this is the place
 *    to do it.
 */
static void mdlStart(SimStruct *S)
{
  /*
   * Get access to Parameter/Input/Output/DWork/size information
   */
  uint16_T *work1 = (uint16_T *) ssGetDWork(S, 0);
  real_T *work2 = (real_T *) ssGetDWork(S, 1);

  /*
   * Call the legacy code function
   */
  sinkStart( work1, work2);
}

#endif

/* Function: mdlOutputs ===================================================
 * Abstract:
 *    In this function, you compute the outputs of your S-function
 *    block. Generally outputs are placed in the output vector(s),
 *    ssGetOutputPortSignal.
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{
  /*
   * Get access to Parameter/Input/Output/DWork/size information
   */
  real_T *p1 = (real_T *) ssGetRunTimeParamInfo(S, 0)->data;
  real_T *u1 = (real_T *) ssGetInputPortSignal(S, 0);
  uint16_T *work1 = (uint16_T *) ssGetDWork(S, 0);
  real_T *work2 = (real_T *) ssGetDWork(S, 1);

  /*
   * Call the legacy code function
   */
  sinkOutput( u1, p1, work1, work2);
}

/* Function: mdlTerminate =================================================
 * Abstract:
 *    In this function, you should perform any actions that are necessary
 *    at the termination of a simulation.
 */
static void mdlTerminate(SimStruct *S)
{
  /*
   * Get access to Parameter/Input/Output/DWork/size information
   */
  uint16_T *work1 = (uint16_T *) ssGetDWork(S, 0);

  /*
   * Call the legacy code function
   */
  sinkTerminate( work1);
}

/*
 * Required S-function trailer
 */
#ifdef MATLAB_MEX_FILE
# include "simulink.c"
#else
# include "cg_sfun.h"
#endif
