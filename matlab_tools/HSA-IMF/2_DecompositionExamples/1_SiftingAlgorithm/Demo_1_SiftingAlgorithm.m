%*********************************************************************
% Theory of the Hilbert Spectrum: Code Examples for Reproducible Research
%*********************************************************************
%
% Description: This Demo file shows illustrates a single iteration of 
%              the sifting algorithm.
%
%*********************************************************************
clear all
close all
clc
addpath(genpath(fileparts(fileparts(pwd))));

%=================================================================
%UNDERLYING SIGNAL MODEL
%=================================================================

fs = 16000; %sampling freq
Ts = 1/fs;
t = 0:Ts:0.54-Ts;
T = length(t);
f = 30;
S = [];PSI = [];IF = [];A = [];
for k = 1:2;
    if k==1
        a = 0.25+gausswin(length(t),1)';
        m = 25*sin(2*pi*2*t);
        fc = 40;
    elseif k==2
        a = 0.7*ones(size(t))+1/5.*sin(20.*t);
        m = zeros(size(t));
        fc = 250;
    end
    [psi,s] = amfmmod(a,m,fc,fs);
    fi = fc.*ones(size(t))+(m);
    PSI = [PSI,psi(:)];
    S = [S,s(:)];
    IF = [IF,fi(:)];
    A = [A,a(:)];
end
x = sum(S,2);
SCALE=1.05;
S = S./ ( SCALE*max(abs(x)) );
x = x./ ( SCALE*max(abs(x)) );

%=================================================================
%ONE SIFTING ITERATION
%=================================================================
rPMOri= rGetPMaxs_s(x);                          %get parabolic maxima
rPmOri= rGetPMins_s(x);                          %get parabolic minima
rPM= rPMaxExtrapol_s(rPMOri, rPmOri, 1);         %extrapolate maxima (prevent end effects)
rPm= rPMinExtrapol_s(rPMOri, rPmOri, 1);         %extrapolate minima (prevent end effects)
bTenv = spline(rPM(:,1), rPM(:,2), 1:length(x)); %interpolate upper envelope
bDenv = spline(rPm(:,1), rPm(:,2), 1:length(x)); %interpolate lower envelope
bBias = (bTenv+bDenv)/2;                         %first bias estimate

%=================================================================
% FIGURES
%=================================================================

epsilon=.01;

%STARTING SIGNALS
figure('units','normalized', 'Position',  [ 0.05    0.05    1-0.1    0.85])
subplot(2,1,1);hold on;
plot(t,S(:,1),'color',rgb('purple'),'LineWidth',3);
plot(t,S(:,2),'color',rgb('green'), 'linewidth',1.0);
axis tight;
a = axis;axis([a(1),a(2),-1,1]);a = axis;
grid on;box on;
title(' ','FontSize',18,'Interpreter','latex','string','Unknown Signals $\varphi_0(t)$ and $\varphi_1(t)$');
%SUPERPOSTITION
%figure('units','normalized', 'Position',  [ 0.05    0.05    1-0.1    0.85])
subplot(2,1,2);hold on;
plot(t,x,'color',rgb('black'));
axis(a);grid on;box on;
title(' ','FontSize',18,'Interpreter','latex','string','Input to the sifting algorithm $r(t) = \varphi_0(t)+\varphi_1(t)$');

%UPPER ENVELOPE
figure('units','normalized', 'Position',  [ 0.05    0.05    1-0.1    0.85])
subplot(2,1,1);hold on;
plot(t,x,'color',rgb('black'));
plot(rPM(:,1)./fs,rPM(:,2),'b.','MarkerSize',15)
plot(t,bTenv,'b','LineWidth',1.5)
axis(a);grid on;box on;
title(' ','FontSize',18,'Interpreter','latex','string','The maxima and upper envelope $u(t)$');
%LOWER ENVELOPE
%figure('units','normalized', 'Position',  [ 0.05    0.05    1-0.1    0.85])
subplot(2,1,2);hold on;
plot(t,x,'color',rgb('black'));
%plot(rPM(:,1)./fs,rPM(:,2),'b.','MarkerSize',20)
%plot(t,bTenv,'b','MarkerSize',15,'LineWidth',2)
plot(rPm(:,1)./fs,rPm(:,2),'rs','MarkerSize',3,'LineWidth',2)
plot(t,bDenv,'r','LineWidth',1.5)
axis(a);grid on;box on;
title(' ','FontSize',18,'Interpreter','latex','string','The minima and lower envelope $l(t)$');


%MEAN ENVELOPE
figure('units','normalized', 'Position',  [ 0.05    0.05    1-0.1    0.85]);
subplot(2,1,1);hold on;
plot(t,x,'color',rgb('black'));
plot(rPM(:,1)./fs,rPM(:,2),'b.','MarkerSize',15)
plot(t,bTenv,'b','MarkerSize',15,'LineWidth',2)
plot(rPm(:,1)./fs,rPm(:,2),'rs','MarkerSize',3,'LineWidth',2)
plot(t,bDenv,'r','LineWidth',1.5)
plot(t,bBias,'color',rgb('purple'),'MarkerSize',15,'LineWidth',3)
axis(a);grid on;box on;
title(' ','FontSize',18,'Interpreter','latex','string','mean envelope $e(t)$');
%MEAN ENVELOPE ALONE
%figure('units','normalized', 'Position',  [ 0.05    0.05    1-0.1    0.85])
subplot(2,1,2);hold on;
plot(t,bBias,'color',rgb('purple'),'MarkerSize',15,'LineWidth',3)
axis(a);grid on;box on;
title(' ','FontSize',18,'Interpreter','latex','string','mean envelope $e(t)\approx\varphi_1(t)$');

%RESIDUE
figure('units','normalized', 'Position',  [ 0.05    0.05    1-0.1    0.85])
subplot(2,1,1)
plot(t,x-bBias','color',rgb('green'), 'linewidth',1.0)
box off
axis(a);grid on;box on;
title(' ','FontSize',18,'Interpreter','latex','string','IMF estimate after one iteration $r(t)-e(t)\approx\varphi_0(t)$');


