#! /usr/bin/env Rscript

library(randomForest)

# Determine location of tempdir
args <- commandArgs(trailingOnly = TRUE)
tempDir <- args[2]

# Load and prepare input
x <- as.matrix(read.table(file.path(tempDir, 'xData.tsv'), header=FALSE, sep="\t"))
y <- as.matrix(read.table(file.path(tempDir, 'yData.tsv'), header=FALSE, sep="\t"))
y <- as.factor(y)

# Run random forest
forestObj <- randomForest(x=x, y=y)

### Write forest fields
##  [1] "call"            "classes"         "confusion"       "err.rate"       
##  [5] "forest"          "importance"      "importanceSD"    "inbag"          
##  [9] "localImportance" "mtry"            "ntree"           "oob.times"      
## [13] "predicted"       "proximity"       "test"            "type"           
## [17] "votes"           "y"    #

write.table(forestObj$classes,    file.path(tempDir, 'classes.tsv'),    row.names=FALSE, col.names=FALSE, sep='\t')
write.table(forestObj$confusion,  file.path(tempDir, 'confusion.tsv'),  row.names=FALSE, col.names=FALSE, sep='\t')
write.table(forestObj$err.rate,   file.path(tempDir, 'err_rate.tsv'),   row.names=FALSE, col.names=FALSE, sep='\t')
write.table(forestObj$importance, file.path(tempDir, 'importance.tsv'), row.names=FALSE, col.names=FALSE, sep='\t')
write.table(forestObj$oob.times,  file.path(tempDir, 'oob_times.tsv'),  row.names=FALSE, col.names=FALSE, sep='\t')
write.table(forestObj$predicted,  file.path(tempDir, 'predicted.tsv'),  row.names=FALSE, col.names=FALSE, sep='\t')
write.table(forestObj$votes,      file.path(tempDir, 'votes.tsv'),      row.names=FALSE, col.names=FALSE, sep='\t')
write.table(forestObj$y,          file.path(tempDir, 'y.tsv'),          row.names=FALSE, col.names=FALSE, sep='\t')

### Write forest field fields
## [1] "bestvar"    "cutoff"     "maxcat"     "ncat"       "nclass"     "ndbigtree"  "nodepred"   "nodestatus"
## [9] "nrnodes"    "ntree"      "pid"        "treemap"    "xbestsplit" "xlevels"

forest <- forestObj$forest

write.table(forest$bestvar,    file.path(tempDir, 'forest_bestvar.tsv'),    row.names=FALSE, col.names=FALSE, sep='\t')
write.table(forest$cutoff,     file.path(tempDir, 'forest_cutoff.tsv'),     row.names=FALSE, col.names=FALSE, sep='\t')
write.table(forest$ndbigtree,  file.path(tempDir, 'forest_ndbigtree.tsv'),  row.names=FALSE, col.names=FALSE, sep='\t')
write.table(forest$nodepred,   file.path(tempDir, 'forest_nodepred.tsv'),   row.names=FALSE, col.names=FALSE, sep='\t')
write.table(forest$nodestatus, file.path(tempDir, 'forest_nodestatus.tsv'), row.names=FALSE, col.names=FALSE, sep='\t')
write.table(forest$nodepred,   file.path(tempDir, 'forest_nodepred.tsv'),   row.names=FALSE, col.names=FALSE, sep='\t')
write.table(forest$pid,        file.path(tempDir, 'forest_pid.tsv'),        row.names=FALSE, col.names=FALSE, sep='\t')
write.table(forest$treemap,    file.path(tempDir, 'forest_treemap.tsv'),    row.names=FALSE, col.names=FALSE, sep='\t')
write.table(forest$xbestsplit, file.path(tempDir, 'forest_xbestsplit.tsv'), row.names=FALSE, col.names=FALSE, sep='\t')
write.table(forest$ncat,       file.path(tempDir, 'forest_ncat.tsv'),       row.names=FALSE, col.names=FALSE, sep='\t')

## Write metadata: mtry, ntree, type
#	ncat, nclass, nrnodes, ntree
metadata <- list(mtry=forestObj$mtry, ntree=forestObj$ntree, type=forestObj$type, 
				 nclass=forest$nclass, nrnodes=forest$nrnodes)
write.table(metadata, file.path(tempDir, 'metadata.tsv'), sep='\t', row.names=FALSE)

## Skipped variables: inbag, localimportance, importanceSD, oob.predicted, proximity, test
