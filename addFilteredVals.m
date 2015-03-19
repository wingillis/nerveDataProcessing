%% channel 50 is difference data
% channel 60 is filtered difference data
% channel 20 and 30 are filtered data
% channel 40 takes the absolute vale of filtered channels and subtracts them
% channel 70 is the smoothed absolute value data, with a smoothing window of 25
% because the fs is 20kHz and a spike is 1kHz, so at least 20 data points would be smoothed
% with a small amount of padding
% Channel 80 is smoothed with a larger window, more looking for stereotypy than before
% letters are appended with Z
clear all
warning('Warning: this file assumes 20kHz sampling rate')

files = dir('*.mat');
% scrsz = get(groot,'ScreenSize');

disp('Bandpass elliptical filtering: 200Hz - 2kHz');
%[b2, a2] = ellip(4, .2, 60, 200/(20e3/2), 'high');
mkdir('dataFigures');

for i=1:length(files)

    [b, a] = ellip(4, .2, 60, [200 2e3]/(20e3/2), 'bandpass');
    [b2, a2] = ellip(4, .2, 60, 120/(20e3/2), 'low');
    s = sprintf('Loading file %s', files(i).name);
    disp(s)
    load(files(i).name);
    timeSpan = ephys.t(end) - ephys.t(1);
    audioTimeSpan = audio.t(end) - audio.t(1);
    t = linspace(0,timeSpan, length(ephys.t));
    audiot = linspace(0, timeSpan,length(audio.t));
    % channel 12 data
    filtCh(:,1) = filtfilt(b,a,ephys.data(:,1));
    % channel 14 data
    filtCh(:,2) = filtfilt(b,a,ephys.data(:,2));

    ephys.data(:,3) = filtCh(:,1);
    ephys.data(:,4) = filtCh(:,2);
    ephys.data(:,5) = ephys.data(:,1) - ephys.data(:,2);
    ephys.data(:,6) = filtCh(:,1) - filtCh(:,2);
    ephys.data(:,7) = abs(filtCh(:,1)) - abs(filtCh(:,2));
    ephys.data(:,8) = smooth(ephys.data(:,7), 25);
    ephys.data(:,9) = smooth(ephys.data(:,7), 400);
    ephys.labels = [12 14 20 30 50 60 40 70 80];
    ephys.ports = 'AAZZZZZZZ';
    lfp = filtfilt(b2,a2, ephys.data(:,1));

    % first figure of abs value subtracted filtered signals
    s = sprintf('Making figure 1 of file %d', i);
    disp(s)
    maxVal = max(abs(ephys.data(:,7)));
    lim = min([200 maxVal]);
    lim = max([60 lim]);
    f(1) = figure(1);
    sh(1) = subplot(2,1,1);
    plot(t, ephys.data(:,7), 'Color', [0 0.65 0]);
    xlabel('Time (s)');
    ylabel('Voltage (µV)');
    axis tight;
    ylim([-lim lim]);
    title('Difference of absolute values of filtered signal');
    sh(2) = subplot(2,1,2);
    %plot(audiot, audio.data(:,1), 'k');
    specgram(audio.data(:,1));
    %linkaxes(sh, 'x');
    %set(gcf, 'Units', 'Inches', 'Position', [0, 0, 22, 14], 'PaperUnits', 'Inches', 'PaperSize', [22, 14]);
    % saveas(f(1), strcat('dataFigures/abs_fDiff_', files(i).name(1:end-4)), 'png');
    % savefig(f(1), strcat('dataFigures/abs_fDiff_',files(i).name(1:end-4)));
    close(f(1));
    % second figure
    s = sprintf('Making figure 2 of file %d', i);
    disp(s)
    maxVal = max(abs(ephys.data(:,6)));
    lim = min([200 maxVal]);
    lim = max([60 lim]);
    f(2) = figure(2);
    sh(1) = subplot(2,1,1);
    plot(t, ephys.data(:,6), 'Color', [0.3255 0.0510 1]);
    xlabel('Time (s)');
    ylabel('Voltage (µV)');
    axis tight;
    ylim([-lim lim]);
    title('Difference of filtered signal');
    sh(2) = subplot(2,1,2);
    %plot(audiot, audio.data(:,1), 'k');
    specgram(audio.data(:,1));
    %linkaxes(sh, 'x');
    %set(gcf, 'Units', 'Inches', 'Position', [0, 0, 22, 14], 'PaperUnits', 'Inches', 'PaperSize', [22, 14]);
    % saveas(f(2), strcat('dataFigures/fDiff_', files(i).name(1:end-4)), 'png');
    % savefig(f(2), strcat('dataFigures/fDiff_',files(i).name(1:end-4)));
    close(f(2));

    dataLength = length(ephys.data(:,1));
    timeLength = dataLength/ephys.fs;
    threeSeconds = 1:3*ephys.fs;
    threeHundredMills = 1:.3*ephys.fs;
    middle = 1.5*ephys.fs;
    middleThree = .15*ephys.fs;
    dataMiddle = dataLength/2;
    dataIndexThree = int64(threeHundredMills + dataMiddle - middleThree);
    % plots zoomed samples from the middle of the data file
    if (timeLength > 3.01)
        dataIndex = int64(threeSeconds + dataMiddle - middle);
        s = sprintf('Making figure 3 of file %d', i);
        disp(s)
        maxVal = max(abs(ephys.data(dataIndex,7)));
        lim = min([200 maxVal]);
        lim = max([60 lim]);
        f(3) = figure(3);
        sh(1) = subplot(2,1,1);
        plot(t(dataIndex), ephys.data(dataIndex,7), 'Color', [0 0.65 0]);
        xlabel('Time (s)');
        ylabel('Voltage (µV)');
        axis tight;
        ylim([-lim lim]);
        title('Difference of abs val of filtered signal (3s span)');
        sh(2) = subplot(2,1,2);
        %plot(audiot(dataIndex), audio.data(dataIndex,1), 'k');
        specgram(audio.data(dataIndex,1));
        %linkaxes(sh, 'x');
        %set(gcf, 'Units', 'Inches', 'Position', [0, 0, 22, 14], 'PaperUnits', 'Inches', 'PaperSize', [22, 14]);
        % saveas(f(3), strcat('dataFigures/zabs_fDiff_', files(i).name(1:end-4)), 'png');
        % savefig(f(3), strcat('dataFigures/zabs_fDiff_',files(i).name(1:end-4)));
        close(f(3));

        s = sprintf('Making figure 4 of file %d', i);
        disp(s)
        maxVal = max(abs(ephys.data(dataIndex,6)));
        lim = min([200 maxVal]);
        lim = max([60 lim]);
        f(4) = figure(4);
        sh(1) = subplot(2,1,1);
        plot(t(dataIndex), ephys.data(dataIndex,6), 'Color', [0.3255 0.0510 1]);
        xlabel('Time (s)');
        ylabel('Voltage (µV)');
        axis tight;
        ylim([-lim lim]);
        title('Difference of filtered signal (3s span)');
        sh(2) = subplot(2,1,2);
        %plot(audiot(dataIndex), audio.data(dataIndex,1), 'k');
        specgram(audio.data(dataIndex, 1));
        %linkaxes(sh, 'x');
        %set(gcf, 'Units', 'Inches', 'Position', [0, 0, 22, 14], 'PaperUnits', 'Inches', 'PaperSize', [22, 14]);
        % saveas(f(4), strcat('dataFigures/zfDiff_', files(i).name(1:end-4)), 'png');
        % savefig(f(4), strcat('dataFigures/zfDiff_',files(i).name(1:end-4)));
        close(f(4));

        s = sprintf('Making figure 5 of file %d', i);
        disp(s)
        maxVal = max(abs(ephys.data(dataIndex,8)));
        lim = min([200 maxVal]);
        lim = max([60 lim]);
        f(6) = figure(6);
        sh(1) = subplot(2,1,1);
        plot(t(dataIndex), ephys.data(dataIndex,8), 'Color', [0.3255 0.0510 1]);
        hold on;
        line([t(dataIndex(1)) t(dataIndex(end))], [0 0], 'Color', 'r');
        hold off;
        xlabel('Time (s)');
        ylabel('Voltage (µV)');
        axis tight;
        ylim([-lim lim]);
        title('Smoothed signal (3s span; 25 averaged windows)');
        sh(2) = subplot(2,1,2);
        %plot(audiot(dataIndex), audio.data(dataIndex,1), 'k');
        specgram(audio.data(dataIndex, 1));
        %linkaxes(sh, 'x');
        % set(gcf, 'Units', 'Inches', 'Position', [0, 0, 22, 14], 'PaperUnits', 'Inches', 'PaperSize', [22, 14]);
        % saveas(f(6), strcat('dataFigures/zsmooth25', files(i).name(1:end-4)), 'png');
        % savefig(f(6), strcat('dataFigures/zsmooth25',files(i).name(1:end-4)));
        close(f(6));
        s = sprintf('Making figure 6 of file %d', i);
        disp(s)
        maxVal = max(abs(ephys.data(dataIndex,9)));
        lim = min([200 maxVal]);
        lim = max([60 lim]);
        f(7) = figure(7);

        sh(1) = subplot(2,1,1);
        plot(t(dataIndex), ephys.data(dataIndex,9), 'Color', [0.3255 0.0510 1]);
        hold on;
        line([t(dataIndex(1)) t(dataIndex(end))], [0 0], 'Color', 'r');
        hold off;
        xlabel('Time (s)');
        ylabel('Voltage (µV)');
        axis tight;
        ylim([-lim lim]);
        title('Smoothed abs subtracted signal (3s span; 400 averaged windows)');
        sh(2) = subplot(2,1,2);
        %plot(audiot(dataIndex), audio.data(dataIndex,1), 'k');
        specgram(audio.data(dataIndex, 1));
        %linkaxes(sh, 'x');
        %set(gcf, 'Units', 'Inches', 'Position', [0, 0, 22, 14], 'PaperUnits', 'Inches', 'PaperSize', [22, 14]);
        %saveas(f(7), strcat('dataFigures/zsmooth400', files(i).name(1:end-4)), 'png');
        %savefig(f(7), strcat('dataFigures/zsmooth400',files(i).name(1:end-4)));
        close(f(7));

        s = sprintf('Making figure 7 of file %d', i);
        disp(s)
        maxVal = max(abs(ephys.data(dataIndex,7)));
        lim = min([200 maxVal]);
        lim = max([60 lim]);
        f(8) = figure(8);

        sh(1) = subplot(2,1,1);
        plot(t(dataIndex), ephys.data(dataIndex,7), 'Color', [0 0.65 0]);
        hold on;
        line([t(dataIndex(1)) t(dataIndex(end))], [0 0], 'Color', 'r');
        hold off;
        xlabel('Time (s)');
        ylabel('Voltage (µV)');
        axis tight;
        ylim([-lim lim]);
        title('LFP');
        sh(2) = subplot(2,1,2);
        plot(t(dataIndex), lfp(dataIndex), 'k');

        linkaxes(sh, 'x');
        %set(gcf, 'Units', 'Inches', 'Position', [0, 0, 22, 14], 'PaperUnits', 'Inches', 'PaperSize', [22, 14]);
        % saveas(f(8), strcat('dataFigures/lfp', files(i).name(1:end-4)), 'png');
        % savefig(f(8), strcat('dataFigures/lfp',files(i).name(1:end-4)));
        close(f(8));



    end
    s = sprintf('Making figure 8 of file %d', i);
    disp(s)
    maxVal = max(abs(ephys.data(dataIndexThree,6)));
    lim = min([200 maxVal]);
    lim = max([60 lim]);
    f(5) = figure(5);
    sh(1) = subplot(2,1,1);
    plot(t(dataIndexThree), ephys.data(dataIndexThree, 6), 'Color', [1 0.2627 0]);
    xlabel('Time (s)');
    ylabel('Voltage (µV)');
    axis tight;
    ylim([-lim lim]);
    title('Difference of filtered signal (300ms span)');
    sh(2) = subplot(2,1,2);
    %plot(audiot(dataIndexThree), audio.data(dataIndexThree,1), 'k');
    specgram(audio.data(dataIndexThree,1));
    %linkaxes(sh, 'x');
    %set(gcf, 'Units', 'Inches', 'Position', [0, 0, 22, 14], 'PaperUnits', 'Inches', 'PaperSize', [22, 14]);
    % saveas(f(5), strcat('dataFigures/zzfDiff_', files(i).name(1:end-4)), 'png');
    % savefig(f(5), strcat('dataFigures/zzfDiff_',files(i).name(1:end-4)));
    close(f(5));
    clear filtCh f dataLength timeLength threeSeconds middle middleThree dataMiddle dataIndex dataIndexThree s b a threeHundredMills
    save(files(i).name, 'adc', 'audio', 'aux', 'digin','digout', 'ephys','file_datenum', 'filestatus','notes','original_filename','parameters','playback','ttl');

end