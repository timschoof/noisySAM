%% Bharadwaj 2015 J Neurosci
% Target: 500 Hz band of noise centered at 4 kHz and modulated at 19 Hz.
% Unmodulated bands of noise above (up to 10 kHz) and below (down to 20 Hz)
% served as maskers to reduce off-frequency cues.
% The target to notched-noise ratio was 10 dB, and the overall level was 80
% dB SPL [broadband root mean square (RMS)].
clear
CF=4000;
TargetWidth=500;
TW_limits=[-1/2, 1/2]*500 + CF;
LowestNoise=20;
HighestNoise=10000;
BackgroundWidth=(TW_limits(1)-LowestNoise) + (HighestNoise-TW_limits(2)) ;
% 10*log10(HighestNoise)
% 10*log10(BackgroundWidth)
% 10*log10(TargetWidth)

% Assuming flat spectra:
target=79.6;
background=69.6;
targetPerHz=target-10*log10(TargetWidth)
backgroundPerHz=background-10*log10(BackgroundWidth)
targetPerHz-backgroundPerHz