##############
## ׼������ ##
##############
# ����ǵ�һ��ʹ��bioconductor��������������£�Ҫ�Ȱ�װ���İ�
source("http://bioconductor.org/biocLite.R")
biocLite()
# ����C:\workingdirectoryĿ¼


#############
##  ��6-1  ##
#############

# ��װ����������R��
source('http://Bioconductor.org/biocLite.R');
biocLite("ShortRead") ;
library(ShortRead);
Q=20;
# ����Q��Sanger���� (Phred+33)
PhredQuality (as.integer(Q));
# ����Q��Illumina���� (Phred+64)
SolexaQuality(as.integer(Q));

#############
##  ��6-2  ##
#############
# ����Ϊfastq�ļ���һ�����е���Ϣ��ת��Ϊ6-2.fastq��C:\workingdirectory�Ա�����6-3ʹ��
@HWUSI-EAS100R:123:C0EPYACXX:6:73:941:1973#0/1
GATTTGGGGTTCAAAGCAGTATCGATCAAATAGTAAATCCATTTGTTCAACTCACAGTTT
+ HWUSI-EAS100R:123:C0EPYACXX:6:73:941:1973#0/1
!''*((((***+))%%%++)(%%%%).1***-+*''))**55CCF>>>>>>CCCCCCC65

#############
##  ��6-3  ##
#############
# ��������R����ǰ���Ѿ���װ
library(ShortRead);
# ��������Ŀ¼
# �豣֤��Ŀ¼���ڣ�����ᱨ��
# R��\����Ϊת���������\nΪ���У���˱�ʾ·��ʱΪ�������ᣬ��Ҫʹ��˫б��\\����ֱ��ʹ�÷�б��/
setwd("c:\\workingdirectory");
# ����FASTQ�ļ�
reads <- readFastq("6-2.fastq");
# �õ���������������
score_sys = data.class(quality(reads));
# �õ���������(�ַ���ʾ)
qual <- quality(quality(reads));
# ��������תΪ16���Ʊ�ʾ	
myqual_16L <- charToRaw(as.character(unlist(qual)));
# �����Phred+64������ʾϵͳ
if(score_sys=="SFastqQuality"){
# ��ʾ����ϵͳ����
cat("The quality score system is Phred+64" ,"\n");	
# ���ԭʼ����ֵ��16����ת10���ƣ��ټ�ȥ64
strtoi(myqual_16L, 16L)-64;			
}
# �����Phred+33������ʾϵͳ
if(score_sys=="FastqQuality"){
# ��ʾ����ϵͳ����
cat("The quality score system is Phred+33" ,"\n");	
# ���ԭʼ����ֵ��16����ת10���ƣ��ټ�ȥ33
strtoi(myqual_16L, 16L)-33;
}

#############
##  ��6-6  ##
#############
# ����RNA-seq�������ϴ󣬱���������Linux������������ϵͳFedora������4G�ڴ����ϵ�Windowsϵͳ���С�
# ��װ����������R��
source('http://Bioconductor.org/biocLite.R');
biocLite("ShortRead") ;
biocLite("SRAdb");
biocLite("R.utils");
library(ShortRead);
library(SRAdb);
library(R.utils);
# ������Ҫ�������ļ�
getFASTQfile("SRR921344");
# ��ѹ�󣬸���Ϊ"T2-1.fastq"
gunzip ("SRR921344.fastq.gz", destname="T2-1.fastq");
# ��Ҫ�����������ļ�����
fastqfile="T2-1.fastq";
# �õ����������Ľ��
qa <- qa(dirPath=".", pattern=fastqfile, type="fastq");
# ���html��ʽ�ķ�������
report(qa, dest="qcReport", type="html");

#############
##  ��6-7  ##
#############
# ����linuxϵͳ�����ظ�ͨ������SRR987316.sra
# �˴���ע�⣬wget�����Ĭ������λ��Ϊ��ǰĿ¼�����ʹ��-O��Ϊָ��λ��
wget ftp-trace.ncbi.nlm.nih.gov/sra/sra-instant/reads/ByRun/sra/SRR/SRR987/SRR987316/SRR987316.sra
# ��SRA��ʽ�ĸ�ͨ������ת��ΪFASTQ��ʽ
./fastq-dump SRR987316.sra
# ����fastqc������汾0.10.1������������Ʊ���
fastqc SRR987316.fastq

