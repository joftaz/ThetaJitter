%*********************************************************************
% Theory of the Hilbert Spectrum: Code Examples for Reproducible Research
%*********************************************************************
%
% Description: This Demo file shows various visualizations for an 
%              AM--FM Component with wideband AM.
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
inst_f = 100.*ones(size(t));    %IF

%WIDEBAND AM MESSAGE
[~,y]  = amfmmod(ones(size(inst_f)),inst_f-mean(inst_f),mean(inst_f),fs,pi/4);
y = y./max(abs(y));y = y+1;y = y./max(abs(y));
a = y;% IA

fc = 500;                       %carrier freq
m = 250*sin(2*pi*(1/2)*t);      %FM message
fi = fc.*ones(size(t))+m;       %IF
[psi,s] = amfmmod(a,m,fc,fs);   %AM--FM component

%==================================================================

%PARAMETERS
fMax = 2*fc;                %max plotting freq
STFTparms = [1024,32];     %STFT window length and advance

%MESSAGE PLOTS
h1 = AMFMmessagePlot(t,m,a);

%3D ARGAND DIAGRAM
h2 = Argand(t,psi);

%3D HILBERT SPECTRUM
h3 = HSA3dPlot(t,s,fi,abs(a),fs,fMax,STFTparms);

%==================================================================



