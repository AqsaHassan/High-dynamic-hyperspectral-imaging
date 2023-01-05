function hdr = readHyspexHdr(fname,flagresampling,flagtemp)

%% This reads header information from image itself
%% input
%% fname -->input file name
%% output
%% hdr --> it is structure, it contains header
%% dependency
%% none
%% @Trond Løke, Norsk Elektro Optikk
%% Received at 03.02.2015
%% update 1
%% updated to read binary header for Mjolnir image, serial number is greater than 5000
%% it read extra parameter temperature_end, temperature_start, temperature_calibration and senor of size 176 byte instead of 200 byte
%% Updated by @Pesal Koirala, Norsk Elektro Optikk, 29.03.2016
%% udpate 2
%% updated second parameter flagresampling, to read MJOLNIR header width or widhout resampling matrices in binary header
%% Update by @Pesal Koirala, Norsk Elektro Optikk, 15.06.2016
%% update 3
%% flagtemp has been introduced, flagtemp should be 1 if, binary header has temperature information
%% updated by @Pesal Koirala, Norsk Elektro Optikk, 05.05.2017
%%  update 4 10.08.2017  @Pesal Koirala, Norsk Elektro Optikk
%% hdr.binaryheaderflag has been headed as one parameter in out put hdr
%% hdr.binarheaderflag=1, can read binary header
%% hdr.binarheaderflag=0,  There is no proper binary header
%% hdr.binarheaderflag=-1 Can not open image file

%% update 5 16.11.2018 @Pesal koirala Norsk Elektro Optikk
%% all strings have been tokenized by end of string terminator
%% update 6 26.11.2018 @Pesal koirala Norsk Elektro Optikk
%% removeSpaceL has been added at the last of this function. L is just notation for Local function.
%% update 7 10.12.2018
%% spectralVector has been chaged to spectralCalib
%% update 8 13.03.2019 @Pesal Koirala, Norks Elektro Optikk
%% in fread(fid,n,'*char') has been replaced by fread(fid,n,'*uint8'), since chararcter encoding other than US_ASCII may influence the result if *char has been used.

if(nargin<1)
    [fl, fd]=uigetfile({'*.hyspex'; '*.img'; '*.*'},'Select Image File');
    fname=[fd fl];
    flagresampling=0;
    flagtemp=0;
elseif(nargin<2)
    if(isempty(fname))
        [fl, fd]=uigetfile({'*.hyspex'; '*.img'; '*.*'},'Select Image File');
        fname=[fd fl];
    end
    if(nargin<2)
        flagresampling=0;
    end
    flagtemp=0;
elseif(nargin<=3)
    if(isempty(fname))
        [fl, fd]=uigetfile({'*.hyspex'; '*.img'; '*.*'},'Select Image File');
        fname=[fd fl];
    end
    if(isempty(flagresampling))
        flagresampling=0;
    end
    if(nargin<3)
        flagtemp=0;
    end
    
    
end

fid = fopen(fname,'r');
if fid==-1
    hdr.binaryheaderflag=-1;
    return;
end


word = fread(fid,  8,'*int8')'; %% *char has been replace by *int8, *char can not guarantee , it will read 8 bytes , if UTF-8 is character encoding
hdr.word=strtok(char(word),0);

if(~strcmpi(removespaceL(char(hdr.word(1:6))),'HYSPEX'))
    hdr.binaryheaderflag=0;
    fclose(fid);
    return;
end

hdr.hdrSize                = fread(fid,  1,'*uint');

if(hdr.hdrSize<=0)
    hdr.binaryheaderflag=0;
    fclose(fid);
    return;
end


