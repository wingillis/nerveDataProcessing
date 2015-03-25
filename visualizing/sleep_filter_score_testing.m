faux_signal = randn(100,1);
match_score = 0.9; % percent
embeddedSignal = [randn(300,1); faux_signal; randn(200,1)];
n = 1:length(embeddedSignal);
template_filter = flipud(faux_signal(:));


filtered_signal = filter(template_filter, 1, embeddedSignal);

norm_factor = faux_signal.'*faux_signal;

matches = n(filtered_signal>norm_factor*match_score);
disp(matches)
reversed_filtered_signal = filter(faux_signal, 1, embeddedSignal);

rev_matches = n(reversed_filtered_signal>norm_factor*match_score);
disp(rev_matches)
figure();
plot(n, embeddedSignal, 'k', n(301:400), faux_signal, 'g', n(matches), embeddedSignal(matches), 'ro');
hold on;
% plot(n(matches), embeddedSignal(matches), 'ro');
title('normal matches')
figure();
plot(n, embeddedSignal, 'k', n(301:400), faux_signal, 'g',  n(rev_matches), embeddedSignal(rev_matches), 'ro');
title('reversed matches')
figure();
plot(filtered_signal);
title('normal filter')

figure();
plot(reversed_filtered_signal)
title('reverse filter')