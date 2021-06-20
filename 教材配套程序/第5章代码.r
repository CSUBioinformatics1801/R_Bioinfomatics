#######################
## ��װ������Ҫ��R�� ##
#######################
rm(list = ls())
setwd("c:\\workingdirectory")
#��5-0
#��װ������Bioconductor
source('http://Bioconductor.org/biocLite.R');
biocLite() 
#�Ѱ�װ��R��
pkgs <- rownames(installed.packages())
#��������Ҫ��R��
packages_1=c("Biobase","CLL","simpleaffy", "affyPLM", "RColorBrewer","affy",
             "gcrma","graph", "GenomicRanges","affycoretools","limma","annotate",
             "hgu95av2.db","GOstats","GeneAnswers","pheatmap","Rgraphviz","GEOquery")
#��Ҫ��װ��R��
packages_2=setdiff(packages_1,pkgs) 
#��װ����R��
biocLite(packages_2) ;

#############
##  ��5-1  ##
#############
#��������R��
#CLL�����Զ�����affy����affy�����к�����Ҫ��rma()����
library (CLL); 
#�������ݣ�CLL���и�����ʾ�����ݼ���
data (CLLbatch) ; 
#�� ��RMA�㷨��������Ԥ�������5.3.3��
CLLrma <- rma(CLLbatch) ; 
#��ȡԤ�����������Ʒ�Ļ���ʵ������̽���飩���ֵ
e <- exprs(CLLrma); 
#�� �� ��������
e[1:5, 1:5]  

#############
##  ��5-2  ##
#############
#��������R��, ǰ���Ѱ�װ
library (CLL); 
#�������ݣ�CLL���и�����ʾ�����ݼ���
data (CLLbatch) ; 
#�鿴 �� �����ͣ����������ʾ
data.class (CLLbatch) ; 
#����������Ʒ��״̬��Ϣ
data(disease); 
#�鿴������Ʒ��״̬��Ϣ
disease; 
#�鿴"AffyBatch"����ϸ����
help (AffyBatch) ; 

#############
##  ��5-3  ##
#############
#�鿴��һ��оƬ�ĻҶ�ͼ��
image(CLLbatch[, 1]);

#############
##  ��5-4  ##
#############
#��������R��
library(simpleaffy);
library (CLL); 
data (CLLbatch) ; 
#�� ȡ �� �� �� �� �� ��
Data.qc <- qc(CLLbatch);
#ͼ �� �� �� ʾ �� �� 
plot(Data.qc);  

#############
##  ��5-5  ##
#############
#��������R��
library (affyPLM);
library (CLL); 
#�������ݣ�CLL���и�����ʾ�����ݼ���
data (CLLbatch);
#�����ݼ����ع���㣬�����һ��"PLMset"���͵Ķ���
Pset<- fitPLM(CLLbatch);
#����һ��оƬ���ݵ�ԭʼͼ
image(CLLbatch[, 1]);
#���ݼ���������Ȩ��ͼ
image(Pset, type = "weights", which = 1, main = "Weights");
#���ݼ����������в�ͼ
image(Pset, type = "resids", which = 1, main = "Residuals");
#���ݼ����������в����ͼ
image(Pset, type = "sign.resids", which = 1, main = "Residuals.sign");

#############
##  ��5-6  ##
#############
#��������R����RColorBrewer ����������Ԥ�����ɫ��
library(affyPLM);
library(RColorBrewer) ;
library (CLL); 
#�������ݣ�CLL���и�����ʾ�����ݼ���
data (CLLbatch);
#�����ݼ����ع���㣬�����һ��"PLMset"���͵Ķ���
Pset <-fitPLM(CLLbatch);
#����һ����ɫ
colors <- brewer.pal(12, "Set3");
#�� ��RLE�� �� ͼ
Mbox(Pset, ylim = c(-1, 1), col = colors, main = "RLE", las = 3) ;
# �� ��NUSE���� ͼ
boxplot(Pset, ylim = c(0.95, 1.22), col = colors, main = "NUSE", las = 3) ;

