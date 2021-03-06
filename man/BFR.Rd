% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/BFR.R
\name{BFR}
\alias{BFR}
\title{BFR}
\usage{
BFR(data = NULL, datasetID = "Line", Multivariate = "Traditional",
  a = NULL, b = NULL, ETA = NULL, nIter = 1500, burnIn = 500,
  thin = 5, saveAt = "", S0 = NULL, df0 = 5, R2 = 0.5,
  weights = NULL, verbose = TRUE, rmExistingFiles = TRUE, groups = NULL,
  CrossValidation = NULL, set_seed = NULL, dec = 4)
}
\arguments{
\item{data}{(\code{data.frame}) the data with the $n$ $Response, also needs $Line and $Env for Cross Validation defined on it (NAs allowed).}

\item{datasetID}{(\code{string}) The name of the column with the identifiers of each line.}

\item{Multivariate}{By default, when de dataset includes more than one Environment and more than one Trait (MTME) the solution is adjusted by the method traditional, also is possible adjust the MTME by "SVD" <doi: >}

\item{a}{(\code{numeric}, $n$) Only requiered for censored outcomes. It's a vector specifying lower bounds for censored observation. By default is null.}

\item{b}{(\code{numeric}, $n$) Only requiered for censored outcomes. It's a vector specifying upper bounds for censored observation. By default is null.}

\item{ETA}{(\code{list}) Two level list used to specify the regression function, also could be generate by ETAGenerate() function for easy-use.}

\item{nIter}{(\code{integer}) The number of iterations.}

\item{burnIn}{(\code{integer}) The number of burn-in.}

\item{thin}{(\code{integer}) The number of thinning.}

\item{saveAt}{(\code{character}) This may include a path and a pre-fix that will be added to the name of the files that are saved as the program runs.}

\item{S0}{(\code{numeric}) The scale parameter for the scaled inverse-chi squared prior assigned to the residual variance, only used with Gaussian outcomes.}

\item{df0}{(\code{numeric}) The scale parameter for the scaled inverse-chi squared prior assigned to the residual variance, only used with Gaussian outcomes.}

\item{R2}{(\code{numeric},$0<R2<1$) The proportion of variance that one expects, a priori, to be explained by the regression. Only used if the hyper-parameters are not specified.}

\item{weights}{(\code{numeric}, $n$) a vector of weights, may be NULL. The residual variance of each data-point is set to be proportional to the inverse of the squared-weight. Only used with Gaussian outcomes.}

\item{verbose}{(\code{logical}) By default is \code{TRUE} and shows a fitting model progress bar if Folds <=1 or cross validation progress bar if Folds > 2.}

\item{rmExistingFiles}{(\code{logical}) By default is \code{TRUE} and removes existing output files from previous runs.}

\item{groups}{(\code{factor}) A vector of the same lenght of \code{data$Response} that associates observations with groups, each group will have an associated variance component for the error term.}

\item{CrossValidation}{(\code{list}) Especified list to KFold Crossvalidation use list(Type = 'KFold', nFolds = 5), and to Random Partiton Cross validation use list(Type = 'RandomPartition', nPartitions = 5, pTesting = 0.20, Traits.testing = NULL)}

\item{set_seed}{(\code{integer}) A seed for replicable research.}

\item{dec}{(\code{integer}) Number of decimals to show on the predictions.}
}
\description{
Bayesian Functional Regression
}
\details{
More details about this function
}
