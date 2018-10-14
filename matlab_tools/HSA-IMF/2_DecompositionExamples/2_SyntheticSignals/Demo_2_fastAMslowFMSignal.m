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
fs = 16000; %sampling freq
Ts = 1/fs;
t = 0:Ts:1.001-Ts;
a = 0.5*ones(size(t))+1/3.*sin(2*pi*50.*t)+1/5.*sin(2*pi*100.*t);
fc = 500;
m = 150*sin(2*pi*1*t);
fi = fc.*ones(size(t))+m;
[psi,s] = amfmmod(a,m,fc,fs); 

%PLOT PARAMTERS
fMax = 1000;
STFTparms = [1024*4,1];

%3D HILBERT SPECTRUM OF UNDERLYING SIGNAL MODEL
h3 = HSA3dPlot(t,s,fi,a,fs,fMax,[1024*2,4]);
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
h = HSA3dPlot(t,S,IF*fs,A,fs,fMax,[1024*2,4]);
title('Proposed Demodulation','FontSize',18,'Interpreter','latex');

%3D HILBERT SPECTRUM RETURNED BY HSA WITH SMOOTHED IF
h = HSA3dPlot(t,S,FIF*fs,A,fs,fMax,[1024*2,4]);
title('Proposed Demodulation (smoothed IF)','FontSize',18,'Interpreter','latex');

%wavwrite(s,fs,16,'syntheticFastAM.wav')



