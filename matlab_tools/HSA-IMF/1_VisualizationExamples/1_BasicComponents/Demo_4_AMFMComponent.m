%*********************************************************************
% Theory of the Hilbert Spectrum: Code Examples for Reproducible Research
%*********************************************************************
%
% Description: This Demo file shows various visualizations for the 
%              AM--FM Component.
%
%*********************************************************************
clear all
close all
clc
addpath(genpath(fileparts(fileparts(pwd))));

%---------------------------------------------------------------------

%UNDERLYING SIGNAL MODEL
fs = 16000;                     %sampling freq
Ts = 1/fs;                      %sampling period
t = 0:Ts:1.001-Ts;              %time index
a = gausswin(length(t),5)';     %IA
fc = 60;                        %carrier freq
m = 55*sin(2*pi*2*t);           %FM message
fi = fc.*ones(size(t))+m;       %IF
[psi,s] = amfmmod(a,m,fc,fs);   %AM--FM component

%==================================================================

%PARAMETERS
fMax = 2*fc;                %max plotting freq
STFTparms = [1024*2,4];     %STFT window length and advance

%MESSAGE PLOTS
h1 = AMFMmessagePlot(t,m,a);

%3D ARGAND DIAGRAM
h2 = Argand(t,psi);
title(' ','FontSize',18,'Interpreter','latex','string','An Amplitude Modulated Frequency Modulated (AM-FM) Component: $\psi(t;\omega_0(t),a_0(t),\phi_0) = a_0(t) e^{j\theta_0(t)}= a_0(t) e^{j[ \omega_c t + \int\limits_{-\infty}^{t} m(\tau)d\tau +\phi_0]},\ \omega_0(t)=\omega_c+m(t)$');

%3D HILBERT SPECTRUM
h3 = HSA3dPlot(t,s,fi,a,fs,fMax,STFTparms);
title(' ','FontSize',18,'Interpreter','latex','string','An Amplitude Modulated Frequency Modulated (AM-FM) Component: $\psi(t;\omega_0(t),a_0(t),\phi_0) = a_0(t) e^{j\theta_0(t)}= a_0(t) e^{j[ \omega_c t + \int\limits_{-\infty}^{t} m(\tau)d\tau +\phi_0]},\ \omega_0(t)=\omega_c+m(t)$');

%==================================================================











