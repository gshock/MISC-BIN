USE [***REMOVED***]
GO

DECLARE @portf_id int
DECLARE @as_of_date datetime 

SET @portf_id = 1 
SET @as_of_date = '1/1/12'

SELECT TF1.issue_id, SUM(TF1.outstanding_amount) AS aggregate_amt, AVG (
		TF1.outstanding_amount / a.purchase_amount) AS weighted_avg_purch_price
	FROM [dbo].[tf_Asset_Portfolio] (@portf_id,@as_of_date) AS TF1
	INNER JOIN asset a ON a.asset_id = TF1.asset_id 
	GROUP BY TF1.issue_id
GO
