### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ f9509a30-3a3c-11eb-16b2-6d2d967af99f
begin
	using Pkg
	Pkg.add(["FFTW","Plots","CSV","DataFrames","Statistics","PlutoUI","Peaks"])
	using FFTW, Plots, CSV, DataFrames, Statistics, PlutoUI, Peaks
end

# ╔═╡ 39d10dae-3a3d-11eb-13ea-8125fd517e4e
data = CSV.read("data/stream_simple.csv",DataFrame)

# ╔═╡ 91202802-3afe-11eb-0bec-27e17fc805fc
plotly()

# ╔═╡ ea0ad14e-3af8-11eb-2b1c-91c08a99d77d
function runave(data;alpha=0.9)
	ave = mean(data)
	runs = []
	for i in 1:length(data)
		ave = ave * alpha + (1-alpha) * data[i]
		push!(runs,ave)
	end
	return runs
end

# ╔═╡ 9f688650-3e2d-11eb-0d8d-c1fed0e55490
function peaktime(data)
	res = []
	for i in 2:length(data)
		if data[i] - data[i-1] > 100
			push!(res,50)
		else	
			push!(res,data[i] - data[i-1])
		end
	end
	return res
end

# ╔═╡ 9c9c1460-3b02-11eb-0631-3d37cd287381
@bind α Slider(0.8:0.01:0.99;default=0.9)

# ╔═╡ 52643a20-3af9-11eb-13ea-91dc64e1ff1e
run_ave = Float64.(runave(data.Count;alpha=α))

# ╔═╡ f9da7cd0-3e30-11eb-2c26-6574a5f1ec7f
p = plot(data.Time,run_ave);

# ╔═╡ aba20fa0-3e2c-11eb-1115-61101d91e01f
peaks = peakprom(run_ave,20)[1]

# ╔═╡ 39381b30-3e31-11eb-0950-a30f253095af
scatter!(p,data.Time[peaks],run_ave[peaks])

# ╔═╡ d22a4430-3e3b-11eb-1e0b-951e5b602f99
peaks[peakprom(run_ave,20)[2] .> 0.2]

# ╔═╡ 8bf03660-3e30-11eb-188b-e9e1bdd19a73
res = peaktime(peaks)

# ╔═╡ fe864a40-3e33-11eb-1b29-5905138e815f
bpm = 60.0 ./ (res ./ 10)

# ╔═╡ fabb2030-3e2d-11eb-00b5-2b878c128f8b
plot(data.Time[peaks[2:end]],[bpm,runave(bpm)])

# ╔═╡ Cell order:
# ╠═f9509a30-3a3c-11eb-16b2-6d2d967af99f
# ╠═39d10dae-3a3d-11eb-13ea-8125fd517e4e
# ╠═91202802-3afe-11eb-0bec-27e17fc805fc
# ╠═ea0ad14e-3af8-11eb-2b1c-91c08a99d77d
# ╠═9f688650-3e2d-11eb-0d8d-c1fed0e55490
# ╠═52643a20-3af9-11eb-13ea-91dc64e1ff1e
# ╠═9c9c1460-3b02-11eb-0631-3d37cd287381
# ╠═f9da7cd0-3e30-11eb-2c26-6574a5f1ec7f
# ╠═39381b30-3e31-11eb-0950-a30f253095af
# ╠═aba20fa0-3e2c-11eb-1115-61101d91e01f
# ╠═d22a4430-3e3b-11eb-1e0b-951e5b602f99
# ╠═8bf03660-3e30-11eb-188b-e9e1bdd19a73
# ╠═fe864a40-3e33-11eb-1b29-5905138e815f
# ╠═fabb2030-3e2d-11eb-00b5-2b878c128f8b
