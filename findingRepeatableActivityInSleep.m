mkdir('dm_data');

files = dir('*.mat');

[b,a] = ellip(4, .2, 60, [300 4e3]/(20e3/2), 'bandpass');
difference = [];
for i=1:3:length(files)

	load(files(i).name, 'amp');
	difference = cat(2, difference, filtfilt(b,a, amp.data(1,:) - amp.data(2,:)).^2);

	clear amp

end
disp('Loaded all files');
disp('Downsampling');
dsmplDiff = downsample(smooth(difference, 1000), 100);


clear difference;

m = [];
numberFiles = 1;
matrixFileNumber = int64(length(dsmplDiff)/ numberFiles);
windowIndex = 1:50;
wTemp = [];
% windowSize = 100;
disp('Building distance matrix');


for j=1:numberFiles
    for i=(j-1)*matrixFileNumber + 1:5:matrixFileNumber*j-4
        if (length(dsmplDiff)<windowIndex(end))
            continue
        else
    	   m = cat(2, m, dsmplDiff(windowIndex));
           windowIndex = windowIndex + 4;
       end
    end

    save(strcat('dm_data/', num2str(j), '_distance_matrix.mat'), 'm');
    m = [];
end

disp('Computing pairwise distance');
load('dm_data/1_distance_matrix.mat')
daAns = pdist(m);
clear m;
daAns = squareform(daAns);
figure();

imagesc(daAns);