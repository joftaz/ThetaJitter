%*********************************************************************
% Theory of the Hilbert Spectrum: Code Examples for Reproducible Research
%*********************************************************************
%
% Description: This Demo file shows illustrates Hilbert Spectral Analysis
%              on a synthitic signal.
%
%*********************************************************************
clear all
close all
clc
addpath(genpath(fileparts(fileparts(pwd))));

%==================================================================

%UNDERLYING SIGNAL MODEL
fs = 44000; %sampling freq
Ts = 1/fs;
t = 0:Ts:1.001-Ts;
a = gausswin(length(t),5)';
fc = 3000;
m = 250*sin(2*pi*70*t)+2000*exp(-4*t)-2000;
fi = fc.*ones(size(t))+m;
[psi,s] = amfmmod(a,m,fc,fs); 

%PLOT PARAMTERS
fMax = 2500;
STFTparms = [1024*4,1];

%3D HILBERT SPECTRUM OF UNDERLYING SIGNAL MODEL
h3 = HSA3dPlot(t,s,fi,a,fs,fMax,STFTparms);
title('Underlying Signal Model','FontSize',18,'Interpreter','latex');

%==================================================================

%HSA PARAMETERS
SiftStopThresh = 30;    
EMDStopThresh = 40;     
alpha  = .95 ;            
I = 1; 
beta = 0;
L = 1;
MA_len = round(fs*.001)-1;

%HSA
[S,A,IF,FIF] = HSA(s, SiftStopThresh, EMDStopThresh, alpha, I, beta, L, MA_len, false);

%3D HILBERT SPECTRUM RETURNED BY HSA
h4 = HSA3dPlot(t,S,IF*fs,A,fs,fMax,STFTparms);
title('Proposed Decomposition/Demodulation','FontSize',18,'Interpreter','latex');

%3D HILBERT SPECTRUM RETURNED BY HSA WITH SMOOTHED IF
h5 = HSA3dPlot(t,S,FIF*fs,A,fs,fMax,STFTparms);
title('Proposed Decomposition/Demodulation (smoothed IF)','FontSize',18,'Interpreter','latex');

%wavwrite(s,fs,16,'syntheticFastFM.wav')

