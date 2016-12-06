
--Create Known Brand

SELECT brand
FROM analytics.dw_listings
WHERE initcap(brand) ILIKE 'Polo By Ralph Lauren'
limit 10


CREATE TEMP TABLE known_brand AS (
SELECT distinct brand, 1
FROM analytics.dw_listings
WHERE brand in (
'Nike', 'Victoria''s Secret', 'Pink Victoria''s Secret','Lululemon Athletica','J. Crew','Forever 21','Coach','Free People','Michael Kors','American Eagle Outfitters','Anthropologie','Old Navy','Kate Spade','Express',
'H&M','Urban Outfitters','Banana Republic','Gap','Tory Burch','Brandy Melville','Lilly Pulitzer','Zara','Loft','Steve Madden','Lularoe','Under Armour','Hollister','Adidas','Vera Bradley','Mac Cosmetics','Miss Me',
'Ugg','Ralph Lauren','Converse','American Apparel','Lucky Brand','Juicy Couture','Abercrombie & Fitch','Ann Taylor','Charlotte Russe','Calvin Klein','Betsey Johnson','Bebe','Madewell','Vintage','Boutique','Guess',
'Louis Vuitton','Toms','Vans','Pandora','Alex & Ani','North Face','Nine West','Ray-Ban','Chanel','Mossimo Supply Co','White House Black Market','Torrid','Jessica Simpson','Kendra Scott','Fossil','Levi''S',
'Nasty Gal','New York & Company','Michael Michael Kors','Merona','Lane Bryant','Urban Decay','Maurices','Gucci','Burberry','Xhilaration','The Limited','Aeropostale','Dooney & Bourke','Sperry Top-Sider','Asos',
'True Religion','Vineyard Vines','Aldo','Bcbgmaxazria','Tiffany & Co.','Patagonia','Topshop','7 For All Mankind','Wildfox','Brighton','Stella & Dot','Vince Camuto','Jordan','Sam Edelman','Rue 21','Polo by Ralph Lauren',
'The North Face','Mossimo Supply Co.','Athleta','Birkenstock','Rock Revival','Lf','Lokai','Sephora','Marc By Marc Jacobs','Talbots','Francesca''s Collections','Hunter Boots','Roxy','Bcbg','Cole Haan','Too Faced',
'Kylie Cosmetics','Jeffrey Campbell','Bke','Inc International Concepts','Tommy Hilfiger','Modcloth','Hot Topic','Cabi','Reebok','Chico''s','Aerie','Columbia','Pacsun','Tobi','Puma','Mary Kay','Bcbgeneration',
'Lc Lauren Conrad','Disney','Rebecca Minkoff','Joe''s Jeans','Prada','Frye','Wet Seal','Apt. 9','Tarte','Hudson Jeans','Silver Jeans','Silpada','Billabong','Liz Claiborne','Anastasia Beverly Hills','Marc Jacobs',
'Dolce Vita','Unif','Paige Jeans','Dr. Martens','Buckle','New Balance','Anne Klein','Bareminerals','Worthington','Champion','Christian Louboutin','Justfab','Rag & Bone','Lush','Dior','Jones New York','Clarks',
'Skechers','Madden Girl','For Love And Lemons','Dkny','Diane Von Furstenberg','Dress Barn','Triangl Swimwear','Clinique','Lulu''s','Cato','Big Star','Gianni Bini','Charming Charlie','Benefit','Franco Sarto',
'Style & Co','Nars','Tahari','Minnetonka','Vince','Cache','Nyx','Rock & Republic','Timberland','J Brand','Dansko','Born','French Connection','Motherhood Maternity','Harley-Davidson','Candie''s','AG Adriano Goldschmied',
'Citizens of Humanity','Faded Glory','Asics','Theory','Kat Von D','Fabletics','Swarovski','Jack Rogers','Acacia Swimwear','Bdg','Longchamp','Lacoste','Missguided','Estee Lauder','Justice','American Rag','Joie',
'Bath And Body Works','Max Studio','Lancome','Eddie Bauer','Vera Wang','Lia Sophia','Cynthia Rowley','Chinese Laundry','Obey','Lands'' End','Ed Hardy','Daytrip','Hello Kitty','Dolce & Gabbana','Kenneth Cole Reaction',
'Crocs','Mudd','Coldwater Creek','Fox','Volcom','Jennifer Lopez','Stuart Weitzman','Sonoma','James Avery','Younique','A.N.A','Aerosoles','Hurley','Smashbox','Fendi','Qupid','Nordstrom','David''S Bridal',
'Yves Saint Laurent','Rampage','Keds','Versace','Elle','Chacos','So','Avenue','Arizona Jean Company','Kenneth Cole','T&J Designs','Bandolino','Bullhead','Alice + Olivia','Oakley','Arden B','Hobo','Eileen Fisher',
'Boden','Carter''s','Seven7','Trina Turk','Cotton On','Splendid','Show Me Your Mumu','La Hearts','Antonio Melani','Divided','Jimmy Choo','Simply Vera Vera Wang','No Boundaries','Spanx','Boohoo','Affliction',
'One Teaspoon','Moda International','All Saints','L.L. Bean','Windsor','Alfani','Croft & Barrow','Bobbi Brown','Cacique','Bath & Body Works','Otterbox','Avon','Shoe Dazzle','Sanuk','Adrianna Papell','Lifeproof',
'Handmade','J. Jill','Ariat','L.A.M.B.','Kimchi Blue','Cherokee','Colourpop','Philosophy','Lilly Pulitzer For Target','Ted Baker','Naturalizer','Armani Exchange','Danskin','Lucy','Sorel','Unknown','O''Neill',
'Becca', 'Premier Designs','Fitbit','Mia','Diesel','Macy''s','Stila','David Yurman','Zella','Lauren Conrad','Aritzia','Club Monaco','Kendall & Kylie','Henri Bendel','Chloe + Isabel','Love Culture','Deb','Vigoss',
'Chaps','Bakers','None','Frederick''s Of Hollywood','James Perse','Tom Ford','Boston Proper','Bamboo','Venus','Target','Bisou Bisou','Carlos Santana','Miche','Thirty One','Liz Lange','Valentino','Almost Famous',
'Tommy Bahama','Bongo','Kardashian Kollection','Lorac','Ivanka Trump','Chloe','Enzo Angiolini','Seychelles','Body Central','J.Crew Factory','Merrell','Bb Dakota','Dana Buchman','Brooks Brothers',
'April Spirit','Hermes','Apple','Xoxo','Fila','Gilly Hicks','Thirty-One','Rocket Dog','Jansport','Quay Australia','Bp','Sam & Libby','Givenchy','Nanette Lepore','Brahmin','Harley Davidson','Brooks','Kensie',
'Makeup Forever','Reformation','Vanity','Silence + Noise','Dollhouse','Jcpenney','Fashion Nova','American Eagle by Payless','St. John''s Bay','Charter Club','Papaya','Vivacouture','St. John','Prana','Halogen',
'The Sak','Ashley Stewart','Sherri Hill','Tilly''s','bar lll','Alo Yoga','Beach Bunny','New Directions','Salvatore Ferragamo','Laundry By Shelli Segal','Soda','Yeezy','Umgee','Ellen Tracy','Fashion Bug',
'Nautica','Report', 'Elizabeth and James', 'Claire''s','Keen','Current/Elliott','Big Buddha','L*Space','Moschino','Uniqlo','Chaser','Ecote','Teva','House of Harlow 1960','Ambiance Apparel','Derek Heart',
'Nicole Miller','Rvca','Rebecca Taylor','Bass','Baby Phat','Blowfish','Maybelline','Daisy Fuentes','Etienne Aigner','Badgley Mischka','Steven By Steve Madden','Donald J. Pliner','Simply Southern','Elf',
'Isaac Mizrahi','Maidenform','It Cosmetics','Flying Tomato','Lauren Ralph Lauren','Kay Jewelers','Monteau','Jamberry','Decree','Minkpink','Gilligan & O''Malley','Lee','Laura Mercier','Tignanello','Havaianas',
'Sabo Skirt','Nydj','Via Spiga','Nfl','Hydraulic','Material Girl','No Brand','Soma','Sole Society','Eshakti','George','G By Guess','Parker','Angie','Bcbgirls','Wrangler','Romeo & Juliet Couture','Adrienne Vittadini',
'Dc','J Crew','Guess By Marciano','Neiman Marcus','Alexander Wang','Ferragamo','Kathy Van Zeeland','Charles David','London Times','Wild Diva','Gymboree','Dickies','Manolo Blahnik','Christopher & Banks','Daniel Rainn',
'Blackmilk','Breckelles','Helmut Lang','Pink Rose','Giorgio Armani','Kors Michael Kors', 'Michael Antonio','Unbranded','Kipling','Celine', 'Sky','Mikoh','Harajuku Lovers','Michael Stars')
limit 1000)











