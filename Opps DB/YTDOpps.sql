SELECT
    o.created_date,
    l.email,
    o.opportunity_id as opp_id,
    l.lead_id,
    l.lead_source,
    CASE
        WHEN o.lead_sub_source LIKE '%-%' THEN LEFT(o.lead_sub_source, POSITION('-' IN o.lead_sub_source) - 1)
        WHEN o.lead_sub_source LIKE '%\_%' THEN LEFT(o.lead_sub_source, POSITION('_' IN o.lead_sub_source) - 1)
        ELSE o.lead_sub_source
    END as parent,
	CASE
    	WHEN o.lead_sub_source LIKE '%-%' THEN SUBSTRING(o.lead_sub_source, POSITION('-' IN o.lead_sub_source) + 1)
    	WHEN o.lead_sub_source LIKE '%\_%' THEN SUBSTRING(o.lead_sub_source, POSITION('_' IN o.lead_sub_source) + 1)
    	ELSE ''
	END AS child,
    o.lead_id,
    o.talked_to_customer as ttc,
    o.loan_status,
    if(flags LIKE '%fbd":"%',json_unquote(json_extract(flags,'$.fbd')),'') as fbd,
    if(flags LIKE '%cnt18":"%',json_unquote(json_extract(flags,'$.cnt18')),'') as cnt18,
    l.bank_name as 'l.bank_name',
    o.bank_name as 'o.bank_name',
    l.routing_number as 'l.aba',
    o.routing_number as 'o.aba',
    aka,
    o.customer_ip AS 'o.ip',
    l.customer_ip AS 'l.ip',
    CASE 
        WHEN o.customer_ip = l.customer_ip THEN 'Match'
        ELSE 'No Match'
    END AS ip_match,
    CASE
        WHEN l.datax_reject_idv LIKE '%P11%' 
          OR l.datax_reject_idv LIKE '%P21%' 
          OR l.datax_reject_idv LIKE '%C1%' 
        THEN 1
        ELSE 0
    END AS POS,
    l.ebureau_fraud_score,
    if(flags LIKE '%gr":%',json_unquote(json_extract(flags,'$.gr')),'') as gr
FROM 
    lms.opportunities o
JOIN 
    lms.leads l ON o.lead_id = l.lead_id
WHERE 
    o.created_date > '2024-01-01'
     AND o.lead_source NOT like ('%react%')
     AND o.lead_source NOT like ('%web%')
--     and o.lead_sub_source like '%123485231'
--     and o.customer_ip = '104.28.50.132'
     and CASE WHEN o.lead_sub_source LIKE '%-%' THEN LEFT(o.lead_sub_source, POSITION('-' IN o.lead_sub_source) - 1) WHEN o.lead_sub_source LIKE '%\_%' THEN LEFT(o.lead_sub_source, POSITION('_' IN o.lead_sub_source) - 1) ELSE o.lead_sub_source
    END IN ('101909')
--    and l.lead_sub_source like '%710572531'
--     and o.loan_status = 'Funded'
--    and talked_to_customer <> ''
Order by o.lead_id Desc
     