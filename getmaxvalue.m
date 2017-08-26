function [RE,REpf,source] = getmaxvalue(data,Xf,chanR,chanlocs,limlo,limhi)

% INPUTS:
% data = 2D matrix with format electrodes x time frames
% Xf = time vector in ms, e.g. [-300:2:500]
% chanlocs = EEG.chanlocs from EEGLAB data set file
% use limlo/limhi to define time window of interest in ms
%
% OUTPUTS:
% Electrode from the Left/Right hemisphere:
%       RE/REpf.rel   in relative coordinates (electrode number in that data set)
%       RE/REpf.abs   in absolute coordinates (electrode name in the 128 Biosemi system)
%       RE/REpf.lat   latency of the MAX in time frames
%       RE/REpf.latms latency of the MAX in ms
%       RE/REpf.max   amplitude of the MAX 

% FEI - University of Glasgow - 03 AUG 2017

countR=0;
for E=1:length(chanlocs)
    for ER=1:length(chanR)
        if strcmp(chanlocs(E).labels,chanR{ER})
            countR=countR+1;
            dataR(countR,:)=data(E,:);
            tmpRE.rel(countR)=E;
            tmpRE.abs{countR}=chanlocs(E).labels;
        end
    end
end

if nargin <4
    limlo=1;
    limhi=length(Xf);
else
    limlo=find(Xf==limlo);
    limhi=find(Xf==limhi);
end

%% get max across electrodes per frame
for f = 1:size(dataR,2)

    tmp = dataR(:,:); 
    REpf(f).max = max(tmp(:,f));
    REpf(f).rel = tmpRE.rel( find(tmp(:,f)==REpf(f).max) ); 
    REpf(f).abs = tmpRE.abs{ find(tmp(:,f)==REpf(f).max) }; 
    
    tmp = data(REpf(f).rel,:);
    REpf(f).lat = find(tmp==REpf(f).max); 
    REpf(f).latms = Xf(find(tmp==REpf(f).max)); % latency in ms
    
end

%% select max across elecs and frame 

tmp = max(dataR(:,limlo:limhi),[],2); 
RE.max = max(tmp); 
RE.rel = tmpRE.rel( find(tmp==RE.max) ); 
RE.abs = tmpRE.abs{ find(tmp==RE.max) }; 
tmp = data(RE.rel,:);
RE.lat = find(tmp==RE.max); % latency in time frames
RE.latms = Xf(find(tmp==RE.max)); % latency in ms

%% MAP
figure('Color','w')

%% MAPS AND TIME COURSES FOR EACH HEMISPHERE

% max value across elecs per frame
tmpR = struct2cell(REpf);
maxmiR = cell2mat(squeeze(tmpR(1,:,:)));
YL = max(maxmiR)+.1*max(maxmiR);

subplot(2,1,2);hold on
title([RE.abs,',  ',num2str(RE.latms),'ms,  ',num2str(RE.max)], ...
    'FontSize',10,'FontName','Utopia')
plot(Xf,data(tmpRE.rel,:)','Color',[.8 .8 .8])
plot(Xf,maxmiR,'k','LineWidth',2)
plot([RE.latms RE.latms],[0 YL],'r--')
scatter(RE.latms,max(maxmiR(limlo:limhi)),50,'MarkerFaceColor','r')
axis([Xf(limlo) Xf(limhi) -YL*.05 YL])
box on

%% topo
subplot(2,1,1)
map=data(:,RE.lat);
topoplot(map,chanlocs,'electrodes','off','shading','interp','headrad','rim','maplimits',[0 YL]);
set(gcf,'renderer','painter');

source = mfilename('fullpath');
