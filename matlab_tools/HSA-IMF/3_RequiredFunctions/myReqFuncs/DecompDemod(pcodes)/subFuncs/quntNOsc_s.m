%  Call Syntax:  quntNOsc = quntNOsc_s (x)
% 
%  Description: This function returns the oscilation count, no steps.
% 
%  Input Arguments:
% 	Name: x
% 	Type: vector
% 	Description: input signal
% 
%  Output Arguments:
% 
% 	Name: quntNOsc
% 	Type: scalar
% 	Description: the oscilation count, no steps
% 
%  References:
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
%    This program was derivved from:
% 
%        “On the HHT, its problems, and some solutions”, Reference: Rato, R. T., Ortigueira, M. D., and Batista, A. G.,
%        Mechanical Systems and Signal Processing , vol. 22, no. 6, pp. 1374-1394, August 2008.
%        Authors: Raul Rato (rtr@uninova.DOT.pt) and Manuel Ortigueira (mdortigueira@uninova.pt or mdo@fct.unl.pt)
% 
% --------------------------------------------------------------------------
%  Notes:
% 
% --------------------------------------------------------------------------
%  Revision History:
% 
%    History:    V1.00 First version (R. Rato)
%                V1.01 Count mismatch detection increased from 1 to 2 (R. Rato)
%                V2.00 vectorize (S. Sandoval)
%                V3.00 myHHT(S. Sandoval)
% 
%  WARNING: This software is a result of our research work and is supplied without any garanties.
%            We would like to receive comments on the results and report on bugs.
% 
% ==========================================================================
%
