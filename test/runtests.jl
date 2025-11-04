using Test
using OrbitalData

@testset "OrbitalData basic" begin
    df = parse_telemetry(joinpath(@__DIR__, "..", "data", "sample_telemetry.csv"))
    @test nrow(df) > 10
    compute_ground_metrics!(df)
    @test :ground_distance_km in names(df)
    summary = summarize_telemetry(df)
    @test summary[:rows] == nrow(df)
    @test summary[:average_altitude_km] > 0
end
