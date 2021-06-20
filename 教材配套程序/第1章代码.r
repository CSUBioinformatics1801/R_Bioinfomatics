#######################
## ��װ������Ҫ��R�� ##
#######################
#�Ѱ�װ��R��
pkgs <- rownames(installed.packages())
#���������
packages_1=c("ggmap","maps","XML","ggplot2","maproj","igraph","quantmod","scales")
#��Ҫ��װ��R��
packages_2=setdiff(packages_1,pkgs) 
#��װ����R�� 
install.packages(packages_2)


##�򵥵��﷨֪ʶ##
#��ֵ����
x <- c(1,2,3,4)
x

#�ӷ�����
c(1,2,3,4) + c(3,4,5,6)

#�ַ�����
c("hello world", "I am a R user")

#���ú���exp����0����Ȼָ��
exp(0)

#����һ������ (1,2,3,4)
x<-1:4
#����x��ÿ��ֵ��ָ��
exp(x)

#����Բ����ĺ���������뾶Ϊ4��Բ���
area<-function(x){  
 result<-pi*x^2
 return(result)
}
area(4)

#����������ֵ�ĺ����
add.diff<-function(x,y){
 add<-x+y
 diff<-x-y
 return(c(add,diff))
}
#���ú���add.diff������5��3�ĺ����
add.diff(x=5,y=3)  


#############
##  ��1-1  ##
#############

library(ggplot2)  #����ggplot2��
library(ggmap)  #����ggmap��
library(XML)   #����XML��
library(maps)    #����maps��
library(mapproj)  #����mapproj��

# ������������ַ��Ϊ�ַ�������url������
url <- 'http://data.earthquake.cn/datashare/globeEarthquake_csn.html';
#windows�¿���Ҫ������������
url= htmlParse(url,encoding="UTF-8")
# �Ը���ҳ���ݽ��н�������ȡ���е����б�񣬲�����tables������
tables <- readHTMLTable(url,stringsAsFactors = FALSE); 
# ȡ����������ĵ�6����񣬴������raw��
raw <- tables[[6]] ;  
#�鿴���ĵ�һ�����ݣ����ﲻ��ʾ�����
raw[1,]
# ֻ����ʱ�䡢���ȡ�γ�����������ݣ����������data��
data <- raw[ ,c(1,3,4)] ;  
# �޸�data�����ı����е�����Ϊ'date'��'lan'��'lon'��
names(data) <- c('date','lan','lon') ;
# ������(data$lan)��γ��(data$lon)�����������ú���as.numeric����ת��Ϊ��ֵ����
data$lan <- as.numeric(data$lan) ;
data$lon <- as.numeric(data$lon) ;
# ��ʱ��(data$date)�����������ú���as.Date����ת��Ϊʱ������("%Y-%m-%d"))
data$date <- as.Date(data$date, "%Y-%m-%d");
# ��ggmap����ȡ��ͼ���õ�ͼ����Ϊ 'china'���Ŵ�4������ͼ����Ϊ����ͼ����ΧΪ����ͼ���豸��+ ����ɢ��ͼ��ɢ��������Դ��data���ݿ������ݾ�γ����Ϊ����ֵ��ɢ����ɫΪ��ɫ��͸����Ϊ0.7��ͼ��λ���ޣ���
ggmap(get_googlemap(center='china', zoom=4, maptype='terrain'), extend='device')+
  geom_point (data=data, aes(x=lon,y=lan), colour='red', alpha=0.4)+
  opts(legend.position="none");

#############
##  ��1-2  ##
#############

#����igraph��
library (igraph);
#����Barabasi-Albertģ������һ�����磬���������100���ڵ㣬ÿ������ʱ����һ���� #��m=1��������g��һ�����󣨲μ������£�����������������������Ϣ
g <- barabasi.game (100, m=1);
plot( g,                        #��ͼ�Ķ�����g
 vertex.size=4, # ����Ĵ�С����Ϊ4
 vertex.label=NA, # ����ı�ǩ����Ϊ��
 edge.arrow.size=0.1, # ��֮�����ߵļ�ͷ��С����Ϊ0.1
 edge.color="grey40", # ��֮�����ߵ���ɫ����Ϊ�Ҷ�
 layout=layout.fruchterman.reingold, # ��������Ĳ��ַ�ʽ
 vertex.color="red", # �������ɫ����Ϊ��ɫ
 frame=TRUE);   #��ͼ��������߿�

#############
##  ��1-3  ##
#############

#����quantmod��
library(quantmod)  
# getSymbols�����Զ�����Yahoo����Դ�����뱣֤����������������ȡ������Դ��SSEC #����ָ֤����Yahoo���룩��ʱ�䷶Χ�Ǵ� '2011-01-01' �� '2012-07-13'
getSymbols('^SSEC', from = '2011-01-01', to='2012-07-13')
#�õ������ݱ�����SSEC��������У��鿴���ĵ�һ�����ݣ����ﲻ��ʾ���
SSEC[1,]
#��ͼK��ͼ��ʱ���������4���£�����ʹ�ð�ɫ����ͼ����ʹ�������ļ���ָ��(TA)
candleChart (last(SSEC,'4 months'), theme=chartTheme('white'), TA=NULL)
# ���MACDָ�꣬ʹ��Ĭ�ϲ���
addMACD()

#############
##  ��1-4  ##
#############