#############
##  ��5-7  ##
#############
#��������R��
library(affy);
library(RColorBrewer);
library (CLL); 
#�������ݣ�CLL���и�����ʾ�����ݼ���
data (CLLbatch);
#�� ȡ �� �� �� ��
data.deg <- AffyRNAdeg(CLLbatch); 
#����һ����ɫ
colors <- brewer.pal(12, "Set3");
#�� ��RNA�� �� ͼ
plotAffyRNAdeg(data.deg, col = colors) ; 
#�����ϲ�λ�� ע ͼ ע
legend("topleft", rownames(pData(CLLbatch)), col = colors, lwd = 1, inset = 0.05, cex = 0.5);
#��CLL���ݼ���ȥ����ƷCLL1, CLL10�� CLL13
CLLbatch <- CLLbatch[, -match(c("CLL10.CEL", "CLL1.CEL", "CLL13.CEL"), sampleNames(CLLbatch))];

#############
##  ��5-8  ##
#############
#��������R��
library (CLL); 
library (gcrma); 
library (graph); 
library(affycoretools);
#�������ݣ�CLL���и�����ʾ�����ݼ���
data (CLLbatch);
data (disease);
#ʹ ��gcrma�㷨��Ԥ��������
CLLgcrma <- gcrma(CLLbatch) ; 
#��ȡ���������
eset <- exprs(CLLgcrma) ;  
#������Ʒ����֮���Pearson���ϵ��
pearson_cor <- cor(eset) ; 
#�õ�Pearson����������Ǿ���
dist.lower <- as.dist(1 - pearson_cor) ;  
#������� 
hc <- hclust(dist.lower, "ave") ; 
#���ݾ�������ͼ 
plot(hc) ; 

#PCA����
samplenames <- sub(pattern="\\.CEL", replacement="",colnames(eset))
groups <- factor(disease[,2])
plotPCA(eset,addtext=samplenames,groups=groups,groupnames=levels(groups))


#############
##  ��5-9  ##
#############
#��������R��
library(affy);
library (CLL); 
data (CLLbatch) ; 
eset.mas <- expresso(CLLbatch,  bgcorrect.method="mas",  normalize.method="constant",   pmcorrect.method="mas", summary.method="mas");
bgcorrect.methods();
normalize.methods(CLLbatch);
pmcorrect.methods();
express.summary.stat.methods();

#############
## ��5-10  ##
#############
#��������R��
library(affy);
library (CLL); 
data(CLLbatch); 
#ʹ��mas����������У��
CLLmas5 <- bg.correct(CLLbatch, method="mas");  
#ʹ��constant������׼��
data_mas5 <- normalize(CLLmas5, method = "constant");
#�鿴ÿ����Ʒ�����ű���
head(pm(data_mas5)/pm(CLLmas5), 5);
#�鿴�ڶ�����Ʒ�����ű�������ô��������
mean(intensity(CLLmas5)[,1])/mean(intensity(CLLmas5)[,2]);

#############
## ��5-11  ##
#############
#��������R��
library(affy);
library (gcrma); 
library(affyPLM) ;
library(RColorBrewer);
library (CLL); 
data (CLLbatch) ; 
colors <- brewer.pal(12, "Set3");
#ʹ��MAS5�� �� �� Ԥ �� �� �� ��
CLLmas5 <- mas5(CLLbatch) ;  
#ʹ ��rma�� �� �� Ԥ �� �� �� ��
CLLrma <- rma(CLLbatch) ; 
##ʹ��gcrma�� �� �� Ԥ �� �� �� ��
CLLgcrma <- gcrma(CLLbatch) ;  
#ֱ �� ͼ
hist(CLLbatch, main = "original", col = colors) ;
legend("topright", rownames(pData(CLLbatch)), col = colors, lwd = 1, inset = 0.05, cex = 0.5, ncol = 3) ;
hist(CLLmas5, main = "MAS 5.0", xlim = c(-150, 2^10), col = colors) ;
hist(CLLrma, main = "RMA", col = colors) ;
hist(CLLgcrma, main = "gcRMA", col = colors) ;
#�� �� ͼ
boxplot(CLLbatch, col = colors, las = 3, main = "original") ;
boxplot(CLLmas5, col = colors,las = 3, ylim=c(0, 1000), main = "MAS 5.0") ;
boxplot(CLLrma, col = colors, las = 3, main = "RMA") ;
boxplot(CLLgcrma, col = colors, las = 3, main = "gcRMA");


