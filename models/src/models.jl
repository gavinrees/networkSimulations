module models

include("analysis/analysis.jl")
include("simulators/simulateIntroductionModel.jl")
include("mutators/mutateUniform.jl")
include("introductionJudgers/judgerSigmaEgo.jl")
include("introductionJudgers/judgerSigmaMean.jl")
include("introductionJudgers/judgerSigmaSum.jl")
include("graphToFitnessMaps/fitnessDivisible.jl")
include("graphToFitnessMaps/fitnessNonRival.jl")
include("graphToFitnessMaps/fitnessEveryonePaysNonRival.jl")
include("graphToFitnessMaps/fitnessClassical.jl")
include("graphToFitnessMaps/fitnessAveraged.jl")
include("graphToFitnessMaps/fitnessClassicalDefCost.jl")
include("farmers/segregationDistributionAveraged.jl")
include("introductionJudgers/judgerEgoDefectorVis.jl")
include("farmers/degreeDistributionAveraged.jl")
include("introductionJudgers/judgerEgoDefAccept.jl")


greet() = println("Hello World!")

end # module
