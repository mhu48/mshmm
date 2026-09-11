\name{dementia}
\alias{dementia}
\docType{data}
\title{
Cognitive change over time.
}
\description{
  This is a constructed data set based on a subset of subjects
  from the Mayo Clinic Study of Aging.  It replicates many important
  aspects of that data such as age distribution, covariate distrbutions
  and correlations, and number of visits (some patients with few, some
  with many).
  }
\usage{data("dementia")}
\format{
  A data frame with 32822 observations on 4500 subjects,
  with the following variables.
  \describe{
    \item{\code{ptnum}}{patient identifier of 1, 2, \ldots}
    \item{\code{age}}{age at this observation}
    \item{\code{years}}{years since enrollment}
    \item{\code{male}}{0= female, 1= male}
    \item{\code{educ}}{years of education, less than 8 coded as 8}
    \item{\code{any.e4}}{1= one or more \eqn{\epsilon}{e}4 alleles in the
      apolipoprotein E (APOE) gene, 0= no \eqn{\epsilone}{e}4 alleles}
    \item{\code{cmc}}{cardiovascular and metabolic conditions (CMC)
      score, the sum of seven conditions proposed by the US Department of
      Heath and Human services as indicators of vacular health:
      hypertension, hyperlipidemia, cardiac arrhythmias, coronary artery
      disease, congestive heart failure, diabetes mellitus, and stroke}
     \item{\code{dx}}{diagnosis at this visit, a factor with levels of
       alive, CU (cogitively unimpaired), MCI (mild cognitive
       impairment), dementia, nondem (not demented), off-dem (dementia
       diagnosed off study) and death.}
     \item{\code{centiloid}}{PET measurment of amyloid level in the brain using
       Pittsburgh compound B (PiB), expressed in centiloid units}
     \item{\code{cogm}}{a z-scored composite of a set of cognitive
       tests targeted at memory}
     \item{\code{cogl}}{a z-scored composite of a set of cognitive
       tests targeted at language}
     \item{\code{cogv}}{a z-scored composite of a set of cognitive
       tests of visual-spatial processing}
     \item{\code{coga}}{a z-scored composite of a set of cognitive
       tests targeted at attention (or executive function)}
     \item{\code{p.tau181}}{assay value of phosphorolated tau-181}
     \item{\code{cogzm}}{a z-scored composite of a set of cognitive
       tests targeted at memory}
     \item{\code{cogzm}}{a z-scored composite of a set of cognitive
       tests targeted at language}
     \item{\code{cogzm}}{a z-scored composite of a set of cognitive
       tests of visual-spatial processing}
     \item{\code{ab42.40}}{an assay of the Abeta protien 42 to Abeta 40
       ratio}
     \item{\code{ptau181}}{an early assay of phosphorylated tau 181}
     \item{\code{ptau217a}}{an early assay of phosphorylated tau 217}
     \item{\code{ptau217b}}{an early assay of phosphorylated tau 217}
  }
}
\details{
The data set is modeled on a subset of the MCSA data used in Jack (2022).
As best possible, it represents a similar pattern of visit frequencies
and intervals between visits, marginal distirbutions of covariates, and
patterns of correlation.  The primary purpose is for the illustration
and exploration of statistical methods on a rich data set of this
nature. It does not reproduce the results in the reference (though they
are similar) and most certainly should be used as a basis for clinical
decision making or practice.

The Mayo Clinic study of aging is based on an age and sex stratified
random sample of subjects from Olmsted County, Minnesota.
Enrolled subjects are scheduled for return visits every 15 months.
This subset was based on those who were enrolled at age 50 or greater,
not demented at enrollment, who had at least one post-enrollment visit.
Patients who have not been assessed for 36 months, and are not yet demented,
are marked for passive assessment through their medical record; i.e., a
review for, among other things, a dementia diagnosis at any physician visit.
This further followup was available on all
subjects through the infrastructure provided by the Rochester
Epidemiology project; thus with respect to the death and dementia endpoints
informative censoring is not an issue.
A medical record review can ascertain the presence of dementia at an
office visit, but cognitively unimpaired (CU) vs. mild cognitive impairment
(MCI) cannot be distinguished.

Participation in the imaging portion of the study (MRI, amyloid PET,
tau PET, optional FDG PET) requires a second patient visit of
2-3 days, partly as a consequence of this less than half the MCSA
subjects chose to partcicpate in the imaging portion of the study.
A small further number are excluded due to technical issues, e.g., a
metallic implant.
Cumulative radiation exposure limits the total number of PET scans;
for this reason subjects with no current evidence of amyloid accumulation
were sometimes scheduled for rescan at every other study visit rather than
at each return.
Since the PiB ligand did not become available until year 6 of the study
a subset of those who elected to participate in imaging will be missing
PET for their first visits.
For further details see Jack (2022) and the references therein.

The \code{dx} variable is a composite: for an on study visit the
diagnosis will be one of CU, MCI or dementia, an off study visit will be
either nondemented or demented (nondem or off-dem), and simple status is
recorded as either alive or dead.
Formally, these could be instead be represented
as three covariates corresponding to a study visit, an off-study office
visit where dementia can be ascertained, and simple alive/dead
information, e.g., a death record, vaccination visit, patient
correspondence, etc.
In analysis this separation into multiple variables will sometimes be necessary.

The data set is laid out in \emph{timeline} form.
Each row of data contains the subject identifier, a time, and covariate values
that were measured at that time point, with missing values for those that
were not. Rows where diagnosis= death, for
instance, will normally be missing all the continuous variables.
The exception is fixed covariates
such as sex and APOE genetic status, which are copied forward across all
data rows. (Although the variable will not have been formally re-measured
at each visit its value at that time is nevertheless known.)
The seven carido-metabolic conditions were coded as
"any history of" and thus the CMC count can only increase.

The blood values for amyloid are sparse (phosphorolated tau and abeta);
the assays were new and in early validation, so only a limited number of
the stored plasma samples, a precious resource, were committed.  (The two
p-tau217 assays are two different vendors, and both have since been
replaced by newer iterations.) 
}
\references{
 Clifford R. Jack Jr., Terry M. Therneau, et.al (2022).
    Long-term associations between amyloid positron emission tomography,
         sex, apolipoprotein E and incident dementia and mortality among 
         individuals without dementia: hazard ratios and absolute risk,
    Brain Communications, doi:10.1093/braincomms/fcac017
}
\examples{
table(table(dementia$ptnum))  # number of rows per subject
id1 <- duplicated(dementia$ptnum, fromLast=TRUE)
id2 <- duplicated(dementia$ptnum)
table(from= dementia$dx[id1], to= dementia$dx[id2]) #observed transitions
}
\keyword{datasets}
