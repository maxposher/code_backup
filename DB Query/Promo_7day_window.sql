

/* Promo 7 Days Window */

 SELECT date(O.booked_at), sum(O.order_gmv)/100 AS GMV, count(distinct O.order_id) AS ORDER_ID, sum(499 - buyer_shipping_fee)/100 AS PROMO_COST
 FROM analytics.dw_orders AS O
 WHERE date(O.booked_at) IN
 (
  '2013-11-28', (date('2013-11-28')-7),
  '2014-06-19', (date('2014-06-19')-7),
  '2014-08-29', (date('2014-08-29')-7),
  '2014-12-18', (date('2014-12-18')-7),
  '2015-04-10', (date('2015-04-10')-7),
  '2015-04-12', (date('2015-04-12')-7),
  '2015-04-15', (date('2015-04-15')-7),
  '2015-04-21', (date('2015-04-21')-7),
  '2015-04-23', (date('2015-04-23')-7),
  '2015-05-24', (date('2015-05-24')-7),
  '2015-05-29', (date('2015-05-29')-7),
  '2015-06-14', (date('2015-06-14')-7),
  '2015-06-19', (date('2015-06-19')-7),
  '2015-06-23', (date('2015-06-23')-7)
  )
  GROUP BY 1
  ORDER BY 1
 
     
  
 SELECT date(O.booked_at), sum(O.order_gmv)/100 AS GMV, count(distinct O.order_id) AS ORDER_ID, sum(499 - buyer_shipping_fee)/100 AS PROMO_COST
 FROM analytics.dw_orders AS O
 WHERE date(O.booked_at) IN
 ('2014-12-18', '2014-12-11')
  GROUP BY 1
  ORDER BY 1
 
 select *
 from analytics.dw_campaign_calendar
     
     