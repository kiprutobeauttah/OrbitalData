# plots.jl
using PlotlyJS, Dates, CSV

function save_interactive_plots(df::DataFrame; outdir::AbstractString="output")
    isdir(outdir) || mkpath(outdir)

    p1 = Plot(scatter(; x=df.longitude, y=df.latitude, mode="markers+lines", name="Ground Track"),
        Layout(title="Ground Track", xaxis_title="Longitude (°)", yaxis_title="Latitude (°)"))
    p2 = Plot(scatter(; x=df.timestamp, y=df.altitude_km, mode="lines", name="Altitude"),
        Layout(title="Altitude vs Time", xaxis_title="Time", yaxis_title="Altitude (km)"))
    p3 = Plot(scatter(; x=df.timestamp, y=df.velocity_kms, mode="lines", name="Reported Velocity"),
        Layout(title="Reported Velocity vs Time", xaxis_title="Time", yaxis_title="Velocity (km/s)"))
    p4 = Plot(scatter(; x=df.timestamp, y=df.ground_speed_kms, mode="lines", name="Computed Ground Speed"),
        Layout(title="Computed Ground Speed vs Time", xaxis_title="Time", yaxis_title="Ground speed (km/s)"))

    savefig(p1, joinpath(outdir, "ground_track.html"))
    savefig(p2, joinpath(outdir, "altitude_vs_time.html"))
    savefig(p3, joinpath(outdir, "reported_velocity_vs_time.html"))
    savefig(p4, joinpath(outdir, "computed_ground_speed_vs_time.html"))

    # Also save augmented CSV
    CSV.write(joinpath(outdir, "telemetry_augmented.csv"), df)
    return outdir
end