#############
## ��5-12  ##
#############
#��������R��
library (gcrma); 
library(RColorBrewer);
library (CLL); 
library (affy); 
data (CLLbatch) ; 
colors <- brewer.pal(12, "Set3");
#ʹ ��gcrma�� �� �� Ԥ �� �� �� ��
CLLgcrma <- gcrma(CLLbatch);  
MAplot(CLLbatch[, 1:4], pairs = TRUE, plot.method = "smoothScatter", cex = 0.8, main = "original MA plot");
MAplot(CLLgcrma[, 1:4], pairs = TRUE, plot.method = "smoothScatter", cex = 0.8,main = "gcRMA MA plot");

#############
## ��5-13  ##
#############
#��������R��
library(limma) ;
library (gcrma); 
library (CLL); 
data (CLLbatch) ; 
data(disease); 
#��CLL���ݼ���ȥ����ƷCLL1, CLL10�� CLL13
CLLbatch <- CLLbatch[, -match(c("CLL10.CEL", "CLL1.CEL", "CLL13.CEL"), sampleNames(CLLbatch))];
#ʹ ��gcrma�� �� �� Ԥ �� �� �� ��
CLLgcrma <- gcrma(CLLbatch);  
# ȥ��CLLgcrma��Ʒ���е�".CEL"
sampleNames(CLLgcrma) <-  gsub(".CEL$", "", sampleNames(CLLgcrma));
# ȥ��disease�ж�Ӧ��ƷCLL1, CLL10�� CLL13�ļ�¼
disease <- disease[match(sampleNames(CLLgcrma), disease[,"SampleID"]),];
# ��������21����Ʒ�Ļ��������
eset <- exprs(CLLgcrma) ;
# ��ȡʵ��������Ϣ
disease <- factor(disease[, "Disease"]);
# �� �� ʵ �� �� �� �� ��
design <- model.matrix(~-1+disease);
# �� �� �Ա� ģ �ͣ��Ƚ�����ʵ�������±������
contrast.matrix <- makeContrasts (contrasts = "diseaseprogres.  - diseasestable", levels = design);
#����ģ ���� ��
fit <- lmFit(eset, design) ;  
# ���ݶԱ� ģ �ͽ��в�ֵ����
fit1 <- contrasts.fit(fit, contrast.matrix) ;   
# �� Ҷ ˹ ����
fit2 <- eBayes(fit1) ; 
# �������� ����ļ���������
dif <- topTable(fit2, coef = "diseaseprogres.  - diseasestable",  n = nrow(fit2), lfc = log2(1.5)) ; 
# ����P.Value�Խ������ɸѡ���õ�ȫ�����������
dif <- dif[dif[, "P.Value"] < 0.01, ] ; 
# �� ʾ �� �� �� ǰ �� ��
head(dif) ;       
design

#############
## ��5-14  ##
#############
# ����ע�͹��߰�
library(annotate) ;
# ��û���оƬע�Ͱ�����
affydb <- annPkgName(CLLbatch@annotation, type = "db");
# �鿴����оƬע�Ͱ�����
affydb
## [1] "hgu95av2.db"
# ����ע�Ͱ�����hgu95av2.db������ע�Ͱ��������趨character.only
library(affydb, character.only = TRUE) ;

