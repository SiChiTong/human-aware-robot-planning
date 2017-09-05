Q = [ 0.9, 0.1; 0.,   0.8  ];
R = [   0; 0.2; ];
P = [   Q,   R; zeros(1, size(Q,2)), eye(1) ];
    
P0 = P * [1;1;1];

N = (eye(size(Q)) - Q )^-1;