hdr.serialNumber           = fread(fid,  1,'*uint');
configFile                 =fread(fid,200,'*int8')';
hdr.configFile             = strtok(char(configFile),0);
settingFile                = fread(fid,120,'*int8')';
hdr.settingFile            = strtok(char(settingFile),0);
hdr.scalingFactor          = fread(fid,  1,'*double');
hdr.electronics            = fread(fid,  1,'*uint');
hdr.comsettingsElectronics = fread(fid,  1,'*uint');
comportElectronics         = fread(fid, 44,'*int8')';
hdr.comportElectronics     = strtok(char(comportElectronics),0);
hdr.fanSpeed               = fread(fid,  1,'*uint');
hdr.backTemperature        = fread(fid,  1,'*uint');
hdr.Pback                  = fread(fid,  1,'*uint');
hdr.Iback                  = fread(fid,  1,'*uint');
hdr.Dback                  = fread(fid,  1,'*uint');
comport                    = fread(fid, 64,'*int8')';
hdr.comport                = strtok(char(comport),0);
detectstring               = fread(fid,200,'*int8')';
hdr.detectstring           = strtok(char(detectstring),0);
if(and(hdr.serialNumber>5000,flagtemp==1))
    sensor                     = fread(fid,168,'*int8')';
    hdr.sensor                 = strtok(char(sensor),0);
    
    hdr.orgspatialSize=fread(fid,1,'*uint');
    hdr.orgspectralSize=fread(fid,1,'*uint');
    
    hdr.temperature_end=fread(fid,1,'*double');
    hdr.temperature_start=fread(fid,1,'*double');
    hdr.temperature_calibration=fread(fid,1,'*double');
elseif(and(hdr.serialNumber<1000, flagtemp==1)) %% for VNIR 1800
    sensor                     = fread(fid,176,'*int8')';
    hdr.sensor                 = strtok(char(sensor),0);
    hdr.temperature_end        =fread(fid,1,'*double');
    hdr.temperature_start      =fread(fid,1,'*double');
    hdr.temperature_calibration=fread(fid,1,'*double');
    
    
else
    [sensor]                     = fread(fid,200,'*uint8')';
    hdr.sensor                 = strtok(char(sensor),0);
end
framegrabber               = fread(fid,200,'*int8')';
hdr.framegrabber           =strtok(char(framegrabber),0);
ID                         = fread(fid,200,'*int8')';
hdr.ID                     = strtok(char(ID),0);

supplier                   = fread(fid,200,'*int8')';
hdr.supplier               = strtok(char(supplier) ,0);

leftGain                   = fread(fid, 32,'*int8')';
hdr.leftGain               = strtok(char(leftGain),0);

rightGain                  = fread(fid, 32,'*int8')';
hdr.rightGain              = strtok(char(rightGain),0);

comment                    = fread(fid,200,'*int8')';
hdr.comment                = strtok(char(comment) ,0);

backgroundFile             = fread(fid,200,'*int8')';
hdr.backgroundFile         = strtok(char(backgroundFile),0);

recordHD                   = fread(fid,  1,'*int8')';
hdr.recordHD               = strtok(char(recordHD) ,0);

