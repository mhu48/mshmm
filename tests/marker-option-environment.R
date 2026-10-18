library(mshmm)

# Distribution options in a marker formula must be evaluated in the formula's
# environment.  Keeping offdens local makes the pre-fix failure deterministic.
local({
    statedata <- data.frame(state = c("CU", "MCI", "dementia", "death"))
    offdens <- matrix(
        c(1, 1, 0, 0, 0, 0, 1, 0), 4, 2,
        dimnames = list(statedata$state, c("ND", "dementia"))
    )
    marker <- state:offdx ~ 0 / discrete(init = offdens)
    p1 <- mshmm:::parsemarker1(marker, statedata)
    p2 <- mshmm:::parsemarker2(
        p1, statedata, terms(~ 1), "(Intercept)", 0L,
        list(c("ND", "dementia"))
    )
    observed <- p2$response[[1]]$rfun(
        factor(c("ND", "dementia"), levels = c("ND", "dementia"))
    )
    stopifnot(isTRUE(all.equal(unname(observed), unname(offdens))))
})
