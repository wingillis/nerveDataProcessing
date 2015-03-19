figure(); 
plot(amp.data(1,:) - amp.data(2,:));


[b,a] = ellip(4,.2,60, [100, 3e3]/(params.amplifier_sample_rate/2), 'bandpass');

d = filtfilt(b,a, amp.data(1,:)-amp.data(2,:));

figure(); 
plot(amp.t, d);