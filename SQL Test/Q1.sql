USE [Deloitte]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_IssuePrice]    Script Date: 10/10/2015 7:20:49 AM ******/
DROP FUNCTION [dbo].[udf_IssuePrice]
GO

/****** Object:  UserDefinedFunction [dbo].[udf_IssuePrice]    Script Date: 10/10/2015 7:20:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gerardo Arevalo
-- Create date: 10/10/15
-- Description:	returns most current price for an issue as of specific date 
-- Test: 
--		SELECT dbo.[udf_IssuePrice] (13, '5/15/12')
-- =============================================
CREATE FUNCTION [dbo].[udf_IssuePrice] 
(
	@issue_id int,
	@as_of_date datetime
)
RETURNS decimal(12,8)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @issue_price decimal(12,8)

	-- Add the T-SQL statements to compute the return value here
	SELECT TOP 1 @issue_price = ip.price 
	FROM issue i
	INNER JOIN Issue_Price ip ON i.issue_id = ip.issue_id 
	WHERE i.issue_id = @issue_id AND ip.as_of_date < @as_of_date
	ORDER BY as_of_date DESC

	-- Return the result of the function
	RETURN @issue_price --RETURNS NULL IF NOT FOUND 

END

GO


