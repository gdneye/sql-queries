SELECT DATE_FORMAT(funded_date, '%Y-%m') as funded_month, 
       COUNT(opportunity_id) as total_number, 
       SUM(principal_amount) as total_amount, 
       COUNT(if(lead_source IN('react','re-applied react'),opportunity_id,NULL)) as react_number, 
       SUM(if(lead_source IN('react','re-applied react'),principal_amount,0)) as react_amount, 
       COUNT(if(lead_source = 'direct_mail',opportunity_id,NULL)) as dm_number, 
       SUM(if(lead_source = 'direct_mail',principal_amount,0)) as dm_total, 
       COUNT(if(lead_source NOT IN('react','re-applied react','direct_mail'),opportunity_id,NULL)) as external_number, 
       SUM(if(lead_source NOT IN('react','re-applied react','direct_mail'),principal_amount,0)) as external_amount
FROM(
  SELECT a.*, 
         if(b.collect_date is null, last_accepted + INTERVAL 2 month, b.collect_date) as collect_date, 
         datediff(last_day(curdate()),last_accepted) as pay_days, 
         datediff(last_day(curdate()),if(collect_date is null, last_accepted + INTERVAL 2 month, collect_date)) as collect_days
  FROM(
    SELECT p.opportunity_id, o.principal_amount, write_off_date, pay_frequency, current_status, paying_with_cc, lead_source, loan_status, funded_date, 
           MAX(if(payment_name = 'payment' and response = 'accepted', posted_date, funded_date)) as last_accepted
    FROM lms.payments p 
    JOIN (
      SELECT opportunity_id, principal_amount, write_off_date, pay_frequency, current_status, paying_with_cc, zip, lead_source, funded_date, loan_status
      FROM lms.opportunities
      WHERE current_status IN('collections') 
        AND write_off <> 1 
        AND third_party_collect = 0 
        AND loan_status = 'funded' 
        AND write_off_date < '2014-01-01'
    ) o ON p.opportunity_Id = o.opportunity_id 
    GROUP BY opportunity_id
  ) a 
  LEFT JOIN (
    SELECT record_id, date(modified_date_time) as collect_date
    FROM (
      SELECT record_id, modified_date_time, new_value
      FROM lms.audit_trail
      WHERE field_name = 'current_status'
        AND new_value = 'collections'
      ORDER BY record_id, modified_date_time asc 
      LIMIT 100000000
    ) t
    GROUP BY record_id
  ) b ON a.opportunity_id = b.record_id
) t
WHERE if(pay_frequency IN('bi weekly','semi monthly'), pay_days >= 75, pay_days >= 90)
  AND collect_days >= 42 
  AND principal_amount > 10
  AND paying_with_cc <> 1
GROUP BY DATE_FORMAT(funded_date, '%Y-%m')
Order by funded_month desc
