drop view if exists პირველი;
create view პირველი as
select ID, თარიღი, trim(დებეტი) as დებეტი, trim(კრედიტი) as კრედიტი
from საწყობი;

drop view if exists მეორე;
create view მეორე as
select პირველი.*, if(mid(კრედიტი,6,2)="  ",mid(დებეტი,6,2),mid(კრედიტი,6,2)) as საწყობის_კოდი
from პირველი;

drop view if exists მესამე;
create view მესამე as
select მეორე.*, concat(ID, საწყობის_კოდი) as გაერთიანებული
from მეორე;

drop view if exists მეოთხე;
create view მეოთხე as
select distinct გაერთიანებული 
from მესამე;

drop view if exists მეხუთე;
create view მეხუთე as
select გაერთიანებული, left(გაერთიანებული,8) as ID, right(გაერთიანებული,2) as საწყობის_კოდი
from მეოთხე;

drop view if exists მეექვსე;
create view მეექვსე as
select გაერთიანებული, ID as დუბლიკატID, საწყობის_კოდი 
from მეხუთე
group by ID
having count(ID)>1;

drop view if exists მეშვიდე;
create view მეშვიდე as
select მეხუთე.ID, მეხუთე.საწყობის_კოდი
from მეექვსე
left join მეხუთე
on მეექვსე.დუბლიკატID=მეხუთე.ID;


drop view if exists მერვე;
create view მერვე as
select ID, თარიღი, mid(დებეტი,18,75) as მასალა, კრედიტი
from პირველი
where კრედიტი like "1630%";

drop view if exists მერვე2;
create view მერვე2 as
select ID, თარიღი, trim(მასალა) as მასალა, კრედიტი
from მერვე;

drop view if exists მეცხრე;
create view მეცხრე as
select მეშვიდე.ID, საწყობის_კოდი, მასალა, concat(მასალა,საწყობის_კოდი) as მასალასაწყობის_კოდი
from მეშვიდე
left join მერვე2
on მეშვიდე.ID=მერვე2.ID
group by ID, საწყობის_კოდი;

drop view if exists წერეთელი2;
create view წერეთელი2 as
select წერეთელი.*, trim(გაერთიანებული) as გაერთიანებული2
from წერეთელი;

drop view if exists მეათე;
create view მეათე as
select მეცხრე.*, საწყობი
from მეცხრე
left join წერეთელი2
on მეცხრე.მასალასაწყობის_კოდი=წერეთელი2.გაერთიანებული2;

select *
from მეათე
where საწყობი is null
