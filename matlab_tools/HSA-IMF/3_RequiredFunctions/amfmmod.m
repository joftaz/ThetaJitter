function [psi,s,t] = amfmmod(a,m,fc,fs,phi) 
%==========================================================================
% Call Syntax: [psi,s] = amfmmod(a,m,Fc,Fs,phi) 
%
% Description: 
%
% Input Arguments:
%   Name: a
%   Type: vector
%   Description: AM message
%
%   Name: m
%   Type: vector
%   Description: FM message
%
%   Name: fc
%   Type: scalar
%   Description: center freq (carrier)
%
%   Name: fs
%   Type: scalar
%   Description: sampling freq
%
%   Name: phi
%   Type: scalar
%   Description: initial phase
%
% Output Arguments:
%   Name: psi
%   Type: vector (complex)
%   Description: AM-FM component
%
%   Name: s
%   Type: vector (real) 
%   Description: real AM-FM signal
%
%   Name: t
%   Type: vector (real) 
%   Description: time index
%
%--------------------------------------------------------------------------
% If you use these files please cite the following:
%
%       @article{HSA2015,
%           title={Theory of the Hilbert Spectrum},
%           author={Sandoval, S. and De~Leon, P.~L.~},
%           journal={{Applied and Computational Harmonic Analysis}},
%           year = {\noop{2015}in review},  }
%
%
% References:
%
%--------------------------------------------------------------------------
% Author: Steven Sandoval
%--------------------------------------------------------------------------
% Creation Date: August 2012
%
% Revision History:
%
%==========================================================================
a = a(:);
m = m(:);

%------------------
% Check valid input
%------------------
if (nargin ~= 4)&&(nargin ~= 5)
    error('Error (amfmmod): must have 4 or 5 input arguments.');
end;

if (nargin <5)
    phi = 0;
end;

if length(a)~=length(m)
    error('Error (amfmmod): a and m must be of same length')
end


%-----------
% Initialize
%-----------
t = 0:length(m)-1;
t = t./fs;
t = t(:);

%-----
% Main
%-----
theta =  2*pi.*fc.*t + 2*pi.*cumsum(m)./fs + phi;
psi = a.*exp(1i*theta);
s = real(psi);



