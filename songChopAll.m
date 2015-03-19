directories = dir();

for i=3:length(directories)
	cd(directories(i).name)
	zftftb_song_chop(pwd);
	cd('..');

end