function [ responseDensityMatrix, measureResult ] = measureBellState( systemDensityMatrix)
% For 3 quibits system
% Definying the Projectors
ket0 = [1; 0];
ket1 = [0; 1];
bellState1 = (kron(ket0,ket0) + kron(ket1,ket1)) / sqrt(2);
bellState2 = (kron(ket0,ket0) - kron(ket1,ket1)) / sqrt(2);
bellState3 = (kron(ket0,ket1) + kron(ket1,ket0)) / sqrt(2);
bellState4 = (kron(ket0,ket1) - kron(ket1,ket0)) / sqrt(2);

Projector1 = kron(bellState1*bellState1',eye(2));
Projector2 = kron(bellState2*bellState2',eye(2));
Projector3 = kron(bellState3*bellState3',eye(2));
Projector4 = kron(bellState4*bellState4',eye(2));

if (rand() <= 0.25)
    responseDensityMatrix = (Projector1 * systemDensityMatrix * Projector1)/trace(Projector1 * systemDensityMatrix * Projector1);
    measureResult = 1;    
elseif(rand() > 0.25 && rand()<=0.5)
    responseDensityMatrix = (Projector2 * systemDensityMatrix * Projector2)/trace(Projector2 * systemDensityMatrix * Projector2);
    measureResult = 2;   
elseif(rand() > 0.5 && rand()<=0.75)
    responseDensityMatrix = (Projector3 * systemDensityMatrix * Projector3)/trace(Projector3 * systemDensityMatrix * Projector3);
    measureResult = 3;    
else
    responseDensityMatrix = (Projector4 * systemDensityMatrix * Projector4)/trace(Projector4 * systemDensityMatrix * Projector4);
    measureResult = 4;
end

end