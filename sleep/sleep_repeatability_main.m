% finding sleep repeatability of song

% square the signal, detrend the data, take an average of all the traces 
% during song reverse that, and turn it into a filter and look for large
% amplitudes through the sample, which could indicate activity resembling
% what is seen during singing

% cluster the songs
% assumes you are in the mat folder

% bandpass filter between 100-3khz
% square the filtered result
% filter with a moving average
% take mean and subtract

skipfiles = 3; % how many files to initially skip (1 = no skipping)
% downsampleFactor = 10;
numFiles = 600; % number of files to look through

% detection threshold for sleep data
templatePercentage = 0.999999999999; % percentage of matching

audio_load=@(FILE) fw_audioload(FILE);
data_load=@(FILE) fw_lg373_dataload(FILE);

% cluster the data as per usual with new arguments

% zftftb_song_clust(pwd,'audio_load',audio_load,'data_load',data_load);

% rs = input('what did you name the directory? ', 's');
cd('/Users/wgillis/Desktop/lg373_agg_song/songmat');
rs = 'sleep_songs';

% assumes extracted_data.mat has been loaded
load(strcat(rs, '_MANUALCLUST/extracted_data.mat'));
% this fw_analysis goes 

% use agg_data, which contains the voltage traces, to then average out the basic filter

% this is now a 1xN vector
data = zeros(size(agg_data.data, 1), size(agg_data.data,2));
for i=1:size(agg_data.data,2)
	% fourth order bandpass elliptical filter between 100Hz and 3kHz
	data(:,i) = bandpassFiltData(agg_data.data(:,i), [100 3e3]/(agg_data.fs/2), 4);
end

% window of 3ms
windowLength = 2*agg_data.fs/1000;
smoothedSongData = squareAndDetrend(data(:,:), windowLength);

% smooth the data (run an fir filter through the data as a moving average)
clear agg_data;

% downsample data
% smoothedSongData = downsample(smoothedSongData, downsampleFactor);
% this smoothed result will be used as the filter 
templateMatch = flipud(smoothedSongData(:));
% templateMatch = smoothedSongData(:);

% filter first then detrend
cd('../../lg373_agg_sleep');

% mkdir('figs');
% mkdir('figs/small');
% mkdir('figs/cumulative');
% mkdir('figs/small/png');
% mkdir('figs/small/fig');
% mkdir('figs/cumulative/png');
% mkdir('figs/cumulative/fig');

% mkdir('figs/phaseShifted');
% mkdir('figs/phaseShifted/png');
% mkdir('figs/phaseShifted/fig');
% mkdir('figs/phaseShifted/two');

files = dir('sleepdata1*.mat');
if(numFiles == 0)
	numFiles = length(files);
end

% scores = [];
hits = 0;
potentialMatchesFound = 0;
scrambled_hits = 0;
scrambled_matchesFound = 0;

for i=1:skipfiles:numFiles

	clear ephys;
	st = sprintf('Now looking in file number %d, name: %s', i, files(i).name);
	% disp(st);
	load(files(i).name, 'ephys');
	data1 = bandpassFiltData(ephys.data(:,1) - ephys.data(:,2), [100 3e3]/(ephys.fs/2), 4);
	% using a smaller window, then filter the signal

	windowed_data = window_data(data1, length(smoothedSongData), windowLength);

	for i=1:size(windowed_data, 2)

		% downsample data to match the song
		% windowLength2 = 1*ephys.fs/1000; % window length of 50ms

		% filter using the template
		scrambled = phase_scramble(windowed_data(:,i), 2);

		filteredSleep = filter(templateMatch, 1, windowed_data(:,i));
		scrambledFilter = filter(templateMatch, 1, scrambled);
		indices = findPotentialMatches(filteredSleep, smoothedSongData, templatePercentage);
		scrambled_indices = findPotentialMatches(scrambledFilter, smoothedSongData, templatePercentage);
		% scores(end+1) = max(filteredSleep);
		
		if(length(indices)>0)

			% plotAndSaveDataSmall(indices, smoothedSongData, filteredSleep, data, ephys.t, files(i).name);
			hits = hits + 1;
			potentialMatchesFound = potentialMatchesFound + length(indices);

			%plotAndSaveDataCumulative(indices, smoothedSongData, filteredSleep, smoothedData, downsampledT, files(i).name);
		end
		if(length(scrambled_indices)>0)
			scrambled_hits = scrambled_hits + 1;
			scrambled_matchesFound = scrambled_matchesFound + length(scrambled_indices);
		end
	end

end

% figure();

% plot(scores)
% title('Scores')
% st = sprintf('Average score is: %e', mean(scores));
% xlabel(st)

disp(sprintf('Number of hits: %d', hits));
disp(sprintf('Total number of potential matches from matching filter: %d', potentialMatchesFound));
disp(sprintf('Total number of scrambled hits: %d', scrambled_hits));
disp(sprintf('Total number of scrambled potential matches of filter: %d', scrambled_matchesFound));
% search through all the sleep data files 