hdr.unknownPOINTER         = fread(fid,  1,'*uint');    %4 byte pointer [useless] XCamera*m_hCam
hdr.serverIndex            = fread(fid,  1,'*uint');
hdr.comsettings            = fread(fid,  1,'*uint');
hdr.numberOfBackground     = fread(fid,  1,'*uint');
hdr.spectralSize           = fread(fid,  1,'*uint');
hdr.spatialSize            = fread(fid,  1,'*uint');
hdr.binning                = fread(fid,  1,'*uint');
hdr.detected               = fread(fid,  1,'*uint');
hdr.integrationtime        = fread(fid,  1,'*uint');
hdr.frameperiod            = fread(fid,  1,'*uint');
hdr.defaultR               = fread(fid,  1,'*uint');
hdr.defaultG               = fread(fid,  1,'*uint');
hdr.defaultB               = fread(fid,  1,'*uint');
hdr.bitshift               = fread(fid,  1,'*uint');
hdr.temperatureOffset      = fread(fid,  1,'*uint');
hdr.shutter                = fread(fid,  1,'*uint');
hdr.backgroundPresent      = fread(fid,  1,'*uint');
hdr.power                  = fread(fid,  1,'*uint');
hdr.current                = fread(fid,  1,'*uint');
hdr.bias                   = fread(fid,  1,'*uint');
hdr.bandwidth              = fread(fid,  1,'*uint');
hdr.vin                    = fread(fid,  1,'*uint');
hdr.vref                   = fread(fid,  1,'*uint');
hdr.sensorVin              = fread(fid,  1,'*uint');
hdr.sensorVref             = fread(fid,  1,'*uint');
hdr.coolingTemperature     = fread(fid,  1,'*uint');
hdr.windowStart            = fread(fid,  1,'*uint');
hdr.windowStop             = fread(fid,  1,'*uint');
hdr.readoutTime            = fread(fid,  1,'*uint');
hdr.p                      = fread(fid,  1,'*uint');
hdr.i                      = fread(fid,  1,'*uint');
hdr.d                      = fread(fid,  1,'*uint');
hdr.numberOfFrames         = fread(fid,  1,'*uint');
hdr.nobp                   = fread(fid,  1,'*uint');
hdr.dw                     = fread(fid,  1,'*uint');
hdr.EQ                     = fread(fid,  1,'*uint');
hdr.lens                   = fread(fid,  1,'*uint');
hdr.FOVexp                 = fread(fid,  1,'*uint');
hdr.scanningMode           = fread(fid,  1,'*uint');
hdr.calibAvailable         = fread(fid,  1,'*uint');
hdr.numberOfAvg            = fread(fid,  1,'*uint');
hdr.SF                     = fread(fid,  1,'*double');
hdr.apertureSize           = fread(fid,  1,'*double');
hdr.pixelSizeX             = fread(fid,  1,'*double');
hdr.pixelSizeY             = fread(fid,  1,'*double');
hdr.temperature            = fread(fid,  1,'*double');
hdr.maxFramerate           = fread(fid,  1,'*double');
hdr.spectralCalibPOINTER   = fread(fid,  1,'*int'); %4 byte pointer [useless]   size = spectralSize*sizeof(double)
hdr.REPOINTER              = fread(fid,  1,'*int'); %4 byte pointer [useless]   size = spectralSize*spatialSize*sizeof(double)
hdr.QEPOINTER              = fread(fid,  1,'*int'); %4 byte pointer [useless]   size = spectralSize*sizeof(double)
hdr.backgroundPOINTER      = fread(fid,  1,'*int'); %4 byte pointer [useless]   size = spatialSize*spectralSize*sizeof(double)
hdr.badPixelsPOINTER       = fread(fid,  1,'*int'); %4 byte pointer [useless]   size = nobp*sizeof(uint)
hdr.imageFormat            = fread(fid,  1,'*uint');
hdr.spectralCalib         = fread(fid,hdr.spectralSize,'*double');

hdr.QE                     = fread(fid,hdr.spectralSize,'*double');
hdr.RE                     = fread(fid,hdr.spectralSize*hdr.spatialSize,'*double');
hdr.backgroundBefore        = fread(fid,hdr.spectralSize*hdr.spatialSize,'*double');
hdr.badPixels             = fread(fid,hdr.nobp,'*uint');

if (or((and(hdr.serialNumber > 3000, hdr.serialNumber<5000)), (and(hdr.serialNumber>=7000,hdr.serialNumber<8000))))
    hdr.backgroundAfter             = fread(fid, hdr.spectralSize*hdr.spatialSize,'*double');
end

if(hdr.serialNumber>5000)
    if(flagresampling)
        orgspectralsize=hdr.orgspectralSize;
        hdr.knumpixel=fread(fid,1,'*uint');
        hdr.kvalmatrix=fread(fid,hdr.knumpixel*orgspectralsize*4,'*double');
        hdr.kindmatrix=fread(fid,hdr.knumpixel*orgspectralsize*4,'*uint');
        hdr.snumband=fread(fid,1,'*uint');
        hdr.swavelengths=fread(fid,hdr.snumband,'*double');
        hdr.svalmatrix=fread(fid,hdr.knumpixel*hdr.snumband*4,'*double');
        hdr.sindmatrix=fread(fid,hdr.knumpixel*hdr.snumband*4,'*uint');
        hdr.slope=fread(fid,hdr.snumband,'*double');
        hdr.intercept=fread(fid,hdr.snumband,'*double');
    end
    
end
hdr.binaryheaderflag=1;
fclose(fid);


function str=removespaceL(oldstr)
%% removes all space from given string, in last L is written to mention it is local function for this file
%% input
%% oldstr--> string of which blank space should be removed
%% output
%% str--> string with out space
%% dependencey--> none

%%@pesal koirala, Norsk Elektro Optikk, 20.06.2017
%% added here 26.11.2018

str=oldstr(~isspace(oldstr));
