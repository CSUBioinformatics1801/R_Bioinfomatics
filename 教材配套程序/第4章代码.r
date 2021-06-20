rm(list = ls())
setwd("c:\\workingdirectory")

#��װ�����õ����������         
#source("http://www.bioconductor.org/biocLite.R");
#biocLite("Biostrings");
#biocLite("BSgenome.Hsapiens.UCSC.hg19");                          
#biocLite("hgu133a2probe");
#����Biostrings��
library(Biostrings);
#��������������������ݰ�
library(BSgenome.Hsapiens.UCSC.hg19);                                         
#����HG-U133A��̽�����ݰ�
library(hgu133a2probe);                                         

#��4.1: �������������������򣬷��򻥲������룬ת¼����ת¼��
#��DNAString����һ��dna����                                                  
dna<-DNAString("TCTCCCAACCCTTGTACCAGT");
#�鿴�������
dna; 

#������dna��DNAString����תΪ"RNAString"���ͣ�ֱ�Ӳ鿴����
Biostrings::dna2rna(dna); 
# ������dna�е�DNAת¼������һ��"RNAString"�����¶���rna
rna<-transcribe(dna); 
#�鿴rna����
rna  

#��תΪ"DNAString"���ͣ�RNA�����еģ�ȫ���滻ΪT
rna2dna(rna); 

#����rna��ת¼���õ��¶���cD��"DNAString"���ͣ�
cD<-cDNA(rna);

#�鿴rna������������
codons(rna);

# rna���룬�����¶���AA��"AAString"���ͣ� 
AA <-translate(rna);

# �鿴AA������
AA;  

# dna�Ļ������ֵõ�һ��"DNAString"���͵Ķ���
complement(dna);

# dna�ķ��򻥲����У�����"DNAString"���͵Ķ���
reverseComplement(dna);

# dna�ķ������У�����"DNAString"���͵Ķ���
reverse(dna);

# ��4.2: ͳ����������������еļ��Ƶ��
# ����22��Ⱦɫ��ȫ���ж���N�ĵط��ڸǣ��Է����������ʱ��߹���Ч��
chr22NoN <-mask (Hsapiens$chr22, "N"); 
# ͳ�Ƶ�2��Ⱦɫ��ȫ�����е����л������[ATCG]�ĳ��ִ���
alphabetFrequency(Hsapiens$chr22, baseOnly =TRUE);
#��ͳ��Ⱦɫ�������м���ĳ��ִ���
alphabetFrequency(Hsapiens$chr22);
#����Hsapiens$chr22�Ƿ�ֻ�л������[ATCG]����ĸ��
hasOnlyBaseLetters(Hsapiens$chr22);
#��ʾHsapiens$chr22�м������ĸ�����ࣨ�������ࣩ
uniqueLetters(Hsapiens$chr22);
#����Hsapiens$chr22��C��G��������ע�ⲻ��CG������
GC_content<-letterFrequency(Hsapiens$chr22, letters ="CG");
#�鿴C��G������
GC_content
#����Hsapiens$chr22��C��G��ռ�ĺ�����������
GC_pencentage<-letterFrequency(Hsapiens$chr22, letters ="CG")/letterFrequency(Hsapiens$chr22, letters ="ACGT");
#�鿴C��G�ĺ���
GC_pencentage

# ��4.3: ģ��ƥ�䣬��һ��������ƥ��һ��ģ��
#��������7�������ɵ�ģ��
my_pattern = "TATAAAA";
#��chr22NoN��ƥ���ģ�壬���߿��Լ��鿴���
mT = matchPattern(my_pattern, chr22NoN);
#����chr22NoN��ƥ���ģ�������
countPattern(my_pattern, chr22NoN);
#��chr22NoN��ƥ���ģ��������һ������
mmT = matchPattern(my_pattern, chr22NoN, max.mismatch =1);
#��һ�ַ�������ƥ������������Կ�����ƥ���˺ܶ�
length(mmT);
#�۲�ǰ5��ƥ��õ���Ƭ���д��������ڵ�λ��
mismatch(my_pattern, mmT[1:5]);
#��ཫҪƥ���ģ������
Lpattern <- "CTCCGAG";
#�ҲཫҪƥ���ģ������
Rpattern <- "GTTCACA";
#������ģ��ͬʱƥ��Hsapiens$chr22��Ҫ���м�����г��Ȳ��ܳ���500bp
LRsegments<-matchLRPatterns(Lpattern, Rpattern, 500, Hsapiens$chr22);
#�鿴ƥ�䵽��ǰ5������
LRsegments[1:5];

