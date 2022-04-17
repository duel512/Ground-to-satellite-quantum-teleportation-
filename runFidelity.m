function averageFidelity=runFidelity(noiseType,noiseValue,polorizationValue,iteration)
sumFidelity = 0;
for i=1:iteration
    sumFidelity = sumFidelity + testFidelity(noiseType, noiseValue, polorizationValue);
end
averageFidelity = sumFidelity / iteration;
