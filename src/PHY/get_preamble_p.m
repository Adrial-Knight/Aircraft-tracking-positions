function preamble = get_preamble_p(Fse)
    P = [ ones(1, Fse/2) zeros(1, Fse/2) ];
    preamble = [ P P zeros(1, Fse) ~P ~P zeros(1, 3*Fse) ];
end