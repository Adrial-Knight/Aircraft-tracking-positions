function encoded = encodeCRC_p(bits)
    P = [ 24 23 22 21 20 19 18 17 16 15 14 13 12 10 3 0 ];
    gen = comm.CRCGenerator(P);
    encoded = gen(bits')';
end