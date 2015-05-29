function phi = reinitialization(phi, dt)
% Christian Valdemar Hansen, SDU 2012.
% Reinitialzation follows the idea from section 3.5 in:
% M. Sussman, P. Smereka and S. Osher, "A Level Set Approach for Com-
% puting Solutions to Incompressible Two-Phase Flow," Journal of Compu-
% tational Physics, vol. 114 (1994), pp. 146-159.


for i=1:10
    old = phi;
    
    a = (phi - [phi(1,:);phi(1:end-1,:)]);
    b = [phi(2:end,:);phi(end,:)] - phi;
    c = phi - [phi(:,1),phi(:,1:end-1)];
    d = [phi(:,2:end),phi(:,end)]-phi;

    pos = find(phi>0);
    neg = find(phi<0);
    G = zeros(size(phi));
    G(pos) = sqrt(max(max(a(pos),0).^2 , min(b(pos),0).^2) + max(max(c(pos),0).^2 , min(d(pos),0).^2)) - 1;
    G(neg) = sqrt(max(min(a(neg),0).^2 , max(b(neg),0).^2) + max(min(c(neg),0).^2 , max(d(neg),0).^2)) - 1;
    S = phi./abs(phi + eps);
    phi = phi - dt*S.*G;

    % Stop iteration
    ind = find(abs(phi)<=1);
    M = length(ind);
    Q = sum(abs(phi(ind) - old(ind)))./M;
    if Q <= dt*1^2
        return;
    end
end