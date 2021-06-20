#####################################
#3.2 ��R������Bioconductor��ʵ�ֿ���#
#####################################

#����������������������������������������������������������������������������
##################################
#A. �������е��뺯��'seq_import'#
##################################
seq_import<- function(input_file) {
  # ���ж�ȡ���ݣ�����������my_fasta������ÿ��Ԫ�ض�Ӧ�ļ�input_file�е�һ�У�
  #�����Ժ����ͨ����������my_fasta����������Ӧ�ļ����С�
  my_fasta<- readLines(input_file);
  
 # �ж�my_fasta��ÿ��Ԫ�ص�һ����ĸ�Ƿ��ǡ�>������ʾһ��fasta��¼��ע��
#�У����жϽ����1��-1��ʾ������������y��
  y <- regexpr("^>", my_fasta, perl = T);

  # ����y��Ϊ1��Ԫ���滻Ϊ0���������ж�Ӧ-1��ע���ж�Ӧ0��
  # �������ֻ��һ��ϰ�����⣬���Ǳ���ġ�
  y[y == 1] <- 0;

  # ��index��¼��y��ȫ��0���������е�λ�ã���Ӧע���е��кš�
  index<- which(y == 0) ;

  # �������ݿ�distance��������1��start�������һ��fasta��¼�������ע�� 
#�е�λ�ã��͵�2��end������һ��fasta��¼�������ע���е�λ�ã���
  distance <- data.frame(start = index[1:(length(index) - 1)], end = index[2:length(index)]);

  # �����ݿ�distance�������һ�У�����Ԫ�أ�����1�������һ��fasta��¼��
  #ע����λ�ã���2����Ϊ�����е�����+1����
  distance<- rbind(distance, c(distance[length(distance[, 1]), 2], length(y) + 1));

  # �����ݿ�distance�����1�У���ֵ�ǵ�2�к͵�1��֮�ע����֮��ľ��룬
#ʵ���Ͼ���ÿ�����м�¼��Ӧ��������
  distance <- data.frame(distance, dist = distance[, 2] - distance[, 1]);

  # ������1��ʼ���������������������ȵ���ע���е�������
  seq_no<- 1:length(y[y == 0]);

  # �ظ�����������seq_no�е�ÿһ��Ԫ�أ��ظ�����Ϊ�����ٽ�ע����֮��ľ��� 
#����distance[, 3]����
  index<- rep(seq_no, as.vector(distance[, 3]));

  # ����һ���µ����ݿ���������ƻ���my_fasta������3�����ݣ���1����index��
#��2����y����3���Ǿɵ�my_fasta��
  my_fasta<- data.frame(index, y, my_fasta);

  # ���ݿ�my_fasta�У���2��Ϊ0��Ԫ�أ���Ӧ�ĵ�1�и�ֵΪ0��
  my_fasta[my_fasta[, 2] == 0, 1] <- 0;

  # tapply��������paste�������ַ������ӹ��ܣ���my_fasta[, 3]�е�ͬһ��
#Ԫ�غϲ���my_fasta[, 3]������ɶ�Ӧmy_fasta[, 1]���������������硰0����ʾ
#�������е�ע���У���1����ʾ��һ����¼���������ݣ��Դ����ơ�
  seqs <- tapply(as.vector(my_fasta[, 3]), factor(my_fasta[, 1]), paste, collapse ="", simplify = F);

  # ������seq����������ת��Ϊ�ַ�����������������1��Ԫ�أ�����ע���У���ʣ��
#������Ϊ���м�¼�����С�
  seqs <- as.character(seqs [2:length(seqs)]);

  # ��my_fasta[, 3]����ȡ���е�ע���У���������Desc��
  Desc<- as.vector(my_fasta[c(grep("^>", as.character(my_fasta[, 3]), perl =TRUE)), 3]);

  # ����һ���µ����ݿ���������ƻ���my_fasta��ÿ�ж�Ӧһ�����м�¼������3����Ϣ�����е�ע�ͣ����Ⱥ��������ݣ���
  my_fasta<- data.frame(Desc, Length =nchar(seqs), seqs);

  # ��my_fasta��һ�е�ע��������ȡ���е�ID(Accession Number)��
  Acc<- gsub(".*gb\\|(.*)\\|.*", "\\1", as.character(my_fasta[, 1]), perl = T);

  # ���ַ�������Acc��ӵ����ݿ���ߣ���Ϊһ�С�
  my_fasta<- data.frame(Acc, my_fasta);

  # ��my_fasta���أ�����ϰ���Եģ�R�������ֵ�������Ϊ����ֵ��
  my_fasta;
}
#��������������������������������������������������������������������������






