clear all;
uiopen('load');

[b,a] = ellip(4,.2,60, [250 5e3]/(parameters.amplifier_sample_rate/2), 'bandpass');

figure();
subplot(4,1,1);
specgram(audio.data);

sh(1) = subplot(4,1,2);
title('Channel 1');
plot(filtfilt(b,a,ephys.data(:,3)));

sh(2) = subplot(4,1,3);
title('Channel 2');
plot(filtfilt(b,a,ephys.data(:,4)));

sh(3) = subplot(4,1,4);
title('Channel 3');
plot(filtfilt(b,a,ephys.data(:,5)));

linkaxes(sh, 'x');
axis tight;