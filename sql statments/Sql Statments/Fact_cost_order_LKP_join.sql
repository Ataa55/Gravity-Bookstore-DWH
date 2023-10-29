select co.*, sh.* from cust_order co
left outer join shipping_method sh
on co.shipping_method_id = sh.method_id