SELECT 
  CASE
    WHEN user_agent = '' THEN 'Blank'
    WHEN user_agent = 'desktop' THEN 'desktop'
    WHEN user_agent LIKE '%iPhone%' THEN 'iPhone'
    WHEN user_agent LIKE '%iPad%' THEN 'iPad'
    WHEN user_agent LIKE '%Macintosh%' THEN 'Macintosh'
    WHEN user_agent LIKE '%Windows%' THEN 'Windows'
    WHEN user_agent LIKE '%X11%' THEN 'Linux'
    WHEN user_agent LIKE '%Android%' THEN 'Android'
    ELSE 'unknown'
  END AS Device,  
  CASE
    WHEN user_agent LIKE '%samsungbrowser%' THEN 'Samsung'
    WHEN user_agent LIKE '%GSA%' THEN 'GSA'
    WHEN user_agent LIKE '%FxiOS%' OR user_agent LIKE '%Firefox%' THEN 'Firefox'
    WHEN user_agent LIKE '%CriOS%' OR (user_agent LIKE '%Chrome%' AND user_agent NOT LIKE '%samsungbrowser%' AND user_agent NOT LIKE '%Edg%' AND user_agent NOT LIKE '%FB_IAB%'AND user_agent NOT LIKE '%musical%') THEN 'Chrome'
    WHEN user_agent LIKE '%Edg%' THEN 'Edge'
    WHEN user_agent LIKE '%Instagram%' THEN 'Instagram'
    WHEN user_agent LIKE '%FBAN%' OR user_agent LIKE '%FB_IAB%' THEN 'Facebook'
    WHEN user_agent LIKE '%musical%' THEN 'Musically'
    WHEN user_agent LIKE '%LinkedIn%' THEN 'LinkedIn'
    WHEN user_agent LIKE '%Version%' AND user_agent NOT LIKE '%Edg%' AND user_agent NOT LIKE '%CriOS%' THEN 'Safari'
    WHEN user_agent LIKE '%Brave%' THEN 'Brave'
    WHEN user_agent LIKE '%Opera%' THEN 'Opera'
    WHEN user_agent LIKE '%YaApp%' OR user_agent LIKE '%YaBrowser%' THEN 'YaBrowser'
    ELSE 'Other'
  END AS Browser,  
  SUM(CASE
    WHEN user_agent REGEXP '-[0-9]{2,3}$' THEN 1
    ELSE 0
  END) AS `-###(#)`,  
  COUNT(*) AS `COUNT(*)`,
  ROUND(SUM(CASE
    WHEN user_agent REGEXP '-[0-9]{2,3}$' THEN 1
    ELSE 0
  END) / COUNT(*) * 100, 2) AS `-###(%)`,
  SUM(CASE
    WHEN user_agent LIKE 'Mozilla/5.0 (%' AND NOT CAST(user_agent AS BINARY) LIKE 'Mozilla/5.0 (%' THEN 1
    ELSE 0
  END) AS `case mismatch`,
  SUM(CASE
    WHEN (
      CAST(user_agent AS BINARY) LIKE 'Mozilla/5.0 (%'
      AND CAST(user_agent AS BINARY) LIKE '% (KHTML, like Gecko) %'
      AND CAST(user_agent AS BINARY) LIKE '%AppleWebKit%'
      AND user_agent NOT REGEXP '-[0-9]{2,3}$'
      AND (
        user_agent REGEXP 'Mozilla/5\\.0 \\(iPhone; CPU iPhone OS 1[6-9](_[0-9]+){1,2} like Mac OS X\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) GSA\\/33[0-9]\\.[0-9]\\.[0-9]{9} Mobile/15E148 Safari/604.1$'
        OR user_agent REGEXP 'Mozilla/5\\.0 \\(iPhone; CPU iPhone OS 1[6-9](_[0-9]+){1,2} like Mac OS X\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) FxiOS\\/13[0-9]\\.[0-9]\\s{1,2}Mobile/15E148 Safari/605.1.15$'
        OR user_agent REGEXP 'Mozilla/5\\.0 \\(iPhone; CPU iPhone OS 1[6-9](_[0-9]+){1,2} like Mac OS X\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) CriOS\\/12[0-9].0.[0-9]{4}.[0-9]{2,3} Mobile/15E148 Safari/604.1$'
        OR user_agent REGEXP 'Mozilla/5\\.0 \\(iPhone; CPU iPhone OS 1[6-9](_[0-9]+){1,2} like Mac OS X\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) EdgiOS\\/12[0-9].0.[0-9]{4}.[0-9]{2,3} Version\\/1[6-8]\\.[0-9](\\.[0-9])? Mobile/15E148 Safari/604.1$'
        OR user_agent REGEXP 'Mozilla/5\\.0 \\(iPhone; CPU iPhone OS 1[6-9](_[0-9]+){1,2} like Mac OS X\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) Version\\/1[6-8]\\.[0-9](\\.[0-9])? Mobile/15E148 Safari/604.1$'
        OR user_agent REGEXP 'Mozilla/5\\.0 \\(iPhone; CPU iPhone OS 1[6-9](_[0-9]+){1,2} like Mac OS X\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) Mobile/'
        OR user_agent REGEXP 'Mozilla/5\\.0 \\(iPad; CPU OS 1[6-9](_[0-9]+){1,2} like Mac OS X\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) CriOS\\/12[0-9].0.[0-9]{4}.[0-9]{2,3} Mobile/15E148 Safari/604.1$'
        OR user_agent REGEXP 'Mozilla/5\\.0 \\(iPad; CPU OS 1[6-9](_[0-9]+){1,2} like Mac OS X\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) EdgiOS\\/12[0-9].0.[0-9]{4}.[0-9]{2,3} Version\\/1[6-8]\\.[0-9](\\.[0-9])? Mobile/15E148 Safari/604.1$'
        OR user_agent REGEXP 'Mozilla\\/5\\.0 \\(iPad; CPU OS 1[6-9](_[0-9]+){1,2} like Mac OS X\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) GSA\\/[2-3][0-9][0-9]\\.[0-9]\\.[0-9]{9} Mobile/15E148 Safari/604.1$'
        OR user_agent REGEXP 'Mozilla\\/5\\.0 \\(iPad; CPU OS 1[6-9](_[0-9]+){1,2} like Mac OS X\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) Version\\/1[6-8]\\.[0-9](\\.[0-9])? Mobile/15E148 Safari/604.1$'
        OR user_agent REGEXP 'Mozilla/5\\.0 \\(Macintosh; Intel Mac OS X 1[0-9](_[0-9]+){1,2}\\) AppleWebKit/537.36 \\(KHTML, like Gecko\\) Chrome\\/12[6-9].0.0.0 Safari\\/537.36$'
        OR user_agent REGEXP 'Mozilla\\/5\\.0 \\(Macintosh; Intel Mac OS X 1[0-9](_[0-9]+){1,2}\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) CriOS\\/12[6-9] Version\\/1[0-9]\\.[0-9](\\.[0-9])? Safari\\/605.1.15$'
        OR user_agent REGEXP 'Mozilla\\/5\\.0 \\(Macintosh; Intel Mac OS X 1[0-9](_[0-9]+){1,2}\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) EdgiOS\\/12[6-9] Version\\/1[0-9]\\.[0-9](\\.[0-9])? Safari\\/605.1.15$'
        OR user_agent REGEXP 'Mozilla/5\\.0 \\(Linux; Android 10; K\\) AppleWebKit/537.36 \\(KHTML, like Gecko\\) Chrome\\/12[6-9].0.0.0 Mobile Safari/537.36$'
        OR user_agent REGEXP 'Mozilla\\/5\\.0 \\(Linux; Android 10; K\\) AppleWebKit/537.36 \\(KHTML, like Gecko\\) SamsungBrowser\\/2[4-7].0 Chrome\\/12[0-9].0.0.0 Mobile Safari/537.36$'
        OR user_agent REGEXP 'Mozilla/5\\.0 \\(Windows NT 10.0; Win64; x64\\) AppleWebKit/537.36 \\(KHTML, like Gecko\\)'
        OR user_agent REGEXP 'Mozilla/5\\.0 \\(Windows NT 10.0; Win64; x64\\) AppleWebKit/537.36 \\(KHTML, like Gecko\\) Chrome\\/12[6-9].0.0.0 Safari\\/537.36$'
        OR user_agent REGEXP 'Mozilla\\/5\\.0 \\(Windows NT 10.0; Win64; x64\\) AppleWebKit/537.36 \\(KHTML, like Gecko\\) Chrome\\/12[6-9].0.0.0 Safari\\/537.36 Edg\\/12[6-9].0.0.0$'
      )
    ) THEN 0
    ELSE 1
  END) AS `non_matching_count`
FROM lms.leads_add_data
WHERE lead_id > '69310330'
GROUP BY Device, Browser
HAVING COUNT(*) > 1;



