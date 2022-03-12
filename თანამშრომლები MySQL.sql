drop view if exists პირველი;
create view პირველი as
select Personnel_ID, თანამშრომლები.First_Name, თანამშრომლები.Last_Name, if(Shift is null,"დღე", shift) as shift, Date_And_Time
from თანამშრომლები
left join ცვლა 
using(personnel_ID);

drop view if exists მეორე;
create view მეორე as
select *
from პირველი
where shift not like "ღამე";

drop view if exists მესამე;
create view მესამე as
select t1.Personnel_ID, t1.First_Name, t1.Last_Name, t1.shift, t1.date_and_time as შესვლა, t2.date_and_time as გამოსვლა
from მეორე as t1
join მეორე as t2
on t1.Personnel_ID=t2.Personnel_ID
where date(t1.date_and_time)=date(t2.date_and_time) and
t1.Date_And_Time !=t2.Date_And_Time
-- and day(t1.date_and_time)=21 and day(t2.date_and_time)=21;

drop view if exists მეოთხე;
create view მეოთხე as
select personnel_ID, first_name, last_name, shift, min(შესვლა) as შესვლა, max(გამოსვლა) as გამოსვლა
from მესამე
group by personnel_ID, date(შესვლა), date(გამოსვლა);

drop view if exists მეხუთე;
create view მეხუთე as
select მეოთხე.*, timestampdiff(second,შესვლა,გამოსვლა) as სხვაობა_საათებში
from მეოთხე;

drop view if exists მეექვსე;
create view მეექვსე as
select Personnel_ID, first_name, last_name, shift, sum(სხვაობა_საათებში) as monthly_worked_hours
from მეხუთე
group by personnel_ID;

drop view if exists მეორე2;
create view მეორე2 as
select *
from პირველი
where shift like "ღამე";

drop view if exists მესამე2;
create view მესამე2 as
select t1.Personnel_ID, t1.First_Name, t1.Last_Name, t1.shift, t1.date_and_time as შესვლა, t2.date_and_time as გამოსვლა
from მეორე2 as t1
join მეორე2 as t2
using(personnel_ID)
where date(t2.date_and_time)-date(t1.date_and_time)=1 and
t1.date_and_time != t2.date_and_time and
time(t1.date_and_time)>"18:00:00" and 
time(t2.date_and_time)<"09:00:00"
-- and day(t1.date_and_time)=20 and day(t2.date_and_time)=21;

drop view if exists მეოთხე2;
create view მეოთხე2 as
select personnel_ID, first_name, last_name, shift, min(შესვლა) as შესვლა, max(გამოსვლა) as გამოსვლა
from მესამე2
group by personnel_ID, date(შესვლა), date(გამოსვლა);

drop view if exists მეხუთე2;
create view მეხუთე2 as
select მეოთხე2.*, timestampdiff(second,შესვლა,გამოსვლა) as სხვაობა_საათებში
from მეოთხე2;

drop view if exists მეექვსე2;
create view მეექვსე2 as
select Personnel_ID, first_name, last_name, shift, sum(სხვაობა_საათებში) as monthly_worked_hours
from მეხუთე2
group by personnel_ID;

select personnel_id, first_name, last_name, shift, sec_to_time(monthly_worked_hours) as hours
from მეექვსე
union
select personnel_id, first_name, last_name, shift, sec_to_time(monthly_worked_hours) as hours
from მეექვსე2