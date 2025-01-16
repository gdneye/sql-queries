SELECT lead_id, refferal_tier, created_date, rejected_by, rejected_reason, lead_status, lead_source , lead_sub_source 
FROM lms.leads l
WHERE refferal_tier <> ''
AND lead_id > '68825845'
-- AND lead_sub_source LIKE '388%'
AND (
    l.datax_reject_idv LIKE '%P11%'
    OR l.datax_reject_idv LIKE '%P21%'
    OR l.datax_reject_idv LIKE '%C1%'
);