# ��4.4: ģ��ƥ�䣬��һ��������ƥ��һ��ģ�壨���볤��һ����
#��ȡ����̽������У����һ��ģ�壬���ڶ���dict
dict<-hgu133a2probe$sequence;
#��������̽�루���У�������
length(dict);
#�鿴̽��ĳ���nchar(dict)�ж����֣�ֻ��һ����25
unique(nchar(dict));
#�鿴dict��ǰ�������ݣ�̽�����У�
dict[1:3];
#������̽�����й���DNA�ʵ䣨ģ�壩�����������һ������
pdict<-PDict(dict, max.mismatch =1);
#�ôʵ�ƥ��Hsapiens$chr22����
vindex<-matchPDict(pdict, Hsapiens$chr22);
#ÿ��ģ�壨̽�����У���Hsapiens$chr22ƥ��ĸ���
count_index<-countIndex(vindex);
#��������ģ��ƥ�������
sum(count_index);
#����ǰ3��ģ���ƥ������� ���ȫ��0������ƥ�䲻��
count_index[1:3];
#ͳ��һ��ƥ�������ķֲ������Կ����󲿷֣�243903��ģ���ƥ��������0
table(count_index);
#��̽����������ȡƥ��������ģ���Ӧ������
dict[count_index == max(count_index)];
#�����������Hsapiens$chr22ƥ�䣬����ƥ�����������������ͳ�Ʒֲ����һ����ͬ
countPattern("CTGTAATCCCAGCACTTTGGGAGGC", Hsapiens$chr22);

# ��4.5: �������Ľṹ
#����chr22_pals���ȣ��޶��������40bp
chr22_pals <-findPalindromes(chr22NoN, min.armlength =40, max.looplength =20);
#����chr22_pals����                                                                 
nchar(chr22_pals);
#�鿴ǰ5���ҵ��Ļ��Ľṹ
chr22_pals[1:5];
#�鿴���Ľṹ�����еļ������
palindromeArmLength(chr22_pals);
#ͳ�ƻ��Ľṹ�е����л������[ATCG]�ĳ��ִ���
ans<-alphabetFrequency(chr22_pals, baseOnly =TRUE);
#�鿴���������Ƶ��
ans;

# ��4.6: ���бȶ�
#��AAString��������һ��"AAString"����aa1
aa1 <-AAString("HXBLVYMGCHFDCXVBEHIKQZ");
#��AAString��������һ��"AAString"����aa2
aa2 <-AAString("QRNYMYCFQCISGNEYKQN");

#����ȫ�ֱȶԣ�Ӧ�þ���"BLOSUM62"��֣�Ҫ��gap open����Ϊ3
needwunsQS(aa1, aa2, "BLOSUM62", gappen =3);
#��DNAString��������һ��"DNAString"����dna1
dna1 <-DNAString("CTCCGAGGGTTTGAATGAT");

#��DNAString��������һ��"DNAString"����dna2
dna2 <-DNAString("CTCCGAGTAGCTGGGATTA");

#����4x4�ľ���DNA��־���
mat <-matrix(-5L, nrow =4, ncol =4); 
for (i in seq_len(4)) mat[i, i] <-0L;
rownames(mat) <-colnames(mat) <-DNA_ALPHABET[1:4];

#����ȫ�ֱȶԣ�Ӧ�þ���mat��֣�Ҫ��gap open����Ϊ0
needwunsQS(dna1, dna2, mat, gappen =0); 

