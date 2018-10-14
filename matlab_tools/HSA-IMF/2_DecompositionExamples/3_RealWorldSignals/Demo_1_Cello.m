%*********************************************************************
% Theory of the Hilbert Spectrum: Code Examples for Reproducible Research
%*********************************************************************
%
% Description: This Demo file shows illustrates Hilbert Spectral Analysis
%              on a cello signal.
%
% The recording of a cello used in this research is 
% Copyrighted © 1995 Internet Cello Society
% it can be obtained at the follow link:
% http://www.cello.org/cello_introduction/b.html
% File: Cstringarco.wav
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
    try
    [x,fs] = wavread(fullfile(pwd,'Cstringarco.wav'));
    catch
        fprintf('\n The recording of a cello used in this research is Copyrighted 1995 Internet Cello Society it can be obtained at the follow link:\n     http://www.cello.org/cello_introduction/b.html\n     File: Cstringarco.wav \n')
        break;
    end
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
    load CelloExamplePreComputed
    
end

%==================================================================

%3D HILBERT SPECTRUM RETURNED BY HSA 
%h = HilbertMultiComponentPlot(t,S,IF*fs,A,fs,fMax,[1024*2,4]);
%title('HSA of Cello','FontSize',18,'Interpreter','latex');

%3D HILBERT SPECTRUM RETURNED BY HSA WITH SMOOTHED IF
h = HSA3dPlot(t,S,FIF*fs,A,fs,fMax,[1024*2,4]);
title('HSA of Cello (smoothed IF)','FontSize',18,'Interpreter','latex');

%2D HILBERT SPECTRUM
HSA2dPlot(t, S, FIF*fs, A, fs, fMax)


