USE [**REMOVED**]
GO

/****** Object:  StoredProcedure [dbo].[usp_Portfolio_Compare]    Script Date: 10/11/2015 10:59:50 PM ******/
DROP PROCEDURE [dbo].[usp_Portfolio_Compare]
GO

/****** Object:  StoredProcedure [dbo].[usp_Portfolio_Compare]    Script Date: 10/11/2015 10:59:50 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gerardo Arevalo
-- Create date: 10/11/15
-- Description:	compares two portfolios as of the same date (or the same portfolio as of two different dates) 
--				aggregated at the issue level
--	Return Codes:	
--				0 OK
--				-1 input is not valid (@as_of_date2)
-- =============================================
CREATE PROCEDURE [dbo].[usp_Portfolio_Compare]
	@portf_id1 int,
	@portf_id2 int,
	@as_of_date1 datetime,
	@as_of_date2 datetime = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--VALIDATE INPUT
	IF(@portf_id1 = @portf_id2 AND @as_of_date2 IS NULL)
	BEGIN 
		PRINT('need @as_of_date2 to compare same portfolio as of two different dates') 
		RETURN -1 
	END 

	DECLARE @second_date_to_use datetime
	SET @second_date_to_use = @as_of_date1

	IF(@portf_id1 = @portf_id2) -- when comparing the same portfolio id use the second date 
	BEGIN
		SET @second_date_to_use = @as_of_date2 
	END 

	-- compare two portfolios, use first date 
    SELECT *, outstanding_amount_1 - outstanding_amount_2 AS [difference] FROM (
		SELECT	TF1.issue_id as issue_id, 
				i.issue_name AS issue_name, 
				SUM(TF1.outstanding_amount) AS outstanding_amount_1,
				SUM(TF2.outstanding_amount) AS outstanding_amount_2
			FROM [dbo].[tf_Asset_Portfolio] (@portf_id1,@as_of_date1) AS TF1
			INNER JOIN issue i ON TF1.issue_id = i.issue_id 
			LEFT JOIN [dbo].[tf_Asset_Portfolio] (@portf_id2,@second_date_to_use) AS TF2 ON TF1.issue_id = TF2.issue_id
			GROUP BY TF1.issue_id, i.issue_name
		) R1

	RETURN 0
END

GO


