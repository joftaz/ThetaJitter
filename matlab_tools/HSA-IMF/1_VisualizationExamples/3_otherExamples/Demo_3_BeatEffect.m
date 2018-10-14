%*********************************************************************
% Theory of the Hilbert Spectrum: Code Examples for Reproducible Research
%*********************************************************************
%
% Description: This Demo file shows various visualizations for  
%              the `beat effect'.
%
%*********************************************************************
clear all
close all
clc
addpath(genpath(fileparts(fileparts(pwd))));

%**********************************
% CHANGE THIS PARAMETER
fdelta = 5;%  <---- TRY 5 and 60 
%**********************************

%==================================================================
%ASSUMING SHCs
%==================================================================

%UNDERLYING SIGNAL MODEL
fs = 16000; %sampling freq
Ts = 1/fs;
t = (0:Ts:1.001-Ts)';
fc = 250;
fc1 = fc-fdelta;
fc2 = fc+fdelta;
a = 1/2.*ones(size(t));
m = zeros(size(t));
fi1 = fc1.*ones(size(t))+m;
fi2 = fc2.*ones(size(t))+m;
[psi1,s1] = amfmmod(a,m,fc1,fs,pi/2); 
[psi2,s2] = amfmmod(a,m,fc2,fs,pi/2); 

%3D HILBERT SPECTRUM
h3 = HSA3dPlot(t,[s1,-s2],[fi1,fi2],[abs(a),abs(a)],fs,2*fc,[1024*8,32]);
title(' ','FontSize',20,'Interpreter','latex','string','$x(t) = \Re\left\lbrace \exp\left(j\omega_a t\right)+\exp\left(j\omega_b t\right) \right\rbrace$');

%====================================================================
%ASSUMING A SINGLE AM COMPONENT
%==================================================================

%UNDERLYING SIGNAL MODEL
a = sin(2*pi*fdelta.*t);
m = zeros(size(t));
fi = fc.*ones(size(t))+m;
[psi,s] = amfmmod(a,m,fc,fs); 

%3D HILBERT SPECTRUM
h3 = HSA3dPlot(t,s,fi,abs(a),fs,2*fc,[1024*8,32]);
title(' ','FontSize',20,'Interpreter','latex','string','$x(t) = \Re\left\lbrace 2\cos\left[\left(\omega_b-\omega_a\right)t/2\right]\exp\left[j\left(\omega_b+\omega_a\right)t/2\right]\right\rbrace$');


%==================================================================



