function [response,p] = PlayAndReturnResponse3I3AFC(Wave2Play,trial,p,player)
%
% varargins
%
% 1 OneSoundDuration (ms)
% 2 ISI (ms)
% 3 CorrectAnswer
% 4 CorrectImage
% 5 IncorrectImage
% 6 trial

% OneSoundDuration=max(p.NoiseDuration,p.ToneDuration); % for pulsed
% background noise
OneSoundDuration=max(p.SignalDuration);
if trial==1
    p.responseGUI = ResponsePad3I3AFC(OneSoundDuration,p.ISI,p.Order,p.CorrectImage,p.IncorrectImage,0);
    pause(0.5);
end

if player == 1 % if you're using playrec
    playrec('play', Wave2Play, [3,4]);
else
    playEm = audioplayer(Wave2Play,p.SampFreq);
    play(playEm);
end

IntervalIndicators(p.responseGUI, OneSoundDuration,p.ISI,p.initialDelay)
response = ResponsePad3I3AFC(OneSoundDuration,p.ISI,p.Order,p.CorrectImage,p.IncorrectImage,trial);



return
trial=2;
playEm = audioplayer(Wave2Play,SampFreq);
play(playEm);
IntervalIndicators(responseGUI, OneSoundDuration,ISI)
response = ResponsePad3I3AFC(Wave2Play,SampFreq,OneSoundDuration,ISI,CorrectAnswer,CorrectImage,IncorrectImage,trial)


return

