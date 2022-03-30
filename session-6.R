in_circle <- function(point) {
  point[[1]]^2 + point[[2]]^2 < 1
}


in_circle(c(0.5,0.5))
in_circle(c(1.1,0))


counter_to_pi <- function(count, total) {
  count/total * 4
}






# montecarlo --------------------------------------------------------------

head(points)

count <- 0
for (point in points) {
  cond <- as.integer(in_circle(point))
  count <- count + cond
}
count
total <- length(points)
counter_to_pi(count, total)


# split -------------------------------------------------------------------


head(points)

cond_v <- c()

points[[100]]

# Ideally a map
for (point_idx in seq_along(points)) {
  point <- points[[point_idx]]
  cond_v[point_idx] <- as.integer(in_circle(point))
}

# ideally a reduce
count <- 0
for (cond in cond_v) {
  count <- count + cond
}
count
total <- length(points)
counter_to_pi(count, total)



# map reduce --------------------------------------------------------------



library(purrr)

# Ideally a map
cond_v <- lapply(points, in_circle)

# ideally a reduce
reduce(cond_v, `+`)

# Ideally a map
count <- 
  points %>% 
  lapply(in_circle) %>% 
  reduce(`+`)

count

# ((((1 + 2) + 3) + 4) + 5)
reduce(1:5, `+`, .dir = "backward")

# (1 + (2 + (3 + (4 + 5))))
# 1 + 2 + 3 + 4 + 5

count
total <- length(points)
counter_to_pi(count, total)


# str reduce --------------------------------------------------------------

reduce(letters, paste)

reduce(letters, paste, .dir = "backward")


# cluster object in functions ---------------------------------------------

parallelo <- function(points) {
  
  # init cluster
  n_cpus <- parallel::detectCores()
  cluster <-  makeCluster(n_cpus, type = "SOCK")
  registerDoSNOW(cluster)

  # run parallel
  snow::parLapply(cl = cluster,
                  x = points,
                  fun = in_circle) %>%
    reduce(`+`) %>% 
    counter_to_pi( n)
  toc()
  
  # stop cluster
  stopCluster(cluster)
}


in_parallelo <- function(cluster, points) {
  # run parallel
  snow::parLapply(cl = cluster,
                  x = points,
                  fun = in_circle) %>%
    reduce(`+`) %>% 
    counter_to_pi( n)
}


n_cpus <- parallel::detectCores()
cluster <-  makeCluster(n_cpus, type = "SOCK")
registerDoSNOW(cluster)
in_parallelo(cluster, points)
stopCluster(cluster)


# reduce ------------------------------------------------------------------

reduce(letters, paste0, .init = "Letters:")
paste0(paste0("Letters:", "a"), "b")




# optim reduce ------------------------------------------------------------

# Ideally a map
cond_v <- lapply(points, in_circle)

tic()
# ideally a reduce
reduce(cond_v, `+`)
toc()

tic()
# ideally a reduce
sum(unlist(cond_v))
toc()


# Ideally a map
count <- 
  points %>% 
  lapply(in_circle) %>% 
  reduce(`+`)

count




# vectorization -----------------------------------------------------------


v1 <- 1:100000
v2 <- 1:100000*3


tic()
v3 <- c()
for (i in seq_along(v1))
  v3[i] <- v1[i] + v2[i]
toc()

v3

v3 <- v1 + v2

sum(v1)










