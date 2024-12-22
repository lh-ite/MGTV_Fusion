clc
close
addpath('Data\','Decomposition\');
addpath("wls_toolbox\");

input_path = 'Data\M3FD_Fusion\IR\';
output_path = './Output_data/TNO_bila/';
if ~exist(output_path,"dir")
    mkdir(output_path);
end
input = dir(strcat(input_path,'*.png'));
for i = 1:42 
    if exist(strcat(output_path,input(i).name),'file')
        continue
    end
    IR = imread(strcat(input_path,input(i).name));
    VIS = imread(strcat('Data\M3FD_fusion\VIS\',input(i).name));
    % M1 =silence_extract(IR);
    % M2 = silence_extract(VIS);
    [~,~,d] = size(IR);
    [~,~,d1] = size(VIS);
    if d==3
        IR = rgb2gray(IR);
    end
    if d1==3
        VIS = rgb2gray(VIS);
    end

    if size(IR)~=size(VIS)
       error('two images are not the same size.');
    end
    VIS = im2double(VIS);
    IR = im2double(IR);
    S_I = GTV(IR,0.005,0.0004,0.1);%LowI
    S_V = GTV(VIS,0.005,0.0004,0.1);
    % S_I = tsmooth(IR,0.001,1);
    % S_V = tsmooth(VIS,0.001,1);
    %S_I = RollingGuidanceFilter_Guided(IR,2,0.05,4);
    %S_V = RollingGuidanceFilter_Guided(VIS,2,0.05,4);
    % S_I = imgaussfilt(IR);
    % S_V = imgaussfilt(VIS);
    % S_I = bilateralFilter(IR);
    % S_V = bilateralFilter(VIS);
    T_I = IR - S_I;%High
    T_V = VIS - S_V;

    % O1 = normalize(M1);
    % O2 = normalize(M2);
    % % 融合纹理层
    % w1=O1./(O1+O2);
    % w2=O2./(O1+O2);
    % F_t= w1.*T_I +w2.*T_V;
    % F_t = lp_fuse(T_V,T_I,1,1,4);
    % F_t = lp_fuse(T_V,T_I,1,2,4);
    F_t = WLS_Fusion(T_V,T_I);
    %处理结构层
    smooth_T_I = imgaussfilt(T_I);%Low
    smooth_T_V = imgaussfilt(T_V);
    % smooth_S_I = imgaussfilt(S_I);
    % smooth_S_V = imgaussfilt(S_V);
    % smooth_T_I = bilateralFilter(T_I);
    % smooth_T_V = bilateralFilter(T_V);
    B_I = S_I-smooth_T_I;%Median
    B_V = S_V -smooth_T_V;
    % B_I = S_I-smooth_S_I;
    % B_V = S_V -smooth_S_V;
    % smooth_T_V_1 = imgaussfilt(B_V);
    % smooth_T_I_1 = imgaussfilt(B_I);
    % B_I_1 = B_I - smooth_T_I_1;
    % B_V_1 = B_V - smooth_T_V_1;
    F_smooth = selc(smooth_T_V,smooth_T_I,1);
    % F_smooth_1 = selc(smooth_T_I_1,smooth_T_V_1,1);
    % sm =ssim(B_V,B_I)-0.4;
    % F_B = sm.*B_I +(1-sm).*B_V;
    pre_image = (VIS+IR)/2;
    % ssim_I = ssim(pre_image,B_I);
    % ssim_V = ssim(pre_image,B_V);
    % w3 = ssim_V/(ssim_I+ssim_V);
    % w4 = 1 - w3;
    % F_B = w3*B_V +w4*B_I;
    [ca,cb,cc,cd] = Relevancy(B_I,B_V,pre_image);
    O1 = normalize(ca);
    O2 = normalize(cb);
    O3 = normalize(cc);
    O4 = normalize(cd);
    Weight1 = (O1+O3)/2;
    Weight2 = (O2+O4)/2;
    % w3=O1./(O1+O2);
    % w4=O2./(O1+O2);
    w3 = Weight1./(Weight2+Weight1);
    w4 = Weight2./(Weight1+Weight2);
    F_B = w4.*B_V+w3.*B_I;
    % F_B = w3*B_V+w4*B_I;
    % F_S = lp_fuse(S_V,S_I,1,1,4);
    Result = F_B+F_smooth+F_t;
    imwrite(Result,strcat(output_path,input(i).name));
    % Result = F_S+F_t;

end