#_____________________________________________________________________________
#######################################
#B. ����ģʽƥ�亯��'pattern_match'#
#######################################
pattern_match<- function(pattern, sequences, hit_num) {

  # ��ȡ������ʽpattern��ʾ��ģ�������������г��ֵ�λ�ã�δ�ҵ�ƥ�佫����
#-1��������λ�ô���һ���б����pos��perl=T��ʾ����perl��������ʽ��ʽ��
  pos<- gregexpr(pattern, as.character(sequences[, 4]), perl= T);

  # lapply��������paste�������ַ������ӹ��ܣ���pos�е�ÿ����Ա�ĵ�һ��Ԫ�ز���������
#�������ӳ�һ���ַ���������unlist�����õ��б�ת��Ϊ����posv��
  posv<- unlist(lapply(pos, paste, collapse =", "));

  # ������posv��ֵΪ-1���ֵΪ0������ʾ��������δ�ҵ�ģ��pattern��
  posv[posv == -1] <- 0;

  # lapply���������Զ��庯��function������pos�е�ÿһ��Ԫ�أ�����
#pattern��ÿ��������ƥ��ĸ���������unlist���������ת��Ϊ������
  hitsv<- unlist(lapply(pos, function(x) if (x[1] == -1) {0} else {length(x)})); 
 
  # ����һ�����ݿ����͵Ľ��sequences��������ԭ��sequences���ݵĵ�1��2��
#3��4�У��ֲ�����2�У���ƥ��λ�㣨Position����ƥ�������Hits����
  sequences <- data.frame(sequences[, 1:3], Position = as.vector (posv), Hits =hitsv, sequences[, 4]);

  # �ҳ�ƥ���������hit_num�����У�������д��ʽ�滻ΪСд��gsub�е�һ������
#[A-Z]ƥ�������д��ĸ����\\L\\1����ʾ��ǰ��С������ƥ���������ĸ�滻Ϊ��Сд��ʽ��
  tag <- gsub("([A-Z])", "\\L\\1", as.character(sequences[sequences[, 5]> hit_num, 6]), perl = T, ignore.case = T);

  # Ϊģ��pattern����С���ţ����ʺ�perl������ʽ��ʽ����������ʹ�á�
  pattern2 = paste("(", pattern, ")", sep ="");

  # ��tag�����У���ģ��patternƥ��Ĳ����滻Ϊ��д��ԭ��ͬ�ϣ���\\U\\1����ʾ
#�滻Ϊ��д��
  tag<- gsub(pattern2, "\\U\\1", tag, perl = T, ignore.case = T);

  # �ҳ�ƥ���������hit_num�����У��������������滻Ϊtag�е��������ݣ�����
#���ݿ�export��
  export<- data.frame(sequences[sequences[, 5] > hit_num,-6],tag);

  # Acc��ǰ���fasta��ʽ��ʶ��>�����õ����ݿ�export����1����Acc����2��
#��Сд��ĸ��ʾ�ĵ��������У�ģʽ�ô�д��ʾ��
  export<- data.frame(Acc =paste(">", export[, 1], sep =""), seq = export[,6]);   
                                                               
  # ���ݿ�export����ת����������ļ�Hit_sequences.fasta��fasta�ļ���ʽ��
  write.table(as.vector(as.character(t(export))), file = "Hit_sequences.fasta", quote = F, row.names = F, col.names = F);

  # �����ʾ��Ϣ
  cat("����ģ��\"", pattern, "\"����", hit_num, "�������е�����������д�뵱ǰ����Ŀ¼���ļ�'Hit_sequences.fasta'", "\n", sep ="");

  # ѡ��ƥ�������sequences�ĵ�5�У�����hit_num������
  selected<- sequences[sequences[, 5] >hit_num, ];

  # �����ʾ��Ϣ
  cat("�������ιž����������������к���ģ��\"", pattern, "\"����������2����", "\n", sep ="");

  # ���ѡ�����еĵ�1��5�е��նˣ���6������������̫��������ʾ
  print(selected[, 1:5]);

  # ����ѡ������
  selected;
}
#_____________________________________________________________________________








