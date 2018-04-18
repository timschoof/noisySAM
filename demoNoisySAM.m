%% run NoisySAM with a pulsed masker
clear
close all
NoisySAM('SR', 'starting_SNR',0, ...
    'usePlayrec', 1, ...
    'trackAbsThreshold', 0, 'modDepthAbsThreshold', 0, ...
    'VolumeSettingsFile', 'VolumeSettings4kHz.txt',...
    'PlotTrackFile', 1, 'outputAllWavs', 1, 'DEBUG', 0);
% ,...
%     'ToneDuration', 500, 'WithinPulseISI', 100, 'NoiseDuration', 500, ...
%     'LongMaskerNoise', 00, 'fixed', 'signal');
return

% with standard settings, peak amplitudes are about 0.62 so rms could be
% about 0.16 instead of 0.1

%% run NoisySAM with a long masker
clear
close all
NoisySAM('SR', 'starting_SNR',0, ...
    'VolumeSettingsFile', 'VolumeSettings4kHz.txt', ...
    'propLongMaskerPreTarget', 0.8, ...
    'SignalDuration', 500, ...
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