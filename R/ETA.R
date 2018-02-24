#' ETAGenerate
#'
#' Function to generate a Linear Predictor from a dataset to BFR.
#'
#' @param dataset TidyFormat
#' @param datasetID column with the identifiers.
#' @param Bands Bands
#' @param Wavelengths Wavelenths
#' @param n.basis Number of basis by default only use 1 basis.
#' @param functionalType Basis function, by default is Fourier.Basis also could be Bspline.Basis.
#' @param priorType Prior to assign, by default is 'FIXED', could be 'BRR', 'BayesA', 'BayesB', 'BayesC' or 'BL'
#' @param bandsType Model to apply in bands, by default 'Alternative' will be used, also could be 'Simple', 'Complex'
#'
#' @return
#' @export
#'
#' @examples
ETAGenerate <- function(dataset, functionalType = Fourier.Basis, Bands = NULL, Wavelengths = NULL, priorType = 'FIXED', bandsType = 'Alternative', n.basis = 1, datasetID = 'Line') {
  dataset <- validate.dataset(dataset, datasetID)
  Design <- check(dataset, Bands)
  switch(Design,
         'Single' = {
           ETA <- NULL
         }, 'SingleBands' = {
           ETA <- list(Bands = list(X = bandsModel(bandsType, Bands, Wavelengths, functionalType, n.basis = n.basis), model = priorType))
         }, 'Env' = {
           ETA <- list(Env = list(X = model.matrix(~0+as.factor(dataset$Env)), model = priorType),
                       Line = list(X = model.matrix(~0+as.factor(dataset$Line)), model = priorType),
                       LinexEnv = list(X = model.matrix(~0+as.factor(dataset$Line):as.factor(dataset$Env)), model = priorType))
         }, 'EnvBands' = {
           ETA <- list(Env = list(X = model.matrix(~0+as.factor(dataset$Env)), model = priorType),
                       Line = list(X = model.matrix(~0+as.factor(dataset$Line)), model = priorType),
                       LinexEnv = list(X = model.matrix(~0+as.factor(dataset$Line):as.factor(dataset$Env)), model = priorType),
                       Bands = list(X = bandsModel(bandsType, Bands, Wavelengths, functionalType, n.basis = n.basis), model = priorType),
                       BandsxEnv = list(X = bandsModel(bandsType, Bands, Wavelengths, functionalType, n.basis = n.basis, interaction = dataset$Env), model = priorType))
         }, 'Trait' = {
           ETA <- list(Trait = list(X = model.matrix(~0+as.factor(dataset$Trait)), model = priorType),
                       Line = list(X = model.matrix(~0+as.factor(dataset$Line)), model = priorType),
                       LinexTrait = list(X = model.matrix(~0+as.factor(dataset$Line):as.factor(dataset$Trait)), model = priorType))
         }, 'TraitBands' = {
           ETA <- list(Trait = list(X = model.matrix(~0+as.factor(dataset$Trait)), model = priorType),
                       Line = list(X = model.matrix(~0+as.factor(dataset$Line)), model = priorType),
                       LinexTrait = list(X = model.matrix(~0+as.factor(dataset$Line):as.factor(dataset$Trait)), model = priorType),
                       Bands = list(X = bandsModel(bandsType, Bands, Wavelengths, functionalType, n.basis = n.basis), model = priorType),
                       BandsxTrait = list(X = bandsModel(bandsType, Bands, Wavelengths, functionalType, n.basis = n.basis, interaction = dataset$Trait), model = priorType))
         }, 'Multi' = {
           ETA <- list(Env = list(X = model.matrix(~0+as.factor(dataset$Env)), model = priorType),
                       Trait = list(X = model.matrix(~0+as.factor(dataset$Trait)), model = priorType),
                       Line = list(X = model.matrix(~0+as.factor(dataset$Line)), model = priorType),
                       LinexEnv = list(X = model.matrix(~0+as.factor(dataset$Line):as.factor(dataset$Env)), model = priorType),
                       LinexTrait = list(X = model.matrix(~0+as.factor(dataset$Line):as.factor(dataset$Trait)), model = priorType),
                       EnvxTrait = list(X = model.matrix(~0+as.factor(dataset$Env):as.factor(dataset$Trait)), model = priorType),
                       EnvxTraitxLine = list(X = model.matrix(~0+as.factor(dataset$Env):as.factor(dataset$Trait):as.factor(dataset$Line)), model = priorType))
         }, 'MultiBands' = {
           ETA <- list(Env = list(X = model.matrix(~0+as.factor(dataset$Env)), model = priorType),
                       Trait = list(X = model.matrix(~0+as.factor(dataset$Trait)), model = priorType),
                       Line = list(X = model.matrix(~0+as.factor(dataset$Line)), model = priorType),
                       LinexEnv = list(X = model.matrix(~0+as.factor(dataset$Line):as.factor(dataset$Env)), model = priorType),
                       LinexTrait = list(X = model.matrix(~0+as.factor(dataset$Line):as.factor(dataset$Trait)), model = priorType),
                       EnvxTrait = list(X = model.matrix(~0+as.factor(dataset$Env):as.factor(dataset$Trait)), model = priorType),
                       EnvxTraitxLine = list(X = model.matrix(~0+as.factor(dataset$Env):as.factor(dataset$Trait):as.factor(dataset$Line)), model = priorType),
                       Bands = list(X = bandsModel(bandsType, Bands, Wavelengths, functionalType, n.basis = n.basis), model = priorType),
                       BandsxEnv = list(X = bandsModel(bandsType, Bands, Wavelengths, functionalType, n.basis = n.basis, interaction = dataset$Env), model = priorType),
                       BandsxTrait = list(X = bandsModel(bandsType, Bands, Wavelengths, functionalType, n.basis = n.basis, interaction = dataset$Trait), model = priorType))
         }, stop('Error in dataset or Bands provided')
  )
  out <- list(ETA = ETA, #Linear predictor
              dataset = dataset, #Fixed Dataset
              Design = Design) #Type of model
  class(out) <- 'ETA'
  return(out)
}

