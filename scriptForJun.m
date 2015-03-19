% go to folder you want to extract data out of

zftftb_song_chop();

cd('chop_data/wav');

% before 

proc_dir = zftftb_song_clust(pwd);

% ask for name of folder
% sResult = input('What is the name of the MANUALCLUST folder? (excluding MANUALCLUST)?', 's');

load(strcat(proc_dir, '/extracted_data.mat'));

[sdi, f,t] = zftftb_sdi(agg_audio.data, agg_audio.fs);

cd('../..');

f = figure();
imagesc(sdi.im);
axis xy;

saveas(f, 'chop_data/sdi', 'png');
savefig(f, 'chop_data/Song_sdi');