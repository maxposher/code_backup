


library("RPostgreSQL")
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, host="localhost", port="5439",dbname="production", user="maxshen", password=p)

search   <-dbGetQuery(con, "     
                      SELECT U.user_id, U.buyer_activated_at, SUM(keyword_search) AS KS, SUM(brand_browsing) AS BB, SUM(category_browsing) AS CB
                       FROM analytics.dw_users AS U
                      LEFT JOIN 
                      (SELECT id, actor_id, at AS action_time , 
                      case when  direct_object_usersearchrequest_query is not null then 1 else 0 end as keyword_search, 
                      case when direct_object_executedSearchRequest_query_and_facet_filters_brand_0 is not null then 1 else 0 end as brand_browsing, 
                      case when direct_object_executedSearchRequest_query_and_facet_filters_category_feature_0 is not null then 1 else 0 end as category_browsing 
                      From raw_hive.search_events 
                      where   at  >= '2015-10-30' 
                      AND     at  <= '2015-11-05'  
                      AND   actor_type = 'User') AS B ON U.user_id = B.actor_id   
                      WHERE action_time <  least(U.buyer_activated_at, cast(date(joined_at + 1) AS timestamp))       
                      AND   U.join_date BETWEEN '2015-10-30' AND '2015-11-04' 
                      -- AND   U.reg_app = 'iphone'
                      GROUP BY 1,2
                     ")
search$buyer<- ifelse(is.na(search$buyer_activated_at),0,1)
search_backup<- search


searcher_BA <- data.frame(matrix(ncol = 3, nrow = 108))
colnames(searcher_BA) <- c('Likes', 'population' ,'buyer')
c<- 1
for(i in seq(from = 0 , to = 100, by = 1)){
  searcher_BA[c,c('Likes')] <- i
  
  n_size <- length(search[search$ks  == i, c('buyer')])
  searcher_BA[c,c('population')] <- n_size
  
  n_buyer <- sum(search[search$ks  == i, c('buyer')])
  searcher_BA[c,c('buyer')]  <- n_buyer
  c<- c + 1
}

searcher_BA[c,c('Likes')] <- i+1
n_size <- length(search[search$ks  > i, c('buyer')])
searcher_BA[c,c('population')] <- n_size
n_buyer <- sum(search[search$ks  > i, c('buyer')])
searcher_BA[c,c('buyer')]  <- n_buyer
searcher_BA



searcher_BA <- data.frame(matrix(ncol = 3, nrow = 58))
colnames(searcher_BA) <- c('Likes', 'population' ,'buyer')
c<- 1
for(i in seq(from = 0 , to = 50, by = 1)){
  searcher_BA[c,c('Likes')] <- i
  
  n_size <- length(search[search$bb  == i, c('buyer')])
  searcher_BA[c,c('population')] <- n_size
  
  n_buyer <- sum(search[search$bb  == i, c('buyer')])
  searcher_BA[c,c('buyer')]  <- n_buyer
  c<- c + 1
}

searcher_BA[c,c('Likes')] <- i+1
n_size <- length(search[search$bb  > i, c('buyer')])
searcher_BA[c,c('population')] <- n_size
n_buyer <- sum(search[search$bb  > i, c('buyer')])
searcher_BA[c,c('buyer')]  <- n_buyer
searcher_BA



searcher_BA <- data.frame(matrix(ncol = 3, nrow = 58))
colnames(searcher_BA) <- c('Likes', 'population' ,'buyer')
c<- 1
for(i in seq(from = 0 , to = 50, by = 1)){
  searcher_BA[c,c('Likes')] <- i
  
  n_size <- length(search[search$cb  == i, c('buyer')])
  searcher_BA[c,c('population')] <- n_size
  
  n_buyer <- sum(search[search$cb  == i, c('buyer')])
  searcher_BA[c,c('buyer')]  <- n_buyer
  c<- c + 1
}

searcher_BA[c,c('Likes')] <- i+1
n_size <- length(search[search$cb  > i, c('buyer')])
searcher_BA[c,c('population')] <- n_size
n_buyer <- sum(search[search$cb  > i, c('buyer')])
searcher_BA[c,c('buyer')]  <- n_buyer
searcher_BA





#Likers
liker_BA <- data.frame(matrix(ncol = 3, nrow = 20))
colnames(liker_BA) <- c('Likes', 'population' ,'BA')
c<- 1
for(i in seq(from = 0 , to = 10, by = 1)){
  
  liker_BA[c,c('Likes')] <- i
  n_population                <- length(t_data[t_data$likes == i  & t_data$reg_app == 'iphone', c('d1_ba')])
  liker_BA[c,c('population')] <- n_population
  n_buyer                     <- sum(t_data[t_data$likes == i  & t_data$reg_app == 'iphone', c('d1_ba')])
  liker_BA[c,c('BA')]         <- n_buyer/n_population
  c<- c + 1
}

liker_BA[c,c('Likes')] <- i+1
n_population                <- length(t_data[t_data$likes > i  & t_data$reg_app == 'iphone', c('d1_ba')])
liker_BA[c,c('population')] <- n_population  
n_buyer                     <- sum(t_data[t_data$likes > i  & t_data$reg_app == 'iphone', c('d1_ba')])
liker_BA[c,c('BA')]         <- n_buyer/n_population
liker_BA

