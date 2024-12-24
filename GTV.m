function S=GTV(I,lambda,sigma12,sigma2,N,flog)

    if(~exist('lambda','var'))
        lambda=5;
    end
    if(~exist('sigma12','var'))
        sigma12=0.01;
    end
    if(~exist('sigma2','var'))
        sigma2=0.1;
    end
    if(~exist('N','var'))
        N =4 ;
    end
    if(~exist('flog','var'))
        flog=1;
    end

    epsilon=0.001;
    I=im2double(I);
    S=I;
    for i=1:N
        [wx,wy]=computeWeights(S,sigma12,sigma2,epsilon,flog);
        S=solveLinearEquation(I,wx,wy,lambda);
    end
end

function[wxt,wyt]=computeWeights(s,sigma12,sigma2,epsilon,flog)

    dxo=diff(s,1,2);
    dxo=padarray(dxo,[0,1],'post');
    dyo=diff(s,1,1);
    dyo=padarray(dyo,[1,0],'post');

    % wxo=max(max(abs(dxo),[],3),epsilon).^(-1);%表示每个位置上梯度的最大幅度
    % wyo=max(max(abs(dyo),[],3),epsilon).^(-1);
    wxo=max(max(abs(dxo),[],3),epsilon).^(-1);%表示每个位置上梯度的最大幅度
    wyo=max(max(abs(dyo),[],3),epsilon).^(-1);
    if(flog==1)%用于控制是否应用对数梯度。
        si=gauss_filter(s,sigma2);
        % si = bilateralFilter(s);
        dxs=diff(si,1,2);
        dxs=padarray(dxs,[0,1],'post');
        dys=diff(si,1,1);
        dys=padarray(dys,[1,0],'post');

        % wxt=max(max((exp((dxs.*dxs)./(2*sigma12))),[],3),epsilon).^(-1);
        % wyt=max(max((exp((dys.*dys)./(2*sigma12))),[],3),epsilon).^(-1);
        wxt=min(max((exp((dxs.*dxs)./(2*sigma12))),[],3),epsilon).^(-1);
        wyt=min(max((exp((dys.*dys)./(2*sigma12))),[],3),epsilon).^(-1);
        wxt=wxo.*wxt;
        wyt=wyo.*wyt;
    else
        wxt=wxo;
        wyt=wyo;
    end
    wxt(:,end)=0;
    wyt(end,:)=0;
end


function out=solveLinearEquation(in,wx,wy,lambda)%解线性方程组
    [h,w,c]=size(in);
    n=h*w;
    wx=wx(:);%变为列向量
    wy=wy(:);

    ux=padarray(wx,h,'pre');ux=ux(1:end-h);
    uy=padarray(wy,1,'pre');uy=uy(1:end-1);
    D=wx+ux+wy+uy;
    B=spdiags([-wx,-wy],[-h,-1],n,n);%对角线矩阵B
    L=B+B'+spdiags(D,0,n,n);%对角线矩阵l

    A=speye(n)+lambda*L;
    F=ichol(A,struct('michol','on'));
    out=in;
    for i=1:c
        tin=in(:,:,i);
        [tout,~]=pcg(A,tin(:),0.1,100,F,F');
        out(:,:,i)=reshape(tout,h,w);
    end
end