# ����ÿ��̽�����ID��ȡ��Ӧ�Ļ���Gene Symbol������Ϊһ���µ��У��ӵ����ݿ�dif���
dif$symbols <- getSYMBOL(rownames(dif), affydb) ;
# ����ÿ��̽�����ID��ȡ��Ӧ�Ļ���EntrezID������Ϊһ���µ��У��ӵ����ݿ�dif���
dif$EntrezID <- getEG(rownames(dif), affydb) ;
# �� ʾ �� �� �� ǰ �� ��
head(dif) ; 

#############
## ��5-15  ##
#############
# ��������R��
library(GOstats);
# ��ȡHG_U95Av2оƬ������̽�����Ӧ��EntrezID��ע�Ᵽ֤uniq
entrezUniverse <- unique(unlist(mget(rownames(eset), hgu95av2ENTREZID)));
# ��ȡ���в�����������Ӧ��EntrezID��ע�Ᵽ֤uniq
entrezSelected <- unique(dif[!is.na(dif$EntrezID), "EntrezID"]);
# ����GO�������������в���
params <- new("GOHyperGParams", geneIds = entrezSelected, universeGeneIds = entrezUniverse, 
              annotation = affydb, ontology = "BP", pvalueCutoff = 0.001, conditional = FALSE, testDirection = "over");
# �����е�GOterm����params�����������μ���
hgOver <- hyperGTest(params);
# ��������GOterm�ļ���������
bp <- summary(hgOver) ;
# ͬʱ��������GOterm�ļ������ļ���ÿ��GOterm����ָ��ٷ���վ�����ӣ����Ի������ϸ��Ϣ
htmlReport (hgOver,  file='ALL_go.html') ;
# �� ʾ �� �� �� ǰ �� ��
head (bp) ; 

#############
## ��5-16  ##
#############
# ��������R��
library(GeneAnswers) ; 
# ѡȡdif�е�������Ϣ�����µľ��󣬵�һ�б�����EntrezID
humanGeneInput <- dif[, c("EntrezID", "logFC", "P.Value")];  
##�� �� humanGeneInput�л��� �� �� �� ֵ
humanExpr <- eset[match(rownames(dif), rownames(eset)), ] ;  
# ǰ�����������кϲ�����һ�б�����EntrezID
humanExpr <- cbind(humanGeneInput[, "EntrezID"], humanExpr) ; 
# ȥ ��NA�� ��
humanGeneInput <- humanGeneInput[!is.na(humanGeneInput[,  1]), ] ; 
humanExpr <- humanExpr[!is.na(humanExpr[, 1]), ] ;
# KEGGͨ·�ĳ����μ���
y <- geneAnswersBuilder(humanGeneInput, "org.Hs.eg.db", categoryType = "KEGG", testType = "hyperG", pvalueT = 0.1, geneExpressionProfile = humanExpr, verbose = FALSE) ;
getEnrichmentInfo(y)[1:6,]

#############
## ��5-17  ##
#############
#��������R��
library(pheatmap);
# �ӻ���������У�ѡȡ����������Ӧ������
selected <- eset[rownames(dif), ] ;
# ��selected����ÿ�е�������̽����IDת��Ϊ��Ӧ�Ļ���symbol
rownames(selected) <- dif$symbols;
# ���ǵ���ʾ����������ֻ��ǰ20���������ͼ
pheatmap(selected[1:20, ], color = colorRampPalette(c("green", "black", "red"))(100),  fontsize_row = 4, scale = "row", border_color = NA);

#��������R��
library(Rgraphviz);
# ����������GO term��DAG��ϵͼ����ͼ5-21
ghandle <- goDag(hgOver) ; 
# ��ͼ�޴�ֻ��ȡһ�������ݹ����ֲ�ͼ
subGHandle <- subGraph (snodes=as.character(summary(hgOver)[,1]), graph=ghandle) ;
plot(subGHandle) ;