#_____________________________________________________________________________
############################################
#C. ���就���Ậ��ͳ�ƺ���'getAApercentage'#
############################################
getAApercentage<- function(sequences) {
  # ����һ������20�ֱ�׼�����ᵥ��ĸ��д�����ݿ�AA��
  AA <- data.frame(AA =c("A", "C", "D", "E", "F", "G", "H", "I", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "Y"));

  # strsplit��������������sequences[, 6])ת�����ַ����飬lapply�������� 
#table����ͳ��ÿ�������и��ַ��������ᣩ���ֵĴ�����
  AAstat<- lapply(strsplit(as.character(sequences[, 6]), ""), table);

  # ����ѭ��ÿ�δ���һ�����У�ȫ�����й�length(AAstat)����
  for (i in 1:length(AAstat)) { 
    # ����ÿ��������20�ְ�������ֵİٷֱȡ�
AAperc<- AAstat[[i]]/sequences[, 3][i] * 100;

    # ת��Ϊ���ݿ򣬵�1���ǰ��������࣬��2���ǰٷֱȺ�����
AAperc<- as.data.frame(AAperc);

    # �����ݿ��2�����Ƹ�Ϊ��i�����е�Acc��
names(AAperc)[2] <- as.vector(sequences[i, 1]);

    # ͨ��AA�е�����Ϊ��AA�����к�AAperc������Ϊ��Var1������֮���Ԫ��ͬ��ӳ��ϲ�#AA��AAperc��������һ���µĶ���AA��������������ʵ�ʾ��ǰ��ա�AA����20�ְ���       
    #���˳�򲻶������ÿ�������еķֲ����ݣ�ÿ��ѭ������һ�С�
    AA <- merge(AA, AAperc, by.x ="AA", by.y ="Var1", all = T);
  }#ѭ��������

  # ��AA�а����������ٷֱ�Ϊ��NA�����ֵΪ0��
  for (i in 1:length(AA[[1]])) { #��ѭ���ܴ�����20���ְ����ᣩ��
    for (j in 1:length(AA)) {    #��ѭ���ܴ�������������+1
      if (is.na(AA[i, j])) {     #������֡�NA�� ��
        AA[i, j] <- 0;           #�滻Ϊ0��
      }
    }
  }#ѭ��������

  # ͳ������������ÿ�ְ�������ֵ�ƽ���ٷֱȣ�����AA���һ�С�
  AApercentage <- data.frame(AA, Mean =apply(AA[, 2:length(AA)], 1, mean, na.rm = T));

  # ������AApercentage�����ͬ����csv�ļ���
  write.csv(AApercentage, file ="AApercentage.csv", row.names = F, quote = F) ;

  # ��ʾ������ɡ�
  cat("������ֲ������Ѿ�д�뵱ǰ����Ŀ¼�µ��ļ�'AApercentage.csv'", "\n");

  # ����AApercentage��
  AApercentage;
}
#_____________________________________________________________________________







#_____________________________________________________________________________
####################################
#D. ���������ȶԺ���'seq_alignment'#
####################################
seq_alignment<- function(sequences) {
      # shell�ɵ��ò���ϵͳ����������ַ�����ʽ������delΪwindowsϵͳ�ϵ�ɾ�����/fѡ���ʾǿ��ɾ��ֻ���ļ���my_needle_fileΪ��Ҫɾ�����ļ�������������Ŀ����ɾ���ϴγ������еĽ���ļ������򱾴����н����׷��д���ϴεĽ���ļ���
	shell("del /f my_needle_file");

      # ����ѭ��ÿ��дһ�����д���file1����һ������file2��Ȼ�����needle�������ȶԣ�����ÿ�ζ��ǶԱ��������У����׷��д�����ļ���
	for (i in 1:length(sequences[, 1])) {

      # ��1������д��file1��fasta��ʽ����
		cat(as.character(paste(">", as.vector(sequences[i, 1]), sep ="")), as.character(as.vector(sequences[i, 6])), file ="file1", sep ="\n");

		for (j in 1:length(sequences[, 1])) {
                    # ��2������д��file2��fasta��ʽ����
			cat(as.character(paste(">", as.vector (sequences[j, 1]), sep ="")), as.character(as.vector(sequences[j, 6])), file ="file2", sep ="\n");

                    # ����needle����Ա�file1��file2�е����У����׷��д���ļ���my_needle_file����
			shell("needle file1 file2 stdout -gapopen 10.0 -gapextend 0.5 >> my_needle_file");
		}
	}
      # ��ʾ���
	cat("Needle��������������е������ȶԣ���������ļ�\"my_needle_file\"\n");
}   
#_____________________________________________________________________________




