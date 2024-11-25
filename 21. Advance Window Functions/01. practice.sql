use swiggy;
select * from restaurants;

-- 1. List the top 5 cuisines as per the revenue generated by top 5 restaurants of every cuisine
select cuisine, sum(rating_count*cost) as 'revenue'from 	
( 	select *, cost*rating_count, 
	row_number() over(partition by cuisine order by cost*rating_count desc) as 'rank'
    from restaurants
) t 
where t.rank < 6
group by cuisine
order by revenue desc;

-- 2. What is the of the total revenue is generated by top 1% restaurants
select sum(cost*rating_count) as 'revenue' from
	(select *, cost*rating_count, row_number() over(order by cost*rating_count desc) as 'rank'
		from restaurants) t
	where t.rank <= 614;

-- 3. Check the same for top 20% restaurants
select sum(cost*rating_count) as 'revenue' from
	(select *, cost*rating_count, row_number() over(order by cost*rating_count desc) as 'rank'
		from restaurants) t
	where t.rank <= 12280;


-- 4. What % of revenue is generated by top 20% of restaurants with respect to total revenue?
with 
	q1 as (select sum(cost*rating_count) as 'top_revenue' from
			(select *, cost*rating_count, row_number() over(order by cost*rating_count desc) as 'rank'
				from restaurants) t
			where t.rank <= 12280),
	q2 as (select sum(cost*rating_count) as 'total_revenue' from restaurants)
    
select (top_revenue/total_revenue)*100 as 'revenue %' from q1,q2;


