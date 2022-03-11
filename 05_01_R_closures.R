
# Closure components ------------------------------------------------------

# R functions have three main components:
#   
# 1. an argument list
# 2. a body
# 3. an environment

f <- function(x, y = 0) {
  x + y
}

print(f)

environment(f) # definition environment
formals(f)
body(f)


args(f)

# pure functions ----------------------------------------------------------

f <- function(x, y = 0) {
  x + y
}

# non pure
y <- 3
g <- function(x) {
  x + y
}

g(2) # 5
y <- 1
g(2) # 3

# environments intro -------------------------------------------------------

list1 <- list()

list1$a <- 1
list1$b <- 2
list1$a
list1$b

e1 <- new.env()
e1$a <- 1
e1$b <- 2
e1$a
e1$b

# Copy on modify
list2 <- list1
list2
list1$a <- 33

# Copy by reference
e2 <- e1
e1
e2

e1$a <- 33
e1$a
e2$a

# 1. associated envirnoment -----------------------------------------------

environment(f)
environment(filter)
environment(stats::filter)
environment(dplyr::filter)

# 2. call environment -----------------------------------------------------

g <- function(y) {
  
  f <- function(x) {
    x + y
  }

  f
}

# add logs
g <- function(y) {
  
  message("environment (function g): ")
  print(environment())
  
  useless_variable <- 0
  
  f <- function(x) {
    message("environment (function f): ")
    print(environment())
    x + y
  }

  f
}

add_one <- g(1)
add_one(7)

environment(add_one)

# the environment of the function `add_one` contains the variables used by the run of `g(1)`
ls(environment(add_one))
environment(add_one)$y
environment(add_one)$f


# try again
add_two <- g(2)
add_two(7)

environment(add_two)


environment(add_one)$y
environment(add_two)$y

ls(environment(g))
ls(environment(add_one))

ls(environment(add_two))


environment(g)
tmp <- g(1)

# global env
a <- 0
globalenv()$a

# factory environment management ------------------------------------------

g <- function(y) {
  e <- environment()
  message("environment() (funzione g)")
  print(e)
  
  a <- 0
  
  f <- function(x) {
    message("environment() (funzione f)")
    print(environment())
    
    x + y
  }
  
  # restituisco sia la funzione sia un environment per confrontarlo
  list(
    f = f,
    e = environment()
  )
}


add_one_ls <- g(1)   ############

add_one <- add_one_ls$f     # diamo lo stesso nome di prima
env_call_g1 <- add_one_ls$e # questo è l'environment creato dalla chiamata di g

# Sono lo stesso oggetto
identical( environment(add_one),  env_call_g1 )
# come si evince stampandoli a schermo
environment(add_one)
env_call_g1 

# 1. L'environment creato durante la chiamata di `g` rimane in memoria come environment associato ad `add_one`
# 2. Quando genero add_two la nuova chiamata di `g` crea un nuovo environment esclusivo per `add_two`

###############################
# 3. environment: parent frame -----------------------------------------------

h1 <- function() {
  a <- runif(5000)
  # a <- runif(500000000)
  
  3
}


h2 <- function() {
  a <- runif(5000)
  # a <- runif(500000000)

  f <- function(variables) {
   a + 1 
  }
  f
}

a <- h()
gc()


# 3. environment: parent frame -----------------------------------------------

g <- function(y) {
  
  message("environment (g function): ")
  print(environment())
  message("parent.frame (g function): ")
  print(parent.frame())
  
  f <- function(x) {
    message("environment (f function): ")
    print(environment())
    message("parent.frame (f function): ")
    print(parent.frame())
    x + y
  }

  f
}

# Now that h() call add_one(), without generating it, its call environment is the parent.frame
h <- function(a) {
  message("environment (h function): ")
  print(environment())
  message("parent.frame  (h function): ")
  print(parent.frame())
  
  add_one(a)
}
h(2)

# Use case:
eval2 <- function(expr) {
  a <- 0
  eval(expr, envir = parent.frame())
}

a <- 2
eval2( a + 2)

# 4. name environment --------------------------------------------------------

environment(add_one)

ls(globalenv())

ls(environment(add_one))

# garbage collector ----------------------------------------------------------

gc()
a <- runif(200000000)
rm(a)
gc()

# garbage collector for call environment -------------------------------------

h1 <- function() {
  # a <- runif(5000)
  a <- runif(200000000)
  
  3
}


h2 <- function() {
  # a <- runif(5000)
  a <- runif(200000000)
  
  f <- function(variables) {
    # in theory you may want to use a, i.e. `a + 1`, 
    # but it is not necessary for the proof of concept
    3 
  }
  f
}

a <- h1()
gc() # release memory immediately
b <- h2()
gc() # not release

rm(b)
gc() # release again


# mutable -----------------------------------------------------------------


# iterator ----------------------------------------------------------------

iterator_gen <- function() {
  counter <- 0
  
  f <- function() {
    counter <<- counter + 1
    counter
  }
}

i1 <- iterator_gen()
i2 <- iterator_gen()

i1()
i2()

i1()
i2()

i1()
i1()

i2()


# Exercises: ---------------------------------------------------------------

# 1. create a function that can reset the counter to 0
reset(c1) # NULL
c1() == 1 # restarts

# 2. What happens when an iterator is copied?
# i3 <- i2
# i3()


# memoization -------------------------------------------------------------

cache <- new.env()
exists(as.character(1), envir = cache)

memory_f <- function(x) {
  key <- as.character(x)
  
  if (!exists(key, envir = cache)) {
    Sys.sleep(2L)
    result <- x + 1000
    assign(key, result, envir = cache)
  }
  
  get(key, envir = cache)
}

memory_f(1)
memory_f(2.2)

# Exercise: can you cache a maximum number of elements?

# memoization -------------------------------------------------------------

f <- function(x, y) {
  Sys.sleep(3)
  x + y
}

f(1,2)


library(memoise)

f_mem <- memoise(f)
f_mem(1,2)


