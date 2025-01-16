SELECT 
    DATE_FORMAT(o.created_date, '%Y-%m') AS month,
    POS,
    COUNT(*) AS total_leads,
    SUM(CASE WHEN o.loan_status = 'Funded' THEN 1 ELSE 0 END) AS funded_leads,
    SUM(CASE WHEN o.loan_status = 'Funded' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS conversion_rate,
    SUM(CASE WHEN fbd IS NOT NULL THEN fbd ELSE 0 END) AS total_fbd,  -- Sum of FBD values excluding rescinded
    SUM(CASE WHEN fbd IS NOT NULL THEN 1 ELSE 0 END) AS non_null_fbd_count,  -- Count of non-null FBDs excluding rescinded
    (SUM(CASE WHEN fbd IS NOT NULL THEN fbd ELSE 0 END) / SUM(CASE WHEN fbd IS NOT NULL THEN 1 ELSE 0 END)) * 100 AS fbd_percentage,  -- FBD calculation excluding rescinded
    CASE 
        WHEN SUM(CASE WHEN o.loan_status = 'Funded' THEN 1 ELSE 0 END) > 0 
        THEN (SUM(CASE WHEN fbd IS NOT NULL THEN 1 ELSE 0 END) / SUM(CASE WHEN o.loan_status = 'Funded' THEN 1 ELSE 0 END)) * 100
        ELSE 0
    END AS cured_percentage  -- Cured percentage calculation
FROM (
    SELECT o.opportunity_id, o.lead_id, o.flags, o.created_date, o.loan_status,
        CASE
            WHEN l.datax_reject_idv LIKE '%P11%' 
              OR l.datax_reject_idv LIKE '%P21%' 
              OR l.datax_reject_idv LIKE '%C1%' 
            THEN 1
            ELSE 0
        END AS POS,
        CASE
            -- Only include FBD in the calculation when loan_status is not rescinded
            WHEN o.flags LIKE '%fbd":"%' AND o.loan_status != 'Rescinded'
            THEN json_unquote(json_extract(o.flags,'$.fbd'))
            ELSE NULL
        END AS fbd
    FROM lms.opportunities o
    JOIN lms.leads l ON o.lead_id = l.lead_id
    WHERE o.created_date > '2023-06-01'
      AND o.lead_source NOT LIKE ('%react%')
      AND o.lead_source NOT LIKE ('%web%')
) AS o
GROUP BY month
ORDER BY month desc, POS;
