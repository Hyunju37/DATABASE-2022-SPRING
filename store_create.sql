use Sneakers_shop_DB
Go
if OBJECT_ID (N'dbo.brand', N'U') is not null
drop table dbo.brand
Go
create table brand (
	brand_name		varchar(20),
	num_of_goods	numeric(4,0) check(num_of_goods >= 0),
	primary key (brand_name)
)
if OBJECT_ID (N'dbo.display', N'U') is not null
drop table dbo.display
Go
create table display (
	section			varchar(10),
	section_id		numeric(3,0),
	num_of_rows		numeric(2,0) check(num_of_rows >= 1),
	num_of_columns	numeric(2,0) check(num_of_columns >= 1),
	primary key (section_id)
)
if OBJECT_ID (N'dbo.style', N'U') is not null
drop table dbo.style
Go
create table style (
	brand_name		varchar(20),
	style_name		varchar(40) not null,
	style_code		varchar(20),
	primary key (style_code),
	foreign key (brand_name) references brand(brand_name) on delete cascade
)

if OBJECT_ID (N'dbo.model', N'U') is not null
drop table dbo.model
Go
create table model (
	style_code		varchar(20),
	color			varchar(20),
	model_id		varchar(10),
	gender			varchar(6) check (gender in ('Female', 'Male', 'Unisex')),
	price			numeric(8,0),
	section_id		numeric(3,0),
	section_row		numeric(2,0),
	section_column	numeric(2,0),
	primary key (model_id),
	foreign key (style_code) references style(style_code) on delete cascade,
	foreign key (section_id) references display(section_id) on delete set null
)

if OBJECT_ID (N'dbo.product', N'U') is not null
drop table dbo.product
Go
create table product (
	model_id		varchar(10),
	size			numeric(3,0) check (size >= 110 and size <= 310),
	inventory		numeric(3,0),
	primary key (model_id, size),
	foreign key (model_id) references model(model_id) on delete cascade
)

if OBJECT_ID (N'dbo.member', N'U') is not null
drop table dbo.member
Go
create table member (
	membership_id	varchar(8),
	first_name		varchar(20) not null,
	last_name		varchar(20),
	phone_number	varchar(11),
	point			numeric(10,0),
	join_year		numeric(4,0) check (join_year >=1970),
	join_month		numeric(2,0) check (join_month >= 1 and join_month <= 12),
	join_date		numeric(2,0) check (join_date >= 1 and join_date <=31),
	primary key (membership_id)
)

if OBJECT_ID (N'dbo.buys', N'U') is not null
drop table dbo.buys
Go
create table buys (
	model_id		varchar(10),
	size			numeric(3,0),
	quantity		numeric(2,0) check (quantity > 0),
	approval_number	varchar(15),
	primary key (approval_number, model_id, size),
	--foreign key (membership_id) references member(membership_id) on delete set null,
	foreign key (model_id, size) references product(model_id, size) on delete cascade,
	foreign key (approval_number) references purchase(approval_number) on delete cascade
)
if OBJECT_ID (N'dbo.purchase', N'U') is not null
drop table dbo.purchase
Go
create table purchase (
	approval_number	varchar(15),
	membership_id	varchar(8),
	total			numeric(9,0),
	subtotal		numeric(9,0),
	p_year			numeric(4,0) check (p_year >=1970),
	p_month			numeric(2,0) check (p_month >= 1 and p_month <= 12),
	p_date			numeric(3,0) check (p_date >= 1 and p_date <=31),
	p_hr			numeric(2,0) check (p_hr >= 0 and p_hr < 24),
	p_min			numeric(2,0) check (p_min >= 0 and p_min < 60),
	p_sec			numeric(2,0) check (p_sec >= 0 and p_sec < 60),
	primary key (approval_number),
	foreign key (membership_id) references member(membership_id) on delete set null,
)
if OBJECT_ID (N'dbo.exchanges', N'U') is not null
drop table dbo.exchanges
Go
create table exchanges (
	approval_number		varchar(15),
	old_model_id		varchar(10),
	old_size			numeric(3,0),
	new_model_id		varchar(10),
	new_size			numeric(3,0),
	new_approval_number	varchar(15),
	quantity			numeric(2,0) check (quantity > 0),
	primary key (new_approval_number),
	foreign key (approval_number, old_model_id, old_size) references buys(approval_number, model_id, size),
	foreign key (old_model_id, old_size) references product(model_id, size) on delete set null,
	foreign key (new_model_id, new_size) references product(model_id, size) 
)
if OBJECT_ID (N'dbo.refunds', N'U') is not null
drop table dbo.refunds
Go
create table refunds (
	approval_number		varchar(15),
	model_id			varchar(10),
	size				numeric(3,0),
	new_approval_number	varchar(15),
	quantity			numeric(2,0) check (quantity > 0),
	primary key (new_approval_number),
	foreign key (approval_number, model_id, size) references buys(approval_number, model_id, size),
	foreign key (model_id, size) references product(model_id, size) on delete set null
)





