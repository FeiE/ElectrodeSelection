function topo_markelecs(chan,chanlocs)
% topo_markelecs() - mark electrodes of interest in a topographic map
%                    of a scalp data field in a 2-D circular view
%                    (looking down at the top of the head)
% example:
% chan = {'B9' 'B8' 'B7' 'B6' 'B5' 'B4' 'B3' 'B2' 'B1' ...
%     'B10' 'B11' 'B12' 'B13' 'B14' 'B15' 'B16' 'B17' 'B18' 'B19'};
% chanlocs - name of an EEG electrode position file (>> topoplot example).
%            Else, an EEG.chanlocs structure 
%            (>> help readlocs or >> topoplot example)

% NOTE: The cartoon head is drawn using code in topoplot.m file from EEGLAB
% v6.01b (http://sccn.ucsd.edu/eeglab/).

figure;
BACKCOLOR = [1 1 1];  % EEGLAB standard
rmax = 0.5;             % actual head radius - Don't change this!
CIRCGRID   = 201;       % number of angles to use in drawing circles
AXHEADFAC = 1.3;        % head to axes scaling factor
HEADCOLOR = [0 0 0];    % default head color (black)
EMARKER = '.';          % mark electrode locations with small disks
ECOLOR = [0 0 0];       % default electrode color = black
EMARKERSIZE = [];       % default depends on number of electrodes, set in code
EMARKERLINEWIDTH = 1;   % default edge linewidth for emarkers
HLINEWIDTH = 1.7;         % default linewidth for head, nose, ears
HEADRINGWIDTH    = .007;% width of the cartoon head ring

%
%% %%%%%%%%%%%%%%%%%%% Read the channel location information %%%%%%%%%%%%%%%%%%%%%%%%
%
[~, ~, Th Rd indices] = readlocs( chanlocs,'filetype','loc');
Th = pi/180*Th;                              % convert degrees to radians
plotchans = indices;

%
%% %%%%%%%%%%%%%%%%%% marked elecs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
count = 0;
for e=1:length(chan)   
    for E = 1:length(chanlocs)
        if strcmp(chanlocs(E).labels,chan{e})  
        count = count + 1; 
            chanM(count) = E;   
        end
    end
end

%
%% %%%%%%%%%%%%%%%%%% remove infinite and NaN values %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
[x,y]     = pol2cart(Th,Rd);  % transform electrode locations from polar to cartesian coordinates
plotchans = abs(plotchans);   % reverse indicated channel polarities
Rd        = Rd(plotchans);
x         = x(plotchans);
y         = y(plotchans);
plotrad = min(1.0,max(Rd)*1.02);            % default: just outside the outermost electrode location
plotrad = max(plotrad,0.5);                 % default: plot out to the 0.5 head boundary
headrad = rmax;
pltchans = find(Rd <= plotrad); % plot channels inside plotting circle
x     = x(pltchans);
y     = y(pltchans);
squeezefac = rmax/plotrad;
x    = x*squeezefac;
y    = y*squeezefac;

%
%% %%%%%%%%%%%%%%%%%%%%%% Draw blank head %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
cla
hold on
set(gca,'Xlim',[-rmax rmax]*AXHEADFAC,'Ylim',[-rmax rmax]*AXHEADFAC)

%
%% %%%%%%%%%%%%%%%%%% Plot filled ring to mask jagged grid boundary %%%%%%%%%%%%%%%%%%%%%%%%%%%
%
hwidth = HEADRINGWIDTH;                   % width of head ring
hin  = squeezefac*headrad*(1- hwidth/2);  % inner head ring radius
circ = linspace(0,2*pi,CIRCGRID);
rx = sin(circ);
ry = cos(circ);

%
%% %%%%%%%%%%%%%%%%%%%%%%%% Plot cartoon head, ears, nose %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
headx = [[rx(:)' rx(1) ]*(hin+hwidth)  [rx(:)' rx(1)]*hin];
heady = [[ry(:)' ry(1) ]*(hin+hwidth)  [ry(:)' ry(1)]*hin];

patch(headx,heady,ones(size(headx)),HEADCOLOR,'edgecolor',HEADCOLOR); hold on

%
%% %%%%%%%%%%%%%%%%%% Plot ears and nose %%%%%%%%%%%%%%%%%%%%%%%%%%%
%
base  = rmax-.0046;
basex = 0.18*rmax;                   % nose width
tip   = 1.15*rmax;
tiphw = .04*rmax;                    % nose tip half width
tipr  = .01*rmax;                    % nose tip rounding
q = .04; % ear lengthening
EarX  = [.497-.005  .510  .518  .5299 .5419  .54    .547   .532   .510   .489-.005]; % rmax = 0.5
EarY  = [q+.0555 q+.0775 q+.0783 q+.0746 q+.0555 -.0055 -.0932 -.1313 -.1384 -.1199];
sf    = headrad/plotrad;

plot3([basex;tiphw;0;-tiphw;-basex]*sf,[base;tip-tipr;tip;tip-tipr;base]*sf,...
    2*ones(size([basex;tiphw;0;-tiphw;-basex])),...
    'Color',HEADCOLOR,'LineWidth',HLINEWIDTH);                 % plot nose
plot3(EarX*sf,EarY*sf,2*ones(size(EarX)),'color',HEADCOLOR,'LineWidth',HLINEWIDTH)    % plot left ear
plot3(-EarX*sf,EarY*sf,2*ones(size(EarY)),'color',HEADCOLOR,'LineWidth',HLINEWIDTH)   % plot right ear

%
%% %%%%%%%%%%%%%%%%%%% Show electrode information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
plotax = gca;
axis square                                           % make plotax square
axis off

pos = get(gca,'position');
set(plotax,'position',pos);

xlm = get(gca,'xlim');
set(plotax,'xlim',xlm);

ylm = get(gca,'ylim');
set(plotax,'ylim',ylm);                               % copy position and axis limits again


if isempty(EMARKERSIZE)
    EMARKERSIZE = 5;
end

%
%% %%%%%%%%%%%%%%%%%%%%%%% Mark electrode locations only %%%%%%%%%%%%%%%%%%%%%%%%%%
%
ELECTRODE_HEIGHT = 2.1;  % z value for plotting electrode information (above the surf)
plot3(y,x,ones(size(x))*ELECTRODE_HEIGHT,...
    EMARKER,'Color',ECOLOR,'markersize',6,'linewidth',EMARKERLINEWIDTH);hold on

plot3(y(chanM),x(chanM),ones(size(x(chanM)))*ELECTRODE_HEIGHT,...
    EMARKER,'Color',ECOLOR,'markersize',28,'linewidth',EMARKERLINEWIDTH);

set(gcf, 'color', BACKCOLOR)
set(gcf,'renderer','painter');
