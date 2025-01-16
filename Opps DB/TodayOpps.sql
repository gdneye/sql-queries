SELECT
    o.opportunity_id,
    l.ssn,
    l.cell_phone ,
    l.home_phone ,
    l.employer_phone_number ,
    l.first_name ,
    l.last_name ,
    l.employer,
    o.lead_id,
--    o.created_date,
    o.talked_to_customer as ttc,
    o.loan_status,
    o.lead_source,
    CASE
        WHEN o.lead_sub_source LIKE '%-%' THEN LEFT(o.lead_sub_source, POSITION('-' IN o.lead_sub_source) - 1)
        WHEN o.lead_sub_source LIKE '%\_%' THEN LEFT(o.lead_sub_source, POSITION('_' IN o.lead_sub_source) - 1)
        ELSE o.lead_sub_source
    END as parent,    
    o.lead_sub_source ,
    o.customer_ip AS opp_ip,
    l.customer_ip AS lead_ip,
    o.created_date ,
    aka,
    if(flags LIKE '%gr":%',json_unquote(json_extract(flags,'$.gr')),'') as gr,
    CASE 
        WHEN o.customer_ip = l.customer_ip THEN 'Match'
        ELSE 'No Match'
    END AS ip_match,
        if(flags LIKE '%fbd":"%',json_unquote(json_extract(flags,'$.fbd')),'') as fbd,
    if(flags LIKE '%cnt18":"%',json_unquote(json_extract(flags,'$.cnt18')),'') as cnt18
FROM 
    lms.opportunities o
LEFT JOIN 
    lms.leads l ON o.lead_id = l.lead_id
WHERE 
    o.created_date > CURDATE() - INTERVAL 0 DAY
     AND o.lead_source NOT like ('%react%')
     AND o.lead_source NOT like ('%web%')
--     AND 
--     if((    	CAST(o.aka AS BINARY)  LIKE 'Mozilla/5.0 (%'
--        AND (o.aka REGEXP 'Mozilla/5\\.0 \\(iPad; CPU OS 17(_[0-9]+){1,2} like Mac OS X\\) AppleWebKit/605\\.1\\.15 \\(KHTML, like Gecko\\)' 
--        OR o.aka REGEXP 'Mozilla/5\\.0 \\(iPhone; CPU iPhone OS 1[6-8](_[0-9]+){1,2} like Mac OS X\\) AppleWebKit/605\\.1\\.15 \\(KHTML, like Gecko\\)'
--        OR o.aka REGEXP 'Mozilla/5\\.0 \\(Linux; Android 10; K\\) AppleWebKit/537\\.36 \\(KHTML, like Gecko\\) Chrome\\/12[4-9]' 
--        OR o.aka REGEXP 'Mozilla/5\\.0 \\(Linux; Android 10; K\\) AppleWebKit/537\\.36 \\(KHTML, like Gecko\\) S' 
--        OR o.aka REGEXP 'Mozilla/5\\.0 \\(Macintosh; Intel Mac OS X 10_15_[0-9]\\) AppleWebKit/(537\\.36|605\\.1\\.15) \\(KHTML, like Gecko\\) Chrome\\/1[1-2][1-9]'  
--        OR o.aka REGEXP 'Mozilla/5\\.0 \\(Macintosh; Intel Mac OS X 10_15_[0-9]\\) AppleWebKit/(537\\.36|605\\.1\\.15) \\(KHTML, like Gecko\\) Version'  
--        OR o.aka REGEXP 'Mozilla/5\\.0 \\(Windows NT 10.0; Win64; x64\\) AppleWebKit/537\\.36 \\(KHTML, like Gecko\\) Chrome\\/12[4-9]' 
--    )),0,1) = 1
--    and aka <> ''
--    and aka like '%X11%'
     order by lead_id desc
    