%*********************************************************************
% Theory of the Hilbert Spectrum: Code Examples for Reproducible Research
%*********************************************************************
%
% Description: This Demo file shows various visualizations for a 
%              triangular waveform.
%
%*********************************************************************
clear all
close all
clc
addpath(genpath(fileparts(fileparts(pwd))));

%==================================================================
%ASSUMING SHCs
%==================================================================

%UNDERLYING SIGNAL MODEL
fs = 16000; %sampling freq
f_c = 10;% fundemental
fMax = f_c*6; %max plot freq
nComp = 15;%partical sum 
Ts = 1/fs;
t = 0:Ts:1;
T = length(t);
PSI = [];S = [];IF = [];A = [];
for k = 1:nComp;
    psi = ((8)/((2*k-1)^2*pi^2)).*exp(1i*2*pi*(2*k-1)*f_c.*t);
    s = real(psi);
    fi = f_c*ones(size(t)).*(2*k-1);
    a = abs(psi);
    PSI = [PSI,psi(:)];
    S = [S,s(:)];
    IF = [IF,fi(:)];
    A = [A,a(:)];
end

%3D HILBERT SPECTRUM
h2 = HSA3dPlot(t,S,IF,A,fs,fMax,[1024*4,4]);
title(' ','FontSize',18,'interpreter','latex', 'string','Triangle Wave: $x(t) = \Re\left[\sum\limits_{k=0}^{\infty} \frac{8A}{\pi^2}\frac{1}{(2k+1)^2} e^{j (2k+1) \omega_0 t}\right]$')

%2D HILBERT SPECTRUM
HSA2dPlot(t, S, IF, A, fs, fMax)
%HSAprint2dPlot('TempFileName')

%====================================================================
%ASSUMING A SINGLE AM--FM COMPONENT WITH HARMONIC CORRESPONDENCE
%==================================================================

%UNDERLYING SIGNAL MODEL
fs = 48000; %sampling freq
Ts = 1/fs;
t = 0:Ts:1;
T = length(t);
S = -sawtooth(2*pi*f_c*t,0.5);
S = S(:);
PSI = [hilbert(S(:))];
IFest = estIFdirect(sum(PSI,2))*fs;
A = [abs(PSI)];
IFest = estIFdirect(sum(PSI,2))*fs;

%3D HILBERT SPECTRUM
h4 = HSA3dPlot(t,S,IFest,abs(PSI),fs,fMax,[1024*4,4]);
title(' ','FontSize',18,'interpreter','latex', 'string','Triangle Wave: $x(t) = \Re\left[  \frac{8A}{\pi^2} \tilde{a}(t)e^{j(\omega_0 t+M(t))}   \right],\ \tilde{a}(t)e^{jM(t)} = \sum\limits_{k=0}^{\infty} \frac{1}{(2k+1)^2}e^{j 2k\omega_0 t}$')

%2D HILBERT SPECTRUM
HSA2dPlot(t, S, IFest, abs(PSI), fs, fMax)
%HSAprint2dPlot('TempFileName')


%====================================================================
%ASSUMING A SINGLE AM COMPONENT
%==================================================================

%UNDERLYING SIGNAL MODEL
a_am = (sawtooth(2*pi*f_c*t,0.5))./(cos(2*pi*f_c*t+pi)) ./5;
a_am(abs(a_am)>1)=NaN;
Idx = abs(cos(2*pi*f_c*t+pi))<1e-10;
a_am(Idx) = a_am([Idx(2:end),false]);
s_am = -(sawtooth(2*pi*f_c*t,0.5))./(cos(2*pi*f_c*t+pi)).*cos(2*pi*f_c*t+pi);
s_am(abs(s_am)>1)=NaN;

%3D HILBERT SPECTRUM
h2 = HSA3dPlot(t,s_am',f_c*ones(size(t')),abs(a_am').^2,fs,fMax,[1024*4,4]);%.^2 to emph dynamic range
title(' ','FontSize',18,'interpreter','latex', 'string','Triangle Wave: $x(t)=  \Re\left[ \frac{\ x_{\triangle}(\omega_0 t)}{\cos(\omega_0 t)}e^{j\omega_0 t} \right]$')

%2D HILBERT SPECTRUM
HSA2dPlot(t, s_am', f_c*ones(size(t')), abs(a_am').^2, fs, fMax)%.^2 to emph dynamic range
%HSAprint2dPlot('TempFileName')

%====================================================================





% %FM VIEW

fs = 16000;
%f_c = 25;
Ts = 1/fs;
t = 0:Ts:1;
T = length(t);

S_FM = -sawtooth(2*pi*f_c*t,0.5)';

% figure()
% plot(t,S_FM)


SIGMA = real( sqrt(1-S_FM.^2));
    
    SGNtemp   = -sign(diff(S_FM(:)));
    SGN = vertcat(SGNtemp(1),SGNtemp(:));
    SIGMA = SGN.*SIGMA;
    
        %figure(100)
        %plot(SIGMA(:,j))
    
    nanLoc = crossing(SIGMA);
    SIGMA(nanLoc)=NaN;
      
    YY = spline(   find(  not(isnan(SIGMA))  )  , SIGMA(not(isnan(SIGMA))),   find(isnan( SIGMA ))             ); 
    
    SIGMA(isnan(SIGMA))=YY;
    PSI = S_FM +1i.*SIGMA;
    IF = estIFdirect(PSI);
    
    



HSA3dPlot(t,S_FM,IF*fs,ones(size(IF)),fs,fMax,[1024*4,4]);%.^2 to emph dynamic range
HSA2dPlot(t,S_FM,IF*fs,ones(size(IF)),fs,fMax)
%HSAprint2dPlot('TempFileName')


















