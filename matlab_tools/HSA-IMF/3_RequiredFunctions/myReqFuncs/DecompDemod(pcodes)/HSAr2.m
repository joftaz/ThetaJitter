%  Call Syntax:  [S,A,IF,IF_MA] = HSA(x, SiftStopThresh, EMDStopThresh, alpha, I, beta, L, MA_len, parFlag)
% 
%  Description: This function perfoms EMDand demodulation
% 
%  Input Arguments:
% 	Name: x
% 	Type: vector (real)
% 	Description: original signal to decompose/demodulate
% 
% 	Name: SiftStopThresh
% 	Type: scalar 
% 	Description: Sifting stop criterion in dB [usually start around 30dB ]
% 
% 	Name: EMDStopThresh
% 	Type: scalar 
% 	Description: EMD stop criterion in dB [usually start around 10dB]
% 
% 	Name: alpha
% 	Type: scalar 
% 	Description: sifting step size [normally<=1]
% 
% 	Name: I
% 	Type: integer 
% 	Description: number of ensemble trials
% 
% 	Name: beta
% 	Type: vector 
% 	Description: scale factor for noise 
% 
% 	Name: L
% 	Type: integer
% 	Description:  number of points to replace in demodulation to left and right of zero crossing [start with 0 and increase]
% 
% 	Name: MA_len
% 	Type: integer
% 	Description: moving average filter length
% 
% 	Name: parFlag
% 	Type: logical
% 	Description: utilize parallel [default: 1]
%                    1 - use parfor (it is assumed that a parallel pool is already configured and open)
% 
%  Output Arguments:
% 
% 	Name: S
% 	Type: matrix (real)
% 	Description: matrix of IMF modes  (each as a column), with residual in last column.
% 
% 	Name: A
% 	Type: matrix (real)
% 	Description: matrix of inst. amplitudes, columns correspond to each IMF
% 
% 	Name: IF
% 	Type: matrix (real)
% 	Description: normalized inst freq, columns correspond to each IMF
% 
% 	Name: IF_MA
% 	Type: matrix (real)
% 	Description: IFpassed though moving average filter with length MA_len
% --------------------------------------------------------------------------
% 
%  If you use these files please cite the following:
% 
%        @article{HSA2015,
%            title={Theory of the Hilbert Spectrum},
%            author={Sandoval, S. and De~Leon, P.~L.~},
%            journal = {arXiv:1504.07554 [math.CV]},
%            url = {http://arxiv.org/abs/1504.07554}
% 
% 
%    References:
% 
%        N. E. Huang, Z. Shen, S. R. Long, M. C. Wu, H. H. Shih, Q. Zheng, N.-
%        C. Yen, C. C. Tung, and H. H. Liu, "The empirical mode decomposition
%        and the hilbert spectrum for nonlinear and non-stationary time series
%        analysis," Proceedings of the Royal Society of London. Series A:
%        Mathematical, Physical and Engineering Sciences, vol. 454, no. 1971,
%        pp. 903–995, 1998.
% 
%        R. Rato, M. Ortigueira, and A. Batista, “On the HHT, its problems, and
%        some solutions," Mechanical Systems and Signal Processing, vol. 22,
%        no. 6, pp. 1374–1394, 2008.
% 
%        M. E. Torres, M. A. Colominas, G. Schlotthauer, and P. Flandrin,
%        "A complete ensemble empirical mode decomposition with adaptive
%        noise," in Acoustics, Speech and Signal Processing (ICASSP), 2011
%        IEEE International Conference on. IEEE, 2011, pp. 4144–4147.
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
%    History:    V1.00 First version (R. Rato)
%                V1.01 Count mismatch detection increased from 1 to 2 (R. Rato)
%                V2.00 vectorize (S. Sandoval)
%                V3.00 HSA (S. Sandoval)
% 
%  WARNING: This software is a result of our research work and is supplied without any garanties.
%            We would like to receive comments on the results and report on bugs.
% 
% ==========================================================================
%