delete from brand;

insert into brand values ('Nike', '40');
insert into brand values ('Adidas', '50');
insert into brand values ('Converse', '20');
insert into brand values ('Reebok', '10');
insert into brand values ('New Balance', '30');
insert into brand values ('Vans', '40');
insert into brand values ('Puma', '40');

select * from brand;

delete from display;

insert into display values ('Hot', '001', '5', '6');
insert into display values ('Running', '002', '6', '5');
insert into display values ('New', '003', '6', '4');
insert into display values ('Sport', '004', '6', '5');
insert into display values ('Kids', '005', '5', '4');

select * from display;

delete from style;

insert into style values('Nike', 'Air Max AP', 'CU4826');
insert into style values('Nike', 'Flex Runner 2 ', 'DJ6038');
insert into style values('Adidas', 'BW ARMY', 'BZ0579');
insert into style values('Converse', 'Chuck Taylor All Star 70', 'CS2058');
insert into style values('Reebok', 'LT COURT', 'RB5116');
insert into style values('Reebok', 'Club C', 'RB5937');
insert into style values('New Balance', '990v5 sneakers', 'ML4081');
insert into style values('Vans', 'OLD SKOOL', 'VN3628');
insert into style values('Puma', 'Clyde core foil sneakers', 'PKI387');
insert into style values('Puma', 'Army Trainer', 'TK1945');

select * from style;

delete from model;

insert into model values('CU4826', 'White', '1010085447', 'Unisex', '119000', '002', '3','4');
insert into model values('CU4826', 'Blue', '1010085442', 'Female', '119000', '002', '4', '4');
insert into model values('DJ6038', 'Black', '1010091013', 'Male', '59000', '001', '4', '3');
insert into model values('BZ0579', 'White', '1010058170', 'Unisex', '139000', '001', '1', '2');
insert into model values('BZ0579', 'Beige', '1010058172', 'Female', '139000', '003', '5', '1');
insert into model values('CS2058', 'Black', '1010063424', 'Unisex', '85000', '001', '4', '2');
insert into model values('CS2058', 'Sunflower', '1010063434', 'Unisex', '75500', '003', '2', '2');
insert into model values('RB5116', 'Gray', '1010090727', 'Unisex', '99000', '004', '3', '5');
insert into model values('RB5116', 'Aqua', '1010090728', 'Unisex', '33000', '005', '2', '1');
insert into model values('RB5937', 'Cream', '1010070428', 'Unisex', '79000', '003', '5', '3');
insert into model values('ML4081', 'GrayBlue', '1010085325', 'Male', '79000', '004', '4', '2');
insert into model values('ML4081', 'Gray', '1010085329', 'Female', '79000', '004', '5', '2');
insert into model values('VN3628', 'Green', '1010034907', 'Unisex', '79000', '004', '4', '3');
insert into model values('PKI387', 'White', '1010090359','Unisex', '84000', '001', '4', '6');
insert into model values('TK1945', 'Cream', '1010090365', 'Unisex', '96000', '002', '5', '2');

select * from model;

delete from product;

insert into product values('1010034907', '225', '1');
insert into product values('1010034907', '240', '2');
insert into product values('1010034907', '265', '3');
insert into product values('1010058170', '240', '0');
insert into product values('1010058170', '250', '3');
insert into product values('1010058170', '280', '2');
insert into product values('1010058170', '290', '1');
insert into product values('1010058172', '220', '1');
insert into product values('1010058172', '230', '3');
insert into product values('1010063424', '235', '2');
insert into product values('1010063424', '245', '2');
insert into product values('1010063424', '255', '2');
insert into product values('1010063434', '240', '1');
insert into product values('1010063434', '300', '2');
insert into product values('1010070428', '220', '3');
insert into product values('1010070428', '230', '2');
insert into product values('1010070428', '260', '2');
insert into product values('1010085325', '260', '1');
insert into product values('1010085325', '270', '3');
insert into product values('1010085329', '220', '3');
insert into product values('1010085329', '240', '2');
insert into product values('1010085442', '230', '3');
insert into product values('1010085442', '240', '2');
insert into product values('1010085442', '250', '2');
insert into product values('1010085447', '240', '1');
insert into product values('1010085447', '260', '2');
insert into product values('1010085447', '280', '3');
insert into product values('1010090359', '225', '2');
insert into product values('1010090359', '260', '3');
insert into product values('1010090359', '290', '2');
insert into product values('1010090365', '230', '3');
insert into product values('1010090365', '250', '1');
insert into product values('1010090365', '280', '2');
insert into product values('1010090727', '240', '2');
insert into product values('1010090727', '255', '3');
insert into product values('1010090727', '270', '1');
insert into product values('1010090728', '170', '1');
insert into product values('1010090728', '190', '2');
insert into product values('1010090728', '200', '2');
insert into product values('1010091013', '280', '2');
insert into product values('1010091013', '290', '3');

