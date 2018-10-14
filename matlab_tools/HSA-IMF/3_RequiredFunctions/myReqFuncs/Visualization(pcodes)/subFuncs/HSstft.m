% ==========================================================================
%   X = HSstft(x,h,frame_advance)
% 
%  Description: This function computes the short-time Fourier transform of a
%  signal using a specifed windowing function and frame advance.
% 
%  Input Arguments:
% 	Name: x
% 	Type: vector (signal length x 1)
% 	Description: time domain signal
% 
% 	Name: win_func
% 	Type: vector (window-length x 1)
% 	Description: the desired windowing function for STFT computation
% 
% 	Name: frame_advance
% 	Type: scalar
% 	Description: the frame advance in samples
% 
%  Output Arguments:
% 	Name: X
% 	Type: matrix (window-length x number of frames)
% 	Description: the short-time Fourier transfrom of x
% 
% 	Name: x_k
% 	Type: matrix (window length x number of frames)
% 	Description: windowed and framed signal
% 
%  References:
%  [1] T. F. Quatieri, "Discrete-Time Speech Signal Processing Principles 
%   and Practice," Prentice Hall, 2002.  pp. 342-343
% 
%  Author: Steven Sandoval
% 
% =========================================================================
%
