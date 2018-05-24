  function targMap = targDataMap(),

  ;%***********************
  ;% Create Parameter Map *
  ;%***********************
      
    nTotData      = 0; %add to this count as we go
    nTotSects     = 1;
    sectIdxOffset = 0;
    
    ;%
    ;% Define dummy sections & preallocate arrays
    ;%
    dumSection.nData = -1;  
    dumSection.data  = [];
    
    dumData.logicalSrcIdx = -1;
    dumData.dtTransOffset = -1;
    
    ;%
    ;% Init/prealloc paramMap
    ;%
    paramMap.nSections           = nTotSects;
    paramMap.sectIdxOffset       = sectIdxOffset;
      paramMap.sections(nTotSects) = dumSection; %prealloc
    paramMap.nTotData            = -1;
    
    ;%
    ;% Auto data (mytemplate_P)
    ;%
      section.nData     = 74;
      section.data(74)  = dumData; %prealloc
      
	  ;% mytemplate_P.PCIDAS160212_P1_Size
	  section.data(1).logicalSrcIdx = 0;
	  section.data(1).dtTransOffset = 0;
	
	  ;% mytemplate_P.PCIDAS160212_P1
	  section.data(2).logicalSrcIdx = 1;
	  section.data(2).dtTransOffset = 2;
	
	  ;% mytemplate_P.PCIDAS160212_P2_Size
	  section.data(3).logicalSrcIdx = 2;
	  section.data(3).dtTransOffset = 3;
	
	  ;% mytemplate_P.PCIDAS160212_P2
	  section.data(4).logicalSrcIdx = 3;
	  section.data(4).dtTransOffset = 5;
	
	  ;% mytemplate_P.PCIDAS160212_P3_Size
	  section.data(5).logicalSrcIdx = 4;
	  section.data(5).dtTransOffset = 6;
	
	  ;% mytemplate_P.PCIDAS160212_P3
	  section.data(6).logicalSrcIdx = 5;
	  section.data(6).dtTransOffset = 8;
	
	  ;% mytemplate_P.PCIDAS160212_P4_Size
	  section.data(7).logicalSrcIdx = 6;
	  section.data(7).dtTransOffset = 9;
	
	  ;% mytemplate_P.PCIDAS160212_P4
	  section.data(8).logicalSrcIdx = 7;
	  section.data(8).dtTransOffset = 11;
	
	  ;% mytemplate_P.PCIDAS160212_P5_Size
	  section.data(9).logicalSrcIdx = 8;
	  section.data(9).dtTransOffset = 12;
	
	  ;% mytemplate_P.PCIDAS160212_P5
	  section.data(10).logicalSrcIdx = 9;
	  section.data(10).dtTransOffset = 14;
	
	  ;% mytemplate_P.PCIDAS160212_P6_Size
	  section.data(11).logicalSrcIdx = 10;
	  section.data(11).dtTransOffset = 15;
	
	  ;% mytemplate_P.PCIDAS160212_P6
	  section.data(12).logicalSrcIdx = 11;
	  section.data(12).dtTransOffset = 17;
	
	  ;% mytemplate_P.PCIDAS160212_P7_Size
	  section.data(13).logicalSrcIdx = 12;
	  section.data(13).dtTransOffset = 18;
	
	  ;% mytemplate_P.PCIDAS160212_P7
	  section.data(14).logicalSrcIdx = 13;
	  section.data(14).dtTransOffset = 20;
	
	  ;% mytemplate_P.PCIDAS160212_P8_Size
	  section.data(15).logicalSrcIdx = 14;
	  section.data(15).dtTransOffset = 21;
	
	  ;% mytemplate_P.PCIDAS160212_P8
	  section.data(16).logicalSrcIdx = 15;
	  section.data(16).dtTransOffset = 23;
	
	  ;% mytemplate_P.PCIDAS160212_P9_Size
	  section.data(17).logicalSrcIdx = 16;
	  section.data(17).dtTransOffset = 24;
	
	  ;% mytemplate_P.PCIDAS160212_P9
	  section.data(18).logicalSrcIdx = 17;
	  section.data(18).dtTransOffset = 26;
	
	  ;% mytemplate_P.SineWave_Amp
	  section.data(19).logicalSrcIdx = 18;
	  section.data(19).dtTransOffset = 27;
	
	  ;% mytemplate_P.SineWave_Bias
	  section.data(20).logicalSrcIdx = 19;
	  section.data(20).dtTransOffset = 28;
	
	  ;% mytemplate_P.SineWave_Freq
	  section.data(21).logicalSrcIdx = 20;
	  section.data(21).dtTransOffset = 29;
	
	  ;% mytemplate_P.SineWave_Hsin
	  section.data(22).logicalSrcIdx = 21;
	  section.data(22).dtTransOffset = 30;
	
	  ;% mytemplate_P.SineWave_HCos
	  section.data(23).logicalSrcIdx = 22;
	  section.data(23).dtTransOffset = 31;
	
	  ;% mytemplate_P.SineWave_PSin
	  section.data(24).logicalSrcIdx = 23;
	  section.data(24).dtTransOffset = 32;
	
	  ;% mytemplate_P.SineWave_PCos
	  section.data(25).logicalSrcIdx = 24;
	  section.data(25).dtTransOffset = 33;
	
	  ;% mytemplate_P.SineWave1_Amp
	  section.data(26).logicalSrcIdx = 25;
	  section.data(26).dtTransOffset = 34;
	
	  ;% mytemplate_P.SineWave1_Bias
	  section.data(27).logicalSrcIdx = 26;
	  section.data(27).dtTransOffset = 35;
	
	  ;% mytemplate_P.SineWave1_Freq
	  section.data(28).logicalSrcIdx = 27;
	  section.data(28).dtTransOffset = 36;
	
	  ;% mytemplate_P.SineWave1_Hsin
	  section.data(29).logicalSrcIdx = 28;
	  section.data(29).dtTransOffset = 37;
	
	  ;% mytemplate_P.SineWave1_HCos
	  section.data(30).logicalSrcIdx = 29;
	  section.data(30).dtTransOffset = 38;
	
	  ;% mytemplate_P.SineWave1_PSin
	  section.data(31).logicalSrcIdx = 30;
	  section.data(31).dtTransOffset = 39;
	
	  ;% mytemplate_P.SineWave1_PCos
	  section.data(32).logicalSrcIdx = 31;
	  section.data(32).dtTransOffset = 40;
	
	  ;% mytemplate_P.SineWave2_Amp
	  section.data(33).logicalSrcIdx = 32;
	  section.data(33).dtTransOffset = 41;
	
	  ;% mytemplate_P.SineWave2_Bias
	  section.data(34).logicalSrcIdx = 33;
	  section.data(34).dtTransOffset = 42;
	
	  ;% mytemplate_P.SineWave2_Freq
	  section.data(35).logicalSrcIdx = 34;
	  section.data(35).dtTransOffset = 43;
	
	  ;% mytemplate_P.SineWave2_Hsin
	  section.data(36).logicalSrcIdx = 35;
	  section.data(36).dtTransOffset = 44;
	
	  ;% mytemplate_P.SineWave2_HCos
	  section.data(37).logicalSrcIdx = 36;
	  section.data(37).dtTransOffset = 45;
	
	  ;% mytemplate_P.SineWave2_PSin
	  section.data(38).logicalSrcIdx = 37;
	  section.data(38).dtTransOffset = 46;
	
	  ;% mytemplate_P.SineWave2_PCos
	  section.data(39).logicalSrcIdx = 38;
	  section.data(39).dtTransOffset = 47;
	
	  ;% mytemplate_P.SineWave3_Amp
	  section.data(40).logicalSrcIdx = 39;
	  section.data(40).dtTransOffset = 48;
	
	  ;% mytemplate_P.SineWave3_Bias
	  section.data(41).logicalSrcIdx = 40;
	  section.data(41).dtTransOffset = 49;
	
	  ;% mytemplate_P.SineWave3_Freq
	  section.data(42).logicalSrcIdx = 41;
	  section.data(42).dtTransOffset = 50;
	
	  ;% mytemplate_P.SineWave3_Hsin
	  section.data(43).logicalSrcIdx = 42;
	  section.data(43).dtTransOffset = 51;
	
	  ;% mytemplate_P.SineWave3_HCos
	  section.data(44).logicalSrcIdx = 43;
	  section.data(44).dtTransOffset = 52;
	
	  ;% mytemplate_P.SineWave3_PSin
	  section.data(45).logicalSrcIdx = 44;
	  section.data(45).dtTransOffset = 53;
	
	  ;% mytemplate_P.SineWave3_PCos
	  section.data(46).logicalSrcIdx = 45;
	  section.data(46).dtTransOffset = 54;
	
	  ;% mytemplate_P.SineWave4_Amp
	  section.data(47).logicalSrcIdx = 46;
	  section.data(47).dtTransOffset = 55;
	
	  ;% mytemplate_P.SineWave4_Bias
	  section.data(48).logicalSrcIdx = 47;
	  section.data(48).dtTransOffset = 56;
	
	  ;% mytemplate_P.SineWave4_Freq
	  section.data(49).logicalSrcIdx = 48;
	  section.data(49).dtTransOffset = 57;
	
	  ;% mytemplate_P.SineWave4_Hsin
	  section.data(50).logicalSrcIdx = 49;
	  section.data(50).dtTransOffset = 58;
	
	  ;% mytemplate_P.SineWave4_HCos
	  section.data(51).logicalSrcIdx = 50;
	  section.data(51).dtTransOffset = 59;
	
	  ;% mytemplate_P.SineWave4_PSin
	  section.data(52).logicalSrcIdx = 51;
	  section.data(52).dtTransOffset = 60;
	
	  ;% mytemplate_P.SineWave4_PCos
	  section.data(53).logicalSrcIdx = 52;
	  section.data(53).dtTransOffset = 61;
	
	  ;% mytemplate_P.SineWave5_Amp
	  section.data(54).logicalSrcIdx = 53;
	  section.data(54).dtTransOffset = 62;
	
	  ;% mytemplate_P.SineWave5_Bias
	  section.data(55).logicalSrcIdx = 54;
	  section.data(55).dtTransOffset = 63;
	
	  ;% mytemplate_P.SineWave5_Freq
	  section.data(56).logicalSrcIdx = 55;
	  section.data(56).dtTransOffset = 64;
	
	  ;% mytemplate_P.SineWave5_Hsin
	  section.data(57).logicalSrcIdx = 56;
	  section.data(57).dtTransOffset = 65;
	
	  ;% mytemplate_P.SineWave5_HCos
	  section.data(58).logicalSrcIdx = 57;
	  section.data(58).dtTransOffset = 66;
	
	  ;% mytemplate_P.SineWave5_PSin
	  section.data(59).logicalSrcIdx = 58;
	  section.data(59).dtTransOffset = 67;
	
	  ;% mytemplate_P.SineWave5_PCos
	  section.data(60).logicalSrcIdx = 59;
	  section.data(60).dtTransOffset = 68;
	
	  ;% mytemplate_P.PCIDDA0812_P1_Size
	  section.data(61).logicalSrcIdx = 60;
	  section.data(61).dtTransOffset = 69;
	
	  ;% mytemplate_P.PCIDDA0812_P1
	  section.data(62).logicalSrcIdx = 61;
	  section.data(62).dtTransOffset = 71;
	
	  ;% mytemplate_P.PCIDDA0812_P2_Size
	  section.data(63).logicalSrcIdx = 62;
	  section.data(63).dtTransOffset = 77;
	
	  ;% mytemplate_P.PCIDDA0812_P2
	  section.data(64).logicalSrcIdx = 63;
	  section.data(64).dtTransOffset = 79;
	
	  ;% mytemplate_P.PCIDDA0812_P3_Size
	  section.data(65).logicalSrcIdx = 64;
	  section.data(65).dtTransOffset = 85;
	
	  ;% mytemplate_P.PCIDDA0812_P3
	  section.data(66).logicalSrcIdx = 65;
	  section.data(66).dtTransOffset = 87;
	
	  ;% mytemplate_P.PCIDDA0812_P4_Size
	  section.data(67).logicalSrcIdx = 66;
	  section.data(67).dtTransOffset = 93;
	
	  ;% mytemplate_P.PCIDDA0812_P4
	  section.data(68).logicalSrcIdx = 67;
	  section.data(68).dtTransOffset = 95;
	
	  ;% mytemplate_P.PCIDDA0812_P5_Size
	  section.data(69).logicalSrcIdx = 68;
	  section.data(69).dtTransOffset = 101;
	
	  ;% mytemplate_P.PCIDDA0812_P5
	  section.data(70).logicalSrcIdx = 69;
	  section.data(70).dtTransOffset = 103;
	
	  ;% mytemplate_P.PCIDDA0812_P6_Size
	  section.data(71).logicalSrcIdx = 70;
	  section.data(71).dtTransOffset = 104;
	
	  ;% mytemplate_P.PCIDDA0812_P6
	  section.data(72).logicalSrcIdx = 71;
	  section.data(72).dtTransOffset = 106;
	
	  ;% mytemplate_P.PCIDDA0812_P7_Size
	  section.data(73).logicalSrcIdx = 72;
	  section.data(73).dtTransOffset = 107;
	
	  ;% mytemplate_P.PCIDDA0812_P7
	  section.data(74).logicalSrcIdx = 73;
	  section.data(74).dtTransOffset = 109;
	
      nTotData = nTotData + section.nData;
      paramMap.sections(1) = section;
      clear section
      
    
      ;%
      ;% Non-auto Data (parameter)
      ;%
    

    ;%
    ;% Add final counts to struct.
    ;%
    paramMap.nTotData = nTotData;
    


  ;%**************************
  ;% Create Block Output Map *
  ;%**************************
      
    nTotData      = 0; %add to this count as we go
    nTotSects     = 1;
    sectIdxOffset = 0;
    
    ;%
    ;% Define dummy sections & preallocate arrays
    ;%
    dumSection.nData = -1;  
    dumSection.data  = [];
    
    dumData.logicalSrcIdx = -1;
    dumData.dtTransOffset = -1;
    
    ;%
    ;% Init/prealloc sigMap
    ;%
    sigMap.nSections           = nTotSects;
    sigMap.sectIdxOffset       = sectIdxOffset;
      sigMap.sections(nTotSects) = dumSection; %prealloc
    sigMap.nTotData            = -1;
    
    ;%
    ;% Auto data (mytemplate_B)
    ;%
      section.nData     = 20;
      section.data(20)  = dumData; %prealloc
      
	  ;% mytemplate_B.PCIDAS160212_o1
	  section.data(1).logicalSrcIdx = 0;
	  section.data(1).dtTransOffset = 0;
	
	  ;% mytemplate_B.PCIDAS160212_o2
	  section.data(2).logicalSrcIdx = 1;
	  section.data(2).dtTransOffset = 1;
	
	  ;% mytemplate_B.PCIDAS160212_o3
	  section.data(3).logicalSrcIdx = 2;
	  section.data(3).dtTransOffset = 2;
	
	  ;% mytemplate_B.PCIDAS160212_o4
	  section.data(4).logicalSrcIdx = 3;
	  section.data(4).dtTransOffset = 3;
	
	  ;% mytemplate_B.PCIDAS160212_o5
	  section.data(5).logicalSrcIdx = 4;
	  section.data(5).dtTransOffset = 4;
	
	  ;% mytemplate_B.PCIDAS160212_o6
	  section.data(6).logicalSrcIdx = 5;
	  section.data(6).dtTransOffset = 5;
	
	  ;% mytemplate_B.PCIDAS160212_o7
	  section.data(7).logicalSrcIdx = 6;
	  section.data(7).dtTransOffset = 6;
	
	  ;% mytemplate_B.PCIDAS160212_o8
	  section.data(8).logicalSrcIdx = 7;
	  section.data(8).dtTransOffset = 7;
	
	  ;% mytemplate_B.PCIDAS160212_o9
	  section.data(9).logicalSrcIdx = 8;
	  section.data(9).dtTransOffset = 8;
	
	  ;% mytemplate_B.PCIDAS160212_o10
	  section.data(10).logicalSrcIdx = 9;
	  section.data(10).dtTransOffset = 9;
	
	  ;% mytemplate_B.PCIDAS160212_o11
	  section.data(11).logicalSrcIdx = 10;
	  section.data(11).dtTransOffset = 10;
	
	  ;% mytemplate_B.PCIDAS160212_o12
	  section.data(12).logicalSrcIdx = 11;
	  section.data(12).dtTransOffset = 11;
	
	  ;% mytemplate_B.PCIDAS160212_o13
	  section.data(13).logicalSrcIdx = 12;
	  section.data(13).dtTransOffset = 12;
	
	  ;% mytemplate_B.PCIDAS160212_o14
	  section.data(14).logicalSrcIdx = 13;
	  section.data(14).dtTransOffset = 13;
	
	  ;% mytemplate_B.SineWave
	  section.data(15).logicalSrcIdx = 14;
	  section.data(15).dtTransOffset = 14;
	
	  ;% mytemplate_B.SineWave1
	  section.data(16).logicalSrcIdx = 15;
	  section.data(16).dtTransOffset = 15;
	
	  ;% mytemplate_B.SineWave2
	  section.data(17).logicalSrcIdx = 16;
	  section.data(17).dtTransOffset = 16;
	
	  ;% mytemplate_B.SineWave3
	  section.data(18).logicalSrcIdx = 17;
	  section.data(18).dtTransOffset = 17;
	
	  ;% mytemplate_B.SineWave4
	  section.data(19).logicalSrcIdx = 18;
	  section.data(19).dtTransOffset = 18;
	
	  ;% mytemplate_B.SineWave5
	  section.data(20).logicalSrcIdx = 19;
	  section.data(20).dtTransOffset = 19;
	
      nTotData = nTotData + section.nData;
      sigMap.sections(1) = section;
      clear section
      
    
      ;%
      ;% Non-auto Data (signal)
      ;%
    

    ;%
    ;% Add final counts to struct.
    ;%
    sigMap.nTotData = nTotData;
    


  ;%*******************
  ;% Create DWork Map *
  ;%*******************
      
    nTotData      = 0; %add to this count as we go
    nTotSects     = 3;
    sectIdxOffset = 1;
    
    ;%
    ;% Define dummy sections & preallocate arrays
    ;%
    dumSection.nData = -1;  
    dumSection.data  = [];
    
    dumData.logicalSrcIdx = -1;
    dumData.dtTransOffset = -1;
    
    ;%
    ;% Init/prealloc dworkMap
    ;%
    dworkMap.nSections           = nTotSects;
    dworkMap.sectIdxOffset       = sectIdxOffset;
      dworkMap.sections(nTotSects) = dumSection; %prealloc
    dworkMap.nTotData            = -1;
    
    ;%
    ;% Auto data (mytemplate_DWork)
    ;%
      section.nData     = 13;
      section.data(13)  = dumData; %prealloc
      
	  ;% mytemplate_DWork.lastSin
	  section.data(1).logicalSrcIdx = 0;
	  section.data(1).dtTransOffset = 0;
	
	  ;% mytemplate_DWork.lastCos
	  section.data(2).logicalSrcIdx = 1;
	  section.data(2).dtTransOffset = 1;
	
	  ;% mytemplate_DWork.lastSin_o
	  section.data(3).logicalSrcIdx = 2;
	  section.data(3).dtTransOffset = 2;
	
	  ;% mytemplate_DWork.lastCos_c
	  section.data(4).logicalSrcIdx = 3;
	  section.data(4).dtTransOffset = 3;
	
	  ;% mytemplate_DWork.lastSin_oj
	  section.data(5).logicalSrcIdx = 4;
	  section.data(5).dtTransOffset = 4;
	
	  ;% mytemplate_DWork.lastCos_j
	  section.data(6).logicalSrcIdx = 5;
	  section.data(6).dtTransOffset = 5;
	
	  ;% mytemplate_DWork.lastSin_l
	  section.data(7).logicalSrcIdx = 6;
	  section.data(7).dtTransOffset = 6;
	
	  ;% mytemplate_DWork.lastCos_h
	  section.data(8).logicalSrcIdx = 7;
	  section.data(8).dtTransOffset = 7;
	
	  ;% mytemplate_DWork.lastSin_i
	  section.data(9).logicalSrcIdx = 8;
	  section.data(9).dtTransOffset = 8;
	
	  ;% mytemplate_DWork.lastCos_b
	  section.data(10).logicalSrcIdx = 9;
	  section.data(10).dtTransOffset = 9;
	
	  ;% mytemplate_DWork.lastSin_e
	  section.data(11).logicalSrcIdx = 10;
	  section.data(11).dtTransOffset = 10;
	
	  ;% mytemplate_DWork.lastCos_bn
	  section.data(12).logicalSrcIdx = 11;
	  section.data(12).dtTransOffset = 11;
	
	  ;% mytemplate_DWork.PCIDDA0812_RWORK
	  section.data(13).logicalSrcIdx = 12;
	  section.data(13).dtTransOffset = 12;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(1) = section;
      clear section
      
      section.nData     = 6;
      section.data(6)  = dumData; %prealloc
      
	  ;% mytemplate_DWork.systemEnable
	  section.data(1).logicalSrcIdx = 13;
	  section.data(1).dtTransOffset = 0;
	
	  ;% mytemplate_DWork.systemEnable_e
	  section.data(2).logicalSrcIdx = 14;
	  section.data(2).dtTransOffset = 1;
	
	  ;% mytemplate_DWork.systemEnable_b
	  section.data(3).logicalSrcIdx = 15;
	  section.data(3).dtTransOffset = 2;
	
	  ;% mytemplate_DWork.systemEnable_p
	  section.data(4).logicalSrcIdx = 16;
	  section.data(4).dtTransOffset = 3;
	
	  ;% mytemplate_DWork.systemEnable_l
	  section.data(5).logicalSrcIdx = 17;
	  section.data(5).dtTransOffset = 4;
	
	  ;% mytemplate_DWork.systemEnable_c
	  section.data(6).logicalSrcIdx = 18;
	  section.data(6).dtTransOffset = 5;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(2) = section;
      clear section
      
      section.nData     = 2;
      section.data(2)  = dumData; %prealloc
      
	  ;% mytemplate_DWork.PCIDAS160212_IWORK
	  section.data(1).logicalSrcIdx = 19;
	  section.data(1).dtTransOffset = 0;
	
	  ;% mytemplate_DWork.PCIDDA0812_IWORK
	  section.data(2).logicalSrcIdx = 20;
	  section.data(2).dtTransOffset = 2;
	
      nTotData = nTotData + section.nData;
      dworkMap.sections(3) = section;
      clear section
      
    
      ;%
      ;% Non-auto Data (dwork)
      ;%
    

    ;%
    ;% Add final counts to struct.
    ;%
    dworkMap.nTotData = nTotData;
    


  ;%
  ;% Add individual maps to base struct.
  ;%

  targMap.paramMap  = paramMap;    
  targMap.signalMap = sigMap;
  targMap.dworkMap  = dworkMap;
  
  ;%
  ;% Add checksums to base struct.
  ;%


  targMap.checksum0 = 3045967463;
  targMap.checksum1 = 1564323053;
  targMap.checksum2 = 445448437;
  targMap.checksum3 = 320842124;

