% finding sleep repeatability of song

% square the signal, detrend the data, take an average of all the traces 
% during song reverse that, and turn it into a filter and look for large
% amplitudes through the sample, which could indicate activity resembling
% what is seen during singing

% cluster the songs
% assumes you are in the mat folder
audio_load=@(FILE) fw_audioload(FILE);
data_load=@(FILE) fw_lg373_dataload(FILE);

% cluster the data as per usual with new arguments

zftftb_song_clust(pwd,'audio_load',audio_load,'data_load',data_load);

rs = input('what did you name the directory? ', 's');

% assumes extracted_data.mat has been loaded
load(strcat(rs, '_MANUALCLUST/extracted_data.mat'));
% this fw_analysis goes 

% use agg_data, which contains the voltage traces, to then average out the basic filter

cd('../sleep');

files = dir('sleepdata1*.mat');

for i=1:length(files)
	clear adc audio aux digin digout ephys file_datenum filestatus notes original_filename parameters playback ttl
	load(files(i).name);


% search through all the sleep data files 


% find the max amplitude, and give a hit for everything that is greater than
% 80% of the max