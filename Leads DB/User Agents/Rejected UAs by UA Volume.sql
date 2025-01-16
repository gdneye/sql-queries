SELECT user_agent, COUNT(lead_add_id) as total
FROM lms.leads_add_data 
WHERE lead_id IN(
    SELECT lead_id
    FROM lms.leads
    WHERE lead_id >  (SELECT lead_id FROM lms.monthly_slices WHERE month_end = '2024-09-30')
    AND created_date >= date(curdate() - INTERVAL 3 day)
    AND rejected_reason = 'UAR'
)
GROUP BY 1
ORDER BY 2 desc