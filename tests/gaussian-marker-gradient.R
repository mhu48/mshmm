library(mshmm)

# A multiprocess state space repeats each Gaussian peak across several joint
# states.  Check the response-level gradient with multiple observations and a
# death state (map 0) before exercising the full HMM score below.
repeated_stateinfo <- list(
    levels=c("A0", "A1"), index=c(1L, 2L, 1L, 2L, 1L, 2L, 0L), sname="A"
)
repeated_response <- mshmm:::gaussian(repeated_stateinfo, mlevel=NULL)
repeated_y <- c(.4, -.7)
repeated_eta <- rbind(
    c(-.5, log(.8), 1.2, log(1.1)),
    c(-.3, log(.9), 1.0, log(1.2))
)
repeated_prob <- repeated_response$rfun(
    repeated_y, repeated_eta, gradient=TRUE
)
repeated_grad <- attr(repeated_prob, "gradient")
eps <- 1e-6
for (j in seq_len(ncol(repeated_eta))) {
    upper <- lower <- repeated_eta
    upper[, j] <- upper[, j] + eps
    lower[, j] <- lower[, j] - eps
    numeric_grad <- (
        repeated_response$rfun(repeated_y, upper) -
        repeated_response$rfun(repeated_y, lower)
    ) / (2 * eps)
    stopifnot(isTRUE(all.equal(
        repeated_grad[, , j], numeric_grad,
        tolerance=1e-6, check.attributes=FALSE
    )))
}

# The Gaussian response gradient is indexed by state, observation, and marker
# linear predictor.  Exercise the full hmm2 marker update and compare its score
# with finite differences of hmm1 for a one-observation latent-state model.
stateinfo <- list(levels=c("A0", "A1"), index=1:2, sname="A")
response <- mshmm:::gaussian(stateinfo, mlevel=NULL)
response$e2map <- 1:4

test_env <- new.env(parent=asNamespace("mshmm"))
test_env$control <- list(debug=0, smallpos=1e-10)
test_env$id <- 1L
test_env$X <- matrix(1, nrow=1, ncol=1)
test_env$nparm <- c(0L, 4L, 0L)
test_env$nlp <- c(0L, 4L, 0L)
test_env$nstate <- 2L
test_env$iprob <- matrix(c(.65, .35), nrow=1)
test_env$p0fixed <- NULL
test_env$nmarker <- 1L
test_env$otype <- 3L
test_env$ymarker <- matrix(.4, nrow=1)
test_env$rlist <- list(response)
test_env$eta.beta2 <- function(x) diag(4)
test_env$qmatrix <- matrix(0L, 2, 2)
test_env$exactabsorb <- integer(0)

hmm1_test <- mshmm:::hmm1
hmm2_test <- mshmm:::hmm2
environment(hmm1_test) <- test_env
environment(hmm2_test) <- test_env

B <- matrix(c(-.5, log(.8), 1.2, log(1.1)), nrow=1)
analytic <- hmm2_test(1L, B)
analytic_score <- rowSums(analytic$deriv) / sum(analytic$alpha)

eps <- 1e-6
numeric_score <- vapply(seq_len(ncol(B)), function(j) {
    upper <- lower <- B
    upper[1, j] <- upper[1, j] + eps
    lower[1, j] <- lower[1, j] - eps
    (hmm1_test(1L, upper) - hmm1_test(1L, lower))/(2 * eps)
}, numeric(1))

stopifnot(isTRUE(all.equal(analytic_score, numeric_score,
                           tolerance=1e-6, check.attributes=FALSE)))

# Repeat the score check for the seven-state product construction used by the
# dementia analysis.  Three living states share each of the two amyloid peaks,
# and marker information is propagated across multiple visits and transitions.
product_stateinfo <- list(
    levels=c("A0", "A1"),
    index=c(1L, 2L, 1L, 2L, 1L, 2L, 0L),
    sname="A"
)
product_response <- mshmm:::gaussian(product_stateinfo, mlevel=NULL)
product_response$e2map <- 1:4
product_q <- matrix(0L, 7L, 7L)
product_q[cbind(c(1L, 3L, 5L), c(2L, 4L, 6L))] <- 1L
product_q[cbind(c(1L, 2L, 3L, 4L), c(3L, 4L, 5L, 6L))] <- 1L
product_q[cbind(1:6, rep(7L, 6L))] <- 1L
product_q[product_q > 0] <- seq_len(sum(product_q > 0))
nq <- sum(product_q > 0)

