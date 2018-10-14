%*********************************************************************
% Theory of the Hilbert Spectrum: Code Examples for Reproducible Research
%*********************************************************************
%
% Description: This Demo file shows various visualizations for a 
%              sinusoidal FM waveform.
%
%*********************************************************************
clear all
close all
clc
addpath(genpath(fileparts(fileparts(pwd))));

%==================================================================
%FM VIEW
%==================================================================

%UNDERLYING SIGNAL MODEL
fs = 16000; %sampling freq
Ts = 1/fs;
t = (0:1*fs/2)./fs;
a = ones(size(t));
fc = 55;
fm = 2;
B = 35;
m = B*cos(2*pi*fm*t);%fm message
fi = fc.*ones(size(t))+m;
phi = -2*pi.*m(1)./fs;%phase offset
[psi,s] = amfmmod(a,m,fc,fs,phi); 
fMax = 2*fc;

%3D HILBERT SPECTRUM
HSA3dPlot(t,s,fi',a',fs,fMax,[1024*4,4]);
title(' ','FontSize',18,'Interpreter','latex','string',['$x(t) = \Re\lbrace e^{j\left[\omega_c t + Bsin(\omega_mt)\right]} \rbrace$']);

%2D HILBERT SPECTRUM
HSA2dPlot(t, s, fi', a', fs, fMax)
%HSAprint2dPlot('TempFileName')



%==================================================================
%SHC VIEW
%==================================================================

%UNDERLYING SIGNAL MODEL
nComp = 22;
PSI = [];
S = [];
IF = [];
A = [];
for k = -nComp:nComp;
    psi = besselj(k,B/fm) .*exp(1i*(2*pi*fc.*t + k*2*pi*fm.*t));
    s = real(psi);
    fi = fc*ones(size(t))+k*fm;
    a = abs(psi);
    PSI = [PSI,psi(:)];
    S = [S,s(:)];
    IF = [IF,fi(:)];
    A = [A,a(:)];
end

%3D HILBERT SPECTRUM
HSA3dPlot(t,S,IF,A,fs,fMax,[1024,4]);
title(' ','FontSize',18,'Interpreter','latex','string',['$x(t) = \Re\lbrace\sum\limits_{k=-',num2str(nComp),'}^{',num2str(nComp),'}J_k(2\pi B/\omega_m)e^{j[(\omega_c+k\omega_m)t]}\rbrace$']);

%2D HILBERT SPECTRUM
HSA2dPlot(t, S, IF, A, fs, fMax)
%HSAprint2dPlot('TempFileName')

%==================================================================











