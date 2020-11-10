##################### FUNCTION TO PERFORM PRS-PCA ###########################
# Coombes, B., Ploner, A., Bergen, S., Biernacka, J. (2020). A principal component approach to improve association testing with polygenic risk scores Genetic Epidemiology https://dx.doi.org/10.1002/gepi.22339

# INPUTS:
# dat = n x (p+1) dataframe of PRSs under different settings with first column as ID
# x = label for PRS (typically named for phenotype (i.e. MDD))
# OUTPUTS:
# list of 
#  - data = dataframe with cols (ID , PRS-PCA1 , PRS-PCA2)
#  - r2 = variance explained by each PC of the PRS matrix
#  - loadings = the PC-loadings used to create PRS-PCA1

prs.pc <- function(dat){
  xo <- scale(as.matrix(dat[,c(-1,-2)]))  ## scale cols of matrix of only PRSs (remove FID, IID, assuming they are first two cols)
  message("\nGenerating PRS-PCA from the following Pt: ", paste0(colnames(xo), sep = ", "),"\n")
  g <- prcomp(xo)   ## perform principal components
  pca.r2 <- g$sdev^2/sum(g$sdev^2)    ## calculate variance explained by each PC
  pc1.loadings <- g$rotation[,1];     ## loadings for PC1
  pc2.loadings <- g$rotation[,2]      ## loadings for PC2
  ## flip direction of PCs to keep direction of association
  ## (sign of loadings for PC1 is arbitrary so we want to keep same direction)
  if (mean(pc1.loadings>0)==0){     
    pc1.loadings <- pc1.loadings*(-1) 
    pc2.loadings <- pc2.loadings*(-1)
  }
  ## calculate PRS-PCA (outputs PC1 and PC2 even though PC1 sufficient)
  pc1 <- xo %*% pc1.loadings
  pc2 <- xo %*% pc2.loadings
  out <- dat[,c(1,2)]
  out[,"prs.pc1"] <- scale(pc1)   ## rescales PRS-PCA1 
  out[,"prs.pc2"] <- scale(pc2)  ## rescales PRS-PCA2
  return(list(data=out,r2=pca.r2,loadings=pc1.loadings))
}
