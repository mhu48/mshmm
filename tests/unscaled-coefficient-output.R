library(mshmm)

# Added when the preserved September repair was committed to Git.  It guards
# the September fix that replaces starting values with optimized coefficients
# when centering and scaling are both disabled.
ddata <- data.frame(
    id=c(1, 1, 2, 2, 3, 3),
    time=c(0, 1, 0, 2, 0, 3),
    state=c(1, 2, 1, 3, 1, 0)
)
ddata$state <- factor(ddata$state, 0:3,
                      c("censor", "entry", "recur", "death"))
states <- c("entry", "recur", "death")
qmat <- rbind(c(0, 1, 1), c(0, 0, 1), c(0, 0, 0))
dimnames(qmat) <- list(states, states)
icoef <- matrix(
    log(c(.1, .2, .3)), nrow=1L,
    dimnames=list("(Intercept)", c("1:2", "1:3", "2:3"))
)

fit <- cmsh(
    Surv(time, state) ~ 1, data=ddata, id=id,
    qmatrix=qmat, init=icoef, iter=5, mc.cores=1,
    control=mshmm:::cmsh.control(center=FALSE, scale=FALSE)
)
internal <- fit$fit$coef
stopifnot(length(internal) == length(fit$coefficients))
stopifnot(max(abs(unname(fit$coefficients) - unname(internal))) < 1e-8)
