%  Call Syntax:  h = HilbertMultiComponentPlot(t,S,IF,A,fs,fMax,STFTparms)
% 
%  Description: This function plots a multicomponent AM-FM signal.
% 
%  Input Arguments:
% 	Name: t
% 	Type: column vector (Px1)
% 	Description: time index
% 
% 	Name: S
% 	Type: real matrix (PxK)
% 	Description: each column is the real signal s_k(t) coressponting to a single component
% 
% 	Name: IF
% 	Type: real matrix (PxK)
% 	Description: each column is the inst. freq. \check{f}_k(t) coressponting to a single component
% 
% 	Name: A
% 	Type: real matrix (PxK)
% 	Description: each column is the inst ampl. a_k(t) coressponting to a single component
% 
% 	Name: fs
% 	Type: scalar
% 	Description: sampling freq
% 
% 	Name: fMax or [fMax,fMin](optional)
% 	Type: scalar or [scalar,scalar]
% 	Description: max plotting freq
% 
% 	Name: STFTparams (optional)
% 	Type: vector (1x2)
% 	Description: STFT parameters: [N_FFT,frame_advance]
% 
%  Output Arguments:
% 
% 	Name: h
% 	Type: structure
% 	Description: sturcture containing figure handles
% 
% --------------------------------------------------------------------------
% 
%  If you use these files please cite the following:
% 
% 
%        @article{HSA2015,
%            title={Theory of the Hilbert Spectrum},
%            author={Sandoval, S. and De~Leon, P.~L.~},
%            journal = {arXiv:1504.07554 [math.CV]},
%            url = {http://arxiv.org/abs/1504.07554}
% 
%    References:
% 
% --------------------------------------------------------------------------
%  Notes:
% 
% 
% 
% --------------------------------------------------------------------------
%  Author: Steven Sandoval
% --------------------------------------------------------------------------
%  Revision History:
% 
% 
% --------------------------------------------------------------------------
% 
%    History:    V1.00 (S.Sandoval)
% 
%  WARNING: This software is a result of our research work and is supplied without any guaranties.
%           We would like to receive comments on the results and report on bugs.
% 
% ==========================================================================
%