# ��4.7: ��д�����ļ�(Fasta��Fastq��ʽ)
# ָ���ļ���Ŀ¼(Biostrings��װĿ¼�е�extdata��Ŀ¼)���ļ���(someORF.fa)
filepath<-system.file("extdata", "someORF.fa", package ="Biostrings");  
# ��ʾ����FASTA�ļ��е�������Ϣ
fasta.info(filepath);
# ��ȡFASTA�ļ�
x <-readDNAStringSet(filepath); 

# �鿴FASTA�ļ�������
x;  
# ��������ļ�
out1 <- 'example1.fasta';
# ������������ļ�out1����ʽ����FASTA
writeXStringSet(x, out1);

# ָ���ļ���Ŀ¼���ļ���(s_1_sequence.txt)�������FASTQ�ļ�
filepath<-system.file("extdata", "s_1_sequence.txt", package ="Biostrings") ; 

# ��ʾ����FASTQ�ļ��е�������Ϣ
fastq.geometry(filepath); 
#��ȡFASTQ�ļ�
x <-readDNAStringSet(filepath, format ="fastq");  
# �鿴FASTQ�ļ����������������ʾ
x;  
# �ӵ�1��Ⱦɫ���ϰ��չ̶����ȣ�50bp������ȡ�����У�read������㣨������
sw_start<-seq.int(1, length(Hsapiens$chr1) -50, by =50);
# ����㿪ʼȡread��ÿ������Ϊ10bp��ע��sw�ĸ�ʽ��"XStringViews"
sw<-Views(Hsapiens$chr1, start =sw_start, width =10);
# ����sw�ĸ�ʽ��"XStringViews"ת��Ϊ"XStringSet"
my_fake_shortreads<-as(sw, "XStringSet");
# ����"ID"�ӿ�ͷ6�����ֵĸ�ʽ���õ�һ��������
my_fake_ids<-sprintf("ID%06d", seq_len(length(my_fake_shortreads)));  
# ���������滻������
names(my_fake_shortreads) <-my_fake_ids;
# �鿴��500000��500005�����ݣ��������������ʾ
my_fake_shortreads[500000:500005];
# ��������ļ�
out2 <- 'example2.fastq';
# ������������ļ�out2����ʽ��FASTQ�� ����ȱ��������Ϣ
writeXStringSet(my_fake_shortreads, out2, format ="fastq");
# ����������Ϣ
my_fake_quals <- rep.int(BStringSet("DCBA@?>=<;"), length(my_fake_shortreads));
#�鿴my_fake_quals���ݣ��������������ʾ
my_fake_quals;
# ��������ļ�
out3 <- 'example3.fastq';
# ������������ļ�out3����ʽ����FASTQ�� ��κ���������Ϣ
writeXStringSet(my_fake_shortreads, out3, format ="fastq", qualities =my_fake_quals);

# ��4-8
# ��װCLL���ݰ�
#source("http://www.bioconductor.org/biocLite.R");
#biocLite("CLL"); 
# ����CLL���ݰ�
library(CLL) ; 
# �������ݣ����ļ��и�����ʾ�����ݣ�
data(CLLbatch);

# �鿴����������ṹ
phenoData(CLLbatch);


