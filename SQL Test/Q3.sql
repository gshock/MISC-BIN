USE [Deloitte]
GO

/****** Object:  StoredProcedure [dbo].[usp_Portfolio_Issuer_List]    Script Date: 10/10/2015 7:19:54 AM ******/
DROP PROCEDURE [dbo].[usp_Portfolio_Issuer_List]
GO

/****** Object:  StoredProcedure [dbo].[usp_Portfolio_Issuer_List]    Script Date: 10/10/2015 7:19:54 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gerardo Arevalo
-- Create date: 10/10/15
-- Description:	returns unique list of all issuers ever invested in that portfolio, along with every company in their parent company hierarchy
-- =============================================
CREATE PROCEDURE [dbo].[usp_Portfolio_Issuer_List]
	@portf_id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    ;with cte_for_issuers
	as(
		SELECT DISTINCT i1.issuer_id, i1.issuer_name, i1.parent_id FROM (
			SELECT issue_id, issuer_id FROM issue 
			WHERE issue_id IN (SELECT issue_id FROM asset WHERE portf_id = @portf_id)
		) T1
		INNER JOIN  issuer i1 ON i1.issuer_id = T1.issuer_id 
	)
	SELECT issuer_id, issuer_name, NULL AS first_investment_date
		FROM cte_for_issuers
	UNION ALL
	SELECT i.issuer_id, i.issuer_name, NULL AS first_investment_date
		FROM issuer i
		WHERE i.issuer_id IN (SELECT parent_id FROM cte_for_issuers WHERE parent_id IS NOT NULL)

END

GO


