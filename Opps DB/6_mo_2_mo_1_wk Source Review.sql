WITH conversion_stats AS (
    SELECT 
        CASE
            WHEN o.lead_sub_source LIKE '%-%' THEN LEFT(o.lead_sub_source, POSITION('-' IN o.lead_sub_source) - 1)
            WHEN o.lead_sub_source LIKE '%\_%' THEN LEFT(o.lead_sub_source, POSITION('_' IN o.lead_sub_source) - 1)
            ELSE o.lead_sub_source
        END as parent,
        COUNT(CASE WHEN o.created_date > DATE_SUB(CURDATE(), INTERVAL 12 month) THEN 1 ELSE NULL END) AS total_last_12_months, 
        SUM(CASE WHEN o.loan_status = 'Funded' AND o.created_date > DATE_SUB(CURDATE(), INTERVAL 12 month) THEN 1 ELSE 0 END) AS funded_last_12_months, 
        SUM(CASE WHEN o.talked_to_customer <> '' AND o.created_date > DATE_SUB(CURDATE(), INTERVAL 12 month) THEN 1 ELSE 0 END) AS ttc_last_12_months, 
        SUM(CASE WHEN o.aka <> '' AND o.created_date > DATE_SUB(CURDATE(), INTERVAL 12 month) THEN 1 ELSE 0 END) AS red_last_12_months, 
        SUM(CASE WHEN o.loan_status = 'Funded' AND o.created_date > DATE_SUB(CURDATE(), INTERVAL 12 month) AND o.created_date <= DATE_SUB(CURDATE(), INTERVAL 6 WEEK) THEN 1 ELSE 0 END) AS cured_fbd_last_12mo,
        SUM(CASE WHEN o.loan_status = 'Funded' 
                    AND o.created_date > DATE_SUB(CURDATE(), INTERVAL 12 month) 
                    AND o.created_date <= DATE_SUB(CURDATE(), INTERVAL 6 WEEK) 
                    AND o.flags LIKE '%fbd":"%' 
                    AND json_unquote(json_extract(o.flags, '$.fbd')) = '1'
                THEN 1 ELSE 0 END) AS fbd_total,
        SUM(CASE WHEN o.loan_status = 'Funded' 
                    AND o.created_date > DATE_SUB(CURDATE(), INTERVAL 12 month) 
                    AND o.created_date <= DATE_SUB(CURDATE(), INTERVAL 6 WEEK) 
                    AND o.flags LIKE '%cnt18":"%' 
                    AND json_unquote(json_extract(o.flags, '$.cnt18')) = '1'
                THEN 1 ELSE 0 END) AS cnt18_total,
        SUM(CASE WHEN o.loan_status = 'Funded' AND o.created_date > DATE_SUB(CURDATE(), INTERVAL 12 month) AND o.created_date <= DATE_SUB(CURDATE(), INTERVAL 6 WEEK) THEN 1 ELSE 0 END) AS cured_cnt18_last_12mo,
        COUNT(CASE WHEN o.created_date > DATE_SUB(CURDATE(), INTERVAL 2 MONTH) THEN 1 ELSE NULL END) AS total_last_2_months, 
        SUM(CASE WHEN o.loan_status = 'Funded' AND o.created_date > DATE_SUB(CURDATE(), INTERVAL 2 MONTH) THEN 1 ELSE 0 END) AS funded_last_2_months, 
        SUM(CASE WHEN o.talked_to_customer <> '' AND o.created_date > DATE_SUB(CURDATE(), INTERVAL 2 MONTH) THEN 1 ELSE 0 END) AS ttc_last_2_months, 
        SUM(CASE WHEN o.aka <> '' AND o.created_date > DATE_SUB(CURDATE(), INTERVAL 2 MONTH) THEN 1 ELSE 0 END) AS red_last_2_months, 
        COUNT(CASE WHEN o.created_date > DATE_SUB(CURDATE(), INTERVAL 1 WEEK) THEN 1 ELSE NULL END) AS total_last_week, 
        SUM(CASE WHEN o.loan_status = 'Funded' AND o.created_date > DATE_SUB(CURDATE(), INTERVAL 1 WEEK) THEN 1 ELSE 0 END) AS funded_last_week, 
        SUM(CASE WHEN o.talked_to_customer <> '' AND o.created_date > DATE_SUB(CURDATE(), INTERVAL 1 WEEK) THEN 1 ELSE 0 END) AS ttc_last_week, 
        SUM(CASE WHEN o.aka <> '' AND o.created_date > DATE_SUB(CURDATE(), INTERVAL 1 WEEK) THEN 1 ELSE 0 END) AS red_last_week 
    FROM lms.opportunities o 
    WHERE o.lead_source NOT LIKE ('%react%') 
    AND o.lead_source NOT LIKE ('%web%') 
        and (CASE 
            WHEN o.lead_sub_source LIKE '%-%' THEN LEFT(o.lead_sub_source, POSITION('-' IN o.lead_sub_source) - 1)
            WHEN o.lead_sub_source LIKE '%\\_%' THEN LEFT(o.lead_sub_source, POSITION('_' IN o.lead_sub_source) - 1)
            ELSE o.lead_sub_source 
        END
    ) IN ('15586','11490','20954','102813','1720','15581','102033','3749','101909','219066','802280','16515','19190','14351','2924','103278','14529','102144','21295','16510','16355','102206')
    GROUP BY parent
) 
SELECT 
    cs.parent AS parent,
    cs.total_last_12_months AS "12mo_cnt(#)", 
    cs.funded_last_12_months AS "12mo_conv(#)", 
    ROUND(CASE WHEN cs.total_last_12_months > 0 THEN (cs.ttc_last_12_months / cs.total_last_12_months)  ELSE 0 END, 2) AS "12mo_ttc(%)", 
    ROUND(CASE WHEN cs.total_last_12_months > 0 THEN (cs.funded_last_12_months / cs.total_last_12_months) ELSE 0 END, 2) AS "12mo_conv(%)", 
    cs.cured_fbd_last_12mo AS "Cured FBD(#)", 
    CASE 
        WHEN cs.cured_fbd_last_12mo > 0 THEN ROUND((cs.fbd_total / cs.cured_fbd_last_12mo) , 2) 
        ELSE NULL 
    END AS "FBD(%)",
    cs.cured_cnt18_last_12mo AS "Cured Cnt18(#)", 
    CASE 
        WHEN cs.cured_cnt18_last_12mo > 0 THEN ROUND((cs.cnt18_total / cs.cured_cnt18_last_12mo) , 2) 
        ELSE NULL 
    END AS "Cnt18(%)",
    cs.total_last_2_months AS "2mo_cnt(#)", 
    cs.funded_last_2_months AS "2mo_conv(#)", 
    ROUND(CASE WHEN cs.total_last_2_months > 0 THEN (cs.ttc_last_2_months / cs.total_last_2_months) ELSE 0 END, 2) AS "2mo_ttc(%)", 
    ROUND(CASE WHEN cs.total_last_2_months > 0 THEN (cs.funded_last_2_months / cs.total_last_2_months) ELSE 0 END, 2) AS "2mo_conv(%)", 
    ROUND(CASE WHEN cs.total_last_2_months > 0 THEN (cs.red_last_2_months / cs.total_last_2_months)  ELSE 0 END, 2) AS "2mo_red(%)", 
    cs.total_last_week AS "1wk_cnt(#)", 
    cs.funded_last_week AS "1wk_conv(#)", 
    ROUND(CASE WHEN cs.total_last_week > 0 THEN (cs.ttc_last_week / cs.total_last_week) ELSE 0 END, 2) AS "1wk_ttc(%)", 
    ROUND(CASE WHEN cs.total_last_week > 0 THEN (cs.funded_last_week / cs.total_last_week)  ELSE 0 END, 2) AS "1wk_conv(%)", 
    ROUND(CASE WHEN cs.total_last_week > 0 THEN (cs.red_last_week / cs.total_last_week)  ELSE 0 END, 2) AS "1wk_red(%)" 
FROM conversion_stats cs 
ORDER BY cs.parent;
