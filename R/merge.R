

setwd("D:/workplace_milly/TW Database/COMPANY INFO")

library(plyr)
library(stringr)



# google���
google_info <- read.csv("raw data/google_info.csv", stringsAsFactors = FALSE)
google_info <- unique(google_info)
google_info$GUI <- sprintf("%08d", google_info$GUI)

# �R���a�}�PGUI�@�P���Ъ��C
# GUI���ƪ���m
double_GUI <- data.frame(table(google_info$GUI))
double_GUI <- as.character(double_GUI[which(double_GUI$Freq != 1), "Var1"])
pos_double_GUI <- which(google_info$GUI %in% double_GUI)
# �a�}���ƪ���m
double_add <- data.frame(table(google_info$google.address))
double_add <- as.character(double_add[which(double_add$Freq != 1), "Var1"])
pos_double_add <- which(google_info$google.address %in% double_add)
# intersect of address and GUI
pos <- intersect(pos_double_GUI, pos_double_add)
if (length(pos) != 0) {
  google_info <- google_info[-pos, ]
}

t <- data.frame(table(google_info$GUI))
t <- as.character(t[which(t$Freq != 1), "Var1"])
pos <- which(google_info$GUI %in% t)
if (length(pos) != 0) {
  google_info <- google_info[-pos, ]
}
google_info <- google_info[, -1]



# ��T�����
trade <- list.files("raw data/", "trade")
trade <- trade[length(trade)]
trade <- read.csv(paste0("raw data/", trade), stringsAsFactors = FALSE)

# �g�ٳ��]�F�q���
gcis <- list.files("raw data/", "gcis")
#gcis <- gcis[1]
gcis <- read.csv(paste0("raw data/", gcis), stringsAsFactors = FALSE)
gcis <- unique(gcis)
names(gcis) <- c("GUI", "��´����", "���q���A", "��~����")

# �X��
# tw_data <- join(gcis, trade)
tw_data <- join(trade, gcis)

# �W�[�������
tw_data$`����` <- substr(tw_data$`�a�}`, 1, 3)

# mappping google information
tw_data <- join(tw_data, google_info)



# �վ����W�ٻP��춶��
names(tw_data)[which(names(tw_data) == "����W��") ] <- "company"



# ���W�ٶ���
nm <- c(names(tw_data)[1:5], "google.address", names(tw_data)[6:13], "google.tel", names(tw_data)[14:28], "����", names(tw_data)[29:31])
tw_data <- tw_data[, nm]

# �s��
# write.csv(tw_data, "../tw_data_0522.csv", row.names = FALSE, na = "")
write.csv(tw_data, paste0("../", gsub("gcis", "tw_data", list.files("raw data/", "gcis"))), na = "", row.names = FALSE)
rm(gcis, trade)




# �X�ְ�T���L��Ƥ��q
# ��T���L��Ƥ��q
tw_data_no <- list.files("raw data/", "no_trade")
tw_data_no <- read.csv(paste0("raw data/", tw_data_no), stringsAsFactors = FALSE)
tw_data_no$`��~�N�X�P�W��` <- paste0(tw_data_no$`��~�N�X1`, " ", tw_data_no$`�W��1`, "\n",
                               tw_data_no$`��~�N�X2`, " ", tw_data_no$`�W��2`, "\n",
                               tw_data_no$`��~�N�X3`, " ", tw_data_no$`�W��3`)

tw_data_no$`��~�N�X�P�W��` <- str_trim(gsub("NA", "", tw_data_no$`��~�N�X�P�W��`))

#�R�����}����~�N�X�P�W�����
for (i in paste0(c("��~�N�X", "�W��"), rep(1:4, each =2))) {
  tw_data_no[, i] <- NULL
}

# mapping google information
tw_data_no <- join(tw_data_no, google_info)
#tw_data_no$company.name <- NULL

names(tw_data_no)[which(names(tw_data_no) == "����W��")] <- "company"
#�N�L��T����ƪ����ɻ��P��T���n�O��ƬۦP
for (i in setdiff(names(tw_data), names(tw_data_no))) {
  tw_data_no[, i] <- NA
}

# �X�ְ�T������ƻP��T���θ��
tw_data_all <- rbind(tw_data, tw_data_no)
# �s��
write.csv(tw_data_all, paste0("../", gsub("gcis", "tw_data_all", list.files("raw data/", "gcis"))), row.names = FALSE, na = "")









