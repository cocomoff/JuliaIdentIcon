module IdentIcon

using StatsBase
using Plots
gr()

export generate_solution,
       represent,
       get_initial_solutions,
       crossover,
       mutation,
       visualize,
       visualize_crossover,
       visualize_mutation

const DEF_SIZE = 8

generate_solution(;S=DEF_SIZE) = rand(0:1, S * div(S, 2))

function represent(s; S=DEF_SIZE)
    smat = reshape(s, (S, div(S, 2)))
    [smat reverse(smat, dims=2)]
end

get_initial_solutions(N; S=DEF_SIZE) = zeros(Int, N, S * div(S, 2))


function crossover(s1, s2; S=DEF_SIZE)
    t = rand(1:(S * div(S, 2)))
    s12 = copy(s1)
    s12[t:end] = s2[t:end]
    s12
end


function mutation(s; S=DEF_SIZE)
    t = rand(1:(S * div(S, 2)))
    new_s = copy(s)
    new_s[t] = (new_s[t] + 1) % 2
    new_s
end

# visualizer

function visualize_crossover(sol1, sol2; PX=120, PY=120, figname="icons_crossover.png", cmap=:thermal)
    ST = (PX, PY)
    sol12 = crossover(sol1, sol2)
    h1 = heatmap(represent(sol1), aspect_ratio=1, colorbar=false, title="1", size=ST, ticks=false, xaxis=false, yaxis=false, c=cmap)
    h2 = heatmap(represent(sol2), aspect_ratio=1, colorbar=false, title="2", size=ST, ticks=false, xaxis=false, yaxis=false, c=cmap)
    h3 = heatmap(represent(sol12), aspect_ratio=1, colorbar=false, title="1 x 2", size=ST, ticks=false, xaxis=false, yaxis=false, c=cmap)
    fig = plot(h1, h2, h3, size=(PX * 3, PY * 1), layout=(1, 3))
    savefig(fig, figname)
    fig
end

function visualize_mutation(sol1; PX=120, PY=120, figname="icons_mutation.png", cmap=:thermal)
    ST = (PX, PY)
    sol1m = mutation(sol1)
    h1  = heatmap(represent(sol1), aspect_ratio=1, colorbar=false, title="1", size=ST, ticks=false, xaxis=false, yaxis=false, c=cmap)
    h1m = heatmap(represent(sol1m), aspect_ratio=1, colorbar=false, title="mutation 1", size=ST, ticks=false, xaxis=false, yaxis=false, c=cmap)
    fig = plot(h1, h1m, size=(PX * 2, PY * 1), layout=(1, 2))
    savefig(fig, figname)
    fig
end


function visualize(solutions::Array{Int, 2}; PX=120, PY=120, figname="icons.png", cmap=:thermal)
    ST = (PX, PY)
    N = size(solutions)[1]
    
    # generate icons
    h = []
    for n in 1:N
        rs = represent(solutions[n, 1:end])
        hn = heatmap(rs, aspect_ratio=1, colorbar=false,
                     title="$n", size=ST, ticks=false, xaxis=false,
                     yaxis=false, c=cmap)
        push!(h, hn)
    end

    # plot all
    fig = plot(h..., layout=(2, 5), aspect_ratio=1, colorbar=false, size=(PX * 5, PY * 2), ticks=false, c=:thermal)
    savefig(fig, figname)
    fig
end


end