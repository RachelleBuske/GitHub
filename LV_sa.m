%filename:  LV_sa.m
% Overview: main program for simulating the left heart and the systemic arteries
clear all %clear all variables
clf       %and figures
global T TS tauS tauD; % define global variables
global Csa Rs RMi RAo dt CHECK PLA; % define global variables
%Csa=Csa/2
%Rs=Rs/2
in_LV_sa  %initialize
for klok=1:klokmax % sets loop time from 1 to maximum time steps
  t=(klok*dt); % sets time as timestep multiplied by the duration
  PLV_old=PLV; % Sets pressure of the left ventricle to current
  Psa_old=Psa; % Sets pressure of the systemic artery to current
  CLV_old=CLV; % Sets compliance of left ventricle to current
  CLV=CV_now(t,CLVS,CLVD); % %Defines value of CLV (liters/mmHg) at t
  %find self-consistent 
  %valve states and pressures:
  set_SMi_SAo
  %store in arrays for future plotting:
  t_plot(klok)=t; % sets time at timestep value
  CLV_plot(klok)=CLV; % places CLV value into timestep placeholder
  PLV_plot(klok)=PLV; % places PLV value into timestep placeholder
  Psa_plot(klok)=Psa; % places Psa value into timestep placeholder
  VLV_plot(klok)=CLV*PLV+VLVd; % places VLV value into timestep placeholder
  Vsa_plot(klok)=Csa*Psa+Vsad; % places Vsa value into timestep placeholder
  QMi_plot(klok)=SMi*(PLA-PLV)/RMi; % places QMi value into timestep placeholder
  QAo_plot(klok)=SAo*(PLV-Psa)/RAo;  % places QAo value into timestep placeholder
  Qs_plot(klok)=Psa/Rs; % places Qs value into timestep placeholder
  SMi_plot(klok)=SMi; % places SMi value into timestep placeholder
  SAo_plot(klok)=SAo; % places SAo value into timestep placeholder
end
%plot results:
figure(1)
subplot(3,1,1), plot(t_plot,CLV_plot)
    title('Left Ventricle Compliance')
    xlabel('Compliance (liters/mmHg)')
    ylabel('time (minutes)')
subplot(3,1,2), plot(t_plot,PLV_plot,t_plot,Psa_plot)
    title('Pressure of Left Ventricle and Systemic Artery')
    xlabel('time (minutes)')
    ylabel('Pressure (mmHg)')
    legend('Left Ventricle','Systemic Artery')
subplot(3,1,3), plot(t_plot,QMi_plot,t_plot,QAo_plot,t_plot,Qs_plot)
    title('Flow')
    xlabel('time (minutes)')
    ylabel('Flow')
    legend('Flow in mitral valve','Flow in Aortic Artery','Systemic Flow')
%left ventricular pressure-volume loop
figure(2)
plot(VLV_plot,PLV_plot)
    title('Left ventricular pressure-volume loop')
    xlabel('Volume (Liters)')
    ylabel('Pressure (mmHg)')
%systemic arterial pressure-volume "loop"
figure(3)
plot(Vsa_plot,Psa_plot)
    title('Systemic arterial pressure-volume "loop"')
    xlabel('Volume (liters)')
    ylabel('Pressure (mmHg)')

max = findpeaks(Psa_plot);
min = findpeaks(-Psa_plot);
BP_systolic = mean(max) ; 
BP_diastolic = -mean(min) ;