#____________________________________________________________________________
#########################################
#E1. ���庯��'getScoreMatrix'��÷־���#
########################################
getScoreMatrix<- function(sequences) {
    # ��ȡmy_needel_file�е������У���������score��
score <- readLines("my_needle_file");

    # �����ԡ�# Score����ͷ���У���# Score: 290.5������������score��
score <- score[grep("^# Score", score, perl = T)];

    # �������β���ո���ַ����滻Ϊ�գ�ֻ����score��������ֵ÷֡�
score <- gsub(".* ", "", as.character(score), perl = T);

    # ���ַ�����תΪ��ֵ������
score <- as.numeric(score);

    # ��scoreת��Ϊn*n����ֵ����nΪ��������length(sequences[, 1])
scorem<- matrix(score, length(sequences[, 1]), length (sequences[, 1]),dimnames =list(as.vector(sequences[, 1]), as.vector(sequences[, 1])));

    # �÷־����������õ���ͨ���������as.dist����ת��Ϊ�����Ǿ������
scorem.dist<- as.dist(1/scorem);

    # ���ݾ�����󣬵��ò�ξ��ຯ��hclust���������о��ࡣ
hc<- hclust(scorem.dist, method ="complete");

    # ���Ʋ�ξ�������
    plot(hc, hang = -1, main ="Distance Tree Based on Needle All-Against-All Comparison", xlab =" sequence name", ylab ="distance");

    # ���رȶԵ÷־���
    scorem;
}
#____________________________________________________________________________









#_____________________________________________________________________________

##############################
#E2. ���庯��'infile_produce'#
##############################
infile_produce<- function(scorem) {
    # ��÷־���������Ϊ�������
z <- 1/scorem;

    # ����scorem�л��еĳ���
len = sqrt(length(scorem)) ;

    # ����������жԽ��߸�ֵΪ0��seq����һ����1��length(scorem)��������byΪ�����������е�ֵ���Խ���Ԫ����z�е�λ��
z[seq(1, length(scorem), by = (len + 1))] <- 0;

    # ����round������z����ֵ������С�����7λ
z <- round(z, 7) ;

    # ���len������Ϣ��infile
write.table(len, file ="infile", quote = F, row.names = F, col.names = F) ;

    # ׷�ӣ�append=T������������z��infile
write.table(as.data.frame(z), file ="infile", append = T, quote = F, col.names = F, sep ="\t");

#�����ʾ
    cat("Phylip��ʽ�ľ�������Ѿ����������Ŀ¼����Ϊ'infile'���ļ����Ա�ʹ��Phylip����������з�����",  "\n");
}














################
#3.2.2 ����ʵ��#
################
#_______________________________________________
#################################
#A. ���ú���'seq_import'��������#
################################
setwd("C:/workingdirectory");
my_file<- "AE004437.faa";
my_sequences<- seq_import(input_file = my_file);

#B. ���ú���'pattern_match'Ѱ��ģ��
hit_sequences<- pattern_match(pattern ="H..H{1,2}", sequences = my_sequences, hit_num =2)
AA_percentage<- getAApercentage(sequences = hit_sequences)

#D. ���ú���'seq_alignment'�������������ȶ�
seq_alignment(sequences = hit_sequences)

#E1. ���ú���'getScoreMatrix'�õ��÷־���
score_matrix<- getScoreMatrix(sequences = hit_sequences)

#E2. ���ú���'infile_produce'����PHYLIP����������ļ�infile
infile_produce(scorem = score_matrix)
#_________________________________________________________







