function [decoded, error_flag] = decodeCRC_p(packet)
    P = [ 24 23 22 21 20 19 18 17 16 15 14 13 12 10 3 0 ];
    detector = comm.CRCDetector(P);
    [ decoded, error_flag ] = detector(packet');
    decoded = decoded';
end