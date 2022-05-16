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
	section			varchar(1),
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
	style_name		varchar(40),
	style_code		varchar(8),
	primary key (style_code),
	foreign key (brand_name) references brand(brand_name)
)

if OBJECT_ID (N'dbo.model', N'U') is not null
drop table dbo.model
Go
create table model (
	style_code		varchar(8),
	color			varchar(20),
	model_id		varchar(10),
	gender			varchar(6) check (gender in ('Female', 'Male', 'Unisex')),
	price			numeric(8,0),
	section_id		numeric(3,0),
	section_row		numeric(2,0),
	section_column	numeric(2,0),
	primary key (model_id),
	foreign key (style_code) references style(style_code) on delete cascade,
	foreign key (section_id) references display(section_id)
)

if OBJECT_ID (N'dbo.product', N'U') is not null
drop table dbo.product
Go
create table product (
	model_id		varchar(10),
	size			numeric(3,0) check (size >= 110 and size <= 310),
	inventory		numeric(3,0),
	primary key (model_id, size),
	foreign key (model_id) references model(model_id)
)

if OBJECT_ID (N'dbo.member', N'U') is not null
drop table dbo.member
Go
create table member (
	membership_id	varchar(8),
	first_name		varchar(20),
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
	membership_id	varchar(8),
	model_id		varchar(10),
	size			numeric(3,0),
	quantity		numeric(2,0) check (quantity > 0),
	approval_number	varchar(15),
	primary key (approval_number, model_id, size),
	foreign key (membership_id) references member(membership_id),
	foreign key (model_id, size) references product(model_id, size),
	foreign key (approval_number) references purchase(approval_number)
)
if OBJECT_ID (N'dbo.purchase', N'U') is not null
drop table dbo.purchase
Go
create table purchase (
	approval_number	varchar(15),
	total			numeric(9,0),
	subtotal		numeric(9,0),
	p_year			numeric(4,0) check (p_year >=1970),
	p_month			numeric(2,0) check (p_month >= 1 and p_month <= 12),
	p_date			numeric(3,0) check (p_date >= 1 and p_date <=31),
	p_hr			numeric(2,0) check (p_hr >= 0 and p_hr < 24),
	p_min			numeric(2,0) check (p_min >= 0 and p_min < 60),
	p_sec			numeric(2,0) check (p_sec >= 0 and p_sec < 60),
	primary key (approval_number)
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
	foreign key (approval_number) references purchase(approval_number),
	foreign key (old_model_id, old_size) references product(model_id, size),
	foreign key (old_model_id) references model(model_id),
	foreign key (new_model_id, new_size) references product(model_id, size),
	foreign key (new_model_id) references model(model_id)
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
	foreign key (approval_number) references purchase(approval_number),
	foreign key (model_id, size) references product(model_id, size),
	foreign key (model_id) references model(model_id)
)
