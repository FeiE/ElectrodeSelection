# Electrode_Selection

- Traditionally, analyses are restricted to an subset of electrodes and then focus on one single electrode with maximum value from the subset. The same electrode is even applied to all participants. This approach is problematic because of a lack of robustness with respect to the electrode selected. 

- Here we calculate the time courses of the maximum value across all electrodes of interest for each participant. 


## Maximum value across electrodes of interest ##

The figure below visualizes the results of one participant. Topographic map shows the effects congregate at posterior lateral electrodes, particularly on the right hemisphere. Therefore we focus on eletrodes from the right hemishpere. At the bottom the thin lines indicate the time courses of the right electrodes. The thicker line shows the maximum values across those electrodes. Maximum value across electrodes and frame is detailed on the top. 

<img src="/results_visualization.png" alt="" width="500">





## Electrodes of interest ##
Using ['topo_markelecs.m'](https://github.com/FeiE/Electrode_Selection/blob/master/topo_markelecs.m), electrodes of interest can be marked in a topographic map of a scalp data field in a 2-D circular view (looking down at the top of the head).

<img src="/topo_markelecs_relecs.png" alt="" width="300">
