%  Call Syntax:  [A,IF,MA_IF,AW_IF] = HSdemodDirect(S,L,NN)
% 
%  Description:  This function perfoms AM-FM demodulation using the same
%                assumptions made when performing EMD. A direct approach is
%                taken to obtain estimates of the parameters.
% 
%  Input Arguments:
% 
% 	Name: S
% 	Type: matrix (real)
% 	Description: matrix of IMF modes  (each as a column), with residual in last column.
% 
% 	Name: L (optional)
% 	Type: integer  [default value:0]
% 	Description: ignore L additional point in the vacinity of sigma's zeros
% 	crossings to determine the inst. freq, (this help with computational
% 	problems)
% 
% 	Name: NN (optional)
% 	Type: odd integer [default value: 11]
% 	Description: filter length for IF
% 
%  Output Arguments:
% 
% 	Name: A
% 	Type: matrix (real)
% 	Description: matrix of inst. amplitudes, columns correspond to each IMF
% 
% 	Name: IF
% 	Type: matrix (real)
% 	Description: normalized inst freq, columns correspond to each IMF
% 
% 	Name: MA_IF (optional)
% 	Type: matrix (real)
% 	Description: moving average (length NN) filtered normalized inst freq, columns correspond to each IMF
% 
% 	Name: AW_IF (optional)
% 	Type: matrix (real)
% 	Description: amplitude weighed moving average (length NN) filtered normalized inst freq, columns correspond to each IMF
% 
% 
%  If you use these files please cite the following:
% 
%        @article{HSA2015,
%            title={Theory of the Hilbert Spectrum},
%            author={Sandoval, S. and De~Leon, P.~L.~},
%            journal={{Applied and Computational Harmonic Analysis}},
%            year = {\noop{2015}in review},  }
% 
%    References:
% 
%        “On the HHT, its problems, and some solutions”, Reference: Rato, R. T., Ortigueira, M. D., and Batista, A. G.,
%        Mechanical Systems and Signal Processing , vol. 22, no. 6, pp. 1374-1394, August 2008.
%        Authors: Raul Rato (rtr@uninova.DOT.pt) and Manuel Ortigueira (mdortigueira@uninova.pt or mdo@fct.unl.pt)
% 
% --------------------------------------------------------------------------
%
