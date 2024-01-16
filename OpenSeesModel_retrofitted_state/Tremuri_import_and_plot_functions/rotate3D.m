function rotated = rotate3D(vec, angles)


n = angles;
gamma = norm(angles);
if gamma == 0
    rotated = vec;
else
    n = n/gamma;
    c = cos(gamma);
    s = sin(gamma);
    
    T = zeros(3,3);
    T(1,1) = c + (1-c)*n(1)^2;
    T(1,2) = n(3)*s + (1-c)*n(1)*n(2);
    T(1,3) = -n(2)*s + (1-c)*n(1)*n(3);
    T(2,1) = -n(3)*s + (1-c)*n(1)*n(2);
    T(2,2) = c + (1-c)*n(2)^2;
    T(2,3) = n(1)*s + (1-c)*n(2)*n(3);
    T(3,1) = n(2)*s + (1-c)*n(1)*n(3);
    T(3,2) = -n(1)*s + (1-c)*n(2)*n(3);
    T(3,3) = c + (1-c)*n(3)^2;
    
    rotated = T'*vec;
end

end

