% this script computes the average firing rate of cells during singing, then
% uses that to compare similarity of firing rate during sleep
% after filtering the data, this script finds the maximum similarity in each file
% (not relative to each other, but just to that file) which means many samples will not
% be similar but will be the most similar in that file. Work needs to be done to only
% pick out the most similar examples


% first let's form a template...

if ~exist('spikoclust_spike_detect')
	disp('This library relies on Jeff''s spikoclust library, to be downloaded at:\n https://github.com/jmarkow/spikoclust/archive/master.zip')
	return
end

load('extracted_data.mat', 'agg_data');

sr=[];
smoothv=300;

% take sample spectrogram

trim=[.2 .2]; % remove pads
spike_sigma=.0025; % smoothing factor for spikes (5 ms sigma Gaussian, decent starting point)
template_fs=500; % new sampling rate

spike_kernel_t=[-spike_sigma*3:1/agg_data.fs:spike_sigma*3];
spike_kernel=normpdf(spike_kernel_t,0,spike_sigma);


% filter extracellular signal liberally for LFP

%[b,a]=ellip(3,.2,40,[5 100]/(agg_data.fs/2),'bandpass');

[b,a]=ellip(3,.2,40,[100 5000]/(agg_data.fs/2),'bandpass');

% right now this script assumes lg373rblk as the processed bird

proc_data=double(agg_data.data(:,:,1));
filt_lfp=filtfilt(b,a,proc_data);
timevec=[1:size(agg_data.data,1)]/agg_data.fs;

[b,a]=ellip(2,.2,40,[300 3e3]/(agg_data.fs/2),'bandpass');
filt_spikes=filtfilt(b,a,proc_data);

% threshold for each trial, takes std across rows

threshold=2*std(filt_spikes); 
[na,nb]=size(filt_spikes);

template=sum(filt_spikes'.*filt_spikes');
template=template/nb;
template=smooth(template, smoothv);


[nsamples,ntrials]=size(proc_data);
idxs=round(trim(1)*agg_data.fs):round(nsamples-trim(2)*agg_data.fs);



if ~exist('../filter_template.mat', 'file')
	save('../filter_template.mat', 'spike_template');
end


files = dir('sleep*.mat');

% only looks through the first twenty files

files = files(1:49);

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

%

fw=[];
rv=[];
%trim  -to focus on a piece of the template
template=template(6000:10000);
for i=1:length(files)

	% load data
	load(files(i).name, 'ephys');
	temp_data = filtfilt(b,a, double(ephys.data(:,1) - ephys.data(:,2)));
    z=temp_data.*temp_data;
    z=smooth(z,smoothv);
    r1=xcorr(template(1:end)-mean(template),z-mean(z));
    r2=xcorr(template(end:-1:1)-mean(template),z-mean(z));
    fw=[fw max(r1)];
    rv=[rv max(r2)];
end
%statistical significance.
sr=[sr signrank(fw-rv)]

