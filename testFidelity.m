function fidelity = testFidelity(noiseType, noiseValue, polarizationValue)
% noiseType==1: Bit flip
% noiseType==2: Phase flip
% qlib
% addpath 'C:\Users\Shao\Documents\GitHub\quantum-teleportation'
flagDisplay = 1; % flagDisplay = 1 for no display for density matrices, 0 for display them

%% Define useful stuffs
ket0=[1; 0];
ket1=[0; 1];
bellState1 = (kron(ket0,ket0) + kron(ket1,ket1)) / sqrt(2);

%% Generate random qubit 'phi' and system's density matrix
% generate random qubit 'phi'
r = rand(1,2);
r = r / norm(r);
alfa = r(1,1);
beta = r(1,2);
% show 'phi'
phi = alfa * ket0+beta * ket1;
densityPhi = phi * phi';
if (flagDisplay == 0)
    disp( 'the teleported density is' );
    disp(densityPhi);
end

% get density matrix for system
% assume using bell state 1 for the entangled pair
iniState = kron(phi,bellState1);
iniDensity = iniState * iniState';

%% Generate the noise
% genearate bit flip noise
% M1 for no error, and M2 for different types of errors
if (noiseType == 1)
    M1 = sqrt(1 - noiseValue) * [1 0; 0 1];
    M2 = sqrt(noiseValue) * [0 1; 1 0];
end
% genearate phase flip noise
if (noiseType == 2)
    M1 = sqrt(1 - noiseValue) * [1 0; 0 1];
    M2 = sqrt(noiseValue) * [1 0; 0 -1];
end

%% Aplly the noise
% E for Error patterns
E{1} = kron(M1,kron(M1,M1));
E{2} = kron(M1,kron(M1,M2));
E{3} = kron(M1,kron(M2,M1));
E{4} = kron(M1,kron(M2,M2));
E{5} = kron(M2,kron(M1,M1));
E{6} = kron(M2,kron(M1,M2));
E{7} = kron(M2,kron(M2,M1));
E{8} = kron(M2,kron(M2,M2));
afterNoiseDensity = 0;

for (iter = 1:8)
    afterNoiseDensity = afterNoiseDensity + E{iter} * iniDensity * E{iter}';
end

%% Generate and apply polorization distortion
% generate a pair of random phase
polorA = exp( 2i .* rand * pi );
polorB = exp( 2i .* rand * pi );
polarOperator = [ polorA 0 ; 0 polorB ];

% aplly polorization distortion to qubit B
polarOverallOperator = kron(eye(2),kron(eye(2),polarOperator));
afterPolarDensity = (1 - polarizationValue) * afterNoiseDensity + polarizationValue * polarOverallOperator * afterNoiseDensity * polarOverallOperator';

%% Measurement and calculating states for C, A and B
% get density matrix after measurement for C and A
[afterMeasureDensity, measureResult ] = measureBellState( afterPolarDensity);
% get density of B by partial trace
densityB = partial_trace(afterMeasureDensity, [0 0 1]);
% get state of B by dm2pure function in QLIB
% stateB = dm2pure(densityB);

%% Operation on qubit B to recover initial state
% define operation Z,X on B
Z = [1 0 ; 0 -1];
X = [0 1 ; 1 0];
% operate on B
if (measureResult == 1)
    % do nothing
elseif (measureResult == 2)
    densityB = Z * densityB * Z';
elseif (measureResult == 3)
    densityB = X * densityB * X';
else
    densityB =X * Z * densityB * ( X * Z )';
end

%% get fidelity
% get density for final B
fidelity = 0.933 * abs( trace(densityPhi * densityB) ); % 0.933 is the given overall fidelity on the ground 
if (flagDisplay == 0)
    disp('The final density is ');
    disp(densityB);
end

end