validate.dataset <- function(dataset, datasetID) {
  if (is.null(dataset$Env)) {
    dataset$Env <- ''
  }

  if (is.null(dataset$Trait)) {
    dataset$Trait <- ''
  }

  if (is.null(dataset$Response)) {
    stop("No '$Response' provided in dataset")
  }

  try <- tryCatch({
    dataset[, datasetID]
  }, warning = function(w) {
    warning('Warning with the dataset')
  }, error = function(e) {
    stop("No identifier provided in dataset, use datesetID parameter to select the column of identifiers")
  })

  dataset <- dataset[order(dataset$Trait, dataset$Env),]
  return(dataset)
}

check <- function(dataset, Bands = NULL) {
  nEnv <- length(unique(dataset$Env))
  nTrait <- length(unique(dataset$Trait))
  bandsExist <- !is.null(Bands)

  if (nEnv == 1 & nTrait == 1) {
    if (bandsExist) {
      return('SingleBands')
    } else {
      return('Single')
    }
  } else if (nEnv > 1 & nTrait == 1) {
    if (bandsExist) {
      return('EnvBands')
    } else {
      return('Env')
    }
  } else if (nEnv == 1 & nTrait > 1) {
    if (bandsExist) {
      return('TraitBands')
    } else {
      return('Trait')
    }
  } else {
    if (bandsExist) {
      return('MultiBands')
    } else {
      return('Multi')
    }
  }
}

bandsModel <- function(type, Bands, Wavelengths, functionalType, n.basis, period = NULL , ...) {
  switch(type,
         'Simple' = {
           return(functionalType(Bands, Wavelengths, ...))
         }, 'Complex' = {
           if (functionalType == 'Bspline.Basis') {
             Phi <- fda::eval.basis(c(Wavelengths), fda::create.bspline.basis(range(c(Wavelengths)), nbasis = n.basis, breaks = NULL, norder = 4))
           } else {
             Phi <- fda::eval.basis(c(Wavelengths), fda::create.fourier.basis(range(c(Wavelengths)), nbasis = n.basis, period = diff(range(c(Wavelengths)))))
           }
           return(data.matrix(Bands) %*% Phi %*% solve(t(Phi) %*% Phi) %*% t(Phi))
         }, 'Alternative' = {
           if (functionalType == 'Bspline.Basis') {
             Phi <- fda::eval.basis(c(Wavelengths), fda::create.bspline.basis(range(c(Wavelengths)), nbasis = n.basis, breaks = NULL, norder = 4))
           } else {
             Phi <- fda::eval.basis(c(Wavelengths), fda::create.fourier.basis(range(c(Wavelengths)), nbasis = n.basis, period = diff(range(c(Wavelengths)))))
           }
           return(data.matrix(Bands) %*% Phi)
         },
         stop('Error: bandsType ', type, ' no exist.')
  )
}