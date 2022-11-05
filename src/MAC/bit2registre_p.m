function register = bit2registre(bits, refLon, refLat)
    [decoded, errorFlag] = decodeCRC(bits);
    if ~errorFlag
        fmt = polyval(decoded(1:5), 2); % read format (should be [1 0 0 0 1]) and convert to decimal (17)
        payload = decoded(33:88);
        msg_type = polyval(payload(1:5), 2); % read message type and convert to decimal
        address = dec2hex(polyval(decoded(9:32),2));
        register = struct('error',0,'format', fmt, 'address', address, 'type', msg_type, 'name', '        ', 'altitude', -1, 'timeFlag', -1, 'cprflag', -1, 'latitude', [], 'longitude', []);
        % test different message type values
        if 1 <= msg_type && msg_type <= 4 %% id message
            chartable = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ                     0123456789';
            for i = 1:8
                pos = polyval(payload(6*i+3:6*i+8), 2);
                register.name(i) = chartable(pos);
            end
        elseif 5 <= msg_type && msg_type <= 18 || 20 <= msg_type && msg_type <= 22 %% position message
            register.timeFlag = payload(21);
            register.cprflag = payload(22);
            lat=polyval(payload(23:39), 2);
            lon=polyval(payload(40:56), 2);
            [ register.longitude, register.latitude ] = cpr2LatLon(lat ,lon, register.cprflag, refLat, refLon);
            if msg_type>=9
                altitude_bits = [ payload(9:15) payload(17:20) ];
                register.altitude = 25 * polyval(altitude_bits, 2) - 1000;
            else
                register.altitude = 0;
            end
        elseif msg_type == 19 % airborne velocity message
            subtype = payload(6) * 4 + payload(7) * 2 + payload(8); % read subtype
            register.subtype = subtype;
            switch subtype
                case 1 % subsonic ground speed
                    % signs for east-west and north-south components
                    e_w_sign = 1 - 2*payload(14); 
                    n_s_sign = 1 - 2*payload(25);
                    % east-west and north-south values
                    e_w_val = e_w_sign * (polyval(payload(15:24), 2) - 1);
                    n_s_val = n_s_sign * (polyval(payload(26:35), 2) - 1);
                    register.heading_EW = e_w_val;
                    register.heading_NS = n_s_val;
                case 2 % supersonic ground speed
                    % signs for east-west and north-south components
                    e_w_sign = 1 - 2*payload(14); 
                    n_s_sign = 1 - 2*payload(25);
                    % east-west and north-south values
                    e_w_val = 4 * e_w_sign * (polyval(payload(15:24), 2) - 1);
                    n_s_val = 4 * n_s_sign * (polyval(payload(26:35), 2) - 1);
                    register.heading_EW = e_w_val;
                    register.heading_NS = n_s_val;
                case 3 % subsonic air speed
                    heading = polyval(payload(15:24), 2) * (2*pi) / 1024; % heading in radians
                    speed = polyval(payload(26:35), 2) - 1;
                    register.heading_EW = speed * cos(heading) * payload(14);
                    register.heading_NS = speed * sin(heading) * payload(14);
                case 4 % supersonic air speed
                    heading = polyval(payload(15:24), 2) * (2*pi) / 1024; % heading in radians
                    speed = 4 * (polyval(payload(26:35), 2) - 1);
                    register.heading_EW = speed * cos(heading) * payload(14);
                    register.heading_NS = speed * sin(heading) * payload(14);
            end
        end
    else
        register = struct('error', 1);
    end
end