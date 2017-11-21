function [k1,k2] = genCorrSource(n_pairs,k_dither,qe,verbose)
% Generate momentum-correlated source
%
% [K1,K2] = GENCORRSOURCE(N_PAIRS,K_DITHER,QE,VERBOSE)
% 
%
% N_PAIRS:      number of correlated pairs generated (not all may be detected)
% K_DITHER:     random dither in k-space per particle (sdev; 1x3 vector) 
% QE:           detection efficiency
% VERBOSE:      
%

k=cell(1,2);

%%% generate ideal correlated source
% random vectors on unit sphere
k{1}=get_rand_usph(n_pairs);

% back-to-back correlated counterpart
k{2}=-k{1};

%%% detector efficiency
% NOTE applying QE at this point is computationally efficient and does not sacrifice simulation accuracy
ncounts=NaN(1,2);
for ii=1:2
    is_detected=(rand(n_pairs,1)<qe);
    ncounts(ii)=sum(is_detected);
    k{ii}=k{ii}(is_detected,:);
end

%%% momentum width
for ii=1:2
    % build dither matrix
    dk_temp=random('Normal',0,1,size(k{ii})).*k_dither; 

    % apply
    k{ii}=k{ii}+dk_temp;
end

%%% assign outputs
k1=k{1};
k2=k{2};

end
