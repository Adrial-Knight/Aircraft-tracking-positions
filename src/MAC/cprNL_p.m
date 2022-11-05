function n = cprNL_p(x)
    if x==0
        n = 59;
    elseif abs(x)==87
        n = 2
    elseif abs(x) > 87
        n = 1
    else
        a = 1 - cos(pi/30);
        b = cos((pi/180)*abs(x)) ^ 2;
        n = floor((2*pi)/acos(1 - a/b));
    end
end