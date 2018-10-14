%*********************************************************************
% Theory of the Hilbert Spectrum: Code Examples for Reproducible Research
%*********************************************************************
%
% Description: This Demo file shows a comparison of various Hilbert Spectral
%              Analysis (HSA) algorithms on a pcg signal.
%
%*********************************************************************
clear all
close all
clc
drawnow;
addpath(genpath(fileparts(pwd)));

%------------------------------INPUT SIGNAL---------------------------------

[x,fs] = audioread('201106221450.wav');%Classifying Heart Sounds Challenge - Peter J. Bentley @ www.peterjbentley.com/heartchallenge/
x = x(fs+1:4*fs);
x = x./max(abs(x));
Ts = 1/fs;
t = (0:length(x)-1).*Ts;


%==================================================================

%PAR1METERS
SiftStopThresh = 30;
EMDStopThresh = 10;
alpha  = .95 ;
I = 20;
beta = 3;
c = 0.9;
L = 0;

STFTparms = [1024*2,8];
fMax = 500;


%HSA ALGORITHM PRESENTED AT ICASSP 2017 (HSAr3)
[S,A,IF] = HSAr3(x, SiftStopThresh, EMDStopThresh, alpha,I,beta,c,L);

% %3D HILBERT SPECTRUM RETURNED BY HSA
% h = HSA3dPlot(t,S,IF*fs,A,fs,fMax,[1024*2,4]);
% title('3D Hilbert Spectrum','FontSize',18,'Interpreter','latex');

%2D HILBERT SPECTRUM RETURNED BY HSA
HSA2dPlot(t, S, IF*fs, A, fs, fMax)
title('2D Hilbert Spectrum')
set(gcf,'units','normalized','outerposition',[0 0 1 1])




