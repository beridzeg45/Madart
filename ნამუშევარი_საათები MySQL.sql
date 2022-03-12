drop view if exists პირველი;
create view პირველი as
select t1.Personnel_ID, t1.First_Name, t1.Last_Name, t1.Date_And_Time as შესვლა ,t2.Date_And_Time as გამოსვლა
from თანამშრომლები as t1
join თანამშრომლები as t2
on t1.Personnel_ID=t2.Personnel_ID
where date(t1.date_and_time)=date(t2.date_and_time) and
t1.Date_And_Time !=t2.Date_And_Time and
t1.Date_And_Time<t2.Date_And_Time;

drop view if exists მეორე;
create view მეორე as 
select პირველი.*, round(timestampdiff(second,შესვლა,გამოსვლა)/3600,3) as სხვაობა_საათებში
from პირველი;

select Personnel_ID, first_name, last_name, sum(სხვაობა_საათებში) as monthly_worked_hours
from მეორე
group by personnel_ID