select * from product;

delete from member;

insert into member values('75601237', 'James', 'McGill', '01010713726', '13000', '2019', '2', '14');
insert into member values('75602139', 'Mike', 'Ermantraut', '01054420770', '12000', '2019', '3', '31');
insert into member values('75602450', 'Kim', 'Wexler', '01070989860', '25000', '2019', '5', '20');
insert into member values('75602641', 'Nacho', 'Varga', '01099425072', '31000', '2019', '9', '6');
insert into member values('75602858', 'Lalo', 'Salamanca', '01078414997', '8000', '2020', '3', '28');
insert into member values('75602873', 'Kim', 'Kardashian', '01023674420', '54000', '2020', '6', '5');
insert into member values('75603053', 'Khloe', 'Kardashian', '01023357654', '40000', '2020', '11', '06');
insert into member values('75603078', 'Kylie', 'Jenner', '01037245151', '60000', '2020', '12', '24');
insert into member values('75603850', 'Kris', 'Jenner', '01036025818', '52000', '2020', '12', '26');
insert into member values('75603907', 'Hyunju', 'Sung', '01099201680', '14000', '2021', '12', '1');

select * from member;

delete from buys;

insert into buys values('1010085325', '270', '1', '1901099470'); --Jimmy
insert into buys values('1010058170', '240', '1', '1901099477'); --Kim Wex
insert into buys values('1010058170', '280', '1', '1901099477'); --Kim Wex
insert into buys values('1010091013', '290', '1', '2001099287'); --Lalo
insert into buys values('1010090727', '240', '1', '2001099365'); --Kim k
insert into buys values('1010034907', '265', '1', '2001099367'); --Nacho
insert into buys values('1010090359', '260', '1', '2001099374'); --Kris
insert into buys values('1010085442', '230', '1', '2001099396'); --Kylie
insert into buys values('1010090728', '190', '1', '2001099396'); --Kylie
insert into buys values('1010063434', '240', '1', '2001099482'); --Khloe
insert into buys values('1010058172', '230', '1', '2001099561'); --Kim K
insert into buys values('1010085447', '280', '1', '2001099673'); --Jimmy
insert into buys values('1010085329', '220', '1', '2001099688'); --HJ

select * from buys;

delete from purchase;

insert into purchase values('1901099470', '75601237', '79000', '79000', '2019', '5', '15', '11', '11', '39');
insert into purchase values('1901099477', '75602450', '278000', '258000', '2019', '5', '26', '15', '03', '20');
insert into purchase values('2001099287', '75602858', '59000', '49000', '2020', '3', '28', '12', '45', '00');
insert into purchase values('2001099365', '75602873', '99000', '99000', '2020', '6', '30', '17', '31', '50');
insert into purchase values('2001099367', '75602641', '79000', '79000', '2020', '7', '5', '14', '50', '29');
insert into purchase values('2001099374', '75603850', '84000', '84000', '2021', '2', '23', '13', '07', '36');
insert into purchase values('2001099396', '75603078', '152000', '152000', '2021', '5', '16', '13', '42', '53');
insert into purchase values('2001099482', '75603053', '75500', '75500', '2021', '6', '21', '15', '22', '30');
insert into purchase values('2001099561', '75602873', '139000', '139000', '2021', '7', '15', '12', '33', '29');
insert into purchase values('2001099673', '75601237', '119000', '10900', '2021', '10', '3', '16', '53', '59');
insert into purchase values('2001099688', '75603907', '79000', '79000', '2021', '12', '25', '17', '27', '30');

select * from purchase;

delete from exchanges;

insert into exchanges values('2001099561', '1010058172', '230', '1010058172', '220', '2001099562', '1');
insert into exchanges values('2001099396', '1010085442', '230', '1010085442', '240', '2001099397', '1');

select * from exchanges;

delete from refunds;

insert into refunds values('2001099367', '1010034907', '265', '2001099369', '1');

select * from refunds;




select * from INFORMATION_SCHEMA.TABLES


select brand_name, style_name
from style
group by brand_name, style_name

select distinct style_code
from model

delete from style
where brand_name='Converse'

delete from model
where style_code in (
	select style_code
	from style
	where brand_name='Nike'
)

select * from model;

delete from model
where price <
	(select avg(price)	
	from model)

select * from model

select * from product

insert into product values('1010085329', '230', '3');

--on sale!
update model
	set price=price*0.8
	where price > 100000

--Receiving product
update product
	set inventory+=1
	where model_id='1010090365' 
	and size='250'

--updating member's point
update member
set point += (
	select sum(total)*0.01
	from purchase
	where purchase.membership_id=member.membership_id 
)

select * from member