%*********************************************************************
% Theory of the Hilbert Spectrum: Code Examples for Reproducible Research
%*********************************************************************
%
% Description: This Demo file shows various visualizations for an 
%              AM--FM Component with wideband FM.
%
%*********************************************************************
clear all
close all
clc
addpath(genpath(fileparts(fileparts(pwd))));

%---------------------------------------------------------------------

%UNDERLYING SIGNAL MODEL
fs = 44000;                     %sampling freq
Ts = 1/fs;                      %sampling period
t = 0:Ts:1.001-Ts;              %time index
a = gausswin(length(t),5)';     %IA
fc = 1000;                      %carrier freq
m = 250*sin(2*pi*(100)*t);      %FM message
fi = fc.*ones(size(t))+m;       %IF
[psi,s] = amfmmod(a,m,fc,fs);   %AM--FM component

%==================================================================

%PARAMETERS
fMax = 2*fc;                %max plotting freq
STFTparms = [1024,4];       %STFT window length and advance

%MESSAGE PLOTS
h1 = AMFMmessagePlot(t,m,a);

%3D ARGAND DIAGRAM
h2 = Argand(t,psi);

%3D HILBERT SPECTRUM
h3 = HSA3dPlot(t,s,fi,a,fs,fMax,STFTparms);

%==================================================================



