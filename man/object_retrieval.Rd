% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/object_retrieval.R
\name{object_retrieval}
\alias{object_retrieval}
\title{ScienceDirect Object Retrieval}
\usage{
object_retrieval(id, identifier = c("scopus_id", "eid", "doi", "pii",
  "pubmed_id"), ref = NULL, http_end = NULL, ...)
}
\arguments{
\item{id}{Identifier for object}

\item{identifier}{Type of identifier to use}

\item{ref}{document reference}

\item{http_end}{any additional end to http statement.
See \code{\link{generic_elsevier_api}}}

\item{...}{Arguments to be passed to \code{\link{generic_elsevier_api}}}
}
\value{
List of elements, similar to \code{\link{generic_elsevier_api}}
}
\description{
This function wraps \code{\link{generic_elsevier_api}} to give a
retrieval of an object from the Elsevier Object Retrieval API
}
\examples{
api_key = get_api_key(NULL, error = FALSE)
if (!is.null(api_key)){
   x = object_retrieval("S1053811915002700", identifier = "pii",
   verbose = FALSE)
   if (requireNamespace("xml2") & requireNamespace("httr") &
   requireNamespace("rvest")
   ){
       refs = httr::content(x$get_statement)
       refs = refs$choices
       df = t(sapply(refs$choice, c))
       cn = colnames(df)
       cn[ grep("ref", cn)] = "ref"
       cn[ grep("type", cn)] = "type"
       cn[cn =="$"] = "text"
       colnames(df) = cn
       df = as.data.frame(df, stringsAsFactors = FALSE)
       df = df[ grepl("image/jpeg", df$text),,drop = FALSE ]
       df = df[ df$type \%in\% "IMAGE-HIGH-RES",,drop = FALSE ]
       #r = httr::GET(url = df$text[1],
       #        query = list("apiKey" = api_key))
       query = paste0("apiKey=", api_key)
       r = httr::GET(paste0(df$text[1], "&", query))
       img = httr::content(r)
       dims = dim(img)[1:2]
       mdim = max(dims)
       graphics::plot(c(0, ncol(img)), c(0, nrow(img)), type='n')
       graphics::rasterImage(img, 1, 1, ncol(img), nrow(img))
   }
 obj = object_retrieval('S1053811915002700', "pii", verbose = FALSE)
}
}
\seealso{
\code{\link{generic_elsevier_api}}
}
