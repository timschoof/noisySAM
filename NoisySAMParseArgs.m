function sArgs=NoisySAMParseArgs(ListenerName,varargin)
% get arguments for NoisySAM

%% Bharadwaj 2015 J Neurosci
% Target: 500 Hz band of noise centered at 4 kHz and modulated at 19 Hz.
% Unmodulated bands of noise above (up to 10 kHz) and below (down to 20 Hz)
% served as maskers to reduce off-frequency cues.
% The target to notched-noise ratio was 10 dB, and the overall level was 80
% dB SPL [broadband root mean square (RMS)].
% Diotic presentation
% Assuming flat spectra:
%   target=79.6 dB SPL
%   background=69.6 dB SPL
%   target=52.6 dB SPL/Hz
%   background=29.8 dB SPL/Hz


p = inputParser;
p.addRequired('ListenerName', @ischar);

p.addParameter('SAMnoiseBandWidth', 500, @isnumeric); % always centred on the probe
p.addParameter('TargetCentreFreq', 4000, @isnumeric);
p.addParameter('ModulationRate', 20, @isnumeric);
p.addParameter('ModulationPhase', -pi/2, @isnumeric);

p.addParameter('SignalDuration', 400, @isnumeric);
p.addParameter('NoiseDuration', 500, @isnumeric);
% the duration of the masker pulse. If longer than the target, the target is
% centred in it. Only relevant if LongMaskerNoise=0
p.addParameter('LongMaskerNoise', 3000, @isnumeric);
% if 0, masker noise is pulsed along with target intervals
% if >0 = continuous through triple at given duration (ms)
p.addParameter('propLongMaskerPreTarget', 0.5, @isnumeric);
% a parameter to put targets towards one end or the other of the
% LongMaskerNoise. This is the proportion of time that the 'extra' masker
% duration is put at the start of the trial
p.addParameter('preSilence', 100, @isnumeric);
% an interval of silence prepended to the wave to try to avoid sound glitches in Windows

p.addParameter('usePlayrec', 1, @isnumeric); % are you using playrec? yes = 1, no = 0
p.addParameter('VolumeSettingsFile', 'VolumeSettings.txt', @ischar);
p.addParameter('rms2use', 0.1, @isnumeric); % for the target
p.addParameter('ear', 'B', @ischar); % B, L, or R ear(s)
p.addParameter('RiseFall', 50, @isnumeric);
p.addParameter('ISI', 400, @isnumeric);
p.addParameter('SampFreq', 44100, @isnumeric);
p.addParameter('dBSPL', 70, @isnumeric);
% the nominal level of the fixed signal or noise - not yet used

%% parameters concerned with tracking and the task
% p.addParameter('inQuiet',0, @isnumeric);
% present tones in quiet in order to find absolute threshold without the
% masker present. Only makes sense for fixed masker
p.addParameter('starting_SNR',0, @isnumeric);
p.addParameter('START_change_dB', 4, @isnumeric);
p.addParameter('MIN_change_dB', 1, @isnumeric);
p.addParameter('LevittsK', 2, @isnumeric);
p.addParameter('INITIAL_TURNS', 3, @isnumeric);
p.addParameter('FINAL_TURNS', 4, @isnumeric);
p.addParameter('InitialDescentMinimum', -8, @isnumeric);
p.addParameter('TaskFormat', '3I-3AFC', @(x)any(strcmpi(x,{'3I-3AFC','3I-2AFC'})));
p.addParameter('Order', 2, @isnumeric);
p.addParameter('FeedBack', 'Corrective', @ischar);
p.addParameter('MAX_TRIALS', 30, @isnumeric);
p.addParameter('FacePixDir', 'Bears', @ischar);
%% parameters concerned with background noise
p.addParameter('BackNzLevel',-10, @isnumeric); % in dB re target level
p.addParameter('LoBackNzLoPass',3750, @isnumeric);
p.addParameter('LoBackNzHiPass',20, @isnumeric);
%p.addParameter('HiBackNzLevel',0, @isnumeric); % in absolute rms
p.addParameter('HiBackNzLoPass',10000, @isnumeric);
p.addParameter('HiBackNzHiPass',4250, @isnumeric);
% p.addParameter('BackNzPulsed',0, @isnumeric); % 0 = continuous through triple
%% parameters concerned with debugging
p.addParameter('PlotTrackFile', 0, @isnumeric); % once test is finished
p.addParameter('DEBUG', 0, @isnumeric);
p.addParameter('outputAllWavs', 0, @isnumeric); % for debugging purposes
p.addParameter('MAX_SNR_dB', 22, @isnumeric);
p.addParameter('IgnoreTrials', 3, @isnumeric); % number of initial trials to ignore errors on
p.addParameter('OutputDir','results', @ischar);
p.addParameter('StartMessage', 'none', @ischar);
p.addParameter('MaxBumps', 3, @isnumeric);
% p.addParamValue('PresentInQuiet', 0, @(x)x==0 || x==1);

%% parameters concerned with tracking the absolute threshold of the stimuli
%  with a given modulation depth
p.addParameter('trackAbsThreshold', 0, @isnumeric);
p.addParameter('modDepthAbsThreshold', -99, @isnumeric);

p.parse(ListenerName, varargin{:});
sArgs=p.Results;
sArgs.SNR_dB = sArgs.starting_SNR; % current level

sArgs.SAMnoiseBandLimits=[sArgs.TargetCentreFreq-sArgs.SAMnoiseBandWidth/2 sArgs.TargetCentreFreq+sArgs.SAMnoiseBandWidth/2];
sArgs.rms2useBackNz = sArgs.rms2use * 10^(sArgs.BackNzLevel/20);

% if masker is fixed, calculate relative spectrum level of masker and
% background noise
% if strcmp(sArgs.fixed, 'noise') && sArgs.BackNzLevel>0
%     masker_dBperHz = 20*log10(sArgs.rms2use)-10*log10(sArgs.NoiseBandWidth);
%     backgroundNz_dBperHz = 20*log10(sArgs.BackNzLevel)-10*log10(sArgs.BackNzLoPass-sArgs.BackNzHiPass);
%     sArgs.BackNzdB_re_Msk =  backgroundNz_dBperHz-masker_dBperHz;
%     fprintf('BackNzdB_re_Msk= %3.1f\n', sArgs.BackNzdB_re_Msk);
% end

% calculate initialDelay, the time before the 1st signal interval can occur
if sArgs.LongMaskerNoise<=0 % if maskers are pulsed
    % error('pulsed background noises not implemented');
    %% Insist that the duration of the noise is at least as long as the signal
    if sArgs.SignalDuration > sArgs.NoiseDuration
        error('Background noise pulse must be longer than the signal: Nz=%d Sig=%d', ...
            sArgs.NoiseDuration,sArgs.SignalDuration);
    end
    sArgs.initialDelay = (sArgs.NoiseDuration-sArgs.SignalDuration)/2;
else
    sArgs.initialDelay = sArgs.propLongMaskerPreTarget*(sArgs.LongMaskerNoise - (3*sArgs.SignalDuration+2*sArgs.ISI));
end
sArgs.initialDelay = sArgs.initialDelay + sArgs.preSilence;


