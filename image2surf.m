function [H] = image2surf(image,bar,h_max,h_min,par)

% INPUT: 
%     image:            image filename to convert to surface
%     bar:              colorbar of the image
%     h_max (optional): maximum value of colorbar, default = 1
%     h_min (optional): minimum value of colorbar, default = 0
%     par   (optional): use parallel computing, default = 0
%
% OUTPUT:
%     H:                height matrix of the image
%
%
% BSD 3-Clause License
% 
% Copyright (c) 2022, Gureum-and-Yeoreum
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 
% 1. Redistributions of source code must retain the above copyright notice, this
%    list of conditions and the following disclaimer.
% 
% 2. Redistributions in binary form must reproduce the above copyright notice,
%    this list of conditions and the following disclaimer in the documentation
%    and/or other materials provided with the distribution.
% 
% 3. Neither the name of the copyright holder nor the names of its
%    contributors may be used to endorse or promote products derived from
%    this software without specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


if ~exist('h_max','var')
    h_max = 1;
end
if ~exist('h_min','var')
    h_min = 0;
end
if ~exist('par','var')
    par = 0;
end

img = im2double(imread(image))*255;

ii = [reshape(img(:,:,1),[],1), reshape(img(:,:,2),[],1), reshape(img(:,:,3),[],1)];
n_ii = size(ii,1);

c_dif = zeros(n_ii,1);

b = round(mean(im2double(imread(bar))*255,2));
b = [b(:,:,1), b(:,:,2), b(:,:,3)];

if par == 0
    for i = 1:n_ii
        [~,order] = sort(sum((b-ii(i,:)).^2,2));
        c_dif(i,1) = order(1);
    end
else
    parfor i = 1:n_ii
        [~,order] = sort(sum((b-ii(i,:)).^2,2));
        c_dif(i,1) = order(1);
    end
end

h_ref = linspace(h_max,h_min,size(b,1));
h_tmp = reshape(c_dif,size(img(:,:,1)));
H = flipud(h_ref(h_tmp));
% H = (h_ref(h_tmp));

end