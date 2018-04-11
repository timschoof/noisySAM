function Nz = GenerateBackgroundNoiseSAM(p)
%
% Note inconsistent use of the variable LongMaskerNoise between this script
% and Berniotis. Here, LongMaskerNoise is used to determine the duration of
% the background noise (not a masker per se) whereas in Berniotis, it
% referes to the maskers which are in addition to another background noise

if p.LongMaskerNoise<=0 % if maskers are pulsed along with signals
    % error('pulsed background noises not implemented');
    NzSamples=samplify(p.NoiseDuration,p.SampFreq);
    duration = p.NoiseDuration;
else
    NzSamples=samplify(p.LongMaskerNoise,p.SampFreq);
    duration = p.LongMaskerNoise;
end
ISIsamples=samplify(p.ISI,p.SampFreq);
if  p.rms2useBackNz >0
    % generate the noise though ifft
    f=[p.LoBackNzHiPass  p.LoBackNzHiPass+1  p.LoBackNzLoPass  p.LoBackNzLoPass+1 ...
        p.HiBackNzHiPass  p.HiBackNzHiPass+1  p.HiBackNzLoPass  p.HiBackNzLoPass+1 ];
    l=[0   100   100   0  0   100   100   0];
    [Nz, ~]=noise(f,l,p.SampFreq,duration/1000);
    % adjust to the appropriate rms level
    Nz =  adjustRMS(Nz', p.rms2use * 10^(p.BackNzLevel/20));
    % window in the appropriate way by constructing an envelope
    Env = ones(NzSamples,1);
    Env=taper(Env, p.RiseFall, p.RiseFall, p.SampFreq);
    % need to shorten noise (typically)
    start = randi(length(Nz)-length(Env));
    Nz = Nz(start:start+length(Env)-1) .* Env;
else
    Nz = zeros(NzSamples,1);
end
% p.addParameter('BackNzLevel',0, @isnumeric); % in absolute rms
% p.addParameter('BackNzLoPass',0, @isnumeric);
% p.addParameter('BackNzHiPass',50, @isnumeric);

function y = adjustRMS(x, RMS)
y = RMS*x/rms(x);
if max(abs(y))>=1
    error('Clipping from adjustRMS');
end