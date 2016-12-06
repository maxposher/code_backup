
sum(t_data[t_data$likes > 0, c('likes')])/length(t_data[t_data$likes > 0, c('likes')])

#iPhone - Buyers who are likers
173452/229934

#iPhone - D1 - D10 Buyers
71827/103080

#iPhone - D11 - D30 Buyers
27760/32212

#iPhone - >= D30 Buyers
73865/94642

#################################################################################################################################################################
library("RPostgreSQL")
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host="localhost", port="5439",dbname="production", user="maxshen", password=p)

newtonv2<-dbGetQuery(con, "     
                         select *
                         FROM  analytics_scratch.all_new_jan_2016v2 
                         ")

backup<-liker_tiers
liker_tiers[, 3][is.na(liker_tiers[,3])]<- 0 
liker_tiers<-liker_tiers[liker_tiers$d <= 7,   ]

length(liker_tiers[liker_tiers$d > 0 , c('d')])/
length(liker_tiers[ , c('d')])
#late likers has low BA rate, test it on D2


#Search Non - Liker
liker_tiers[, 3][is.na(liker_tiers[,3])]<- 0 

liker_BA <- data.frame(matrix(ncol = 3, nrow = 65))
colnames(liker_BA) <- c('Likes', 'population' ,'BA')
c<- 1
for(i in seq(from = 1 , to = 50, by = 1)){
  liker_BA[c,c('Likes')] <- i

  liker_BA[c,c('population')] <- length(liker_tiers[liker_tiers$likes  == i, c('d')])
  le <- length(liker_tiers[liker_tiers$d > 0 & liker_tiers$likes  == i, c('d')])
  liker_BA[c,c('BA')]  <- le/length(liker_tiers[liker_tiers$likes  == i, c('d')])
                                                                             
  c<- c + 1
}

liker_BA[c,c('Likes')] <- i+1
liker_BA[c,c('population')] <- length(liker_tiers[liker_tiers$likes  > i, c('d')])
le <- length(liker_tiers[liker_tiers$d == 1 & liker_tiers$likes  > i, c('d')])
liker_BA[c,c('BA')]  <- le/length(liker_tiers[liker_tiers$likes  > i, c('d')])
liker_BA

847/4087

7817/60633

3393/87979

7628/93725

3222/27795
1935/15422
480/4137
672/5412
##############2016 Liker Analysis D1 Update################################################
###########################################################################################
nv2_backup <- newtonv2
newtonv2[,5:13][is.na(newtonv2[,5:13])]<- 0 
t_data <- newtonv2
t_data$liker_avail        <-     ifelse(t_data$like_avail_listing > 0,"Yes","No")
t_data$liker_not_for_sale <-     ifelse(t_data$like_nfs_listing > 0,"Yes","No")
t_data$lister <-    ifelse(t_data$created_listing > 0,"Yes","No")
t_data$commenter <- ifelse(t_data$post_comment > 0,"Yes","No")
t_data$searcher <-  ifelse(t_data$search_listing > 0,"Yes","No")
t_data$follow_b <-  ifelse(t_data$follow_brand > 0,"Yes","No")
t_data$follow_p <-  ifelse(t_data$follow_people > 0,"Yes","No")
t_data$seller <-    ifelse(t_data$d1_sa > 0,"Yes","No")
t_data$buyeralltime<- ifelse(is.na(t_data$date_buyer_activated), 0, 1)

t_data$liker_avail        <-     as.factor(t_data$liker_avail)
t_data$liker_not_for_sale <-     as.factor(t_data$liker_not_for_sale)
t_data$lister <-    as.factor(t_data$lister)
t_data$commenter <- as.factor(t_data$commenter)
t_data$searcher <-  as.factor(t_data$searcher)
t_data$follow_b <-  as.factor(t_data$follow_b)
t_data$follow_p <-  as.factor(t_data$follow_p)
t_data$seller <-    as.factor(t_data$seller)
t_data$likes<- t_data$like_avail_listing + t_data$like_nfs_listing

head(t_data)

library(party)
#D1 Buyer
#Like listing for sale is more important


#Best Model
fit_1<-ctree(d1_ba ~ . , data = t_data[t_data$reg_app == 'iphone' 
                                              ,c(5:21)],
             controls = ctree_control(mincriterion = 0.95, minsplit = 100, minbucket = 500))
plot(fit_1, type="simple", 
     terminal_panel=node_terminal(fit_1,fill = c("white"),id= FALSE),
     inner_panel=node_inner(fit_1, pval = FALSE))

#Best Model for long time buyer
fit_1<-ctree(buyeralltime ~ . , data = t_data[t_data$reg_app == 'iphone' 
                                       ,c(5,14:22)],
             controls = ctree_control(mincriterion = 0.95, minsplit = 100, minbucket = 500))

plot(fit_1, type="simple", 
     terminal_panel=node_terminal(fit_1,fill = c("white"),id= FALSE),
     inner_panel=node_inner(fit_1, pval = FALSE))




fit_2<-ctree(buyeralltime ~ . , data = t_data[t_data$reg_app == 'iphone' 
                                       ,c(14:22)],
             controls = ctree_control(mincriterion = 0.95, minsplit = 100, minbucket = 2000))

plot(fit_2 , type="simple",
     terminal_panel=node_terminal(fit_2,fill = c("white"),id= FALSE),
     inner_panel=node_inner(fit_2, pval = FALSE))

i<-10
sum(t_data[t_data$like_avail_listing > i & t_data$reg_app == 'iphone', c('d1_ba')])/
length(t_data[t_data$like_avail_listing > i  & t_data$reg_app == 'iphone', c('d1_ba')])


#Likers
liker_BA <- data.frame(matrix(ncol = 3, nrow = 20))
colnames(liker_BA) <- c('Likes', 'population' ,'BA')
c<- 1
for(i in seq(from = 0 , to = 10, by = 1)){
  
  liker_BA[c,c('Likes')] <- i
  liker_BA[c,c('population')] <-length(t_data[t_data$like_avail_listing == i  & t_data$reg_app == 'iphone', c('d1_ba')])
  le                          <-   sum(t_data[t_data$like_avail_listing == i & t_data$reg_app == 'iphone', c('d1_ba')]) 
  liker_BA[c,c('BA')]         <-le/length(t_data[t_data$like_avail_listing == i  & t_data$reg_app == 'iphone', c('d1_ba')])
  c<- c + 1
}

liker_BA[c,c('Likes')] <- i+1
liker_BA[c,c('population')] <- length(t_data[t_data$like_avail_listing > i  & t_data$reg_app == 'iphone', c('d1_ba')])
buyers                      <- sum(t_data[t_data$like_avail_listing > i & t_data$reg_app == 'iphone', c('d1_ba')]) 
liker_BA[c,c('BA')]         <- buyers/length(t_data[t_data$like_avail_listing > i  & t_data$reg_app == 'iphone', c('d1_ba')])
liker_BA





#Likers
comment_BA <- data.frame(matrix(ncol = 3, nrow = 20))
colnames(comment_BA) <- c('Comments', 'population' ,'BA')
c<- 1
for(i in seq(from = 0 , to = 10, by = 1)){
  
  comment_BA[c,c('Comments')] <- i
  comment_BA[c,c('population')] <-length(t_data[t_data$post_comment == i  & t_data$reg_app == 'iphone', c('d1_ba')])
  buyer                          <-   sum(t_data[t_data$post_comment == i & t_data$reg_app == 'iphone', c('d1_ba')]) 
  comment_BA[c,c('BA')]         <-le/length(t_data[t_data$post_comment == i  & t_data$reg_app == 'iphone', c('d1_ba')])
  c<- c + 1
}

comment_BA[c,c('Comments')] <- i+1
comment_BA[c,c('population')] <- length(t_data[t_data$post_comment > i  & t_data$reg_app == 'iphone', c('d1_ba')])
buyers                      <- sum(t_data[t_data$post_comment > i & t_data$reg_app == 'iphone', c('d1_ba')]) 
comment_BA[c,c('BA')]         <- buyers/length(t_data[t_data$post_comment > i  & t_data$reg_app == 'iphone', c('d1_ba')])
comment_BA

length(t_data[t_data$reg_app == 'iphone', c('d1_ba')])
sum(t_data[t_data$reg_app == 'iphone', c('d1_ba')])



length(t_data[t_data$reg_app == 'iphone' &
              t_data$d1_ba ==    1
              , c('d1_ba')])

length(t_data[t_data$reg_app == 'iphone' &
              t_data$like_avail_listing > 0 &  
              t_data$d1_ba ==    1
              , c('d1_ba')])






liker_BA <- data.frame(matrix(ncol = 3, nrow = 15))
colnames(liker_BA) <- c('Likes', 'population' ,'BA')
c<- 1
for(i in seq(from = 0 , to = 10, by = 1)){
  
  liker_BA[c,c('Likes')] <- i
  liker_BA[c,c('population')] <-length(t_data[t_data$like_avail_listing == i  &
                                           #   t_data$post_comment == 0  &  
                                              t_data$follow_brand == 0  &    
                                              t_data$reg_app == 'iphone',    c('d1_ba')])
  
  le                          <-   sum(t_data[t_data$like_avail_listing == i &
                                            #  t_data$post_comment == 0  &  
                                              t_data$follow_brand== 0  &  
                                              t_data$reg_app == 'iphone', c('d1_ba')]) 
  
  liker_BA[c,c('BA')]         <-le/length(t_data[t_data$like_avail_listing == i  & 
                                             #    t_data$post_comment == 0  &  
                                                 t_data$follow_brand == 0  &     
                                                 t_data$reg_app == 'iphone', c('d1_ba')])
  c<- c + 1
}

liker_BA[c,c('Likes')] <- i+1
liker_BA[c,c('population')] <- length(t_data[t_data$like_avail_listing > i &
                                            # t_data$post_comment == 0  &  
                                              t_data$follow_brand == 0  &    
                                              t_data$reg_app == 'iphone', c('d1_ba')])

buyers                      <- sum(t_data[t_data$like_avail_listing > i &
                                          #   t_data$post_comment == 0  &  
                                             t_data$follow_brand == 0  &     
                                             t_data$reg_app == 'iphone', c('d1_ba')])

liker_BA[c,c('BA')]         <- buyers/length(t_data[t_data$like_avail_listing > i &
                                           #           t_data$post_comment == 0  &  
                                                      t_data$follow_brand == 0  &     
                                                      t_data$reg_app == 'iphone', c('d1_ba')])
liker_BA





fit_1<-ctree(buyeralltime ~ . , data = t_data[t_data$reg_app == 'iphone' 
                                       ,c(6:22)],
             controls = ctree_control(mincriterion = 0.95, minsplit = 100, minbucket = 100))

plot(fit_1, type="simple", 
     terminal_panel=node_terminal(fit_1,fill = c("white"),id= FALSE),
     inner_panel=node_inner(fit_1, pval = FALSE))

