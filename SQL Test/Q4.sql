USE [***REMOVED***]
GO

/****** Object:  UserDefinedFunction [dbo].[tf_Asset_Portfolio]    Script Date: 10/11/2015 8:33:47 PM ******/
DROP FUNCTION [dbo].[tf_Asset_Portfolio]
GO

/****** Object:  UserDefinedFunction [dbo].[tf_Asset_Portfolio]    Script Date: 10/11/2015 8:33:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Gerardo Arevalo
-- Create date: 10/10/15
-- Description:	returns all assets in the portfolio (asset_id, issue_id, outstanding_amount) for a given portfolio as of any date 
-- =============================================
CREATE FUNCTION [dbo].[tf_Asset_Portfolio]
(	
	@portf_id int, 
	@as_of_date smalldatetime 
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT issue_id, asset_id, purchase_total + trans_total AS outstanding_amount 
	FROM (
	SELECT a.asset_id, a.issue_id, 
		purchase_price * purchase_amount  AS purchase_total,
		COALESCE((SELECT SUM (trans_amount) FROM Asset_Transaction WHERE asset_id = a.asset_id), 0) AS trans_total
		FROM asset a
		WHERE portf_id = @portf_id AND purchase_date >= @as_of_date
	) T1
)


GO


