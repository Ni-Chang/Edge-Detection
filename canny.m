clear
clc;

imgsrc = imread('lenna.jpg');
imgsrc = rgb2gray(imgsrc);
[M, N] = size(imgsrc);

%��˹�˲���ƽ������
sigma = 1;
gausFilter = fspecial('gaussian', [3,3], sigma);
img= imfilter(imgsrc, gausFilter, 'replicate');

img = double(img);
m = zeros(M, N); 
theta = zeros(M, N);
sector = zeros(M, N);
canny1 = zeros(M, N);%�Ǽ���ֵ����
canny2 = zeros(M, N);%˫��ֵ��������
lowTh = 0.1;
highTh = 50;

%һ�����޲��
for i = 1:(M-1)
    for j = 1:(N-1)
        gx =  img(i, j) + img(i+1, j) - img(i, j+1)  - img(i+1, j+1);
        gy = -img(i, j) + img(i+1, j) - img(i, j+1) + img(i+1, j+1);
        m(i,j) = (gx^2+gy^2)^0.5 ;

        theta(i,j) = atand(gx/gy)  ;
        tem = theta(i,j);

        if (tem<67.5)&&(tem>22.5)
            sector(i,j) =  0;    
        elseif (tem<22.5)&&(tem>-22.5)
            sector(i,j) =  3;    
        elseif (tem<-22.5)&&(tem>-67.5)
            sector(i,j) =   2;    
        else
            sector(i,j) =   1;    
        end  
    end    
end

%�Ǽ���ֵ����
for i = 2:(M-1)
    for j = 2:(N-1)        
        if sector(i,j)==0 %���� - ����
            if ( m(i,j)>m(i-1,j+1) )&&( m(i,j)>m(i+1,j-1)  )
                canny1(i,j) = m(i,j);
            else
                canny1(i,j) = 0;
            end
        elseif 1 == sector(i,j) %��ֱ����
            if ( m(i,j)>m(i-1,j) )&&( m(i,j)>m(i+1,j)  )
                canny1(i,j) = m(i,j);
            else
                canny1(i,j) = 0;
            end
        elseif sector(i,j)==2 %���� - ����
            if ( m(i,j)>m(i-1,j-1) )&&( m(i,j)>m(i+1,j+1)  )
                canny1(i,j) = m(i,j);
            else
                canny1(i,j) = 0;
            end
        elseif 3 == sector(i,j) %�᷽��
            if ( m(i,j)>m(i,j+1) )&&( m(i,j)>m(i,j-1)  )
                canny1(i,j) = m(i,j);
            else
                canny1(i,j) = 0;
            end
        end        
    end
end

%˫��ֵ���
for i = 2:(M-1)
    for j = 2:(N-1)        
        if canny1(i,j)<lowTh %����ֵ����
            canny2(i,j) = 0;
            continue;
        elseif canny1(i,j)>highTh %����ֵ����
            canny2(i,j) = canny1(i,j);
            continue;
        else %����֮���,��8�����и��ڸ���ֵ�ģ�����Ϊ��Ե
            tem =[canny1(i-1,j-1), canny1(i-1,j), canny1(i-1,j+1);
                       canny1(i,j-1),    canny1(i,j),   canny1(i,j+1);
                       canny1(i+1,j-1), canny1(i+1,j), canny1(i+1,j+1)];
            temMax = max(tem);
            if temMax(1) > highTh
                canny2(i,j) = temMax(1);
                continue;
            else
                canny2(i,j) = 0;
                continue;
            end
        end
    end
end
   
subplot(2,3,1); imshow(imgsrc); title('Original Image');%ԭͼ
subplot(2,3,2); imshow(uint8(img)); title('After Gaussian Filter');%��˹�˲���
subplot(2,3,3); imshow(uint8(m)); title('Derivative');%����
subplot(2,3,4); imshow(uint8(canny1)); title('After NMS');%�Ǽ���ֵ����
subplot(2,3,5); imshow(uint8(canny2)); title(['Result  HighTh=', num2str(lowTh),' LowTh=', num2str(highTh)]);%˫��ֵ