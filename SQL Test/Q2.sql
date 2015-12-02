INSERT Issue_Price
SELECT *
FROM Import_Issue_Price iip
WHERE
   NOT EXISTS (SELECT * FROM Issue_Price ip
              WHERE iip.issue_id = ip.issue_id AND iip.as_of_date = ip.as_of_date)


