function phi = chanvese(I,n,my,lambda1,lambda2,maxsize)
% Christian Valdemar Hansen, SDU 2012.
% Input
% I is the Image 
% n is the number of iterations
% my, lambda1 and lambda2 are parameters for Chan-Vese
% maxsize is the max number of pixels on the long edge on the output image
% Example:
% I = imread('image.jpg');
% chanvese(I,500,1,1,1,300)

if(~exist('n','var')) 
    n=300; 
end
if(~exist('my','var')) 
    my=1; 
end
if(~exist('lambda1','var')) 
    lambda1=1; 
end
if(~exist('lambda2','var')) 
    lambda2=1; 
end
if(~exist('maxsize','var')) 
    maxsize=250; 
end

% Things for the stop criteria
S = stop({'Stop me on the ok button:'}) ;
%[a,b] = size(temp);

if size(I,3) == 3
    temp = rgb2gray(I);
else
    temp = I;
end

% Rescale image/pixel values
temp = double(temp)./255;


% Rescaling the size of the image
scale = maxsize/min(size(temp));
   
if scale<=1   % If the image is bigger than "maxsize" pixel on the shortest edge then rescale
    temp = imresize(temp,scale);
    I = imresize(I,scale);
end



% Choose points for level set funtion
figure, imshow(temp,'InitialMagnification','fit'); 
title('Select initial points for the initial contour, end by pressing "enter" on the key board'); hold on; 
[x1,y1] = ginput;
hold off;
  
% Make a levelset function
[x,y] = meshgrid(1:size(temp,2),1:size(temp,1));
m = inpolygon(x,y,x1,y1);
phi = bwdist(1-m)-bwdist(m)-m;

% Plot initial contour
imshow(temp); hold on;
title('Initial contour');
contour(phi, [0 0], 'r', 'LineWidth',2); drawnow; hold off;
figure,

% % Plot initial level set
%  mesh(double(phi)); hold on;
%  mesh(double(0*phi)); hold off;


% Iterativ method 
dt = 1;

%Chan-Vese method
for i=1:n
    %Finding c- and c+
    heavi = heaviside1(phi);
    cp = sum(sum(heavi.*temp))/length(find(phi>=0)); %inside mean gray level
    cm = sum(sum((1-heavi).*temp))/length(find(phi<0)); %outside mean gray level
    % Curvature
    kappa = curvature(phi);

    % Iterative step
    phi_t = diracdelta(phi).*(my*kappa - lambda1*(temp-cp).^2 + lambda2*(temp-cm).^2);
    phi = phi + dt.*(phi_t./(max(max(abs(phi_t))))); 

    % Print contour
    if(mod(i-1,10) == 0)
        imshow(temp); hold on;
        contour(phi, [0 0], 'r', 'LineWidth',2); drawnow; hold off;
        xlabel('The iteration can be stopped by pressing the OK button in the other window')
    end
    
    % Stop iteration
    if S.Stop();
        % Print Orginal image with the final contour
        figure,
        imshow(I); hold on;
        title(['Finally contour on original image after ' num2str(i) ' iterations']);
        contour(phi, [0 0], 'r', 'LineWidth',2); drawnow; hold off;
        
%         % Plot level set
%         figure,
%         mesh(double(phi)); hold on;
%         mesh(double(0*phi)); hold off;
        return;
    end

    % Reinitialize the level set equation phi
    phi = reinitialization(phi, 0.5);
    
end
end

function Y = heaviside1(X)
epsilon = 1;
Y=1/2*(1+2/pi*atan(X/epsilon));
end

function d = diracdelta(X)
epsilon = 1;
d = (pi*(epsilon^2+X.^2)).\epsilon;
end
