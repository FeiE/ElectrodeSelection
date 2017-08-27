# Electrode_Selection

- Traditionally, analyses are restricted to an subset of electrodes and then focus on one single electrode with maximum value from the subset. The same electrode is even applied to all participants in some studies. This approach is problematic because of a lack of robustness with respect to the electrode selected. 

- Here we calculate the time courses of the maximum value across all electrodes of interest for each participant. 


## Maximum value across electrodes of interest ##

['getmaxvalue.m'](https://github.com/FeiE/Electrode_Selection/blob/master/getmaxvalue.m) can visualize the results per each participant. For example, topographic map shows the effects congregate at posterior lateral electrodes, particularly on the right hemisphere. Therefore we focus on the eletrodes from the right hemishpere. The thin lines indicate the time courses of values per each of those electrodes. The thicker line shows the maximum values across electrodes. Maximum value across electrodes and frames is detailed on the top.

<img src="/results_visualization.png" alt="" width="600">


``` matlab
load('DATA.mat')% for one participant (elecs x time point)
chanR = {'B9' 'B8' 'B7' 'B6' 'B5' 'B4' 'B3' 'B2' 'B1' ...
    'B10' 'B11' 'B12' 'B13' 'B14' 'B15' 'B16' 'B17' 'B18' 'B19'}; % elecs of interest
load('chanloc.mat') % one participant remains 120 elecs
Xf = -300:2:500; 
limlo = 0;limhi = 300; % use limlo/limhi to define time window of interest in ms
[RE,REpf,source] = getmaxvalue(DATA,Xf,chanR,chanloc,limlo,limhi);
```

## Electrodes of interest ##
Using ['topo_markelecs.m'](https://github.com/FeiE/Electrode_Selection/blob/master/topo_markelecs.m), electrodes of interest can be marked in a topographic map of a scalp data field in a 2-D circular view (looking down at the top of the head).

<img src="/topo_markelecs_relecs.png" alt="" width="300">
