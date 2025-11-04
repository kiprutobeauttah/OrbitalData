# demo.jl - example usage
using Pkg
Pkg.activate(joinpath(@__DIR__, ".."))
using OrbitalData

df = parse_telemetry(joinpath(@__DIR__, "..", "data", "sample_telemetry.csv"))
compute_ground_metrics!(df)
stats = summarize_telemetry(df)
println("Summary:")
for (k,v) in stats
    println("$(k): $(v)")
end

out = save_interactive_plots(df; outdir=joinpath(@__DIR__, "..", "output"))
println("Files written to: ", out)
