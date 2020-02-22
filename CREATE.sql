use product_test; 
/*
	use [Changed to match with your database];
*/

create table product (
	product_id int not null unique,			
    description varchar(255),				
    cost decimal(10,2) not null,			
    price decimal(10,2) not null,								
    color varchar(255),		
	dimension varchar(255),				
	size varchar(255),					
    last_update timestamp,
    create_date timestamp,
    primary key (product_id)
);

create table category (
	cate_id int not null unique,
    category_name varchar(255),
    last_update timestamp,
    create_date timestamp,
    
    primary key (cate_id)
);

create table brand (
	brand_id int not null  unique,
    brand_name varchar(255),
    last_update timestamp,
    create_date timestamp,
    primary key (brand_id)
);

create table product_category (
	product_id int not null,
    category_id int not null,
    
    foreign key (product_id) references product (product_id),
    foreign key (cate_id) references category (cate_id)
);

create table product_brand (
	product_id int not null,
    brand_id int not null,
    
    foreign key (product_id) references product (product_id),
    foreign key (brand_id) references brand (brand_id)
);


create table customer (
	cust_id int not null unique,
    last_name varchar(255) not null,
    first_name varchar(255) not null,
    last_update timestamp,
    created_date timestamp
);

create table cart (
/*
	Assume application exist
    the data in this table is generated at the moment customer add item to cart
    
    Scenario:
	a customer add one item to cart on 01/28/20
	then continuously add more item to cart after the first initiation.
	Adding more item to the current cart doesn't affect the data in this table.
	The table products_customer will handle that process.
	
	Now we assume customer paid for the transaction, data will look like the following table.
	
    purchase_date	customer_id		dummy_id	cart_id			status
    01-28-20		1				1			101/28/201		PAID
    01-28-20		1				2			101/28/202		HOLD
    01-28-20		2				1			201/28/201		PAID
    01-25-20		1				1			101/25/201		PAID
	
	Notice, the second row where status is set as HOLD, it mean customer added item to add but didn't pay.
	Data with "hold" status will be removed automaticly by Application after [time] hours.
	
	
*/

	cart_id int not null,
	purchase_date timestamp not null,
    cust_id int not null,
    status ENUM ('PAID','HOLD','DROP'),
	number_of_items int not null,
  --  cart_id_concat varchar(255) not null unique,  --is this commented out for a reason?,
    /*constraint cart_id_concat*/ primary key (customer_id, purchase_date, cart_id),
    foreign key (cust_id) references customer (cust_id)
);


create table customer_cart (
	cart_id int not null,
	--created_date timestamp not null, --from ER diagram, remove if not necessary,
    cust_id int not null,
    purchase_date timestamp not null,
	foreign key (cust_id) references customer (cust_id),
	foreign key (cust_id, purchase_date, cart_id) references cart (cust_id, purchase_date, cart_id)
);


create table trans (
	cust_id int not null,
	trans_id int not null,
    paid_date timestamp not null,
    paid_method ENUM('CREDIT', 'CHECK'),
    paid_status  ENUM('SUCCESS', 'DECLINE', 'REVERT', 'REFUND'),
    card_number int not null,	-- ints only go up to 4 bytes, where credit card numbers are often 16 integers. We may need to use an 8-byte 'bigInt' or something.
	primary key (cust_id, paid_date, trans_id)
);

create table cart_trans (
	cust_id int not null,
    trans_id int not null,
    paid_date timestamp not null,
    cart_id int not null,
	foreign key (cust_id, paid_date, cart_id) references cart (cust_id, paid_date, cart_id),
	foreign key (cust_id, paid_date, trans_id) references trans (cust_id, paid_date, trans_id)
);


create table search_history (
	cust_id int not null,
    product_id int,
    search_date datetime,
    search_description varchar(255),
    status ENUM ('FOUND', 'NOT FOUND') not null,
	foreign key (cust_id) references customer (cust_id),
    foreign key (product_id) references product (product_id)
);

create table product_customer(
	cust_id int not null,
    product_id int not null,
    purchased_date timestamp not null,
    foreign key (cust_id) references customer (cust_id),
    foreign key (product_id) references product (product_id)
);

