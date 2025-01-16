SELECT 
    DATE_FORMAT(DATE_ADD(created_date, INTERVAL(1 - WEEKDAY(created_date)) DAY), '%Y-%m-%d') AS wk_start,
    COUNT(*) AS 'cnt(#)',
    SUM(CASE WHEN rejected_by = 'Internal' THEN 1 ELSE 0 END) AS int_rej,
    SUM(CASE WHEN rejected_by = 'Clarity Free' THEN 1 ELSE 0 END) AS cf_rej,
    SUM(CASE WHEN rejected_by = 'Accelitas BD' THEN 1 ELSE 0 END) AS ab_rej,
    SUM(CASE WHEN rejected_by = 'Clarity Paid' THEN 1 ELSE 0 END) AS cp_rej,
    SUM(CASE WHEN rejected_by = 'Ebureau' THEN 1 ELSE 0 END) AS eb_rej,
    SUM(CASE WHEN rejected_by = 'Clarity Digital' THEN 1 ELSE 0 END) AS cd_rej,
    ROUND((SUM(CASE WHEN rejected_by = 'Internal' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS 'int%',
    ROUND((SUM(CASE WHEN rejected_by = 'Clarity Free' THEN 1 ELSE 0 END) / (COUNT(*) - SUM(CASE WHEN rejected_by = 'Internal' THEN 1 ELSE 0 END))) * 100, 2) AS 'cf%',
    ROUND((SUM(CASE WHEN rejected_by = 'Accelitas BD' THEN 1 ELSE 0 END) / (COUNT(*) - SUM(CASE WHEN rejected_by IN ('Internal', 'Clarity Free') THEN 1 ELSE 0 END))) * 100, 2) AS 'ab%',
    ROUND((SUM(CASE WHEN rejected_by = 'Clarity Paid' THEN 1 ELSE 0 END) / (COUNT(*) - SUM(CASE WHEN rejected_by IN ('Internal', 'Clarity Free', 'Accelitas BD') THEN 1 ELSE 0 END))) * 100, 2) AS 'cp%',
    ROUND((SUM(CASE WHEN rejected_by = 'Ebureau' THEN 1 ELSE 0 END) / (COUNT(*) - SUM(CASE WHEN rejected_by IN ('Internal', 'Clarity Free', 'Accelitas BD', 'Clarity Paid') THEN 1 ELSE 0 END))) * 100, 2) AS 'eb%',
    ROUND((SUM(CASE WHEN rejected_by = 'Clarity Digital' THEN 1 ELSE 0 END) / (COUNT(*) - SUM(CASE WHEN rejected_by IN ('Internal', 'Clarity Free', 'Accelitas BD', 'Clarity Paid', 'Ebureau') THEN 1 ELSE 0 END))) * 100, 2) AS 'cd%',
    COUNT(*) - SUM(CASE WHEN rejected_by = 'Internal' THEN 1 ELSE 0 END) AS rem_int,
    COUNT(*) - SUM(CASE WHEN rejected_by IN ('Internal', 'Clarity Free') THEN 1 ELSE 0 END) AS rem_cf,
    COUNT(*) - SUM(CASE WHEN rejected_by IN ('Internal', 'Clarity Free', 'Accelitas BD') THEN 1 ELSE 0 END) AS rem_ab,
    COUNT(*) - SUM(CASE WHEN rejected_by IN ('Internal', 'Clarity Free', 'Accelitas BD', 'Clarity Paid') THEN 1 ELSE 0 END) AS rem_cp,
    COUNT(*) - SUM(CASE WHEN rejected_by IN ('Internal', 'Clarity Free', 'Accelitas BD', 'Clarity Paid', 'Ebureau') THEN 1 ELSE 0 END) AS rem_eb,
    COUNT(*) - SUM(CASE WHEN rejected_by IN ('Internal', 'Clarity Free', 'Accelitas BD', 'Clarity Paid', 'Ebureau', 'Clarity Digital') THEN 1 ELSE 0 END) AS rem_cd,
    SUM(CASE WHEN lead_status = 'Accepted' THEN 1 ELSE 0 END) AS bids_won,
    (COUNT(*) - SUM(CASE WHEN rejected_by IN ('Internal', 'Clarity Free', 'Accelitas BD', 'Clarity Paid', 'Ebureau', 'Clarity Digital') THEN 1 ELSE 0 END)) - SUM(CASE WHEN lead_status = 'Accepted' THEN 1 ELSE 0 END) AS bids_lost,
    ROUND((SUM(CASE WHEN lead_status = 'Accepted' THEN 1 ELSE 0 END) / (COUNT(*) - SUM(CASE WHEN rejected_by IN ('Internal', 'Clarity Free', 'Accelitas BD', 'Clarity Paid', 'Ebureau', 'Clarity Digital') THEN 1 ELSE 0 END))) * 100, 2) AS 'bid_won%'
FROM lms.leads
WHERE lead_id >= '69000000'
and lead_sub_source like '101909%'
GROUP BY DATE_FORMAT(DATE_ADD(created_date, INTERVAL(1 - WEEKDAY(created_date)) DAY), '%Y-%m-%d')
ORDER BY wk_start DESC;