#############
##  ��6-8  ##
#############
# ��װ����������R��
source('http://Bioconductor.org/biocLite.R');
biocLite("Rsamtools");
biocLite("DESeq");
biocLite("edgeR");
library(Rsamtools);
library(DESeq);
library(edgeR);
# ʾ����������GenomicRanges���е��ļ�extdata
fls <- list.files(system.file("extdata",package="GenomicRanges"),
    recursive=TRUE, pattern="*bam$", full=TRUE);
bfl <- BamFileList(fls, index=character());
features <- GRanges(
    seqnames = c(rep("chr2L", 4), rep("chr2R", 5), rep("chr3L", 2)),
    ranges = IRanges(c(1000, 3000, 4000, 7000, 2000, 3000, 3600, 4000, 
        7500, 5000, 5400), width=c(rep(500, 3), 600, 900, 500, 300, 900, 
        300, 500, 500)), "-",
    group_id=c(rep("A", 4), rep("B", 5), rep("C", 2))) ;
olap <- summarizeOverlaps(features, bfl) ;
deseq <- newCountDataSet(assays(olap)$counts, rownames(colData(olap))) ;
edger <- DGEList(assays(olap)$counts, group=rownames(colData(olap))) ;

#############
##  ��6-9  ##
#############
setwd("c:/workingdirectory");
# �������ݣ���1���ǻ�����������row.name�����1���ǻ��򳤶ȣ���1����sample����
raw.data <- read.table("raw_counts.table",row.names=1);
# ȥ����1�г�����Ϣ��ֻ���������Ļ�����ֵ
counts <- raw.data[, 2:dim(raw.data)[2]];
# ȡ����1�г�����Ϣ
length<-raw.data[, 1];
# ��ȡlib_size����ÿ����Ʒ���Զ��뵽ת¼��Ķ�������
lib_size <- read.table("lib_size.txt");
lib_size <- unlist(lib_size);
# ����RPKMֵ
rpkm <- t(t(counts/length)*10^9/lib_size);
# ���Ϊ��ĸ�ʽ
write.table(rpkm,file = "rpkm.table",sep = "\t");
# �������ϵ��
cor_table = cor(rpkm);
# ���Ϊ��ĸ�ʽ
write.table(cor_table,file = "correlations.table",sep = "\t");

##############
##  ��6-10  ##
##############
# ��װ����������R��
source('http://Bioconductor.org/biocLite.R');
biocLite("DESeq");
library(DESeq);
# ֻ��100bp����Ʒ���м��㣬51bp����Ʒ��ѡ
counts <- cbind(counts[, 1:3],counts[, 7:9]);
# ����ÿ����Ʒ��ʵ��������3������3������
conditions=c(rep("T", 3),rep("CK", 3)); 
# ����CountDataSet����(DESeq���ĺ������ݽṹ)
cds <- newCountDataSet(counts, conditions);
# ����ÿ��������Size Factor����׼������׼�������ݴ��ڶ���cds
cds <- estimateSizeFactors(cds); 
# ��ʾÿ��������Size Factor���ⲽ��������ȥ       
sizeFactors(cds);                          
# ɢ�ȹ���
cds <- estimateDispersions(cds, method = "per-condition", sharingMode="maximum"); 
# ��ʾɢ�ȣ��ⲽ��������ȥ
dispTable(cds);                           
# ����"T-CK"���죬����������et
et <- nbinomTest(cds, "T", "CK");
# �������������Ľ��
write.table(et,file = "T-CK.table",sep = "\t");
# �鿴����cds������
cds

##############
##  ��6-11  ##
##############
# ָ������Ŀ¼����Ŀ¼�������е������ļ�
setwd("C:/workingdirectory");
# ��װ����������R��
library(ShortRead);
library(ggplot2);
# ָ��ת¼�������ļ�����
file="Trinity.fasta";
# ����fasta�ļ�
seqs <- readFasta(file);
# ���������س���Դ�����ļ�contigStats.R
source("http://faculty.ucr.edu/~tgirke/Documents/R_BioCond/My_R_Scripts/contigStats.R");
# ͳ�Ƴ��ȷֲ�����Ϣ
N <- list(seqs=width(seqs)) ;
reflength <- sapply(N, sum) ;
contigStats(N=N, reflength=reflength, style="ggplot2");
stats <- contigStats(N=N, reflength=reflength, style="data");
# ��ʾͳ�ƽ��
stats[["Contig_Stats"]];
# ���ͳ�ƽ��
write.table(t(stats[["Contig_Stats"]]),file="unigenes.dis");
