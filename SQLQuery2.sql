select * from dbo.sharktank;

-- Q.1 Total number of episode
select count(Distinct Ep_No)
from dbo.sharktank;

-- or 
select max(EP_No)
from dbo.sharktank;

-- Q.2 Total number of Pitches

select count(distinct Brand)
from  dbo.sharktank;

-- Q.3 How many pitches converted

select sum(a.pitches_converted) as funding_received, count(*) as total_pitches from(
select Amount_Invested_lakhs, 
case 
when Amount_Invested_lakhs > 0 then 1 else 0 end as "pitches_converted"
from dbo.sharktank) a;

-- Q.4 Total number of male participant

select sum(Male) as total_male_participants
from dbo.sharktank;

-- Q.5 Total number of female participant

select sum(Female) as total_female_participants
from dbo.sharktank;

--Q.6 Gender ratio

select sum(Female) / sum(Male) from dbo.sharktank;

-- Q.7 Total Invested Amount

select sum(Amount_Invested_lakhs) as total_invested
from dbo.sharktank;

-- Q.8 Average Equity Taken by Sharks

select AVG(a.Equity_Taken_P) as Avg_equity_Taken
from (select Equity_Taken_P from dbo.sharktank where Equity_Taken_P > 0) a;

-- Q.9 Highest Deal Taken

select max(Amount_Invested_lakhs) as Highest_deal
from dbo.sharktank;

-- Q.10 Highest Equity Taken by Shark

select max(Equity_Taken_P) as Highest_equity_taken
from dbo.sharktank;

-- Q.11 startups having at least women

select SUM(a.female_count) startups_having_at_least_women from (
select Female, case when Female > 0 then 1 else 0 end as female_count from dbo.sharktank) a;

-- Q.12 pitches converted having atleast women

Select SUM(b.female_count) from (

select case when a.Female > 0 then 1 else 0 end as female_count ,a.*from
(select * from dbo.sharktank where Deal != 'No Deal') a) b;

-- Q.13 avg team members

select AVG(Team_members) from dbo.sharktank

--Q.14 Average amount invested per deal

select AVG(a.Amount_Invested_lakhs) as avg_amount_invested_per_deal from (
select * from dbo.sharktank where Deal != 'No Deal')a;

-- Q.15 Count of avg age group of contestants

select Avg_age, count(Avg_age) cnt
from dbo.sharktank
group by Avg_age
order by cnt desc;

-- Q.16 location group of contestants

select Location, count(Location) cnt
from dbo.sharktank
group by Location
order by cnt desc;

-- Q.17 Count sector group of contestants

select Sector, count(Sector) cnt
from dbo.sharktank
group by Sector
order by cnt desc;

-- Q.18 How many deals done by partners

select Partners, count(Partners) cnt
from dbo.sharktank
where Partners != '-'
group by Partners
order by cnt desc;

-- making the matrix

Select 'Ashneer' as keyy, count(Ashneer_Amount_Invested)
from dbo.sharktank
where Ashneer_Amount_Invested is not null

Select 'Ashneer' as keyy, count(Ashneer_Amount_Invested)
from dbo.sharktank
where Ashneer_Amount_Invested > 0 AND Ashneer_Amount_Invested is not null

select 'Ashneer' as keyy, sum(c.Ashneer_Amount_Invested) as Amount_Invested, AVG(c.Ashneer_Equity_Taken_P) as Avg_Equity_Taken
from (select * from dbo.sharktank where Ashneer_Equity_Taken_P > 0 AND Ashneer_Equity_Taken_P is not null) c;



select m.keyy, m.Total_Deal_Present, m.Total_Deals, n.Total_Amount_Invested, n.Avg_Equity_Taken from

(select a.keyy, a.Total_Deal_Present, b.Total_Deals from (

Select 'Ashneer' as keyy, count(Ashneer_Amount_Invested) as Total_Deal_Present
from dbo.sharktank
where Ashneer_Amount_Invested is not null) a

inner join (

Select 'Ashneer' as keyy, count(Ashneer_Amount_Invested) as Total_Deals
from dbo.sharktank
where Ashneer_Amount_Invested > 0 AND Ashneer_Amount_Invested is not null) b

on a.keyy = b.keyy) m

INNER JOIN

(select 'Ashneer' as keyy, sum(c.Ashneer_Amount_Invested) as Total_Amount_Invested, AVG(c.Ashneer_Equity_Taken_P) as Avg_Equity_Taken
from (select * from dbo.sharktank where Ashneer_Equity_Taken_P > 0 AND Ashneer_Equity_Taken_P is not null) c) n

on m.keyy = n.keyy


-- Q.20 which is the startup in which the highest amount has been invested in each domain/sector

select c.* from
(select Brand, Sector, Amount_Invested_lakhs, Rank() Over(partition by sector order by Amount_Invested_lakhs) as rnk
from dbo.sharktank where Amount_Invested_lakhs !=0) c
where c.rnk = 1











--with Dense Rank() Function
select c.* from
(select Brand, Sector, Amount_Invested_lakhs, DENSE_RANK() Over(partition by sector order by Amount_Invested_lakhs) as rnk
from dbo.sharktank) c
where c.rnk = 1