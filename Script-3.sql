select
	l_returnflag,
	l_linestatus,
	sum(l_quantity) as sum_qty,
	sum(l_extendedprice) as sum_base_price,
	sum(l_extendedprice * (1 - l_discount)) as sum_disc_price,
	sum(l_extendedprice * (1 - l_discount) * (1 + l_tax)) as sum_charge,
	avg(l_quantity) as avg_qty,
	avg(l_extendedprice) as avg_price,
	avg(l_discount) as avg_disc,
	count(*) as count_order
from
	lineitem
where
	l_shipdate <= date '1998-12-01' - interval ':1' day 
group by
	l_returnflag,
	l_linestatus
order by
	l_returnflag,
	l_linestatus;


select l_orderkey, sum(l_extendedprice * (1 - l_discount)) as revenue, o_orderdate, o_shippriority 
from CUSTOMER, ORDERS, LINEITEM 
where c_mktsegment = 'AUTOMOBILE' 
and c_custkey = o_custkey 
and 
l_orderkey = o_orderkey 
and o_orderdate < date '1995-03-13' 
and l_shipdate > date '1995-03-13' 
group by l_orderkey, o_orderdate, o_shippriority 
order by revenue desc, o_orderdate limit 10;



select o_orderpriority, count(*) as order_count 
from ORDERS 
where o_orderdate >= date '1995-01-01' 
and o_orderdate < date '1995-01-01' + interval '3' month 
and exists (select * from LINEITEM where l_orderkey = o_orderkey and l_commitdate < l_receiptdate) 
group by o_orderpriority order by o_orderpriority;



select n_name, sum(l_extendedprice * (1 - l_discount)) as revenue 
from CUSTOMER, ORDERS, LINEITEM, SUPPLIER, NATION, REGION 
where c_custkey = o_custkey 
and l_orderkey = o_orderkey 
and l_suppkey = s_suppkey 
and c_nationkey = s_nationkey 
and s_nationkey = n_nationkey 
and n_regionkey = r_regionkey 
and r_name = 'MIDDLE EAST' 
and o_orderdate >= date '1994-01-01' 
and o_orderdate < date '1994-01-01' + interval '1' year 
group by n_name order by revenue desc;


select supp_nation, cust_nation, l_year, sum(volume) as revenue 
from ( select n1.n_name as supp_nation, n2.n_name as cust_nation, extract(year from l_shipdate) as l_year, 
l_extendedprice * (1 - l_discount) as volume 
from SUPPLIER, LINEITEM, ORDERS, CUSTOMER, NATION n1, NATION n2 
where s_suppkey = l_suppkey 
and o_orderkey = l_orderkey 
and c_custkey = o_custkey 
and s_nationkey = n1.n_nationkey 
and c_nationkey = n2.n_nationkey 
and ((n1.n_name = 'JAPAN' and n2.n_name = 'INDIA') or (n1.n_name = 'INDIA' and n2.n_name = 'JAPAN')) 
and l_shipdate between date '1995-01-01' and date '1996-12-31') 
as shipping 
group by supp_nation, cust_nation, l_year 
order by supp_nation, cust_nation, l_year;



select ps_partkey, sum(ps_supplycost * ps_availqty) as value 
from PARTSUPP, SUPPLIER, NATION 
where ps_suppkey = s_suppkey and s_nationkey = n_nationkey and n_name = 'MOZAMBIQUE' 
group by ps_partkey having sum(ps_supplycost * ps_availqty) > (select sum(ps_supplycost * ps_availqty) * 0.0001000000 
from PARTSUPP, SUPPLIER, NATION 
where ps_suppkey = s_suppkey and s_nationkey = n_nationkey and n_name = 'MOZAMBIQUE')
order by value desc;



SELECT * FROM partsupp ps 
WHERE ps_suppkey 
IN (SELECT s_suppkey FROM supplier 
WHERE ps.ps_suppkey=s_suppkey 
AND s_acctbal > 0);





