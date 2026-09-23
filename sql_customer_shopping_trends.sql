-- 1. How many unique customers visited the store during the period?
select count(distinct `customer id`) as total_customers
from shopping_trends;
-- result: 3,900 unique customers


-- 2. Should the store stock more male or female clothing?
with gender_counts as (
    select
        gender,
        count(distinct `customer id`) as total_customers
    from shopping_trends
    group by gender
)
select
    sum(total_customers) as total_customers,
    round(100.0 * sum(case when gender = 'female' then total_customers else 0 end) / sum(total_customers), 2) as pct_female,
    round(100.0 * sum(case when gender = 'male' then total_customers else 0 end) / sum(total_customers), 2) as pct_male
from gender_counts;
-- result: 32% female / 68% male -> stock more male clothing overall


-- 3. What seasons are represented in the data?
select distinct season
from shopping_trends;
-- result: winter, spring, summer, fall


-- 4. What are the top 3 most purchased items per season?
with item_counts as (
    select
        season,
        `item purchased`,
        count(*) as count_of_items,
        row_number() over (partition by season order by count(*) desc) as rn
    from shopping_trends
    group by season, `item purchased`
)
select season, `item purchased`, count_of_items
from item_counts
where rn <= 3
order by season, rn;
-- winter: sunglasses (52), pants (51), shirt (50)
-- spring: sweater (52), shorts (47), skirt (46)
-- summer: pants (50), jewelry (47), dress (47)
-- fall:   jacket (54), hat (50), handbag (48)


-- 5. What is the most popular item color per season?
with color_counts as (
    select
        season,
        color,
        count(`item purchased`) as total_purchased,
        row_number() over (partition by season order by count(`item purchased`) desc) as rn
    from shopping_trends
    group by season, color
)
select season, color, total_purchased
from color_counts
where rn = 1
order by total_purchased desc;
-- summer: silver (59) | spring: olive (52) | fall: yellow (50) | winter: green (50)


-- 6. Should stocking strategies vary by store location?
select
    location,
    count(*) as count_of_items
from shopping_trends
group by location
order by count_of_items desc
limit 5;
-- top 5 locations by volume: montana (96), california (95), idaho (93), illinois (92), alabama (89)

-- example: fall items purchased specifically in montana
select
    `item purchased`,
    count(*) as count_of_items
from shopping_trends
where season = 'fall' and location = 'montana'
group by `item purchased`
order by count_of_items desc
limit 5;
-- top items in fall/montana: handbag, then a tie among t-shirt, sweater, shorts, coat
-- this differs from the overall fall top-3 (jacket, hat, handbag), confirming that
-- stocking strategy should be tailored by location, not just by season.


-- 7. Which locations are top-performing in customer experience?
select
    location,
    round(avg(`review rating`), 2) as avg_rating
from shopping_trends
group by location
order by avg_rating desc
limit 5;
-- top rated: texas (3.91), wisconsin (3.89), iowa (3.85), maine (3.84), california (3.83)
-- other locations could study their processes (fulfillment, staff, etc.) as a benchmark.


-- 8. Does having more than 10 previous purchases correlate with higher spend?
select
    case
        when `previous purchases` >= 10 then 'more than 10'
        else 'less than 10'
    end as previous_purchase_status,
    count(*) as customer_count,
    round(sum(`purchase amount (usd)`), 2) as total_purchase_amount,
    round(avg(`purchase amount (usd)`), 2) as avg_purchase_amount
from shopping_trends
group by 1
order by total_purchase_amount desc;
-- more than 10: 3,192 customers | total $189,939 | avg $59.50 per order
-- less than 10:   708 customers | total  $43,142 | avg $60.94 per order
--
-- total revenue from the "10+" group is far higher, but that is mostly a volume
-- effect (there are simply more such customers) -- the average order value is
-- actually almost identical between the two groups (~$59-61). so "10+ previous
-- purchases" does not correlate with a higher spend per order; it correlates
-- with higher total revenue because these are the store's most frequent/loyal
-- customers. framing this as a loyalty/retention insight rather than a
-- "higher spenders" insight is more accurate.