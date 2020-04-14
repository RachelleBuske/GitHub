function CV=CV_now(t,CVS,CVD) % create function for ventricle compliance
%filename: CV_now.m
% Overview: Function for ventricle compliance that can be called to evaluate C_LV(t). General
% function as to apply to both sides of the heart. 

global T TS tauS tauD; % define global variables 
tc=rem(t,T); %tc=time in the current cycle, measured from start of systole.
% periodic function
if(tc<TS) % condition if time in current cycle is less than the duration of systole
  e=(1-exp(-tc/tauS))/(1-exp(-TS/tauS)); % equation for the exponent
  CV=CVD*(CVS/CVD)^e; % determines ventricle compliance for maximum value
else % condition if time is greater than duration of systole to time of the period T
  e=(1-exp(-(tc-TS)/tauD))/(1-exp(-(T-TS)/tauD)); % equation for the exponent
  CV=CVS*(CVD/CVS)^e; % determines ventricle compliance for minimum value
end
