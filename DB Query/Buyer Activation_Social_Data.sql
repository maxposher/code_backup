SELECT join_date, count(distinct user_id) FROM
(
(SELECT distinct dw_users.user_id, dw_users.join_date
FROM analytics.dw_user_activity AS dw_user_activity
LEFT JOIN analytics.dw_users AS dw_users ON dw_user_activity.user_id = dw_users.user_id
WHERE (DATE(dw_user_activity.activity_date) - DATE(dw_users.join_date) + 1 <= 7) 
AND (dw_user_activity.activity_name = 'like_listing') 
AND NOT dw_users.guest_user
AND dw_users.join_date >= '2015-08-01'
AND dw_users.join_date < '2015-08-31'
GROUP BY dw_users.user_id, dw_users.join_date
HAVING MAX (dw_user_activity.activity_count) >= 1)

INTERSECT

(SELECT distinct dw_users.user_id, dw_users.join_date
FROM analytics.dw_user_activity AS dw_user_activity
LEFT JOIN analytics.dw_users AS dw_users ON dw_user_activity.user_id = dw_users.user_id
WHERE (DATE(dw_user_activity.activity_date) - DATE(dw_users.join_date) + 1 <= 7) 
AND (dw_user_activity.activity_name = 'item_purchased') 
AND NOT dw_users.guest_user
AND dw_user_activity.activity_count =1
AND dw_users.join_date >= '2015-01-01'
GROUP BY dw_users.user_id, dw_users.join_date)
)
GROUP BY join_date
ORDER BY join_date