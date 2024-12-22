
% If our thesis ideas are helpful to you, please help us light up the stars in Github, Thank you!
% If you use these code in your research, please cite:
% @conference{
%	author = {Guofa Li,Yongjie Lin,Xingda Qu},
%	title  = {An infrared and visible image fusion method based on Multi-scale Transformation and Norm Optimization},
%	booktitle = {Information Fusion},
%	year = {2021}
% }

function [ca,cb,cc,cd] = Relevancy(img1,img2,img3)

AImg = padarray(img1,[7,7 ],'symmetric','both');%visible
BImg = padarray(img2,[7,7],'symmetric','both');%infrared
CImg = padarray(img3,[7,7],'symmetric','both');%pre-fusion
% AImg = padarray(img1,[5,5 ],'symmetric','both');%visible
% BImg = padarray(img2,[5,5],'symmetric','both');%infrared
% CImg = padarray(img3,[5,5],'symmetric','both');%pre-fusion

[M,N]= size(AImg);

%15 * 15 µÄÍ¼Ïñ¿é¡£

i = 1:M-15+1;
j = 1:N-15+1;
[I,J] = meshgrid(i,j);
parfor i = 1:numel(I)              %9
        %  Local relevancy score
        A1 = AImg( (I(i)-1)*1+1:(I(i)-1)*1+15, (J(i)-1)*1+1:(J(i)-1)*1+15 );
        B1 = BImg( (I(i)-1)*1+1:(I(i)-1)*1+15, (J(i)-1)*1+1:(J(i)-1)*1+15 );
        C1 = CImg( (I(i)-1)*1+1:(I(i)-1)*1+15, (J(i)-1)*1+1:(J(i)-1)*1+15 );
        Ccscore(i) = ssim(A1,C1);
        Cdscore(i) = ssim(C1,B1);
        Cascore(i) = entropy(A1);
        Cbscore(i) = entropy(B1);
        % Cascore(i) = vifp_mscale(A1,C1);
        % Cbscore(i) = vifp_mscale(C1,B1);
end

cbscore = reshape(Cbscore,length(j),length(i));
cb = transpose(cbscore);
cascore = reshape(Cascore,length(j),length(i));
ca = transpose(cascore);
ccscore = reshape(Ccscore,length(j),length(i));
cc = transpose(ccscore);
cdscore = reshape(Cdscore,length(j),length(i));
cd = transpose(cdscore);

end