%%
clc;clear;close all
load('allchanlocs.mat') % EEG.chanlocs from EEGLAB data set file
load('DATA.mat')
chanR = {'B9' 'B8' 'B7' 'B6' 'B5' 'B4' 'B3' 'B2' 'B1' ...
    'B10' 'B11' 'B12' 'B13' 'B14' 'B15' 'B16' 'B17' 'B18' 'B19'};
topo_markelecs(chanR,chanlocs)

%%
load('chanloc.mat') % one participant remaining 120 elecs
Xf = -300:2:500;
limlo=0;limhi=300; % use limlo/limhi to define time window of interest in ms
[RE,REpf,source]=getmaxvalue(DATA,Xf,chanR,chanloc,limlo,limhi);
