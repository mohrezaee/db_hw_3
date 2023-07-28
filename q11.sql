SELECT h.first_name, h.last_name, earning.balance
FROM host AS h
INNER JOIN earning ON h.national_code = earning.host_id
WHERE earning.balance_year = 2022
ORDER BY earning.balance DESC
LIMIT 20;