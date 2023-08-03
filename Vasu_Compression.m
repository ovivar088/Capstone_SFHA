%Basic Dynamic Compression

%LINUX COMMANDS:

% open octave with following: "octave"
setenv('LD_LIBRARY_PATH','')

%/usr/share/openmha/examples/01-dynamic-compression , be in this repository
%using CD

addpath('/usr/lib/openmha/mfiles')

openmha = mha_start;

mha_query(openmha,'','read:dynamiccompression_live.cfg');

mha_set(openmha, ' cmd ' ,' start ');
 
gaintable = mha_get(openmha,'mha.overlapadd.mhachain.dc.gtdata');
gtmin = mha_get(openmha,'mha.overlapadd.mhachain.dc.gtmin');
gtstep = mha_get(openmha,'mha.overlapadd.mhachain.dc.gtstep');


%You can design your own gaintable in Matlab, e.g. noise gate, compressive region, output limit
gaintable = dlmread('outputData.txt');
%with
gtmin = zeros(1,size(gaintable,1));
%and
gtstep = 4*ones(1,size(gaintable,1));
%This would result in an input/output characteristic which is the same for every
%channel/band.

level_in = ((1:size(gaintable,2))-1) .* gtstep'+gtmin';
level_out = level_in + gaintable;

%In order to apply the gaintable type
mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable);

%In order to plot input and output level in Matlab, type
figure, plot(level_in',level_out')


%You can design more gaintables in Matlab, e.g. by using gaintable_new =
%[...]
%e.g. Squash all input levels to the same output level, infinite compression:
% gaintable_new = 65.*ones(18,1) - level_in;


%In order to apply the new gaintable type
% mha_set(openmha,'mha.overlapadd.mhachain.dc.gtdata',gaintable_new);
%The fitting GUI can be started by typing 
mhacontrol(openmha)
%18. You can stop openMHA using 
mha_set(openmha,'cmd','quit')