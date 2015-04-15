% map audio load and data load to anonymous functions

audio_load=@(FILE) fw_audioload(FILE);
data_load=@(FILE) fw_lblk170rr_dataload(FILE);

% cluster the data as per usual with new arguments
dt = input('What is the date of these songs? ', 's');
mkdir('figs');

zftftb_song_clust(pwd,'audio_load',audio_load,'data_load',data_load);

rs = input('what did you name the directory? ', 's');

% assumes extracted_data.mat has been loaded
load(strcat(rs, '_MANUALCLUST/extracted_data.mat'));
% take sample spectrogram

[s,f,t]=zftftb_pretty_sonogram(agg_audio.data(:,4),agg_audio.fs,'filtering',300,'clipping',-5,'len',80,'overlap',79);

% filter extracellular signal liberally for LFP
c = input('Press enter to continue', 's');
% f = figure();
for i=1:length(agg_audio.data(1,:))
	[s,f,t] = zftftb_pretty_sonogram(agg_audio.data(:,i), agg_audio.fs, 'filtering', 300, 'clipping', -5, 'len', 80, 'overlap', 79);
	imagesc(s);
	axis xy;
	pause(0.1);
end


[b,a]=ellip(3,.2,40,[5 100]/(agg_data.fs/2),'bandpass');

filt_lfp=filtfilt(b,a,double(agg_data.data(:,:,1)));
timevec=[1:size(agg_data.data,1)]/agg_data.fs;

% sonogram aligned false-color plot of the raw voltage

fig=figure();
ax(1)=subplot(3,1,1);
imagesc(t,f/1e3,s);axis xy;
ylabel('Fs (kHz)');

ax(2)=subplot(3,1,2:3);
imagesc(timevec,[],filt_lfp');box off;
ylabel('Trial');
xlabel('Time (s)');
title(strcat('LFP amplitude ', dt));
linkaxes(ax,'x');
saveas(fig, 'figs/LFP', 'png');
savefig(fig, 'figs/LFP');
% get spikes, set simple threshold (3xSTD)

% first filter for spikes, typical range for the nerve (long spikes, low upper cutoff)

[b,a]=ellip(2,.2,40,[300 3e3]/(agg_data.fs/2),'bandpass');

filt_spikes=filtfilt(b,a,double(agg_data.data(:,:,1)));

% threshold for each trial, takes std across rows

threshold=3*std(filt_spikes);

% only take [n]egative going spikes to start, take .001 .0015 seconds around each detected spike

spikes_threshold=spikoclust_spike_detect(filt_spikes,threshold,agg_data.fs,'method','n','window',[.001 .0015]); 

fig=figure();
ax(1)=subplot(3,1,1);
imagesc(t,f/1e3,s);axis xy;
ylabel('Fs (kHz)');

ax(2)=subplot(3,1,2:3);
spikoclust_raster(spikes_threshold.times/agg_data.fs,spikes_threshold.trial);
axis tight;
linkaxes(ax,'x');
xlabel('Time (s)');
ylabel('Trial');
title(strcat('Raster ', dt));

savefig(fig, 'figs/raster');
saveas(fig, 'figs/raster', 'png');

fig = figure();
plot([1:size(spikes_threshold.windows,1)]/agg_data.fs,spikes_threshold.windows,'k-');
ylabel('Amp. (uV)');
xlabel('Time (s)');
title(strcat('spikes ', dt));
% if you're brave, try some spike sorting
saveas(fig, 'figs/spikes', 'png');
savefig(fig, 'figs/spikes');
[spikes_sorted, spikless]=spikoclust_sort(double(agg_data.data(:,:)),agg_data.fs,'freq_range',[300 3e3],'spike_window',[.001 .0015],'clust_check',1:4);
spikoclust_autostats(spikes_sorted, spikless);
% should only have one cluster

fig = figure();
ax(1)=subplot(3,1,1);
imagesc(t,f/1e3,s);axis xy;
ylabel('Fs (kHz)');

ax(2)=subplot(3,1,2:3);
spikoclust_raster(spikes_sorted.times{1}/agg_data.fs,spikes_sorted.trials{1});
axis tight;
linkaxes(ax,'x');
xlabel('Time (s)');
ylabel('Trial');
title(strcat('Sorted spike raster ', dt));
saveas(fig, 'figs/sorted_raster', 'png');
savefig(fig, 'figs/sorted_raster');
