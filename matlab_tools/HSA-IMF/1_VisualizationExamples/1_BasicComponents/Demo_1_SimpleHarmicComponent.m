%*********************************************************************
% Theory of the Hilbert Spectrum: Code Examples for Reproducible Research
%*********************************************************************
%
% Description: This Demo file shows various visualizations for the 
%              Simple Harmonic Component (SHC).
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
a = ones(size(t));              %IA
fc = 100;                       %carrier freq
m = zeros(size(t));             %FM message
fi = fc.*ones(size(t))+m;       %IF
[psi,s] = amfmmod(a,m,fc,fs);   %AM--FM component

%==================================================================

%PARAMETERS
fMax = 2*fc;                %max plotting freq
STFTparms = [1024*8,128];   %STFT window length and advance

%MESSAGE PLOTS
h1 = AMFMmessagePlot(t,m,a);

%3D ARGAND DIAGRAM
h2 = Argand(t,psi);
title(' ','FontSize',18,'Interpreter','latex','string','A Simple Harmonic Component: $\psi(t;\omega_0,a_0,\phi_0) = a_0 e^{j (\omega_0 t+\phi_0)}$');

%3D HILBERT SPECTRUM
h3 = HSA3dPlot(t,s,fi,a,fs,fMax,STFTparms);
title(' ','FontSize',18,'Interpreter','latex','string','A Simple Harmonic Component: $\psi(t;\omega_0,a_0,\phi_0) = a_0 e^{j (\omega_0 t+\phi_0)}$');

%==================================================================










