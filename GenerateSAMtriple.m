function [w, AMnz, modulator]=GenerateSAMtriple(p)
%
% Vs 2.0 - return only the modulator from the modulated sound

ISIsamples=samplify(p.ISI,p.SampFreq);
ISIwave=zeros(ISIsamples,1);

AMnz=[]; % contains the stimuli without background noise
w=[]; % the actual trial stimulus
if p.LongMaskerNoise<=0
    % calculate the necessary offsets to make the target pulse the same
    % duration as the masker
    BackNzSamples=samplify(p.NoiseDuration,p.SampFreq);
    TargetSamples=samplify(p.SignalDuration,p.SampFreq);
    pre = zeros(ceil((BackNzSamples-TargetSamples)/2),1);
    post = zeros(BackNzSamples-(TargetSamples+length(pre)),1);
    for i=1:3
        % generate one signal
        % function [Nz, flatNz, modulator]=GenerateSAMnz(ModulationPresent, p)
        [AM, flatNz, mm]=GenerateSAMnz(p.Order==i, p);
        if p.Order==i
            modulator=mm;
        end
        % if tracking absolute thresholds, scale the modulated tone by the
        % current SNR level. Otherwise, zero out the unmodulated noises
        if p.trackAbsThreshold
            if p.Order==i
                AM = AM * 10^(p.SNR_dB/20);
            else
                AM=AM*0;
            end
        end
        
        % centre the AM pulse in the background noise
        AM = vertcat(pre, AM, post);
        AMnz = vertcat(AMnz, AM);
        % generate a single pulse of background noise
        backNz=GenerateBackgroundNoiseSAM(p);
        w=vertcat(w, AM+backNz);
        if i<3
            w=vertcat(w,ISIwave);
            AMnz=vertcat(AMnz,ISIwave);
        end
    end
else % long masker (actually background noise)
    % generate the signal pulses
    % construct the 3 intervals with ISIs
    for i=1:3
        % function [Nz, flatNz, modulator]=GenerateSAMnz(ModulationPresent, p)
        [AM, flatNz, mm]=GenerateSAMnz(p.Order==i, p);
        if p.Order==i
            modulator=mm;
        end
        % if tracking absolute thresholds, scale the modulated tone by the
        % current SNR level. Otherwise, zero out the unmodulated noises
        if p.trackAbsThreshold
            if p.Order==i
                AM = AM * 10^(p.SNR_dB/20);
            else
                AM=AM*0;
            end
        end
        
        AMnz=vertcat(AMnz, AM);
        if i<3
            AMnz=vertcat(AMnz,ISIwave);
        end
    end
    %% generate and add in background noise when it is long,
    %  i.e., played through the triple
    if ~ p.trackAbsThreshold
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
    else % if tracking absolute threshold
        if p.rms2useBackNz > 0
            w=GenerateBackgroundNoiseSAM(p);
            % scale background noise 
            w = w * 10^(p.SNR_dB/20);
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
    
end

% prepend silence to wave if necessary
w = vertcat(zeros(p.SampFreq*p.preSilence/1000,1),w);
AMnz = vertcat(zeros(p.SampFreq*p.preSilence/1000,1),AMnz);







