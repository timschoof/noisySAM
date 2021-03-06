%% run NoisySAM with a pulsed masker
clear
close all
SignalDuration=5000;
ISI=200;
LongNoiseDuration=SignalDuration*3+2*ISI;

    % 'LongMaskerNoise', LongNoiseDuration,...
NoisySAM('SR', 'starting_SNR',0, ...
    'VolumeSettingsFile', 'VolumeSettings4kHz.txt', ...
    'BackNzLevel',-10, ...
    'ISI', ISI, ...
    'LongMaskerNoise', LongNoiseDuration,...
    'NoiseDuration', SignalDuration, ...
    'SignalDuration', SignalDuration, ...
    'PlotTrackFile', 1, 'outputAllWavs', 1, 'DEBUG',0);
% ,...
%     'ToneDuration', 500, 'WithinPulseISI', 100, 'NoiseDuration', 500, ...
%     'LongMaskerNoise', 00, 'fixed', 'signal');


% with standard settings, peak amplitudes are about 0.62 so rms could be
% aboit 0.16 instead of 0.1

clear
close all
NoisySAM('SR', 'starting_SNR',0, ...
    'VolumeSettingsFile', 'VolumeSettings4kHz.txt', ...
    'propLongMaskerPreTarget', 0.8, ...
    'BackNzLevel',-100, ...
    'SignalDuration', 2500, ...
    'PlotTrackFile', 1, 'outputAllWavs', 1, 'DEBUG',0);
% ,...
%     'ToneDuration', 500, 'WithinPulseISI', 100, 'NoiseDuration', 500, ...
%     'LongMaskerNoise', 00, 'fixed', 'signal');
return

%% run NoisySAM with a long masker and low level
clear
close all
NoisySAM('SR', 'starting_SNR',0, ...
    'VolumeSettingsFile', 'VolumeSettings4kHz.txt', 'rms2use', .005,...
    'propLongMaskerPreTarget', 0.8, ...
    'SignalDuration', 500, ...
    'PlotTrackFile', 1, 'outputAllWavs', 1, 'DEBUG',0);
% ,...
%     'ToneDuration', 500, 'WithinPulseISI', 100, 'NoiseDuration', 500, ...
%     'LongMaskerNoise', 00, 'fixed', 'signal');
return


summaries('0-wavsOut', 'AllTheWavs');