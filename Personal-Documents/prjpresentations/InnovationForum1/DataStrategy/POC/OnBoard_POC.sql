  
	drop TABLE poc_datastore.uo_client;
	drop TABLE poc_datastore.uo_user;
	drop type poc_datastore.uo_udd_billing_addr;
 
	CREATE TABLE poc_datastore.uo_User
	( created_by  text
		,created_date timestamp
		,modified_by text
		,modified_date timestamp
		,id text
		,source text
		,user_name text
		,temp_user_name text
		,name text
		,email_addr text
		,version text
		,company_id text
		,phone_nbr text
		,pivot_status  text
		,load_ts timestamp 
		,PRIMARY KEY ((id, email_addr), temp_user_name, source,name,company_id)
		) WITH bloom_filter_fp_chance = 0.01
		AND comment = ''
		AND crc_check_chance = 1.0
		AND dclocal_read_repair_chance = 0.1
		AND default_time_to_live = 0
		AND gc_grace_seconds = 864000
		AND max_index_interval = 2048
		AND memtable_flush_period_in_ms = 0
		AND min_index_interval = 128
		AND read_repair_chance = 0.0
		AND speculative_retry = '99.0PERCENTILE'
		AND caching = {
			'keys' : 'ALL',
			'rows_per_partition' : 'NONE'
		}
		AND compression = {
			'chunk_length_in_kb' : 64,
			'class' : 'LZ4Compressor',
			'enabled' : true
		}
		AND compaction = {
			'class' : 'SizeTieredCompactionStrategy',
			'max_threshold' : 32,
			'min_threshold' : 4
		};



	CREATE type poc_datastore.uo_udd_billing_addr
	( 
		steet_addr text,
		zip text,
		city text, 
		state text, 
		country text
	); 

	CREATE TABLE poc_datastore.uo_client  (
		id text,
		company_id text,
		company_name text,
		created_by text,
		created_date timestamp,
		modified_by text,
		modified_date timestamp,
		uo_billing_addr LIST<FROZEN<uo_udd_billing_addr>>,
		version text,
		PRIMARY KEY (id, company_id, company_name)
	) WITH bloom_filter_fp_chance = 0.01
	AND comment = ''
	AND crc_check_chance = 1.0
	AND dclocal_read_repair_chance = 0.1
	AND default_time_to_live = 0
	AND gc_grace_seconds = 864000
	AND max_index_interval = 2048
	AND memtable_flush_period_in_ms = 0
	AND min_index_interval = 128
	AND read_repair_chance = 0.0
	AND speculative_retry = '99.0PERCENTILE'
	AND caching = {
		'keys' : 'ALL',
		'rows_per_partition' : 'NONE'
	}
	AND compression = {
		'chunk_length_in_kb' : 64,
		'class' : 'LZ4Compressor',
		'enabled' : true
	}
	AND compaction = {
		'class' : 'SizeTieredCompactionStrategy',
		'max_threshold' : 32,
		'min_threshold' : 4
	};

  
  
  
 Insert into poc_datastore.uo_client(
		created_by  
		,created_date 
		,modified_by  
		,modified_date
		,id  
		,company_name 
		,version 
		,company_id 
		,uo_billing_addr
		) values
		(  'Onboarding',
			toTimeStamp(now()),
			'Onboarding',toTimeStamp(now()),
 			'0015C00000QIJECQA5',
 			'ABC Enterprises ABC Enterprises1 ABC Enterprises2 ABC Enterprises 3',
 			'0015C00000QIJECQA5',
   			'59',
		  [ { steet_addr : '2 Meridian Xing ',zip :'554545',city :'Richfield', state :'MN', country:'USA'},
			{ steet_addr : '1 Meridian Xing ',zip :'554545',city :'Chicago', state :'IN', country:'USA'}
		  ]
		);
		
		
		select uo_billing_addr  from poc_datastore.uo_client ; 