# ����������KEGGͨ·�Ĺ�ϵͼ����ͼ5-22
yy  <-  geneAnswersReadable (y,verbose  = FALSE);
geneAnswersConceptNet (yy, colorValueColumn= "logFC", centroidSize ="pvalue", output = "interactive");
# ����������KEGGͨ·����ͼ����ͼ5-23
yyy  <- geneAnswersSort (yy, sortBy="pvalue");
geneAnswersHeatmap(yyy)
# ����Ự��Ϣ
sessionInfo()


#############
## ��5-18  ##
#############
#��������R��
library (GEOquery);
library (CLL); 
#���õ�ǰĿ¼
#setwd("c:\\workingdirectory"); 
#����U133A��22215������̽�����б�
U133Acols<-read.table("U133Acols");
#�õ�12�����ݼ���ID�е�����
numbers=c(15471,5563,3325,9844,5788,6344,10072,13911,1420,8671,5764);
#�õ�12�����ݼ���GEO���ݿ��е�ID
GEO_IDs=paste("GSE",numbers,sep = "");
#�õ�12�����ݼ������ļ��ĺ�׺��
tars=paste(GEO_IDs,"_RAW.tar",sep = "");
#����һ���ձ��������˱������ݱ�׼����Ľ��
trainX=c();
#12��ѭ������12�����ݼ�
for(i in 1:length(GEO_IDs))
{
  #�õ��������ݵ�Ŀ��·��������
  GEO_tar <- paste(GEO_IDs[i],tars[i],sep = "/");
  #�������ݼ�
  getGEOSuppFiles(GEO=GEO_IDs[i],baseDir = getwd());
  #����ǰ���ݼ��е�������Ʒ���ݽ�ѹ��data��Ŀ¼
  untar(GEO_tar, exdir="data");
  #�õ���ǰ���ݼ��е�������Ʒ��Ӧ�������ļ�����
  cels <- list.files("data/", pattern = "[gz]");
  #��ѹ��ǰ���ݼ��е�������Ʒ��Ӧ�������ļ�
  sapply(paste("data", cels, sep="/"), gunzip);
  #�õ�data��Ŀ¼��ȫ·��
  celpath <- paste(getwd(),"data",sep = "/");
  #ת��data��Ŀ¼��ͬʱ������ǰĿ¼��oldWD
  oldWD <- setwd(celpath); 
  #��ȡ��ǰĿ¼�е�������Ʒ��Ӧ��CEL�ļ�
  raw_data <- ReadAffy();   
  #�ص�����Ŀ¼
  setwd(oldWD);
  #ɾ��data��Ŀ¼��ȫ���ļ��������´�ѭ����׷��д
  unlink("data", recursive=TRUE) ;
  #��RMA�㷨��׼������
  rma_data <- rma(raw_data); 
  #�õ����������eset
  eset <- exprs(rma_data);
  #���������ת�ú�ѡ����Ҫ����
  x<-t(eset)[,as.vector(t(U133Acols))];
  #��ȡ�����ݼ����ϰ������׷��
  trainX=rbind(trainX,x);
}  
# 12�����ݼ�������ϣ����浽�ļ�trainX��
write.table (trainX, file = "trainX", sep = "\t",row.names = F,col.names = F) ;


#############
## ��5-19  ##
#############
#��������R��
library (GEOquery);
#���õ�ǰĿ¼
setwd("c:\\workingdirectory")
#����U133A��22215������̽�����б�
U133Acols<-read.table("U133Acols");
#���ݼ�GSE2503�Ļ���������
gds<-getGEO(GEO = "GSE2503", destdir = getwd());
#�õ����������eset
eset <- exprs(gds[[1]]);
#���������ת�ú�ѡ����Ҫ����
x<-t(eset)[,as.vector(t(U133Acols))]; 
#ȫ������ת��Ϊ��2Ϊ�׵Ķ���
trainX2<-log2(x) ;
# ������浽�ļ�trainX2��
write.table (trainX2, file = "trainX2",sep = "\t",row.names = F,col.names = F) ;