library(ggplot2);  #����ggplot2����
library(scales);   #����scales����
revigo.names <- c("term_ID", "description", "frequency_%", "plot_X", "plot_Y", "plot_size", "log10_p_value", "uniqueness", "dispensability");
revigo.data <- rbind(c("GO:0009698", "phenylpropanoid metabolic process",  0.024,  1.380, -8.143,  3.438, -6.7645, 0.675, 0.000), 
c("GO:0021722", "superior olivary nucleus maturation",  0.000, -4.773,  3.914,  0.845, -3.5935, 0.874, 0.000), 
c("GO:0019748", "secondary metabolic process",  0.081, -6.414,  0.228,  3.966, -5.0550, 0.909, 0.007), 
c("GO:0042440", "pigment metabolic process",  0.324, -0.765,  0.844,  4.568, -4.3893, 0.909, 0.009), 
c("GO:0051299", "centrosome separation",  0.001,  0.901, -5.814,  1.771, -3.0482, 0.902, 0.012), 
c("GO:0052695", "cellular glucuronidation",  0.000,  6.070, -2.020,  1.398, -6.7645, 0.667, 0.023), 
c("GO:0042501", "serine phosphorylation of STAT protein",  0.001,  4.269,  4.220,  1.944, -3.5935, 0.760, 0.025), 
c("GO:0016101", "diterpenoid metabolic process",  0.005, -4.590, -4.132,  2.772, -3.5346, 0.763, 0.028), 
c("GO:0090313", "regulation of protein targeting to membrane",  0.000,  1.015,  6.202,  1.230, -3.5935, 0.822, 0.133), 
c("GO:0010225", "response to UV-C",  0.001,  6.233,  3.496,  2.121, -3.1409, 0.864, 0.171), 
c("GO:0006063", "uronic acid metabolic process",  0.025,  6.023, -2.786,  3.461, -5.4473, 0.697, 0.408), 
c("GO:0006069", "ethanol oxidation",  0.015,  5.585, -3.328,  3.222, -3.1555, 0.762, 0.427), 
c("GO:0006720", "isoprenoid metabolic process",  0.401, -3.931, -4.897,  4.660, -3.1707, 0.775, 0.481), 
c("GO:0021819", "layer formation in cerebral cortex",  0.000, -4.381,  4.333,  1.740, -3.5935, 0.845, 0.559), 
c("GO:0001523", "retinoid metabolic process",  0.003, -4.238, -4.361,  2.480, -3.6819, 0.741, 0.595), 
c("GO:0090314", "positive regulation of protein targeting to membrane",  0.000,  0.506,  6.348,  0.301, -3.5935, 0.827, 0.598),
c("GO:0052697", "xenobiotic glucuronidation",  0.000,  5.854, -0.744,  1.114, -6.9626, 0.570, 0.617));
#���¶������ݸ�ʽ��ת��
one.data <- data.frame(revigo.data);  #�����ʽת��Ϊ���ݿ��ʽ
names(one.data) <- revigo.names;    #�ı��������
#ֻ����x��y���궼��Ϊnull��������ֵ����
one.data <- one.data [(one.data$plot_X != "null" & one.data$plot_Y != "null"), ];
one.data$plot_X <- as.numeric( as.character(one.data$plot_X) );#factor����ת�ַ�����ת����
one.data$plot_Y <- as.numeric( as.character(one.data$plot_Y) ); #ͬ��
one.data$plot_size <- as.numeric( as.character(one.data$plot_size) ); #ͬ��
one.data$log10_p_value <- as.numeric( as.character(one.data$log10_p_value) ); #ͬ��
one.data$frequency <- as.numeric( as.character(one.data$frequency) ); #ͬ��
one.data$uniqueness <- as.numeric( as.character(one.data$uniqueness) ); #ͬ��
one.data$dispensability <- as.numeric( as.character(one.data$dispensability) ); #ͬ��
#����ʹ��ggplot��ͼ
p1 <- ggplot( data = one.data );    #����������ͼ����,����ͼ�������ݴ��ݸ��ö���
p1 <- p1 + geom_point( aes( plot_X, plot_Y, colour = log10_p_value, size = plot_size), alpha = I(0.6) ) + scale_area();   #ȷ��X�ᡢY�ᡢ��ɫ����С��͸���ȵ�ӳ�����
p1 <- p1 + scale_colour_gradientn (colours = c("blue", "green", "yellow", "red"), limits = c( min(one.data$log10_p_value), 0) );  #ȷ����ɫ���ȵı�ȿ���
p1 <- p1 + geom_point( aes(plot_X, plot_Y, size = plot_size), shape = 21, fill = "transparent", colour = I (alpha ("black", 0.6) )) + scale_area();      #��ӵ�ͼ���󣬲�������ɫ
p1 <- p1 + scale_size( range=c(5, 30)) + theme_bw();    #���õ�Ĵ�С���
ex <- one.data [ one.data$dispensability < 0.15, ];    #����ȡ�Ӽ���ֻҪ���һ��С��0.15�ģ�
p1 <- p1 + geom_text( data = ex, aes(plot_X, plot_Y, label = description), colour = I(alpha("black", 0.85)), size = 3 );            #������ֶ���������ɫ�ʹ�С
p1 <- p1 + labs (y = "semantic space x", x = "semantic space y");    #���X���Y��˵��
p1 <- p1 + opts(legend.key = theme_blank()) ;   #���ͼ��˵��
#����������X���Y��Ŀ̶���
one.x_range = max(one.data$plot_X) - min(one.data$plot_X);
one.y_range = max(one.data$plot_Y) - min(one.data$plot_Y);
p1 <- p1 + xlim(min(one.data$plot_X)-one.x_range/10,max(one.data$plot_X)+one.x_range/10);
p1 <- p1 + ylim(min(one.data$plot_Y)-one.y_range/10,max(one.data$plot_Y)+one.y_range/10);
p1; #ִ�л�ͼָ��

