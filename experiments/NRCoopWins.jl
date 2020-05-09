using Distributed
using DataFrames
import CSV

PROCS = 5
toAdd = PROCS - nprocs()
addedProcs = addprocs(toAdd)

@everywhere begin
    root = "/Users/gavin/Documents/Stay_Loose/Research/Evolutionary_Dynamics/networkSimulations"
	push!(LOAD_PATH, root)
	# println("LOAD_PATH is $LOAD_PATH")
end

function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table! s begin
        "-N"
            help = "an option with an argument"
            arg_type = Int
      		required = true
      	"--judge"
      		help = "The judger to be used"
      		arg_type = String
      		default = "ego"
      	"--fitness"
      		help = "The fitness function"
      		arg_type = String
      		default = "nonRival"
    end

    return parse_args(s)
end


parsed_args = parse_commandline()
@eval @everywhere N = $(parsed_args["N"])
@eval @everywhere judgerName = $(parsed_args["judge"])
@eval @everywhere fName = $(parsed_args["fName"])

@everywhere begin
	import models
	using LightGraphs

	using models.simulateIntroductionModel
	using models.judgerSigmaEgo
	using models.judgerSigmaMean
	using models.fitnessNonRival
	using models.fitnessClassical
	using models.fitnessDivisible
	using models.mutateUniform
	using models.segregationDistributionAveraged

	sampleInt = 5000
	numRounds = 500000
	numSamples = ceil(Int, numRounds/sampleInt)
	function mySimulator(;coopProp = 0.5, intensity = 0.01)
		G = random_regular_graph(N,5)
		nCoops = floor(Int, coopProp * nv(G))
		types = [0 for i in 1:nv(G)]
		for j in 1:nCoops
			types[j] = 1
		end

		fitFunc = GtoFNonRivalTemplate(5,1,intensity)
		updater = fitUpdaterTemplateNonRival(5,1,intensity)
		if fName == "classical"
			fitFunc = GtoFClassicalTemplate
			updater = fitUpdaterTemplateClassical(5,1,intensity)
		elseif fName == "divisible"
			fitFunc = GtoFDivisibleTemplate(5,1, intensity)
			updater = Nothing
		end
		
		judge = judgeSigmaEgo
		if judgerName == "mean"
			judge = judgerSigmaMean
		end

		mut = makeMutator(0.01)
		return simulateIntroModel(G,types,numRounds,judge, fitFunc, mut, sampleInterval = sampleInt, fitUpdater! = updater)
	end
end
coopPropRange = [0.01 * i for i in 1:99]
nTrials = 100 #just for debug!
@time resultDf, seriesDf = segDistAvg(mySimulator, numTrials = nTrials, coopPropRange = coopPropRange, numSamples = numSamples)


CSV.write("$root/data/$(fName)$(judgerName)CoopWins$N.csv", resultDf)
CSV.write("$root/data/$(fName)$(judgerName)CoopWins$(N)TS.csv", seriesDf)



# outgraph, outAvgFits, outTypes, outSamples = simulateIntroModel(G,types,1000000,judge, fitFunc, mut, sampleInterval = 50000)
# println(resultArray)
rmprocs(addedProcs)
println("Done")