# ��4-9
# ��װbiomaRt��
#source("http://www.bioconductor.org/biocLite.R");
#biocLite("biomaRt"); 
# ����biomaRt��
library(biomaRt) ; 
# ��ȡ��ǰ���õ�����Դ��һ������Դ����һ��mart
marts <- listMarts(); 
#ֻ�鿴ǰ����
head(marts); 
#ʹ��ensembl����Դ�����֪���������ǰ��û��Ҫ�鿴��������Դ
ensembl_mart <- useMart(biomart="ensembl"); 
#��ȡensembl_mart�п������ݼ�
datasets <- listDatasets(ensembl_mart); 
#�鿴ǰ10��
datasets[1:10, ]; 
#ʹ������������ݼ�
dataset_pig <- useDataset("sscrofa_gene_ensembl", mart= ensembl_mart);
#��ȡdataset_pig���ݼ��Ͽ��õ�ɸѡ��
filters <- listFilters(dataset_pig); 
#ֻ�鿴ǰ����������û�õ��κ�ɸѡ��
head(filters); 
#��ȡ��ѡ������ԣ��У�
attributes <- listAttributes(dataset_pig); 
#ֻ�鿴ǰ����
head(attributes); 
#��dataset_pig���ݼ�����ȡensembl_transcript_id��description��Ϣ
idlist <- getBM(attributes= c("ensembl_transcript_id", "description"), mart= dataset_pig);
#��dataset_pig���ݼ��и���ensembl_transcript_id��ȡ����
seqs = getSequence(id=idlist["ensembl_transcript_id"], type="ensembl_transcript_id", seqType="3utr", mart = dataset_pig);
#ȥ��û���������ݵ����ݼ�¼
seqs = seqs[!seqs[, 1]=="Sequence unavailable", ];
#ȥ��û��UTRע�͵����ݼ�¼
seqs = seqs[!seqs[ ,1]=="No UTR is annotated for this transcript", ];
#��ȡ���е�����
x=seqs[ ,1];
#��ȡ���е�ID
names(x)=seqs[ ,2];
#��������ļ�"UTR3seqs-1.fa"����ʽΪfasta
writeXStringSet(DNAStringSet(x, use.names=TRUE),"UTR3seqs-1.fa");
#ͬʱ��ȡ��Ӧ3'UTR���е�cDNA����
cDNAseqs = getSequence(id=idlist["ensembl_transcript_id"], type="ensembl_transcript_id", seqType="cdna", mart = dataset_pig);
x=cDNAseqs[ ,1];
names(x)=cDNAseqs[ ,2];
#��������ļ�"UTR3seqs-1.fa"����ʽΪfasta
writeXStringSet(DNAStringSet(x,  use.names=TRUE), " transcriptom.fasta");


# ��4.10
# �����ѹ���ע���ļ�
probeset <- read.csv("PrimeView.na32.annot.csv", comment.char ="#");
# �鿴���������Կ���ÿ��̽����Զ�Ӧ�������ֹ������ݿ��ID��
colnames(probeset);
# ֻ����probeset���У�̽��ID��probeset id����Entrez���ݿ��ID(Entrez.Gene)
Id_mapping <- probeset[,c("Probe.Set.ID", "Entrez.Gene")];
# ��Entrez.Geneһ����Ϣ�еĿհ��ַ���"\\s+"����תΪ���ַ���""��
Id_mapping$Entrez.Gene <- gsub("\\s+","", Id_mapping$Entrez.Gene);
# Entrez.Geneһ����Ϣ��Ϊ�յ����ݱ�������
Id_mapping <- Id_mapping[Id_mapping$Entrez.Gene!="---", ];
# ��ȡ���е�Entrez.Gene��
l<-as.character(Id_mapping$Entrez.Gene);
# ͨ���鿴��������Щ̽��ID��Ӧ���Entrez.Gene��
head(l[!grepl("^\\d+$", l)]);
# �Ƚ���"///"�ָ�Ķ��Entrez.Gene�ָ
entrez<-strsplit(as.character(Id_mapping$Entrez.Gene),"///");
# entrez�����ж�������Ƹ�ֵΪ̽��ID
names(entrez)<-as.character(Id_mapping$Probe.Set.ID);
# �����޷�ֱ�ӽ�����entrez��list��ʽת����matrix��ʽ���Ƚ�list�ڵ�Ԫ��ת����
# ̽��ID��Entrez.GeneΪ������matrix��Ȼ���ٺϲ���һ������Ϊ�����Ч�ʣ� 
# Ҫ�õ�yapply�����������㣬�����ȶ���һ��yapply����
# yapply�����������Ƕ�list����ʱ����ͬʱ�����������Լ�����ֵ��
# �ú�������ࡢ����ǿ�󣬵��﷨���ӣ���ѧ�߿�����������2��
yapply<-function(X,FUN, ...) { 
  index <- seq(length.out=length(X))
  namesX <- names(X) 
  if(is.null(namesX)) namesX <- rep(NA,length(X))
  FUN <- match.fun(FUN) 
  fnames <- names(formals(FUN)) 
  if( ! "INDEX" %in% fnames ){ 
    formals(FUN) <- append( formals(FUN), alist(INDEX=) )   } 
  if( ! "NAMES" %in% fnames ){ 
    formals(FUN) <- append( formals(FUN), alist(NAMES=) )   } 
  mapply(FUN,X,INDEX=index, NAMES=namesX, MoreArgs=list(...)) };
