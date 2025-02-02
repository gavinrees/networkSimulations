module judgerSigmaSum

using LightGraphs

export judgeSigmaSum

function sigma(x,k)
    return 1 / (1 + exp(-x * k))
end

function judgeSigmaSum(graph, types, fitnesses, a,b,c,k)
	introFitness = fitnesses[b]
	aAvgFitness = sum([fitnesses[j] for j in neighbors(G1,a)])
    cAvgFitness = sum([fitnesses[j] for j in neighbors(G1,c)])
    pConnect = sigma(introFitness - aAvgFitness,k) * sigma(introFitness - cAvgFitness,k)
    return pConnect
end

end
