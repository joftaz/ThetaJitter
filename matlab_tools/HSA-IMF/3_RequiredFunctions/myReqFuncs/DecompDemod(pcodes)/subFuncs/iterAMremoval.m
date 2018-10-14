%  Call Syntax:  [A,S_FM,A1] = iterAmpEstDirect(S,K)
% 
%  Description:  This function perfoms iterative amplitude esitmation. It
%                returns both estimates of the amplitude and of the amplitude
%                normalized (pure FM) IMF modes.
% 
%  Input Arguments:
% 	Name: S
% 	Type: matrix (real)
% 	Description: matrix of IMF modes  (each as a column), with residual in last column.
% 
% 	Name: K
% 	Type: integer (optional)
% 	Description: number of iterations [default value: 3]
% 
%  Output Arguments:
% 
% 	Name: A
% 	Type: matrix (real)
% 	Description: matrix of inst. amplitudes, after K iterations.
% 
% 	Name: S_FM
% 	Type: matrix (real)
% 	Description: matrix of amplitude normalized IMF modes, columns correspond to each IMF
% 
% 	Name: A1
% 	Type: matrix (real)
% 	Description: matrix of inst. amplitudes, after 1 iterations. It is
% 	reccomended to use this value as the amplitude esitimate
% 
% --------------------------------------------------------------------------
% 
%  If you use these files please cite the following:
% 
%        @article{HSA2015,
%            title={Theory of the Hilbert Spectrum},
%            author={Sandoval, S. and De~Leon, P.~L.~},
%            journal={{Applied and Computational Harmonic Analysis}},
%            year = {\noop{2015}in review},  }
% 
% 
%    References:
% 
%        R. Rato, M. Ortigueira, and A. Batista, “On the HHT, its problems, and
%        some solutions," Mechanical Systems and Signal Processing, vol. 22,
%        no. 6, pp. 1374–1394, 2008.
% 
%        Huang, Norden E., et al. "On instantaneous frequency." Advances in
%        Adaptive Data Analysis 1.02 (2009): 177-229.
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
%  By: Steven Sandoval
% 
%    History:    V1.00 First version (S Sandoval) May 2014
% 
%  WARNING: This software is a result of our research work and is supplied without any garanties.
%            We would like to receive comments on the results and report on bugs.
% 
% ==========================================================================
%
