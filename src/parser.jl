# parser.jl
using CSV, DataFrames, Dates, Statistics

# Haversine distance (km)
function haversine(lat1, lon1, lat2, lon2)
    R = 6371.0  # Earth radius in km
    dlat = deg2rad(lat2 - lat1)
    dlon = deg2rad(lon2 - lon1)
    a = sin(dlat/2)^2 + cos(deg2rad(lat1))*cos(deg2rad(lat2))*sin(dlon/2)^2
    c = 2 * atan(sqrt(a), sqrt(1 - a))
    return R * c
end

function parse_telemetry(path::AbstractString)
    df = CSV.read(path, DataFrame)
    if :timestamp in names(df)
        try
            df.timestamp = DateTime.(df.timestamp)
        catch
            df.timestamp = DateTime.(replace.(df.timestamp, " "=>"T"))
        end
    else
        error("CSV must contain a 'timestamp' column")
    end

    for col in (:latitude, :longitude, :altitude_km, :velocity_kms)
        if !(col in names(df))
            error("CSV must contain column: $(col)")
        end
    end

    sort!(df, :timestamp)
    return df
end

# Compute per-row dt (seconds), ground distance and ground speed (km, km/s)
function compute_ground_metrics!(df::DataFrame)
    n = nrow(df)
    df.dt = [0.0; diff(DateTime.(df.timestamp))./Second(1)]
    distances = zeros(n)
    for i in 2:n
        distances[i] = haversine(df.latitude[i-1], df.longitude[i-1], df.latitude[i], df.longitude[i])
    end
    df.ground_distance_km = distances
    df.ground_speed_kms = [ (df.dt[i] > 0) ? df.ground_distance_km[i]/df.dt[i] : 0.0 for i in 1:n ]
    return df
end

function summarize_telemetry(df::DataFrame)
    total_distance = sum(df.ground_distance_km)
    avg_altitude = mean(df.altitude_km)
    max_speed = maximum(df.velocity_kms)
    avg_ground_speed = mean(df.ground_speed_kms)
    return Dict(
        :rows => nrow(df),
        :total_ground_distance_km => total_distance,
        :average_altitude_km => avg_altitude,
        :max_reported_velocity_kms => max_speed,
        :average_computed_ground_speed_kms => avg_ground_speed
    )
end