#############################################
#3.3 ��R����Bioconductor����ʵ�ֿ��⣨����һ��
#############################################
#_________________________________________________________
#####################################
#A. �������е��뺯��'bio_seq_import'#
#####################################
bio_seq_import<- function(input_file) {
      # ����fasta�ļ����������my_fasta
	my_fasta <- read.AAStringSet(input_file);

      #��my_fasta��һ�е�ע��������ȡ���е�ID(Accession Number)��
	Acc<- gsub(".*gb\\|(.*)\\|.*", "\\1", as.character(my_fasta[, 1]), perl = T);
     
      #�޸�my_fasta�����names����
	names(my_fasta)<-Acc;

	my_fasta;
}






#B. ����ģʽƥ�亯��'bio_pattern_match'
bio_pattern_match<- function(pattern, sequences, hit_num) {
  # ��sequences�����л�ȡ���������е����ݡ�
  seqs = as.character(sequences);

  # ��ȡ������ʽpattern��ʾ��ģ�������������г��ֵ�λ�ã�δ�ҵ�ƥ�佫����
#-1��������λ�ô���һ���б����pos��perl=T��ʾ����perl��������ʽ��ʽ��
  pos<- gregexpr(pattern, seqs, perl = T);

  # lapply���������Զ��庯��function,����pos�е�ÿһ��Ԫ�أ�����
#pattern��ÿ��������ƥ��ĸ���������unlist���������ת��Ϊ������
  hitsv<- unlist(lapply(pos, function(x) if (x[1] == -1) {0} else {length(x)})); 
 
  # �ҳ�ƥ���������hit_num�����У�������д��ʽ�滻ΪСд��gsub�е�һ������
#[A-Z]ƥ�������д��ĸ����\\L\\1����ʾ��ǰ��С������ƥ���������ĸ�滻Ϊ��Сд��ʽ��
  tag <- gsub("([A-Z])", "\\L\\1", as.character(sequences[hitsv > hit_num]), perl = T, ignore.case = T);

  # Ϊģ��pattern����С���ţ����ʺ�perl������ʽ��ʽ����������ʹ�á�
  pattern2 = paste("(", pattern, ")", sep ="");

  # ��tag�����к�ģ��patternƥ��Ĳ����滻Ϊ��д��ԭ��ͬ�ϣ���\\U\\1����ʾ�滻Ϊ��д��
  tag<- gsub(pattern2, "\\U\\1", tag, perl = T, ignore.case = T);

  # �����µ�AAStringSet����export����ѡ�е�������Ϣ����Сд��ϱ�ʾ�����ᣩ
  export <- AAStringSet(tag);

  # �������export���ļ�Hit_sequences.fasta��fasta�ļ���ʽ��
  write.XStringSet(export, file="Hit_sequences1.fasta");

  # �����ʾ��Ϣ
  cat("����ģ��\"", pattern, "\"����", hit_num, "�������е�����������д�뵱ǰ����Ŀ¼���ļ�'Hit_sequences.fasta'", "\n", sep ="");

  # �����ʾ��Ϣ
  cat("�������ιž����������������к���ģ��\"", pattern, "\"����������2����", "\n", sep ="");

  # ���ѡ�е�����
  print(export);

  # �����µ�AAStringSet����export����ѡ�е�������Ϣ����д��ʾ�����ᣩ
  selected <- AAStringSet(as.character(sequences[hitsv > hit_num]));

  # ����ѡ������
  selected;
}


#C. ���就���Ậ��ͳ�ƺ���'bio_getAApercentage'#

