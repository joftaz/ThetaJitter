%  Call Syntax:  A = AmpEstDirect(S)
% 
%  Description:  This function perfoms direct amplitude esitmation using the same
%                assumptions made when performing EMD.
% 
%  Input Arguments:
% 	Name: S
% 	Type: matrix (real)
% 	Description: matrix of IMF modes  (each as a column), with residual in last column.
% 
%            Name: interp
% 	Type: scalar
% 	Description: 
%            0 - A(:,k) obtained using spline [default]
%            1 - A(:,k) obtained using pchip
% 
%  Output Arguments:
% 
% 	Name: A
% 	Type: matrix (real)
% 	Description: matrix of inst. amplitudes
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
