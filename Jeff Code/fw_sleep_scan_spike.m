function hits=fw_sleep_scan_spike(DIR,TEMPLATE,varargin)
%
%
%


nparams=length(varargin);

if mod(nparams,2)>0
	error('Parameters must be specified as parameter/value pairs');
end

template_fs=500;
spike_thresh=3;
spike_sigma=.0025;
freq_range=[300 3e3];

for i=1:2:nparams
	switch lower(varargin{i})
		case 'template_fs'
			template_fs=varargin{i+1};
		case 'spike_thresh'
			spike_thresh=varargin{i+1};
		case 'spike_sigma'
			spike_sigma=varargin{i+1};
		case 'freq_range'
			freq_range=varargin{i+1};
	end
end

TEMPLATE=TEMPLATE/norm(TEMPLATE,1);
listing=dir(fullfile(DIR,'*.mat'));
template_len=length(TEMPLATE);

hits=[];

for i=1:20

	i

	load(fullfile(DIR,listing(i).name),'ephys');

	spike_kernel_t=[-spike_sigma*3:1/ephys.fs:spike_sigma*3];
	spike_kernel=normpdf(spike_kernel_t,0,spike_sigma);

	[b,a]=ellip(3,.2,40,[freq_range]/(ephys.fs/2),'bandpass');
	filt_spikes=filtfilt(b,a,ephys.data(:,1)-ephys.data(:,2));
	threshold=spike_thresh*(std(filt_spikes));

	spikes_threshold=spikoclust_spike_detect(filt_spikes,threshold,ephys.fs,'method','n','window',[.001 .0015],'visualize','n');

	% make a pp, filter to make smooth rate

	% slide a window across, zscore w/in window
	
	spikes_pp=zeros(size(filt_spikes));
	spikes_pp(spikes_threshold.times)=1;
	spikes_smooth=filter(spike_kernel,1,spikes_pp);
	spikes_smooth=downsample(spikes_smooth,ephys.fs/template_fs);	

	spikes_len=length(spikes_smooth);
	
	idxs=1:(spikes_len)-template_len;

	score=zeros(1,length(idxs));

	for j=idxs
		win=zscore(spikes_smooth(j:j+template_len-1));
		score(j)=sum(flipud(TEMPLATE).*win);
	end

	[vals locs]=findpeaks(score,'minpeakheight',.9,'minpeakdistance',10);

	for j=1:length(locs)
		disp('test')
		hits=[hits spikes_smooth(locs(j):locs(j)+(template_len-1))];
	end

end

