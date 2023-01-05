
clc; clear; close all

roof = double(intmax('uint16'));

%% read white cube

f = msgbox('Select the header of the white cube');
movegui(f,'north')
[headN,pathCB] = uigetfile('*.hdr');
close(f)

hcube = hypercube([pathCB headN]);
whtCUBE = hcube.DataCube;

%% read object cube

f = msgbox('Select the header of the object cube');
movegui(f,'north')
[headN,pathCB] = uigetfile([pathCB '*.hdr']);
close(f)

hcube = hypercube([pathCB headN]);
objCUBE = hcube.DataCube;

%% flat field and save new files

ffCUBE = double(objCUBE)./double(whtCUBE);

nameOUT = ['ff_' erase(headN,'.hdr')];

ffhcube = hypercube(uint16(ffCUBE*roof),hcube.Wavelength);

enviwrite(ffhcube,[pathCB nameOUT])
