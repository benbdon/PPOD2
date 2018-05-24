function bio=templatebio
bio = [];
bio(1).blkName='PCI-DAS1602 12 ';
bio(1).sigName='';
bio(1).portIdx=0;
bio(1).dim=[1,1];
bio(1).sigWidth=1;
bio(1).sigAddress='&template_B.PCIDAS160212';
bio(1).ndims=2;
bio(1).size=[];

bio(getlenBIO) = bio(1);

bio(2).blkName='Sine Wave';
bio(2).sigName='';
bio(2).portIdx=0;
bio(2).dim=[1,1];
bio(2).sigWidth=1;
bio(2).sigAddress='&template_B.SineWave';
bio(2).ndims=2;
bio(2).size=[];


function len = getlenBIO
len = 2;

