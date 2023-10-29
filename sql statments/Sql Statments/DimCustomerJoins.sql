select c.*, ad.city,ad.street_name, ad.street_number, co.country_name
from customer c
left outer join customer_address ca
on c.customer_id = ca.customer_id
left outer join address ad
on ca.address_id = ad.address_id
left outer join country co
on ad.country_id = co.country_id