#############
## ��5-20  ##
#############
#��������R��
library (Biostrings);
#���õ�ǰĿ¼
setwd("c:\\workingdirectory"); 
#���ļ�miRNA.tab����miRNA���У���һ��������ID���ڶ�������������
data1<-read.table("miRNA.tab");
#��ȡ��������
seqs=as.character(data1[,2]);
#��ȡ����ID
names(seqs)=data1[,1];
#������RNAStringSet���󣬱���Ϊfasta��ʽ�ļ�
Biostrings::writeXStringSet(RNAStringSet(seqs, use.names=TRUE),"miRNA.fa");

#############
## ��5-21  ##
#############
#��������R��
library(biomaRt);
library (Biostrings);
#ѡ��"ensembl"���ݿ�
ensembl_mart <- useMart(biomart="ensembl");
#ѡ��"sscrofa"���ݼ�
dataset_pig <-useDataset(dataset="sscrofa_gene_ensembl",mart= ensembl_mart);
#��dataset_pig���ݼ��и���affy_porcine ID��description��Ϣ
idlist <- getBM(attributes=c("affy_porcine","description"), mart=dataset_pig); 
#��dataset_pig���ݼ��и���affy_porcine ID��ȡ����
seqs = getSequence(id=idlist["affy_porcine"], type="affy_porcine", seqType="3utr", mart = dataset_pig);
#ȥ��û���������ݵ����ݼ�¼
seqs = seqs[!seqs[,1]=="Sequence unavailable",];
#ȥ��û��UTRע�͵����ݼ�¼
seqs = seqs[!seqs[,1]=="No UTR is annotated for this transcript",];
#��ȡ���е�����
x=seqs[,1];
#��ȡ���е�ID
names(x)=seqs[,2];
#��������ļ�"UTR3seqs-2.fa"����ʽΪfasta
writeXStringSet(DNAStringSet(x, use.names=TRUE),"UTR3seqs-2.fa");

#############
## ��5-22  ##
#############
#��������R��
library(biomaRt);
library (Biostrings);
pig_affy_IDs<- read.table("pig_affy_IDs");
pig_affy_IDs<- as.character (unlist(pig_affy_IDs));
#�г�"sscrofa"���ݼ���������������֪������"ensembl_transcript_id"��"affy_porcine"
id_mapping <- getBM(attributes=c("ensembl_transcript_id","affy_porcine"), filters = "affy_porcine", values = pig_affy_IDs, mart=dataset_pig);
write.table (id_mapping,"emsembl-affy",sep="\t");

#############
## ��5-23  ##
#############
#��������R��
library(affycoretools);
library(genefilter);
library(annotate);
library(GOstats);
# ��������CEL�ļ�
rawData <- read.affybatch(filenames=list.celfiles());
# ����Ƿ���������ļ�
sampleNames(rawData);
# ʹ��RMA�㷨Ԥ������������
eset <- rma(rawData); 
# ��û���оƬע�Ͱ�����
annoPackage <- paste(annotation(eset), ".db", sep="");
#��װ�����������Ӧ�Ļ���оƬע�Ͱ�
source("http://Bioconductor.org/biocLite.R");
biocLite(annoPackage);
library(annoPackage, character.only = TRUE);
# ȡ������̽�����Affymetrix ID
affy_IDs <- featureNames(eset);
#ȡ�����ݼ���ע����Ϣ
an <- annotation(eset);   
# ����ÿ��̽�����ID��ȡ��Ӧ��Gene Symbol
symbols <- as.character(unlist(mget(affy_IDs,get(paste(an, "SYMBOL", sep="")))));
# ����"NA",ת����""
symbols[is.na(symbols)] <- "";  
# ����ÿ��̽�����ID��ȡ��Ӧ��Gene Name
gene_names <- as.character(unlist(mget(affy_IDs,get(paste(an,"GENENAME", sep="")))));
# ����"NA",ת����""
gene_names[is.na(gene_names)] <- "";
# ����ÿ��̽�����ID��ȡ��Ӧ��Entrez ID
entrez <- unlist(mget(affy_IDs, get(paste(an, "ENTREZID", sep=""))));
# ����ÿ��̽�����ID��ȡ��Ӧ��UNIGENE ID
unigenes <- as.character(unlist(lapply(mget(affy_IDs, get(paste(an, "UNIGENE", sep=""))),paste, collapse="//")));
# ����ÿ��̽�����ID��ȡ��Ӧ��Refseq  ID
refseqs <- as.character(unlist(lapply(mget(affy_IDs, get(paste(an, "REFSEQ", sep=""))),paste, collapse="//")));
# ���ݻ��������ͬʱ��ע�͵��������ݿ�ID����ע��˳���Ӧ��̽������
out <- data.frame(ProbeID=affy_IDs,Symbol=symbols, Name=gene_names, EntrezGene=entrez, UniGene=unigenes,RefSeq=refseqs, exprs(eset), stringsAsFactors=FALSE);
row.names(out) <- 1:length(affy_IDs);
# ����ע�͵����ݻ�����������
write.table(out, "Expression_table.xls", sep='\t',row.names=F); 
# ������Ʒ������
samples <- c('HEK293_EGFP_monolayer','HEK293_EGFP_sphere','HEK293_CD147_monolayer',
             'HEK293_CD147_sphere','MIAPaCa_2_NC','MIAPaCa_2_A6');
