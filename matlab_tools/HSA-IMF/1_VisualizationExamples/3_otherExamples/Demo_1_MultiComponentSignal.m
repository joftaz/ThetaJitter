%*********************************************************************
% Theory of the Hilbert Spectrum: Code Examples for Reproducible Research
%*********************************************************************
%
% Description: This Demo file shows various visualizations for a 
%              general muliticomponent AM--FM signal.
%
%*********************************************************************
clear all
close all
clc
addpath(genpath(fileparts(fileparts(pwd))));

%---------------------------------------------------------------------

%UNDERLYING SIGNAL MODEL
fs = 16000;                 %sampling freq
Ts = 1/fs;                  %sampling period
t = 0:Ts:1-Ts;              %time index 

%DEFINE 3 COMPONENTS
S = [];PSI = [];IF = [];A = [];
for k = 1:3;
    if k==1
        a = gausswin(length(t),5)';
        m = 50*sin(2*pi*2*t);
        fc = 70;
    elseif k==2
        a = 0.5*ones(size(t))+1/3.*sin(20.*t);
        m = zeros(size(t));
        fc = 100;
    elseif k==3
        a = hamming(length(t))';
        m = exp(t+4.5)-exp(4.5);
        fc = 10;
    end
    [psi,s] = amfmmod(a,m,fc,fs);
    fi = fc.*ones(size(t))+(m);
    PSI = [PSI,psi(:)];
    S = [S,s(:)];
    IF = [IF,fi(:)];
    A = [A,a(:)];
end

%==================================================================

%PARAMETERS
fMax = 180;                %max plotting freq
STFTparms = [1024*2,1];       %STFT window length and advance

%3D ARGAND DIAGRAM
h1 = Argand(t,sum(PSI,2));
title(' ','FontSize',18,'Interpreter','latex','string','A Generic Multi-Component AM-FM Signal: $x(t) = \Re\lbrace\sum\limits_{k=0}^{K-1}\psi_k(t;{\omega}_k(t),a_k(t),\phi_k)\rbrace $');

%3D HILBERT SPECTRUM
h2 = HSA3dPlot(t,S,IF,A,fs,fMax,STFTparms);
title(' ','FontSize',18,'Interpreter','latex','string','A Generic Multi-Component AM-FM Signal: $x(t) = \Re\lbrace\sum\limits_{k=0}^{K-1}\psi_k(t;{\omega}_k(t),a_k(t),\phi_k)\rbrace $');

%==================================================================





