product_env <- new.env(parent=asNamespace("mshmm"))
product_env$control <- list(debug=0, smallpos=1e-10)
product_env$id <- rep(1L, 3L)
product_env$X <- matrix(1, 3L, 1L)
product_env$dtime <- c(1.25, .8)
product_env$nparm <- c(nq, 4L, 0L)
product_env$nlp <- c(nq, 4L, 0L)
product_env$nstate <- 7L
product_env$iprob <- matrix(c(.74, .06, .13, .03, .03, .01, 0), 1L)
product_env$p0fixed <- NULL
product_env$nmarker <- 1L
product_env$otype <- rep(3L, 3L)
product_env$ystate <- integer(3L)
product_env$ymarker <- matrix(c(-.6, .1, .9), 3L, 1L)
product_env$rlist <- list(product_response)
product_env$eta.beta1 <- function(x) diag(nq)
product_env$eta.beta2 <- function(x) diag(4L)
product_env$qmatrix <- product_q
product_env$exactabsorb <- 7L
product_env$e1 <- seq_len(nq)
product_env$e3 <- integer()

product_hmm1 <- mshmm:::hmm1
product_hmm2 <- mshmm:::hmm2
environment(product_hmm1) <- product_env
environment(product_hmm2) <- product_env
product_B <- matrix(
    c(log(seq(.015, .075, length.out=nq)),
      -.5, log(.8), 1.0, log(1.1)),
    nrow=1L
)
product_analytic <- product_hmm2(1L, product_B)
product_score <- rowSums(product_analytic$deriv) /
    sum(product_analytic$alpha)
product_numeric <- vapply(seq_along(product_B), function(j) {
    upper <- lower <- product_B
    upper[j] <- upper[j] + eps
    lower[j] <- lower[j] - eps
    (product_hmm1(1L, upper) - product_hmm1(1L, lower)) / (2 * eps)
}, numeric(1))
stopifnot(isTRUE(all.equal(
    product_score, product_numeric,
    tolerance=2e-5, check.attributes=FALSE
)))

# A marker-free alive/censored row rules out an exact absorbing death state.
# The forward score must remove marker-parameter derivatives carried on that
# now-impossible death path, just as it removes probability and rate-score
# mass.  This pattern occurs at administrative/off-study rows in dementia.
censor_env <- new.env(parent=asNamespace("mshmm"))
for (object in ls(product_env, all.names=TRUE)) {
    assign(object, get(object, envir=product_env), envir=censor_env)
}
censor_env$id <- rep(1L, 2L)
censor_env$X <- matrix(1, 2L, 1L)
censor_env$dtime <- 1.25
censor_env$otype <- c(3L, 0L)
censor_env$ystate <- integer(2L)
censor_env$ymarker <- matrix(c(-.6, NA_real_), 2L, 1L)

censor_hmm1 <- mshmm:::hmm1
censor_hmm2 <- mshmm:::hmm2
environment(censor_hmm1) <- censor_env
environment(censor_hmm2) <- censor_env
censor_analytic <- censor_hmm2(1L, product_B)
censor_score <- rowSums(censor_analytic$deriv) /
    sum(censor_analytic$alpha)
censor_numeric <- vapply(seq_along(product_B), function(j) {
    upper <- lower <- product_B
    upper[j] <- upper[j] + eps
    lower[j] <- lower[j] - eps
    (censor_hmm1(1L, upper) - censor_hmm1(1L, lower)) / (2 * eps)
}, numeric(1))
stopifnot(isTRUE(all.equal(
    censor_score, censor_numeric,
    tolerance=2e-5, check.attributes=FALSE
)))
