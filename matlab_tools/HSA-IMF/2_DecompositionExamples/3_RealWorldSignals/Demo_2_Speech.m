%*********************************************************************
% Theory of the Hilbert Spectrum: Code Examples for Reproducible Research
%*********************************************************************
%
% Description: This Demo file shows illustrates Hilbert Spectral Analysis
%              on a speech signal.
%
%*********************************************************************
clear all
close all
clc
addpath(genpath(fileparts(fileparts(pwd))));

%---------------------------------------------------------------------

STR = input('Do you want to load the precomputed values? Y/N [Y]:','s');

%---------------------------------------------------------------------

if sum(strcmpi(STR,{'n','no'}))>0
    
    %===================
    % COMPUTE SOLUTION
    %===================
    %INPUT SIGNAL
    [x,fs] = wavread('shoot.wav');
    Ts = 1/fs;
    t = (0:length(x)-1).*Ts;
    
    %PARAMETERS
    SiftStopThresh = 30;
    EMDStopThresh = 10;
    alpha  = .95 ;
    I = 200;
    beta = 4;
    L = 0;
    MA_len = round(fs*.001)-1;
    fMax = 8000;
    STFTparms = [1024*4,1];
    
    %HSA
    [S,A,IF,FIF] = HSA(x, SiftStopThresh, EMDStopThresh, alpha,I,beta,L,MA_len, true);
    
else
    
    %================
    % LOAD SOLUTION
    %================
    load SpeechExamplePreComputed
    
end

%==================================================================

%3D HILBERT SPECTRUM RETURNED BY HSA 
%h = HilbertMultiComponentPlot(t,S,IF*fs,A,fs,fMax,[1024*2,4]);
%title('HSA of Speech','FontSize',18,'Interpreter','latex');

%3D HILBERT SPECTRUM RETURNED BY HSA WITH SMOOTHED IF
h = HSA3dPlot(t,S,FIF*fs,A,fs,fMax,[1024*2,4]);
title('HSA of Speech (smoothed IF)','FontSize',18,'Interpreter','latex');

%2D HILBERT SPECTRUM
HSA2dPlot(t, S, FIF*fs, A, fs, fMax)