bio_getAApercentage<- function(sequences) {
# ����һ������20�ֱ�׼�����ᵥ��ĸ��д�����ݿ�AA��
AA <- data.frame(AA =c("A", "C", "D", "E", "F", "G", "H", "I", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "Y"));

# strsplit��������������sequences[, 6])ת�����ַ����飬lapply��������#table����ͳ��ÿ�������и��ַ��������ᣩ���ֵĴ�����
AAstat<- lapply(strsplit(as.character(sequences[, 6]), ""), table);
bio_getAApercentage<- function(sequences) {
      # ����һ������20�ֱ�׼�����ᵥ��ĸ��д�����ݿ�AA��
	AA <- c("A", "C", "D", "E", "F", "G", "H", "I", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "Y");
      # �õ�ÿ��������20�ְ�������ֵĴ���
	AApercentage <- letterFrequency(sequences, AA);

      # ����/���г��ȣ��õ�ÿ��������20�ְ�����İٷֺ���
      AApercentage <- t(AApercentage/width(sequences)* 100);
      
      # �޸����ݿ�AApercentage���е�����
	colnames(AApercentage) <- names(sequences);	
      
      # ��������뺯��getAApercentage����ͬ���ο���3-1�е�ע��
	AApercentage <- data.frame(AApercentage, Mean =apply(AApercentage[, 1:dim(AApercentage)[2]], 1, mean, na.rm = T));
	write.csv(AApercentage, file ="AApercentage.csv", row.names = F, quote = F) ;
	cat("������ٷֱȺ����Ѿ�д�뵱ǰ����Ŀ¼�µ��ļ�'AApercentage.csv'", "\n");
	AApercentage;
}

##########################################
#D. ���������ȶԺͺ���'bio_alignAndScore'#
##########################################
bio_alignAndScore<- function(sequences) {
      # ����һ���յĵ÷־��󣬳�ʼֵ��Ϊ0
     scorem=matrix(rep(0,length(sequences)*length(sequences)),nrow = length(sequences), ncol = length(sequences));
      # ����ѭ��ÿ�ζ��ǶԱ��������У��������÷־���scorem
	for (i in 1:length(sequences)) {
		for (j in 1:length(sequences)) {
                     #����pairwiseAlignment���������Ա�
			scorem[i,j]=pairwiseAlignment(sequences[[i]], sequences[[j]], type = "overlap", substitutionMatrix = "BLOSUM62", gapOpening = 9.5, gapExtension = 0.5,scoreOnly=T)
		}
	}
	cat("��������������е������ȶ�\n");
}
#_________________________________________________________




###############
#3.3.2 ����ʵ��
###############
#____________________________________________________________

#���ȣ���װBioconductor��չ����Biostrings����#
source("http://bioconductor.org/biocLite.R") ;
biocLite("Biostrings") ;
biocLite("ape") ;

#A. ���ú���'bio_seq_import'���뼫�����ιž��ĵ�������#
library("Biostrings")
my_file <- "AE004437.faa" 
my_sequences <- bio_seq_import(input_file = my_file)

#B. ���ú���'bio_pattern_match'Ѱ��ģ��
hit_sequences <- bio_pattern_match(pattern ="H..H{1,2}", sequences = my_sequences, hit_num =2)

#C. ���ú���' bio_getAApercentage'ͳ�ư�����ٷֺ���
AA_percentage<- bio_getAApercentage(sequences = hit_sequences)

#D. ���ú���'alignAndScore'�õ������ȶԵ÷־���
score_matrix<- bio_alignAndScore(sequences = hit_sequences)
#____________________________________________________________________



######################################
#3.4 ��R����Bioconductor����ʵ�ֿ���#
######################################
#_____________________________________________________
#E1. ���庯��'read.alignment'��'printMultipleAlignment'
printMultipleAlignment <- function(alignment, chunksize=60)
{
	#�˺�����ҪBiostrings��չ��
	require("Biostrings") ;
	# �Ӷ���alignment ����read.alignment���룩�еõ���������
	numseqs <- alignment$nb ;
	# �õ��������бȶ���һ��ʱ�����г��ȣ�=ԭʼ����+indel��
	alignmentlen <- nchar(alignment$seq[[1]]) ;
	# �趨��ʾʱ��ÿ��������ʼλ�ö�Ӧ�����е�ʵ��λ�ã�����趨ÿ����಻�ܳ���#60bp��chunksize=60��������ʼλ����1��61��121 ����������һ��chunk�������������е�һ�� #������60bp������
	starts <- seq(1, alignmentlen, by=chunksize) ;
             # �õ�chunk����
	n <- length(starts) ;
	# ��������������
	aln <- vector();  #ÿ��Ԫ����һ������
	lettersprinted <- vector(); #��Ӧ���������һλ��ԭʼ���е�λ��
             # ���ѭ����ȫ����������������
	for (j in 1:numseqs)
	{
                         # ÿ����ȡһ������
		aln[j]  <- alignment$seq[[j]] ;        
                         # ��ʼ������                  
		lettersprinted[j] <- 0 ;
	}
	# ÿ��ѭ������һ��chunk
	for (i in 1:n) { 
                          # ÿ��ѭ������һ������
		for (j in 1:numseqs)
		{
                                      # ÿ��ȡһ������
			alnj <- aln[j] ;
                                      # ȡ�����е�i��chunk���ȵ�Ƭ��
			chunkseqjaln <- substring(alnj, starts[i], starts[i]+chunksize-1) ;
                                       # �����е���ĸȫ��ת��Ϊ��д
			chunkseqjaln <- toupper(chunkseqjaln) ;
			# ͳ���ж��١�-��
			gapsj <- countPattern("-",chunkseqjaln) ;	
		             # chunk�ĳ��ȼ�ȥ��-������DNA��ĸ���������ۼӣ����ɶ�Ӧ��ԭʼ��#���е�λ��
			lettersprinted[j] <- lettersprinted[j] + chunksize - gapsj;
			# ��ӡchunk�е�Ƭ�Σ�Ȼ��������һλ�����ԭʼ�����е�λ��                         
			print(paste(chunkseqjaln,lettersprinted[j])) ;
		}
  			# ÿ��chunk��ӡ��ϣ���Ҫ��һ�У��ָ���chunk
print(paste(' ')) ;
	}
}



#E2. ���庯��'cleaned_aln'
cleanAlignment <- function(alignment, minpcnongap, minpcid)
{
     # ����һ�ݱ���alignment��copy�����ڴ洢���º����Ϣ������Ϊ����ֵ
     newalignment <- alignment;
     # �Ӷ���alignment ����read.alignment���룩�еõ���������
     numseqs <- alignment$nb;
     # �õ��������бȶ���һ��ʱ�����г��ȣ�=ԭʼ����+indel�� 
     alignmentlen <- nchar(alignment$seq[[1]]) ;

     # ��newalignment���������������ÿ�
     for (j in 1:numseqs) { newalignment$seq[[j]] <- "" };

     # ѭ��1��ʼ��ÿ��ѭ��������������е�һ��λ��
     for (i in 1:alignmentlen)
     {
        # �������nongap��¼��λ��gap����������ʼ��:
        nongap <- 0;
        # ÿ��ѭ������һ�������еĸ�λ�����ж���Ĳл�
        for (j in 1:numseqs)
        {
          # ȡ��j�����е����вл�
           seqj <- alignment$seq[[j]];
          # ֻ��ȡ��j�����е�i��λ�õĲл�
           letterij <- substr(seqj,i,i);
          # ������ֲ��ǡ�-����nongap�����ͼ�1
           if (letterij != "-") { nongap <- nongap + 1};
        }
         # ��i��λ�õ�nongap�������������������õ�nongap�İٷֱ�
        pcnongap <- (nongap*100)/numseqs;
        # ���ĳ��λ�õ�nongap �ٷֱȺ������ڵ�����ֵminpcnongap
        # �����ж�1��ʼ
        if (pcnongap >= minpcnongap)
        {
           # �����һ������������Ҫ���Ƿ������2������
           # ����������������1����¼�����л�����������2����¼��ͬ�л��Ե�����������ʼ����
           numpairs <- 0; numid <- 0;
           # ��������ѭ�����ڵ�i��λ�������вл��������Ƚ�
           for (j in 1:(numseqs-1))
           {
               # ֻ��ȡ��j�����е�i��λ�õĲл�
              seqj <- alignment$seq[[j]];
               # ֻ��ȡ��j�����е�i��λ�õĲл�
              letterij <- substr(seqj,i,i);
               # ��ȡ��k�����е�i��λ�õĲл���������j��iλ�ñȽ�
              for (k in (j+1):numseqs)
              {
                 seqk <- alignment$seq[[k]];
                 letterkj <- substr(seqk,i,i);
               # ��ȡ��k����j��������gap��
                 if (letterij != "-" && letterkj != "-")
                 {
               # �����л���������������1��
                    numpairs <- numpairs + 1;
               # �����Բл���ͬ����ͬ�л��Եļ�����1
                    if (letterij == letterkj) { numid <- numid + 1};
                 }
              }
           }
           # ��ͬ�л��Գ��������л����������õ�����
           pcid <- (numid*100)/(numpairs);
           # �����ж�2��ʼ���������ı���������ֵ
           if (pcid >= minpcid)
           {
               # �Ͱѵ�iλ���ϣ�����������Ӧ�Ĳл�����д�룬����Ͷ�����λ��
               for (j in 1:numseqs)
               {
                  seqj <- alignment$seq[[j]];
                  letterij <- substr(seqj,i,i);
                  newalignmentj <- newalignment$seq[[j]];
                  newalignmentj <- paste(newalignmentj,letterij,sep="");
                  newalignment$seq[[j]] <- newalignmentj;
               }
           } # �����ж�2����
        } # �����ж�1����
     }  # ѭ��1����
     return(newalignment);
}


#E3. ���庯��'unrootedNJtree'
unrootedNJtree <- function(alignment,type)
{
     # ���������Ҫ ape �� seqinR ��չ��:
     require("ape");
     require("seqinr");
     # ����һ��������ע�������֪ʶ�㣬�Ǻ����ڶ��庯��
     makemytree <- function(alignmentmat)
     {
     # as��ͷ�ĺ������Ǹ�ʽת��
        alignment <- ape::as.alignment(alignmentmat);
     # ������������ǵ�����
        if      (type == "protein")
        {
     # �ӱȶԽ�������еõ�һ�������������
           mydist <- dist.alignment(alignment);
        }
     # �������������DNA
        else if (type == "DNA")
        {
     # as��ͷ�ĺ��������ڸ�ʽת��
           alignmentbin <- as.DNAbin(alignment);
     # �ӱȶԽ�������еõ�һ�������������
           mydist <- dist.dna(alignmentbin);
        }
     # ����λ��������Neighbor-joining����������������
        mytree <- nj(mydist);
     # �������Ľ��������󷵻�
        return(mytree);
     }
     # as��ͷ�ĺ��������ڸ�ʽת��
     mymat  <- as.matrix.alignment(alignment);
     # �������涨��ĺ�������������
     mytree <- makemytree(mymat);
     # �Թ����Ľ��������Ծ٣�bootstrap������
     myboot <- boot.phylo(mytree, mymat, makemytree);
     # �����������������޸���
     plot.phylo(mytree,type="u");
     # �ڻ��õĽ���������ʾ�Ծ�ֵ
     nodelabels(myboot,cex=0.7);   
     # ���Ծ�ֵ�趨Ϊ�ڵ�ı�ǩ
     mytree$node.label <- myboot;  
     # ���ع����Ľ�����������
     return(mytree);
}


#E4. ���庯��'rootedNJtree'
rootedNJtree <- function (alignment, theoutgroup, type)
{
     # �������󲿷ִ�����unrootedNJtree������ͬ�����ֻע�Ͳ�ͬ�����
     require("ape");
     require("seqinr");
     # ����һ������������һ������������ָ�������������䵱��
     makemytree <- function (alignmentmat, outgroup=`theoutgroup`)
     {
        alignment <- ape::as.alignment(alignmentmat);
        if      (type == "protein")
        {
           mydist <- dist.alignment(alignment);
        }
        else if (type == "DNA")
        {
           alignmentbin <- as.DNAbin(alignment);
           mydist <- dist.dna(alignmentbin);
        }
        mytree <- nj(mydist);
     # ������Ҫָ������������Ϊ��
        myrootedtree <- root(mytree, outgroup, r=TRUE);
        return(myrootedtree);
     }
     mymat  <- as.matrix.alignment(alignment);
     # ���ﺯ�����ã�Ҳ����һ������
     myrootedtree <- makemytree(mymat, outgroup=theoutgroup);     
     myboot <- boot.phylo(myrootedtree, mymat, makemytree);
     # �����������������и���
     plot.phylo(myrootedtree,type="p");
     nodelabels(myboot,cex=0.7);   
     myrootedtree$node.label <- myboot;  
     return(myrootedtree);
}
#____________________________________________________________________________


################
#3.4.2 ����ʵ��#
################
#___________________________
install.packages('seqinr');
install.packages('ape');

#E1. ������ضԱȽ������ʾ�����˹��鿴
library('seqinr')
hit_aln  <- read.alignment(file = "Hit_sequences.clustalw", format = "clustal");
printMultipleAlignment(hit_aln, 60)


#E2. ȥ�����رȶ��еĵ�������
cleaned_aln <- cleanAlignment(hit_aln, 25, 25)

#E3. ���ݶ��رȶԽ�������޸���
install.packages('ape')
library('ape')
unrooted_tree <- unrootedNJtree(cleaned_aln,"protein")

#E4. ���ݶ��رȶԽ�������и���
rooted_tree <- rootedNJtree(cleaned_aln, "AAG19157.1", "protein")
#_____________________________________________________________________


