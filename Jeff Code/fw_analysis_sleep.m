% first let's form a template...

% take sample spectrogram

trim=[.2 .2]; % remove pads
spike_sigma=.0025; % smoothing factor for spikes (5 ms sigma Gaussian, decent starting point)
template_fs=500; % new sampling rate

spike_kernel_t=[-spike_sigma*3:1/ephys.fs:spike_sigma*3];
spike_kernel=normpdf(spike_kernel_t,0,spike_sigma);

[s,f,t]=zftftb_pretty_sonogram(audio.data(:,1),audio.fs,'filtering',300,'clipping',-5,'len',80,'overlap',79);

% filter extracellular signal liberally for LFP

[b,a]=ellip(3,.2,40,[5 100]/(ephys.fs/2),'bandpass');

proc_data=double(ephys.data(:,:,1)-ephys.data(:,:,2));
filt_lfp=filtfilt(b,a,proc_data);
timevec=[1:size(ephys.data,1)]/ephys.fs;

[b,a]=ellip(2,.2,40,[300 3e3]/(ephys.fs/2),'bandpass');
filt_spikes=filtfilt(b,a,proc_data);

% threshold for each trial, takes std across rows

threshold=3*std(filt_spikes); 

% only take [n]egative going spikes to start, take .001 .0015 seconds around each detected spike

spikes_threshold=spikoclust_spike_detect(filt_spikes,threshold,ephys.fs,'method','n','window',[.001 .0015]); 
%spikes_sorted=spikoclust_sort(proc_data,ephys.fs,'freq_range',[300 3e3],'spike_window',[.001 .0015],'clust_check',1:4,'sigma_t',3);

% should only have one cluster

figure();
ax(1)=subplot(3,1,1);
imagesc(t,f/1e3,s);axis xy;
ylabel('Fs (kHz)');

ax(2)=subplot(3,1,2:3);
spikoclust_raster(spikes_threshold.times/ephys.fs,spikes_threshold.trial);
axis tight;
linkaxes(ax,'x');
xlabel('Time (s)');
ylabel('Trial');


[nsamples,ntrials]=size(proc_data);
idxs=round(trim(1)*ephys.fs):round(nsamples-trim(2)*ephys.fs);

% now get smooth spike rate 

spikes_pp=zeros(nsamples,ntrials);
ind=sub2ind(size(spikes_pp),spikes_threshold.times,spikes_threshold.trial);
spikes_pp(ind)=1;
smooth_spikes=filter(spike_kernel,1,spikes_pp);

% spike template, average then downsample

spike_template=mean(zscore(smooth_spikes)');
spike_template=spike_template(idxs);
spike_template=flipud(spike_template(:));
spike_template=downsample(spike_template,ephys.fs/template_fs);

lfp_template=mean(zscore(filt_lfp)');
lfp_template=lfp_template(idxs);
lfp_template=flipud(lfp_template(:));
lfp_template=downsample(lfp_template,ephys.fs/template_fs);
