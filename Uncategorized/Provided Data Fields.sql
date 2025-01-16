SELECT l.lead_id, child, user_agent, last_name, first_name, ssn , birth_date , own_home , address  , city, state, zip
	, address_months , email, home_phone , employer_phone_number , cell_phone , employer , job_title  
	, employed_months  , monthly_income , next_pay_date , following_pay_date , pay_frequency , drivers_license_number 
	, drivers_license_state , bank_name , bank_phone , routing_number , account_number, account_type , bank_account_length , l.customer_ip
	,     IF(
        (CAST(user_agent AS BINARY) LIKE 'Mozilla/5.0 (%'
      	AND user_agent NOT REGEXP '( |-)[0-9]{2,3}$'
      	AND user_agent NOT REGEXP 'Edition'
		AND user_agent NOT REGEXP 'bot'
		And user_agent not regexp 'Chrome/[0-9][0-9]\\.'
		AND user_agent NOT REGEXP 'Special'
      AND (
        user_agent REGEXP '^Mozilla/5\\.0 \\((iPhone; CPU iPhone OS|iPad; CPU OS) 1[6-9](_[0-9]+){1,2} like Mac OS X\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) Version\\/1[6-9]\.[0-9](\.[0-9])? Mobile/15E148 Safari/604.1$'
		OR user_agent REGEXP '^Mozilla/5\\.0 \\((iPhone; CPU iPhone OS|iPad; CPU OS) 1[6-9](_[0-9]+){1,2} like Mac OS X\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) CriOS\\/(12[0-9]|13[0-9]).0.[0-9]{4}.[0-9]{2,3} Mobile/15E148 Safari/604.1$'
		OR user_agent REGEXP '^Mozilla/5\\.0 \\((iPhone; CPU iPhone OS|iPad; CPU OS) 1[6-9](_[0-9]+){1,2} like Mac OS X\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) GSA\\/3[2-4][0-9]\.[0-9]\.[0-9]{9} Mobile/15E148 Safari/604.1$'
		OR user_agent REGEXP '^Mozilla/5\\.0 \\((iPhone; CPU iPhone OS|iPad; CPU OS) 1[6-9](_[0-9]+){1,2} like Mac OS X\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) EdgiOS\\/(12[0-9]|13[0-9]).0.[0-9]{4}.[0-9]{2,3} Version\\/1[6-9]\.[0-9](\.[0-9])? Mobile/15E148 Safari/604.1$'
		OR user_agent REGEXP '^Mozilla/5\\.0 \\((iPhone; CPU iPhone OS|iPad; CPU OS) 1[6-9](_[0-9]+){1,2} like Mac OS X\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) FxiOS\\/(12[0-9]|13[0-9]).[0-9] Mobile/15E148 Safari/605.1.15$'
		OR user_agent REGEXP '^Mozilla/5\\.0 \\(Linux; Android 10; K\\) AppleWebKit/537.36 \\(KHTML, like Gecko\\) Chrome\\/(12[1-9]|13[0-9]).0.0.0 Mobile Safari/537.36$'
		OR user_agent REGEXP '^Mozilla/5\\.0 \\(Linux; Android 10; K\\) AppleWebKit/537.36 \\(KHTML, like Gecko\\) Chrome\\/(12[1-9]|13[0-9]).0.0.0 Mobile Safari/537.36 EdgA\\/(12[1-9]|13[0-9]).0.0.0$'
		OR user_agent REGEXP '^Mozilla/5\\.0 \\(Linux; Android 10; K\\) AppleWebKit/537.36 \\(KHTML, like Gecko\\) SamsungBrowser\\/2[4-7].0 Chrome\\/(12[1-9]|13[0-9]).0.0.0 Mobile Safari/537.36$'
		OR user_agent REGEXP '^Mozilla/5.0 \\(Windows NT 10.0; Win64; x64\\) AppleWebKit/537.36 \\(KHTML, like Gecko\\) Chrome/(12[1-9]|13[0-9]).0.0.0 Safari/537.36$'
		OR user_agent REGEXP '^Mozilla/5.0 \\(Windows NT 10.0; Win64; x64\\) AppleWebKit/537.36 \\(KHTML, like Gecko\\) Chrome/(12[1-9]|13[0-9]).0.0.0 Safari/537.36 Edg/(12[1-9]|13[0-9]).0.0.0$'
		OR user_agent REGEXP '^Mozilla/5.0 \\(Macintosh; Intel Mac OS X 1[0-9](_[0-9]+){1,2}\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) Version/1[6-9]\.[0-9](\.[0-9])? Safari/605.1.15$'
		OR user_agent REGEXP '^Mozilla/5.0 \\(Macintosh; Intel Mac OS X 1[0-9](_[0-9]+){1,2}\\) AppleWebKit/537.36 \\(KHTML, like Gecko\\) Chrome/(12[1-9]|13[0-9]).0.0.0 Safari/537.36$'
		OR user_agent REGEXP '^Mozilla/5.0 \\(Macintosh; Intel Mac OS X 1[0-9](_[0-9]+){1,2}\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) CriOS/(12[6-9]|13[0-9]) Version/1[0-9]\.[0-9](\.[0-9])? Safari/605.1.15$'
		OR user_agent REGEXP '^Mozilla/5.0 \\(Macintosh; Intel Mac OS X 1[0-9](_[0-9]+){1,2}\\) AppleWebKit/605.1.15 \\(KHTML, like Gecko\\) EdgiOS/(12[6-9]|13[0-9]) Version/1[0-9]\.[0-9](\.[0-9])? Safari/605.1.15$'
      )
    ) ,0, 
        1
    ) AS bad_UA
FROM lms.leads l
join lms.leads_add_data lad on lad.lead_id = l.lead_id  
where l.lead_id > '69700000'
and parent = '101909'

