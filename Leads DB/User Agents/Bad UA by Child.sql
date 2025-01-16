SELECT 
    DATE(created_date) AS report_date,
    HOUR(created_date) AS report_hour,
    aggregator,
    parent,
    child,
    COUNT(*) AS total_leads,
    ROUND(SUM(IF(
        (
            CAST(user_agent AS BINARY) LIKE 'Mozilla/5.0 (%'
            AND CAST(user_agent AS BINARY) LIKE '% (KHTML, like Gecko) %'
            AND CAST(user_agent AS BINARY) LIKE '%AppleWebKit%'
            AND (
                user_agent REGEXP 'Mozilla/5\.0 \\(iPhone; CPU iPhone OS 1[6-9](_[0-9]+){1,2} like Mac OS X\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) GSA\\/33[0-9]\.[0-9]\.[0-9]{9} Mobile/15E148 Safari/604.1$' 
                OR user_agent REGEXP 'Mozilla/5\.0 \\(iPhone; CPU iPhone OS 1[6-9](_[0-9]+){1,2} like Mac OS X\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) FxiOS\\/13[0-9].[0-9]\\s{1,2}Mobile/15E148 Safari/605.1.15$'
                OR user_agent REGEXP 'Mozilla/5\.0 \\(iPhone; CPU iPhone OS 1[6-9](_[0-9]+){1,2} like Mac OS X\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) CriOS\\/12[0-9].0.[0-9]{4}.[0-9]{2,3} Mobile/15E148 Safari/604.1$' 
                OR user_agent REGEXP 'Mozilla/5\.0 \\(iPhone; CPU iPhone OS 1[6-9](_[0-9]+){1,2} like Mac OS X\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) EdgiOS\\/12[0-9].0.[0-9]{4}.[0-9]{2,3} Version\\/1[6-8]\.[0-9](\.[0-9])? Mobile/15E148 Safari/604.1$' 
                OR user_agent REGEXP 'Mozilla/5\.0 \\(iPhone; CPU iPhone OS 1[6-9](_[0-9]+){1,2} like Mac OS X\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) Version\\/1[6-8]\.[0-9](\.[0-9])? Mobile/15E148 Safari/604.1$'  
                OR user_agent REGEXP 'Mozilla/5\.0 \\(iPhone; CPU iPhone OS 1[6-9](_[0-9]+){1,2} like Mac OS X\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) Mobile/'  
                OR user_agent REGEXP 'Mozilla/5\.0 \\(iPad; CPU OS 1[6-9](_[0-9]+){1,2} like Mac OS X\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) CriOS\\/12[0-9].0.[0-9]{4}.[0-9]{2,3} Mobile/15E148 Safari/604.1$' 
                OR user_agent REGEXP 'Mozilla\\/5\.0 \\(iPad; CPU OS 1[6-9](_[0-9]+){1,2} like Mac OS X\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) EdgiOS\\/12[0-9].0.[0-9]{4}.[0-9]{2,3} Version\\/1[6-8]\.[0-9](\.[0-9])? Mobile/15E148 Safari/604.1$'
                OR user_agent REGEXP 'Mozilla\\/5\.0 \\(iPad; CPU OS 1[6-9](_[0-9]+){1,2} like Mac OS X\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) GSA\\/[2-3][0-9][0-9]\.[0-9]\.[0-9]{9} Mobile/15E148 Safari/604.1$' 
                OR user_agent REGEXP 'Mozilla\\/5\.0 \\(iPad; CPU OS 1[6-9](_[0-9]+){1,2} like Mac OS X\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) Version\\/1[6-8]\.[0-9](\.[0-9])? Mobile/15E148 Safari/604.1$' 
                OR user_agent REGEXP 'Mozilla\\/5\.0 \\(iPad; CPU OS 1[6-9](_[0-9]+){1,2} like Mac OS X\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) Mobile/'  
                OR user_agent REGEXP 'Mozilla/5\.0 \\(Macintosh; Intel Mac OS X 1[0-9](_[0-9]+){1,2}\\) AppleWebKit/537.36 \\(KHTML, like Gecko\\) Chrome\\/12[6-9].0.0.0 Safari\\/537.36$'  
                OR user_agent REGEXP 'Mozilla\\/5\.0 \\(Macintosh; Intel Mac OS X 1[0-9](_[0-9]+){1,2}\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) CriOS\\/12[6-9] Version\\/1[0-9]\.[0-9](\.[0-9])? Safari\\/605.1.15$' 
                OR user_agent REGEXP 'Mozilla\\/5\.0 \\(Macintosh; Intel Mac OS X 1[0-9](_[0-9]+){1,2}\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) EdgiOS\\/12[6-9] Version\\/1[0-9]\.[0-9](\.[0-9])? Safari\\/605.1.15$'
                OR user_agent REGEXP 'Mozilla\\/5\.0 \\(Macintosh; Intel Mac OS X 1[0-9](_[0-9]+){1,2}\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) Version\\/1[7-9].[0-9] Safari\\/605.1.15$' 
                OR user_agent REGEXP 'Mozilla/5\.0 \\(Linux; Android 10; K\\) AppleWebKit/537.36 \\(KHTML, like Gecko\\) Chrome\\/12[6-9].0.0.0 Mobile Safari/537.36$' 
                OR user_agent REGEXP 'Mozilla\\/5\.0 \\(Linux; Android 10; K\\) AppleWebKit/537.36 \\(KHTML, like Gecko\\) Chrome\\/12[6-9].0.0.0 Safari/537.36$'  
                OR user_agent REGEXP 'Mozilla\\/5\.0 \\(Linux; Android 10; K\\) AppleWebKit/537.36 \\(KHTML, like Gecko\\) SamsungBrowser\\/2[4-7].0 Chrome\\/12[0-9].0.0.0 Mobile Safari/537.36$'  
                OR user_agent REGEXP 'Mozilla/5\.0 \\(Windows NT 10.0; Win64; x64\\) AppleWebKit/537.36 \\(KHTML, like Gecko\\) Chrome\\/12[6-9].0.0.0 Safari\\/537.36$' 
                OR user_agent REGEXP 'Mozilla\\/5\.0 \\(Windows NT 10.0; Win64; x64\\) AppleWebKit/537.36 \\(KHTML, like Gecko\\) Chrome\\/12[6-9].0.0.0 Safari\\/537.36 Edg\\/128.0.0.0$'
            ) 
            OR user_agent = ''
        ), 
        0, 
        1
    )) / COUNT(*) * 100, 2) AS bad_UA_percentage
FROM lms.leads_add_data lad
WHERE created_date > '2024-09-23'
AND parent = '762339'
GROUP BY report_date, report_hour, child
ORDER BY report_date DESC, report_hour DESC, bad_UA_percentage DESC, total_leads DESC;
