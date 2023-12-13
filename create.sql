DROP TABLE state CASCADE;
DROP TABLE realm CASCADE;
DROP TABLE quality_type CASCADE;
DROP TABLE quality CASCADE;
DROP TABLE customer CASCADE;
DROP TABLE delivery_place CASCADE;
DROP TABLE associate CASCADE;
DROP TABLE "user" CASCADE;
DROP TABLE yarn_type CASCADE;
DROP TABLE yarn_code CASCADE;
DROP TABLE yarn CASCADE;
DROP TABLE currency CASCADE;
DROP TABLE composition CASCADE;
DROP TABLE "order" CASCADE;
DROP TABLE colour CASCADE;
DROP TABLE order_item CASCADE;
DROP TABLE options CASCADE;
DROP TABLE order_item_options CASCADE;
DROP TABLE delivery CASCADE;
DROP TABLE quality_finish CASCADE;
DROP TABLE knitting_order CASCADE;
DROP TABLE batch CASCADE;
DROP TABLE employee CASCADE;
DROP TABLE stock CASCADE;
DROP TABLE qc_test CASCADE;
DROP TABLE log;


CREATE TABLE log (
	log_id serial PRIMARY KEY,
	ts timestamptz default now(),
	name varchar default current_user,
	query varchar,
	params varchar[]
);

select 'state';
CREATE TABLE state (
	state_id serial PRIMARY KEY,
	realm_id integer,
	state_name varchar CHECK(NOT state_name IS NULL AND state_name <> ''),
	next_state integer[],
	state_last_changed timestamptz default now(),
	state_history varchar DEFAULT '' NOT NULL
);

select 'realms';
CREATE TABLE realm (
	realm_id serial PRIMARY KEY,
	realm_name varchar CHECK(NOT realm_name IS NULL AND realm_name <> ''),
	state_id integer references state,
	state_last_changed timestamptz default now(),
	realm_history varchar DEFAULT '' NOT NULL
);
ALTER TABLE state ADD CONSTRAINT "$1" FOREIGN KEY(realm_id) REFERENCES realm;



select 'quality_type';
CREATE TABLE quality_type (
	quality_type_id serial primary key,
	quality_type varchar DEFAULT '' NOT NULL,
	quality_type_last_changed timestamptz default now(),
	quality_type_history varchar DEFAULT '' NOT NULL
);

select 'quality';
CREATE TABLE quality (
	quality_id serial PRIMARY KEY,
	polish_quality_name varchar DEFAULT '',
	danish_quality_name varchar DEFAULT '',
	customer_quality_name varchar DEFAULT '',
	machine_width integer,
	machine_fin integer,
	raw_gramma numeric(5,2),
	raw_width numeric(5,2),
	raw_twice boolean NOT NULL,
	quality_type_id integer references quality_type,
	quality_last_changed timestamptz default now(),
	quality_history varchar DEFAULT '' NOT NULL,
	CONSTRAINT "$1" CHECK(not coalesce(polish_quality_name,danish_quality_name,customer_quality_name) is null)
);

select 'customer';
CREATE TABLE customer (
	customer_id serial PRIMARY KEY,
	name varchar NOT NULL,
	country varchar DEFAULT 'Denmark',
	address varchar NOT NULL,
	city varchar NOT NULL,
	nip varchar,
	regon varchar,
	email varchar,
	contact_person varchar,
	phone varchar,
	customer_last_changed timestamptz default now(),
	customer_history varchar DEFAULT '' NOT NULL
);

select 'delivery_place';
CREATE TABLE delivery_place (
	delivery_place_id serial PRIMARY KEY,
	country varchar DEFAULT 'Denmark'::varchar,
	address varchar NOT NULL,
	city varchar NOT NULL,
	delivery_place_last_changed timestamptz default now(),
	delivery_place_history varchar DEFAULT '' NOT NULL
);

select 'associate';
CREATE TABLE associate (
	associate_id serial PRIMARY KEY,
	area varchar CHECK(area in ('dyehouse','knittinghouse','spedition','stockhouse','customer')),
	company varchar NOT NULL,
	country varchar DEFAULT 'Poland'::varchar,
	address varchar NOT NULL,
	city varchar NOT NULL,
	nip varchar,
	regon varchar,
	associate_last_changed timestamptz default now(),
	associate_history varchar DEFAULT '' NOT NULL
);


select 'user';
CREATE TABLE "user" (
	user_id serial PRIMARY KEY,
	name varchar,
	passwd varchar,
	email varchar,
	customer_id integer references customer,
	user_last_changed timestamptz default now(),
	user_history varchar DEFAULT '' NOT NULL
);

select 'yarn_type';
CREATE TABLE yarn_type (
	yarn_type_id serial PRIMARY KEY,
	yarn_type varchar,
	yarn_type_last_changed timestamptz default now(),
	yarn_type_history varchar DEFAULT '' NOT NULL
);


