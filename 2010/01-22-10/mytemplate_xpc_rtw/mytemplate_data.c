/*
 * mytemplate_data.c
 *
 * Real-Time Workshop code generation for Simulink model "mytemplate.mdl".
 *
 * Model Version              : 1.20
 * Real-Time Workshop version : 7.1  (R2008a)  23-Jan-2008
 * C source code generated on : Tue Jul 07 16:31:21 2009
 */

#include "mytemplate.h"
#include "mytemplate_private.h"

/* Block parameters (auto storage) */
Parameters_mytemplate mytemplate_P = {
  /*  PCIDAS160212_P1_Size : '<Root>/PCI-DAS1602 12 '
   */
  { 1.0, 1.0 },
  14.0,                                /* PCIDAS160212_P1 : '<Root>/PCI-DAS1602 12 '
                                        */

  /*  PCIDAS160212_P2_Size : '<Root>/PCI-DAS1602 12 '
   */
  { 1.0, 1.0 },
  1.0,                                 /* PCIDAS160212_P2 : '<Root>/PCI-DAS1602 12 '
                                        */

  /*  PCIDAS160212_P3_Size : '<Root>/PCI-DAS1602 12 '
   */
  { 1.0, 1.0 },
  0.0048828125,                        /* PCIDAS160212_P3 : '<Root>/PCI-DAS1602 12 '
                                        */

  /*  PCIDAS160212_P4_Size : '<Root>/PCI-DAS1602 12 '
   */
  { 1.0, 1.0 },
  10.0,                                /* PCIDAS160212_P4 : '<Root>/PCI-DAS1602 12 '
                                        */

  /*  PCIDAS160212_P5_Size : '<Root>/PCI-DAS1602 12 '
   */
  { 1.0, 1.0 },
  4.0,                                 /* PCIDAS160212_P5 : '<Root>/PCI-DAS1602 12 '
                                        */

  /*  PCIDAS160212_P6_Size : '<Root>/PCI-DAS1602 12 '
   */
  { 1.0, 1.0 },
  1.0,                                 /* PCIDAS160212_P6 : '<Root>/PCI-DAS1602 12 '
                                        */

  /*  PCIDAS160212_P7_Size : '<Root>/PCI-DAS1602 12 '
   */
  { 1.0, 1.0 },
  0.0005,                              /* PCIDAS160212_P7 : '<Root>/PCI-DAS1602 12 '
                                        */

  /*  PCIDAS160212_P8_Size : '<Root>/PCI-DAS1602 12 '
   */
  { 1.0, 1.0 },
  -1.0,                                /* PCIDAS160212_P8 : '<Root>/PCI-DAS1602 12 '
                                        */

  /*  PCIDAS160212_P9_Size : '<Root>/PCI-DAS1602 12 '
   */
  { 1.0, 1.0 },
  1.0,                                 /* PCIDAS160212_P9 : '<Root>/PCI-DAS1602 12 '
                                        */
  3.0,                                 /* SineWave_Amp : '<Root>/Sine Wave'
                                        */
  0.0,                                 /* SineWave_Bias : '<Root>/Sine Wave'
                                        */
  150.0,                               /* SineWave_Freq : '<Root>/Sine Wave'
                                        */
  7.4929707272742341E-002,             /* SineWave_Hsin : '<Root>/Sine Wave'
                                        */
  9.9718881811220750E-001,             /* SineWave_HCos : '<Root>/Sine Wave'
                                        */
  -7.4929707272742341E-002,            /* SineWave_PSin : '<Root>/Sine Wave'
                                        */
  9.9718881811220750E-001,             /* SineWave_PCos : '<Root>/Sine Wave'
                                        */
  0.0,                                 /* SineWave1_Amp : '<Root>/Sine Wave1'
                                        */
  0.0,                                 /* SineWave1_Bias : '<Root>/Sine Wave1'
                                        */
  200.0,                               /* SineWave1_Freq : '<Root>/Sine Wave1'
                                        */
  9.9833416646828155E-002,             /* SineWave1_Hsin : '<Root>/Sine Wave1'
                                        */
  9.9500416527802571E-001,             /* SineWave1_HCos : '<Root>/Sine Wave1'
                                        */
  -9.9833416646828155E-002,            /* SineWave1_PSin : '<Root>/Sine Wave1'
                                        */
  9.9500416527802571E-001,             /* SineWave1_PCos : '<Root>/Sine Wave1'
                                        */
  0.0,                                 /* SineWave2_Amp : '<Root>/Sine Wave2'
                                        */
  0.0,                                 /* SineWave2_Bias : '<Root>/Sine Wave2'
                                        */
  200.0,                               /* SineWave2_Freq : '<Root>/Sine Wave2'
                                        */
  9.9833416646828155E-002,             /* SineWave2_Hsin : '<Root>/Sine Wave2'
                                        */
  9.9500416527802571E-001,             /* SineWave2_HCos : '<Root>/Sine Wave2'
                                        */
  -9.9833416646828155E-002,            /* SineWave2_PSin : '<Root>/Sine Wave2'
                                        */
  9.9500416527802571E-001,             /* SineWave2_PCos : '<Root>/Sine Wave2'
                                        */
  0.0,                                 /* SineWave3_Amp : '<Root>/Sine Wave3'
                                        */
  0.0,                                 /* SineWave3_Bias : '<Root>/Sine Wave3'
                                        */
  200.0,                               /* SineWave3_Freq : '<Root>/Sine Wave3'
                                        */
  9.9833416646828155E-002,             /* SineWave3_Hsin : '<Root>/Sine Wave3'
                                        */
  9.9500416527802571E-001,             /* SineWave3_HCos : '<Root>/Sine Wave3'
                                        */
  -9.9833416646828155E-002,            /* SineWave3_PSin : '<Root>/Sine Wave3'
                                        */
  9.9500416527802571E-001,             /* SineWave3_PCos : '<Root>/Sine Wave3'
                                        */
  0.0,                                 /* SineWave4_Amp : '<Root>/Sine Wave4'
                                        */
  0.0,                                 /* SineWave4_Bias : '<Root>/Sine Wave4'
                                        */
  200.0,                               /* SineWave4_Freq : '<Root>/Sine Wave4'
                                        */
  9.9833416646828155E-002,             /* SineWave4_Hsin : '<Root>/Sine Wave4'
                                        */
  9.9500416527802571E-001,             /* SineWave4_HCos : '<Root>/Sine Wave4'
                                        */
  -9.9833416646828155E-002,            /* SineWave4_PSin : '<Root>/Sine Wave4'
                                        */
  9.9500416527802571E-001,             /* SineWave4_PCos : '<Root>/Sine Wave4'
                                        */
  0.0,                                 /* SineWave5_Amp : '<Root>/Sine Wave5'
                                        */
  0.0,                                 /* SineWave5_Bias : '<Root>/Sine Wave5'
                                        */
  200.0,                               /* SineWave5_Freq : '<Root>/Sine Wave5'
                                        */
  9.9833416646828155E-002,             /* SineWave5_Hsin : '<Root>/Sine Wave5'
                                        */
  9.9500416527802571E-001,             /* SineWave5_HCos : '<Root>/Sine Wave5'
                                        */
  -9.9833416646828155E-002,            /* SineWave5_PSin : '<Root>/Sine Wave5'
                                        */
  9.9500416527802571E-001,             /* SineWave5_PCos : '<Root>/Sine Wave5'
                                        */

  /*  PCIDDA0812_P1_Size : '<Root>/PCI-DDA08 12 '
   */
  { 1.0, 6.0 },

  /*  PCIDDA0812_P1 : '<Root>/PCI-DDA08 12 '
   */
  { 1.0, 2.0, 3.0, 4.0, 5.0, 6.0 },

  /*  PCIDDA0812_P2_Size : '<Root>/PCI-DDA08 12 '
   */
  { 1.0, 6.0 },

  /*  PCIDDA0812_P2 : '<Root>/PCI-DDA08 12 '
   */
  { -10.0, -10.0, -10.0, -10.0, -10.0, -10.0 },

  /*  PCIDDA0812_P3_Size : '<Root>/PCI-DDA08 12 '
   */
  { 1.0, 6.0 },

  /*  PCIDDA0812_P3 : '<Root>/PCI-DDA08 12 '
   */
  { 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 },

  /*  PCIDDA0812_P4_Size : '<Root>/PCI-DDA08 12 '
   */
  { 1.0, 6.0 },

  /*  PCIDDA0812_P4 : '<Root>/PCI-DDA08 12 '
   */
  { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 },

  /*  PCIDDA0812_P5_Size : '<Root>/PCI-DDA08 12 '
   */
  { 1.0, 1.0 },
  0.0005,                              /* PCIDDA0812_P5 : '<Root>/PCI-DDA08 12 '
                                        */

  /*  PCIDDA0812_P6_Size : '<Root>/PCI-DDA08 12 '
   */
  { 1.0, 1.0 },
  -1.0,                                /* PCIDDA0812_P6 : '<Root>/PCI-DDA08 12 '
                                        */

  /*  PCIDDA0812_P7_Size : '<Root>/PCI-DDA08 12 '
   */
  { 1.0, 1.0 },
  3.0                                  /* PCIDDA0812_P7 : '<Root>/PCI-DDA08 12 '
                                        */
};
