

-- New Users (Active)
SELECT count(distinct dw_user_activity.user_id) AS user_id
FROM analytics.dw_user_activity AS dw_user_activity
LEFT JOIN analytics.dw_users AS dw_users
 ON  dw_user_activity.user_id = dw_users.user_id
  WHERE 
      (date(dw_users.cohort_date) between '01-SEP-2015' AND '30-SEP-2015')
       AND 
     dw_user_activity.activity_name = 'active_on_app'
     AND 
     date(dw_user_activity.activity_date) between '01-SEP-2015' AND '30-SEP-2015'
     AND NOT dw_users.guest_user
     
-- Returning Users (Active)
SELECT count(distinct dw_user_activity.user_id) AS user_id
FROM analytics.dw_user_activity AS dw_user_activity
LEFT JOIN analytics.dw_users AS dw_users
 ON  dw_user_activity.user_id = dw_users.user_id
  WHERE 
      NOT (dw_users.cohort_date between '01-SEP-2015' AND '30-SEP-2015')
       AND 
     dw_user_activity.activity_name = 'active_on_app'
     AND 
     dw_user_activity.activity_date between '01-SEP-2015' AND '30-SEP-2015'
     AND NOT dw_users.guest_user
   
-- Returning from Previous Month  
select count(distinct user_id) as return_users
FROM
(
(SELECT distinct dw_user_activity.user_id AS user_id
FROM analytics.dw_user_activity AS dw_user_activity
LEFT JOIN analytics.dw_users AS dw_users
 ON  dw_user_activity.user_id = dw_users.user_id
  WHERE 
     dw_user_activity.activity_name = 'active_on_app'
     AND 
     dw_user_activity.activity_date between '01-AUG-2015' AND '31-AUG-2015'
     AND NOT dw_users.guest_user)
INTERSECT
(SELECT distinct dw_user_activity.user_id AS user_id
FROM analytics.dw_user_activity AS dw_user_activity
LEFT JOIN analytics.dw_users AS dw_users
 ON  dw_user_activity.user_id = dw_users.user_id
  WHERE 
     NOT (dw_users.cohort_date between '01-SEP-2015' AND '30-SEP-2015')
       AND 
     dw_user_activity.activity_name = 'active_on_app'
     AND 
     dw_user_activity.activity_date between '01-SEP-2015' AND '30-SEP-2015'
     AND NOT dw_users.guest_user)
)


-- Churn from Previous Month's new users
select count(distinct user_id) as churn_users
FROM
(
(SELECT distinct dw_user_activity.user_id AS user_id
FROM analytics.dw_user_activity AS dw_user_activity
LEFT JOIN analytics.dw_users AS dw_users
 ON  dw_user_activity.user_id = dw_users.user_id
  WHERE 
      (dw_users.cohort_date between '01-AUG-2015' AND '31-AUG-2015')
       AND 
     dw_user_activity.activity_name = 'active_on_app'
     AND 
     dw_user_activity.activity_date between '01-AUG-2015' AND '31-AUG-2015'
     AND NOT dw_users.guest_user)
MINUS
(SELECT distinct dw_user_activity.user_id AS user_id
FROM analytics.dw_user_activity AS dw_user_activity
LEFT JOIN analytics.dw_users AS dw_users
 ON  dw_user_activity.user_id = dw_users.user_id
  WHERE 
     NOT (dw_users.cohort_date between '01-SEP-2015' AND '30-SEP-2015')
       AND 
     dw_user_activity.activity_name = 'active_on_app'
     AND 
     dw_user_activity.activity_date between '01-SEP-2015' AND '30-SEP-2015'
     AND NOT dw_users.guest_user)
)

-- Churn from Previous Month's returning users
select count(distinct user_id) as churn_users
FROM
(
(SELECT distinct dw_user_activity.user_id AS user_id
FROM analytics.dw_user_activity AS dw_user_activity
LEFT JOIN analytics.dw_users AS dw_users
 ON  dw_user_activity.user_id = dw_users.user_id
  WHERE 
     NOT (dw_users.cohort_date between '01-AUG-2015' AND '31-AUG-2015')
       AND 
     dw_user_activity.activity_name = 'active_on_app'
     AND 
     dw_user_activity.activity_date between '01-AUG-2015' AND '31-AUG-2015'
     AND NOT dw_users.guest_user)
MINUS
(SELECT distinct dw_user_activity.user_id AS user_id
FROM analytics.dw_user_activity AS dw_user_activity
LEFT JOIN analytics.dw_users AS dw_users
 ON  dw_user_activity.user_id = dw_users.user_id
  WHERE 
     NOT (dw_users.cohort_date between '01-SEP-2015' AND '30-SEP-2015')
       AND 
     dw_user_activity.activity_name = 'active_on_app'
     AND 
     dw_user_activity.activity_date between '01-SEP-2015' AND '30-SEP-2015'
     AND NOT dw_users.guest_user)
)