select 'yarn_code';
CREATE TABLE yarn_code (
	yarn_code_id serial PRIMARY KEY,
	yarn_code varchar NOT NULL,
	yarn_name varchar NOT NULL,
	yarn_code_last_changed timestamptz default now(),
	yarn_code_history varchar DEFAULT '' NOT NULL
);


select 'yarn';
CREATE TABLE yarn (
	yarn_id serial PRIMARY KEY,
	yarn_code_id integer references yarn_code,
	thickness varchar,
	name varchar,
	unit varchar,
	twist character(1),
	yarn_type_id integer references yarn_type,
	yarn_last_changed timestamptz default now(),
	yarn_history varchar DEFAULT '' NOT NULL,
	CONSTRAINT yarn_twist CHECK (twist IS NULL OR twist = 'S' OR twist = 'Z')
);

select 'currency';
CREATE TABLE currency (
	currency_id serial PRIMARY KEY,
	name varchar,
	abbr varchar(5) NOT NULL,
	currency_last_changed timestamptz default now(),
	currency_history varchar DEFAULT '' NOT NULL
);

select 'composition';
CREATE TABLE composition (
	composition_id serial PRIMARY KEY,
	quality_id integer references quality,
	yarn_id integer references yarn,
	percentage integer CHECK (percentage >= 0 AND percentage <= 100)
);


select 'order';
CREATE TABLE "order" (
	order_id serial PRIMARY KEY,
	customer_id integer references customer,
	customer_order_no varchar DEFAULT '' NOT NULL,
	order_state_id integer references state,
	order_date date DEFAULT now() NOT NULL,
	quality_id integer references quality,
	added_by integer references "user",
	added_ts timestamp with time zone DEFAULT now() NOT NULL,
	order_notes varchar,
	order_last_changed timestamptz default now(),
	order_history varchar DEFAULT '' NOT NULL
);

select 'colour';
CREATE TABLE colour (
	colour_id serial PRIMARY KEY,
	name varchar,
	code varchar,
	customer_id integer references customer,
	quality_id integer references quality,
	dyehouse_id integer references associate,
	registration_date date DEFAULT now(),
	dh_in_date date,
	dh_out_date date,
	send_date date,
	acceptation_date date DEFAULT (now() + '3 days'::interval),
	recipe varchar,
	dh_number varchar,
	round integer DEFAULT 1 NOT NULL,
	dh_done_date timestamp with time zone,
	dh_prepared_pieces integer,
	dh_sent_pieces integer,
	colour_last_changed timestamptz default now(),
	colour_history varchar DEFAULT '' NOT NULL
);

select 'order_item';
CREATE TABLE order_item (
	order_id integer references "order",
	position integer DEFAULT 1 NOT NULL,
	delivery_place_id integer references delivery_place,
	amount_kg numeric(7,2) NOT NULL,
	amount_m numeric(7,2),
	colour varchar,
	colour_id integer references colour,
	price numeric(7,2),
	currency_id integer references currency,
	requested_date date NOT NULL,
	confirmed_date date,
	order_item_state_id integer references state,
	dye_with_id integer,
	dye_with_pos integer,
	priority numeric(6,4) DEFAULT 0.0 NOT NULL,
	history text,
	item_notes text,
	order_item_last_changed timestamptz default now(),
	order_item_history varchar DEFAULT '' NOT NULL,
	CONSTRAINT order_item_pk PRIMARY KEY(order_id,position),
	CONSTRAINT order_item_order_item_fk FOREIGN KEY (dye_with_id, dye_with_pos) REFERENCES order_item(order_id, position)
);

select 'options';
CREATE TABLE options (
	option_id serial PRIMARY KEY,
	option_name varchar CHECK(not option_name is null and not option_name = ''),
	option_type varchar CHECK(option_type in ('boolean','integer','varchar','date','timestamp')),
	options_last_changed timestamptz default now(),
	options_history varchar DEFAULT '' NOT NULL
);

INSERT INTO options (option_name,option_type) VALUES ('sleeve','boolean');
INSERT INTO options (option_name,option_type) VALUES ('enzym','boolean');
INSERT INTO options (option_name,option_type) VALUES ('for_fix','boolean');
INSERT INTO options (option_name,option_type) VALUES ('double_dye','boolean');
INSERT INTO options (option_name,option_type) VALUES ('brussing','boolean');
INSERT INTO options (option_name,option_type) VALUES ('extra_soft','boolean');
INSERT INTO options (option_name,option_type) VALUES ('for_print','boolean');
INSERT INTO options (option_name,option_type) VALUES ('garment','boolean');
INSERT INTO options (option_name,option_type) VALUES ('pigment','boolean');


