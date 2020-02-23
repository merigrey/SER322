use product_test; 
/*
	use [Changed to match with your database];
*/

create table products (
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
	category_id int not null unique,
    category_name varchar(255),
    last_update timestamp,
    create_date timestamp,
    
    primary key (category_id)
);

create table brand (
	brand_id int not null  unique,
    brand_name varchar(255),
    last_update timestamp,
    create_date timestamp,
    primary key (brand_id)
);

create table products_category (
	product_id int not null,
    category_id int not null,
    
    foreign key (product_id) references products (product_id),
    foreign key (category_id) references category (category_id)
);

create table products_brand (
	product_id int not null,
    brand_id int not null,
    
    foreign key (product_id) references products (product_id),
    foreign key (brand_id) references brand (brand_id)
);


create table customer (
	customer_id int not null unique,
    last_name varchar(255) not null,
    first_name varchar(255) not null,
    last_update timestamp,
    create_date timestamp
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
    customer_id int not null,
    status ENUM ('PAID','HOLD','DROP'),
    --count int not null, --COUNT is a keyword, removed and replaced with:
	number_of_items int not null,
  --  cart_id_concat varchar(255) not null unique,  --is this commented out for some reason?
    /*constraint cart_id_concat*/ primary key (customer_id, purchase_date, cart_id),
    foreign key (customer_id) references customer (customer_id)
);


create table customer_cart (
	cart_id int not null,
    customer_id int not null,
	--created_date timestamp not null, --from ER diagram, remove if not necessary,
    purchase_date timestamp not null,
	foreign key (customer_id) references customer (customer_id),
	foreign key (customer_id, purchase_date, cart_id) references cart (customer_id, purchase_date, cart_id)
);


create table trans (
	customer_id int not null,
	trans_id int not null,
    purchase_date timestamp not null,
    paid_method ENUM('CREDIT', 'CHECK'),
    paid_status  ENUM('SUCCESS', 'DECLINE', 'REVERT', 'REFUND'),
    card_number int not null, --card numbers are often 16 integers, which is >4bytes, the max for int holders in Java?
	primary key (customer_id, purchase_date, trans_id)
);

create table trans_cart (
	customer_id int not null,
    trans_id int not null,
    purchase_date timestamp not null,
    cart_id int not null,
	foreign key (customer_id, purchase_date, cart_id) references cart (customer_id, purchase_date, cart_id),
	foreign key (customer_id, purchase_date, trans_id) references trans (customer_id, purchase_date, trans_id)
);


create table search_history (
	customer_id int not null,
    product_id int,
    search_date datetime,
    search_description varchar(255),
    search_status ENUM ('FOUND', 'NOT FOUND') not null,
	foreign key (customer_id) references customer (customer_id),
    foreign key (product_id) references products (product_id)
);

create table product_cust(
	customer_id int not null,
    product_id int not null,
    purchase_data timestamp not null,
    foreign key (customer_id) references customer (customer_id),
    foreign key (product_id) references products (product_id)
);