# ����Աȵ�����    
compNames = paste(samples[c(1,1,2,3,5)],samples[c(2,3,4,4,6)],sep=' vs '); 
# ���һ������׼��Ҫ��ÿ��������6����Ʒ�����ٱ��һ��
flt1 <- kOverA(1,6); 
# ����Ա���log2Fold����1���Ļ��������������������������ͬ���ļ�
out <- foldFilt(eset,fold=1,groups=1:6,comps=list(c(1,2),c(1,3),c(2,4),c(3,4),c(5,6)),compNames,text=T,html=F,save=T,filterfun=flt1);


#############
## ��5-24  ##
#############
# GO��3����������3������ֿ�ע��
go_domains <- c('BP','CC','MF');
# ��ȡ����̽�����Ӧ��GO��Ϣ��û��GOע�͵ļ�¼ΪFALSE��
no_go <- sapply(mget(affy_IDs, hgu133plus2GO), function(x) if(length(x) == 1 && is.na(x))TRUE else FALSE);
# ��ȡ������GOע�͵�̽����
affy_IDs <- affy_IDs[!no_go];
# ��ȡ����̽�����Ӧ��"EntrezGene"����ȥ���ظ���¼
all_probes <- unique(getEG(affy_IDs, "hgu133plus2"));
# ��ȡ�Ա�1�ͶԱ�4֮�䣬�Ա�2�ͶԱ�3֮��Ĳ�����̽���飬�Լ��Ա�5�Ĳ�����̽����
sig_probes.temp <- list(names(which(abs(out[[2]][,1])==1 & abs(out[[2]][,4])==1)),
                        names(which(abs(out[[2]][,2])==1 & abs(out[[2]][,3])==1)),
                        names(which(abs(out[[2]][,5])==1)));
# �������ļ�������  	       
fnames <- c('common probesets for monolayer vs sphere','common probesets for EGFP vs CD147',
            'MIAPaCa_2_NC vs MIAPaCa_2_A6');
# ÿ��ѭ������һ�γ����μ��飬�����ݲ����������GO�ĸ���	    
for(i in 1:3){
  sig_probes = unique(getEG(sig_probes.temp[[i]][sig_probes.temp[[i]]%in%affy_IDs], "hgu133plus2"));
  for(j in 1:3){
    # �趨�����μ������
    params = new("GOHyperGParams", geneIds=sig_probes, universeGeneIds=all_probes, conditional = TRUE,
                 annotation = annotation(eset), ontology = go_domains[j],pvalueCutoff=.01);
    # �����μ���
    hypt = hyperGTest(params);
    # ���html��ʽ�ı����ļ�
    htmlReport(hypt, digits=8, file=paste(fnames[i],'_',go_domains[j],'.html',sep=''));
  }
}

