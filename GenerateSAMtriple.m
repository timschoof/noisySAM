function [w, AMnz, modulator]=GenerateSAMtriple(p)
ISIsamples=samplify(p.ISI,p.SampFreq);
ISIwave=zeros(ISIsamples,1);

AMnz=[];
w=[];
if p.LongMaskerNoise<=0
    % error('pulsed background noises not implemented');
    % calculate the necessary offsets to make the target pulse the same
    % duration as the masker
    BackNzSamples=samplify(p.NoiseDuration,p.SampFreq);
    TargetSamples=samplify(p.SignalDuration,p.SampFreq);
    pre = zeros(ceil((BackNzSamples-TargetSamples)/2),1);
    post = zeros(BackNzSamples-(TargetSamples+length(pre)),1);
    for i=1:3
        % generate one signal
        % function [Nz, flatNz, modulator]=GenerateSAMnz(ModulationPresent, p)
        [AM, flatNz, modulator]=GenerateSAMnz(p.Order==i, p);
        % centre the AM pulse in the background noise
        AM = vertcat(pre, AM, post);
        % generate a single pulse of background noise
        backNz=GenerateBackgroundNoiseSAM(p);
        w=vertcat(w, AM+backNz);
        if i<3
            w=vertcat(w,ISIwave);            
        end
    end
else % long masker (actually background noise)
    % generate the signal pulses
    % construct the 3 intervals with ISIs
    for i=1:3
        % function [Nz, flatNz, modulator]=GenerateSAMnz(ModulationPresent, p)
        [Nz, flatNz, modulator]=GenerateSAMnz(p.Order==i, p);
        AMnz=vertcat(AMnz, Nz);
        if i<3
            AMnz=vertcat(AMnz,ISIwave);
        end
    end
    %% generate and add in background noise when it is long,
    %  i.e., played through the triple
    if p.rms2useBackNz > 0
        w=GenerateBackgroundNoiseSAM(p);
        % centre targets in background noise
        xtra = length(w)-length(AMnz);
        xtraFront = ceil(p.propLongMaskerPreTarget*xtra);
        if xtra>0
            AMnz=vertcat(zeros(xtraFront,1),AMnz, zeros(xtra-xtraFront,1));
        end
        w = w + AMnz;
    else
        w = AMnz;
    end
    
end

% prepend silence to wave if necessary
w = vertcat(zeros(p.SampFreq*p.preSilence/1000,1),w);
AMnz = vertcat(zeros(p.SampFreq*p.preSilence/1000,1),AMnz);