--Inventory
SELECT 
	TO_CHAR(dw_listings.created_at, 'YYYY-MM-DD') AS "created_day",
	COUNT(DISTINCT CASE WHEN (((dw_listings.parent_listing_id) IS NULL)) THEN dw_listings.listing_id ELSE NULL END) AS "count listing"
FROM analytics.dw_listings AS dw_listings
LEFT JOIN known_brand as B on dw_listings.brand = b.brand
WHERE((dw_listings.created_at >= (TIMESTAMP '2015-10-01')))
AND  b.brand is not null 
AND  dw_listings.listing_condition ILIKE 'ret'
--AND  dw_listings.listing_type is null   --Single Item
--AND  dw_listings.listing_type = 'multi_item'
AND (dw_listings.listing_price*.01) <= 7500 
AND ( dw_listings.create_source_type IS NULL  OR dw_listings.parent_listing_id IS NOT NULL) 
AND ((CASE
      WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'available') THEN 'Available' 
      WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'not_for_sale') THEN 'Not_For_Sale' 
      WHEN (dw_listings.inventory_status = 'sold_out') THEN 'Sold_Out' 
      WHEN (dw_listings.listing_status = 'archived' and dw_listings.inventory_status = 'available') THEN 'Deleted_Available_Listing' 
      WHEN (dw_listings.listing_status = 'archived') THEN 'Deleted_by_User' 
      WHEN (dw_listings.listing_status = 'hidden' or dw_listings.listing_status = 'user_restricted') THEN 'Deleted_by_Admin' 
      WHEN (dw_listings.listing_status = 'draft' or dw_listings.listing_status = 'for_review') THEN 'Draft_InReview' 
