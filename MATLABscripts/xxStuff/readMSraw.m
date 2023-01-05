function [CUBE,wl] = readMSraw(headN,pathCB) 

% read the header

head = importdata([pathCB headN]); % cube header

IDX = contains(head,'lines');
ht = head(IDX);
match = ["lines","="];
ht = erase(ht,match);
ht = str2double(ht{1});

IDX = contains(head,'samples');
wt = head(IDX);
match = ["samples","="];
wt = erase(wt,match);
wt = str2double(wt{1});

IDX = contains(head,'bands');
bd = head(IDX);
match = ["bands","="];
bd = erase(bd,match);
bd = str2double(bd{1});

dt = 'uint16';

IDX = contains(head,'header offset');
ho = head(IDX);
match = ["header offset","="];
ho = erase(ho,match);
ho = str2double(ho{1});

IDX = contains(head,'interleave');
il = head(IDX);
match = ["interleave","="," "];
il = erase(il{1},match);

IDX = contains(head,'byte order');
bo = head(IDX);
match = ["byte order","="];
bo = erase(bo,match);
bo = str2double(bo{1});
if bo==0
    bo = 'ieee-le';
else
    bo = 'ieee-be';
end

IDX = contains(head,'wavelength  =');
wl = head(IDX);
match = ["wavelength","= {","}"," "];
wl = erase(wl{1},match);
wl = str2num(wl)';

% read the cube

CUBE = multibandread([pathCB erase(headN,'.hdr') '.hyspex'],[ht,wt,bd],dt,ho,il,bo);

end
