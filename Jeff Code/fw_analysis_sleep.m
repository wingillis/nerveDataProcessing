% first let's form a template...
if ~exist('agg_data', 'var')
	disp('Please load aggregate song ephys data');
	return
end
% take sample spectrogram

trim=[.2 .2]; % remove pads
spike_sigma=.0025; % smoothing factor for spikes (5 ms sigma Gaussian, decent starting point)
template_fs=500; % new sampling rate

spike_kernel_t=[-spike_sigma*3:1/agg_data.fs:spike_sigma*3];
spike_kernel=normpdf(spike_kernel_t,0,spike_sigma);

[s,f,t]=zftftb_pretty_sonogram(agg_audio.data(:,1),agg_audio.fs,'filtering',300,'clipping',-5,'len',80,'overlap',79);

% filter extracellular signal liberally for LFP

[b,a]=ellip(3,.2,40,[5 100]/(agg_data.fs/2),'bandpass');

% right now this script assumes lg373rblk as the processed bird

proc_data=double(agg_data.data(:,:,1));
filt_lfp=filtfilt(b,a,proc_data);
timevec=[1:size(agg_data.data,1)]/agg_data.fs;

[b,a]=ellip(2,.2,40,[300 3e3]/(agg_data.fs/2),'bandpass');
filt_spikes=filtfilt(b,a,proc_data);

% threshold for each trial, takes std across rows

threshold=3*std(filt_spikes); 

% only take [n]egative going spikes to start, take .001 .0015 seconds around each detected spike

spikes_threshold=spikoclust_spike_detect(filt_spikes,threshold,agg_data.fs,'method','n','window',[.001 .0015]); 
%spikes_sorted=spikoclust_sort(proc_data,agg_data.fs,'freq_range',[300 3e3],'spike_window',[.001 .0015],'clust_check',1:4,'sigma_t',3);

% should only have one cluster

figure();
ax(1)=subplot(3,1,1);
imagesc(t,f/1e3,s);axis xy;
ylabel('Fs (kHz)');

ax(2)=subplot(3,1,2:3);
spikoclust_raster(spikes_threshold.times/agg_data.fs,spikes_threshold.trial);
axis tight;
linkaxes(ax,'x');
xlabel('Time (s)');
ylabel('Trial');


[nsamples,ntrials]=size(proc_data);
idxs=round(trim(1)*agg_data.fs):round(nsamples-trim(2)*agg_data.fs);

% now get smooth spike rate 

spikes_pp=zeros(nsamples,ntrials);
ind=sub2ind(size(spikes_pp),spikes_threshold.times,spikes_threshold.trial);
spikes_pp(ind)=1;
smooth_spikes=filter(spike_kernel,1,spikes_pp);

% spike template, average then downsample

spike_template=mean(zscore(smooth_spikes)');
spike_template=spike_template(idxs);
spike_template=flipud(spike_template(:));
spike_template=downsample(spike_template,agg_data.fs/template_fs);

lfp_template=mean(zscore(filt_lfp)');
lfp_template=lfp_template(idxs);
lfp_template=flipud(lfp_template(:));
lfp_template=downsample(lfp_template,agg_data.fs/template_fs);

% open up sleep data files, filter the data, detect spikes

files = dir('*.mat');

% only work with a small subset of files to begin with

% files = files(1:5:48); % only 9 files

% use previous filter parameters
% first, test with only one file

load(files(1).name, 'ephys');
% filtered_data = filtfilt(b,a, double(ephys.data(:,1) - ephys.data(:,2)));
% sleep_threshold = 3*std(filtered_data);
% % repeat spike detection parameters as above
% sleep_spikes = spikoclust_spike_detect(filtered_data, sleep_threshold, ephys.fs, 'method', 'n', 'window', [.001 .0015]);
% % getting smooth spike rate (don't quite understand this yet)
% [nsamples, ntrials] = size(filtered_data);
% spikes_pp_sleep = zeros(nsamples, ntrials);
% idxs=round(trim(1)*ephys.fs):round(nsamples-trim(2)*ephys.fs);
% ind=sub2ind(size(spikes_pp_sleep),sleep_spikes.times,sleep_spikes.trial);
% spikes_pp_sleep(ind)=1;
% smooth_spikes=filter(spike_kernel,1,spikes_pp_sleep);


% spike_template=spike_template./norm(spike_template,1);

% % perform a matched filter on the sleep spikes
% filtering = filter(spike_template, 1, zscore(downsample(smooth_spikes, ephys.fs/template_fs)));

% figure();
% subplot(3,1,1:2);
% imagesc(filtering);
% subplot(3,1,3);
% plot(filtering);

filtered_data = zeros(length(downsample(ephys.data(:,1),ephys.fs/template_fs)), length(files));
filtered_data = filtered_data';

for i=1:length(files)

	% load data
	load(files(i).name, 'ephys');
	temp_data = filtfilt(b,a, double(ephys.data(:,1) - ephys.data(:,2)));
	sleep_threshold = 3*std(temp_data);
	% repeat spike detection parameters as above
	sleep_spikes = spikoclust_spike_detect(temp_data, sleep_threshold, ephys.fs, 'method', 'n', 'window', [.001 .0015], 'visualize', 'n');
	% getting smooth spike rate (don't quite understand this yet)
	[nsamples, ntrials] = size(temp_data);
	spikes_pp_sleep = zeros(nsamples, ntrials);
	% idxs=round(trim(1)*ephys.fs):round(nsamples-trim(2)*ephys.fs);
	ind=sub2ind(size(spikes_pp_sleep),sleep_spikes.times,sleep_spikes.trial);
	spikes_pp_sleep(ind)=1;
	smooth_spikes=filter(spike_kernel,1,spikes_pp_sleep);

	spike_template=spike_template./norm(spike_template,1);
	filtering = filter(spike_template, 1, zscore(downsample(smooth_spikes, ephys.fs/template_fs)));
	filtered_data(i,:) = filtering;
end

figure();
subplot(3,1,1);
colormap spring;
imagesc(filtered_data);
axis xy;
subplot(3,1,2:3);
colormap default;
hold on;
for j=1:size(filtered_data,1)
	plot((filtered_data(j,:)./4)+(j-1));
end
ylim([-0.5 size(filtered_data,1)+1]);
hold off;