# �������涨��õ�yapply������ʵ����Ҫ�Ĺ���
entrez<-yapply(entrez, function(.ele){cbind(rep(NAMES, length(.ele)), gsub(" ","",.ele))});
# ת�������е�matrix
entrez<-do.call(rbind, entrez);
# ȥ���ظ���¼
entrez<-unique(entrez);
# �����������õ�һ��IDӳ���ļ�
write.table(entrez, file="primeviewHumanGeneExprs.txt", sep="\t", col.names=F, row.names=F, quote=F);

# ��4.11
# ��װ��������Ӧ��R��
source("http://bioconductor.org/biocLite.R");
biocLite("AnnotationDbi");
library(AnnotationDbi);
# �鿴���еĿ���ģ��
available.chipdbschemas();
# �ڵ�ǰĿ¼���½�����primeview���ļ���
dir.create("primeview");
# ����֮ǰ���ɵ�primeviewHumanGeneExprs.txt������һ��SQLite���ݿ⣬ע����Ϣ��Դ��human.db0��ģ�����"HUMANCHIP_DB"����һ����ʱ�൱��
# �ⲽ�����󣬿�����primeview���ļ����п���һ������ļ�primeview.sqlite
populateDB("HUMANCHIP_DB", affy=F, prefix="primeview", fileName="primeviewHumanGeneExprs.txt", metaDataSrc=c("DBSCHEMA"="HUMANCHIP_DB", "ORGANISM"="Homo sapiens", "SPECIES"="Human", "MANUFACTURER"="Affymetrix", "CHIPNAME"="PrimeView Human Gene Expression Array", "MANUFACTURERURL"="http://www.affymetrix.com"), baseMapType="eg", outputDir="primeview");
# �������ݿ����ӣ�ָ������ģ��"HUMANCHIP.DB"�����ݰ�������"primeview.db"�Լ��汾��"1.0.0"�������Ϣ
seed<-new("AnnDbPkgSeed", Package = "primeview.db", Version="1.0.0", PkgTemplate="HUMANCHIP.DB", AnnObjPrefix="primeview");
# ��primeview���ļ��У� ��������primeview.db�ļ�
makeAnnDbPkg(seed, file.path("primeview", "primeview.sqlite"), dest_dir="primeview");



# ��4.12
# ��װ��������Ӧ��R��
#source("http://bioconductor.org/biocLite.R");
#biocLite("AnnotationDbi");
#biocLite("AnnotationForge");
library(AnnotationDbi);
library(AnnotationForge);
# �鿴���еĿ���ģ��
available.chipdbschemas();
# �ڵ�ǰĿ¼���½�����primeview���ļ���
dir.create("primeviewdb");
# ֱ��ʹ��affy��ע���ļ���ͨ���Զ�������primeviewdb�ļ���������sqlite�ļ�
# ��primeviewdb���ļ��У���������primeview.db�ļ�
makeDBPackage("HUMANCHIP_DB", affy=TRUE, prefix="primeviewdb", fileName="PrimeView.na32.annot.csv", baseMapType="eg", outputDir="primeviewdb", version="1.0.0", manufacturer="affymetrix", chipName="PrimeView Human Gene Expression Array", manufacturerUrl="http://www.affymetrix.com");
# ������µĻỰ��Ϣ
sessionInfo();
