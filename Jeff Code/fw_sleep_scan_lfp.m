function hits=fw_sleep_scan_lfp(DIR,TEMPLATE,varargin)
%
%
%


nparams=length(varargin);

if mod(nparams,2)>0
	error('Parameters must be specified as parameter/value pairs');
end

template_fs=500;
freq_range=[5 100];

for i=1:2:nparams
	switch lower(varargin{i})
		case 'template_fs'
			template_fs=varargin{i+1};
		case 'freq_range'
			freq_range=varargin{i+1};
	end
end

TEMPLATE=TEMPLATE/norm(TEMPLATE,1);

listing=dir(fullfile(DIR,'*.mat'));
template_len=length(TEMPLATE);

hits=[];

for i=1:length(listing)

	
	i
	load(fullfile(DIR,listing(i).name),'ephys');

	[b,a]=ellip(3,.2,40,[freq_range]/(ephys.fs/2),'bandpass');

	target=filtfilt(b,a,ephys.data(:,1)-ephys.data(:,2));
	target=zscore(target);
	target=downsample(target,ephys.fs/template_fs);

	score=filter(TEMPLATE,1,target);

	[vals locs]=findpeaks(score,'minpeakheight',1.8,'minpeakdistance',10);

	for j=1:length(locs)
		hits=[hits target((locs(j)-(template_len-1)):locs(j))];
	end


end


