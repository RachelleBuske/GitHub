function [PLV,Psa]=PLV_Psa_new(PLV_old,Psa_old,CLV_old,CLV,SMi,SAo) % define function
%filename PLV_Psa_new.m
% Overview: Function solves for the pressures given the state of the valves. 
  % Solves for PLV(t) and Psa(t) given the data: 
    % the values of these pressures at the previous time step
    % PLv(t - ~t) and Psa(t - ~t)
    % the left ventricular compliance at both the previous and current time step
    % CLV(t - ~t) and CLV(t)
    % the state of the valves at the current time, SMi(t) and SAo(t)
    % all of the constant parameters listed as global variables 
global Csa Rs RMi RAo dt CHECK PLA; % set global parameters
C11=CLV+dt*((SMi/RMi)+(SAo/RAo)); % compliance in valve state 11 
C12=-dt*(SAo/RAo); % compliance in valve state 12 = 21
C22=Csa+dt*((SAo/RAo)+(1/Rs)); % compliance in valve state 22
B1=CLV_old*PLV_old+dt*(SMi/RMi)*PLA; % standard form 
B2=Csa*Psa_old; % standard form 
D=C11*C22-C12^2; % define denominator
PLV=(B1*C22-B2*C12)/D; % Left ventricle pressure
Psa=(B2*C11-B1*C12)/D; % Systemic artery pressure
if (CHECK) % global parameter CHECK set during initialization to the value 0 (false) or 1 (true).
% When CHECK has the value 1, the function PLV_Psa_new checks itself by substituting
% the computed solution back into the equations that it is trying to solve.
% result of the check should be CH1=CH2=O
  LHS1=(CLV*PLV-CLV_old*PLV_old)/dt;
  RHS1=(SMi/RMi)*(PLA-PLV)-(SAo/RAo)*(PLV-Psa);
  CH1=RHS1-LHS1
  LHS2=Csa*(Psa-Psa_old)/dt;
  RHS2=(SAo/RAo)*(PLV-Psa)-(1/Rs)*Psa;
  CH2=RHS2-LHS2
end
