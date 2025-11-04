# OrbitalData

<img src = "assets/orbital-cover.jpg">
**Satellite Telemetry Parser & Visualizer**

This package parses CSV telemetry, computes basic derived metrics, and saves both interactive HTML plots and an augmented CSV.  
Package name: `OrbitalData`  
Created: 2025-11-04

## Quickstart

```bash
# From the project root:
julia --project=. -e 'using Pkg; Pkg.instantiate()'
julia --project=. examples/demo.jl
```

The example will read `data/sample_telemetry.csv`, run parsing and analysis, and write outputs to `output/`.

## Project layout
```
OrbitalData/
├── Project.toml
├── README.md
├── LICENSE
├── .gitignore
├── .github/workflows/ci.yml
├── src/OrbitalData.jl
├── src/parser.jl
├── src/plots.jl
├── test/runtests.jl
├── data/sample_telemetry.csv
└── examples/demo.jl
```
---
_powered by Beauttah_