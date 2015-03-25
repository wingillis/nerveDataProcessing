t = 1:1/ephys.fs:length(ephys.t);

a_b = bandpassFiltData(ephys.data(:,vec(1))- ephys.data(:,vec(2)), [300 3e3]/(ephys.fs/2), 4);
a_c = bandpassFiltData(ephys.data(:,vec(1))- ephys.data(:,vec(3)), [300 3e3]/(ephys.fs/2), 4);
b_c = bandpassFiltData(ephys.data(:,vec(2))- ephys.data(:,vec(3)), [300 3e3]/(ephys.fs/2), 4);
aa = bandpassFiltData(ephys.data(:,vec(1)), [300 3e3]/(ephys.fs/2), 4);
bb = bandpassFiltData(ephys.data(:,vec(2)), [300 3e3]/(ephys.fs/2), 4);

figure();
sh(1) = subplot(5,1,1); 
plot(t, abs(aa) - abs(bb)); 
title('Absolute value subtraction');
sh(2) = subplot(5,1,2); 
plot(t, a_b); title('A-B'); 
sh(3) = subplot(5,1,3); 
plot(t, a_c); title('A-C'); 
sh(4) = subplot(5,1,4); 
plot(t, b_c); title('B-C');
sh(5) = subplot(5,1,5);
plot(t, abs(a_c) - abs(b_c));
title('Abs a-c - b-c')


linkaxes(sh, 'xy');
ylim([-300 300]);
