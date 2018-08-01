using PyPlot, Gurobi, JuMP

seed = 345345
srand(seed)
X = randn(2,50) # generate 50 random points
t = linspace(0,2pi,100) # parameter that traverses the circle
r = 2; x = 0; y = 0 # radius and coordinates of the center

plot( x + r*cos.(t), y + r*sin.(t)) # plot circle radius r with center (x1,x2)
scatter( X[1,:], X[2,:], color="green") # plot the 50 points
axis("equal") # make x and y scales equal


m = Model(solver = GurobiSolver())

@variable(m, x[1:50])
@variable(m, y[1:50])
@variable(m, cx)
@variable(m, cy)
@variable(m, R >= 0)

@constraint(m, cx .+ x .== X[1,:] )
@constraint(m, cy .+ y  .== X[2,:])
@constraint(m, x.^2 .+ y.^2 .<= R^2)

#minimize radius
@objective(m, Min, pi .* R^2)
solve(m)

println(getvalue(cx))
println(getvalue(cy))
println(getvalue(R))

using PyPlot
figure(figsize=(12,4))
t = linspace(0,2pi,100) # parameter that traverses the circle
plot( getvalue(cx) + getvalue(R)*cos.(t), getvalue(cy) + getvalue(R)*sin.(t)) # plot circle radius r with center (x1,x2)
scatter( X[1,:], X[2,:], color="red") # plot the 50 points
axis("equal") # make x and y scales equal
show()