select 'order_item_options';
CREATE TABLE order_item_options (
	order_item_option_id serial PRIMARY KEY,
	option_id integer references options,
	order_id integer,
	position integer,
	boolean_value boolean DEFAULT NULL,
	integer_value integer DEFAULT NULL,
	varchar_value varchar DEFAULT NULL,
	date_value date DEFAULT NULL,
	timestamp_value timestamptz DEFAULT NULL,
	CONSTRAINT order_item_options_fk FOREIGN KEY (order_id,position) references order_item(order_id,position)
);


select 'delivery';
CREATE TABLE delivery (
	delivery_id serial PRIMARY KEY,
	order_id integer,
	position integer,
	associate_id integer references associate,
	arrival_date date NOT NULL,
	amount_kg numeric(7,2) NOT NULL,
	delivery_last_changed timestamptz default now(),
	delivery_history varchar DEFAULT '' NOT NULL,
	CONSTRAINT delivery_fk FOREIGN KEY (order_id, position) REFERENCES order_item(order_id, position)
);

select 'quality_finish';
CREATE TABLE quality_finish (
	quality_finish_id serial primary key,
	customer_id integer references customer,
	quality_id integer references quality,
	finish_gramma numeric(5,2),
	finish_width numeric(5,2),
	fin_twice boolean NOT NULL,
	quality_finish_last_changed timestamptz default now(),
	quality_history varchar DEFAULT '' NOT NULL
);

select 'knittinorder';
CREATE TABLE knitting_order (
	knitting_order_id serial PRIMARY KEY,
	order_id integer ,
	position integer ,
	associate_id integer references associate,
	quantity numeric(6,2),
	unit varchar CHECK(unit in ('kg','mtr','pcs')),
	knitting_order_date timestamptz DEFAULT now(),
	knitting_order_notes varchar,
	knitting_order_last_changed timestamptz default now(),
	knitting_order_history varchar DEFAULT '' NOT NULL,
	CONSTRAINT knitting_order_fk FOREIGN KEY (order_id, position) REFERENCES order_item(order_id, position)
);

select 'batch';
CREATE TABLE batch (
	batch_id serial PRIMARY KEY,
	order_id integer,
	position integer,
	create_ts timestamptz default now(),
	total_weight numeric(6,2),
	batch_state_id integer references state,
	batch_last_changed timestamptz default now(),
	batch_history varchar DEFAULT '' NOT NULL,
	CONSTRAINT batch_fk FOREIGN KEY (order_id, position) REFERENCES order_item(order_id, position)
);

select 'process';
CREATE TABLE process (
	process_id serial PRIMARY KEY,
	process_name varchar NOT NULL,
	associate_id integer references associate
);

CREATE TABLE processing_order (
	processing_order_id serial PRIMARY KEY,
	process_id integer references process,
	order_id integer,
	position integer,
	CONSTRAINT process_fk FOREIGN KEY (order_id, position) REFERENCES order_item(order_id, position)
);	
CREATE TABLE processing_done (
	processing_done_id serial PRIMARY KEY,
	batch_id integer references batch,
	done_ts timestamptz default now()
);

select 'employee';
CREATE TABLE employee (
	employee_id integer PRIMARY KEY,
	department varchar,
	name varchar,
	employee_last_changed timestamptz default now(),
	employee_history varchar DEFAULT '' NOT NULL
);

select 'stock';
CREATE TABLE stock (
	stock_id serial PRIMARY KEY,
	knitting_order_id integer references knitting_order,
	batch_id integer references batch,
	roll_no varchar default currval('stock_stock_id_seq'),
	lot varchar,
	shift integer CHECK(shift in (1,2,3)),
	prod_date date,
	employee_id integer references employee,
	raw_weight numeric(4,2),
	ready_weight numeric(4,2),
	quality_id integer references quality,
	ts_in timestamptz default now(),
	stock_state_id integer references state,
	stock_last_changed timestamptz default now(),
	stock_history varchar DEFAULT '' NOT NULL
);

select 'qc_test';
CREATE TABLE qc_test (
	test_id serial PRIMARY KEY,
 	batch_id integer references batch,
 	width numeric(5,2),
 	gramma numeric(5,2),
 	shrinkage_l numeric(5,2),
 	shrinkage_w numeric(5,2),
 	associate_id integer references associate,
 	ts timestamptz default now(),
 	acetate varchar,
 	cotton varchar,
 	polyamide varchar,
 	polyester varchar,
 	acryl varchar,
 	wool varchar,
 	wet varchar,
 	dry varchar,
 	grade varchar,
 	laundry_method varchar,
 	dry_method varchar,
 	notes text,
	qc_test_last_changed timestamptz default now(),
	qc_test_history varchar DEFAULT '' NOT NULL
);
