ELSE 'Unknown' 
END ILIKE 'Available' OR CASE
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'available') THEN 'Available' 
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'not_for_sale') THEN 'Not_For_Sale' 
WHEN (dw_listings.inventory_status = 'sold_out') THEN 'Sold_Out' 
WHEN (dw_listings.listing_status = 'archived' and dw_listings.inventory_status = 'available') THEN 'Deleted_Available_Listing' 
WHEN (dw_listings.listing_status = 'archived') THEN 'Deleted_by_User' 
WHEN (dw_listings.listing_status = 'hidden' or dw_listings.listing_status = 'user_restricted') THEN 'Deleted_by_Admin' 
WHEN (dw_listings.listing_status = 'draft' or dw_listings.listing_status = 'for_review') THEN 'Draft_InReview' 
ELSE 'Unknown' 
END ILIKE 'Sold_Out' OR CASE
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'available') THEN 'Available' 
WHEN (dw_listings.listing_status = 'published' and dw_listings.inventory_status = 'not_for_sale') THEN 'Not_For_Sale' 
WHEN (dw_listings.inventory_status = 'sold_out') THEN 'Sold_Out' 
WHEN (dw_listings.listing_status = 'archived' and dw_listings.inventory_status = 'available') THEN 'Deleted_Available_Listing' 
WHEN (dw_listings.listing_status = 'archived') THEN 'Deleted_by_User' 
WHEN (dw_listings.listing_status = 'hidden' or dw_listings.listing_status = 'user_restricted') THEN 'Deleted_by_Admin' 
WHEN (dw_listings.listing_status = 'draft' or dw_listings.listing_status = 'for_review') THEN 'Draft_InReview' 
ELSE 'Unknown' 
END ILIKE 'Deleted_Available_Listing'))
GROUP BY 1
ORDER BY 1 ASC




WITH Big_L AS (
SELECT L.*, L2.listing_id AS child
FROM   analytics.dw_listings AS L 
       LEFT JOIN ( SELECT parent_listing_id, listing_id
                   FROM  analytics.dw_listings 
                   WHERE parent_listing_id IS NOT NULL) AS L2 on L.listing_id = L2.parent_listing_id
WHERE  L.parent_listing_id is null 
AND    L.create_source_type IS NULL 
AND    (L.listing_type is null or L.listing_type = 'multi_item')
) 
SELECT created_day, count(listing_id)
FROM(  SELECT  TO_CHAR(dw_listings.created_at, 'YYYY-MM-DD') AS "created_day",
                dw_listings.listing_id,
                avg(dw_listings.count_inventory_units ) AS "Inventory_Units",
                COUNT(distinct O.listing_id) AS "Sold"
        FROM Big_L AS dw_listings
        LEFT JOIN known_brand as B on dw_listings.brand = b.brand
        LEFT JOIN analytics.dw_order_items AS O on O.listing_id = CASE WHEN child is not null then child else dw_listings.listing_id END
        WHERE date(dw_listings.created_at) >= '2015-10-01'
        AND b.brand is not null
        AND  date(O.booked_at_time) -   date(created_at) + 1 <= 30
        AND  dw_listings.listing_condition ILIKE 'ret'
        AND (dw_listings.listing_price*.01) <= 7500 
        AND (dw_listings.create_source_type IS NULL OR dw_listings.parent_listing_id IS NULL) 
GROUP BY 1,2
ORDER BY 1 ASC
)
WHERE inventory_units*0.5 <= Sold
GROUP BY 1
ORDER BY 1







