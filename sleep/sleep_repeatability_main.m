% finding sleep repeatability of song

% square the signal, detrend the data, take an average of all the traces 
% during song reverse that, and turn it into a filter and look for large
% amplitudes through the sample, which could indicate activity resembling
% what is seen during singing

% cluster the songs
% assumes you are in the mat folder
skipfiles = 10; % how many files to initially skip
downsampleFactor = 10;

% detection threshold for sleep data
templatePercentage = 0.6; % percentage of matching

audio_load=@(FILE) fw_audioload(FILE);
data_load=@(FILE) fw_lg373_dataload(FILE);

% cluster the data as per usual with new arguments

zftftb_song_clust(pwd,'audio_load',audio_load,'data_load',data_load);

rs = input('what did you name the directory? ', 's');

% assumes extracted_data.mat has been loaded
load(strcat(rs, '_MANUALCLUST/extracted_data.mat'));
% this fw_analysis goes 

% use agg_data, which contains the voltage traces, to then average out the basic filter

% this is now a 1xN vector
subtractedMean = squareAndDetrend(agg_data.data(:,:));

% smooth the data (run an fir filter through the data as a moving average)

% making a window length of 50ms

windowLength = 5*agg_data.fs/100;
smoothedSongData = smoothData(subtractedMean, windowLength);

% downsample data
smoothedSongData = downsample(smoothedSongData, downsampleFactor);
% this smoothed result will be used as the filter 
templateMatch = flipud(smoothedSongData(:));


cd('../../lg373_agg_sleep');

files = dir('sleepdata1*.mat');

for i=1:length(files)

	clear ephys
	load(files(i).name, 'ephys');
	data = squareAndDetrend(ephys.data(:,1)-ephys.data(:,2));

	%downsample data to match the song
	windowLength2 = 5*ephys.fs/100; % window length of 50ms
	smoothedData = smoothData(data, windowLength2)
	smoothedData = downsample(smoothedData, downsampleFactor);
	downsampledT = downsample(ephys.t, downsampleFactor);

	% filter using the template
	filteredSleep = filter(templateMatch, 1, smoothedData);

	indices = findPotentialMatches(filteredSleep, templateMatch, templatePercentage);



end

% search through all the sleep data files 


% find the max amplitude, and give a hit for everything that is greater than
% 80% of the max