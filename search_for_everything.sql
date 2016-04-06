--+++++++++++++++++++++
--Search for column name
--+++++++++++++++++++++
SELECT 
	* 
FROM 
(SELECT
	t.name as [table_view_name],
	c.name as [column_name],
	'table' AS [Type],
	'select * from ' + t.name AS [select *],
	'select ' + c.name + ' from ' + t.name AS [select column]
FROM
	sys.tables t
INNER JOIN
	sys.objects o ON t.object_id = o.object_id
INNER JOIN
	sys.columns c ON o.object_id = c.object_id
UNION
SELECT
	v.name as [table_view_name],
	c.name as [column_name],
	'view' AS [Type],
	'select * from ' + v.name AS [select *],
	'select ' + c.name + ' from ' + v.name AS [select column]
FROM
	sys.views v
INNER JOIN
	sys.objects o ON v.object_id = o.object_id
INNER JOIN
	sys.columns c ON o.object_id = c.object_id
) a
WHERE 
	a.column_name like '%StoreNo%' 
--AND
--	a.[table_view_name] like '%flxfld%'

ORDER BY a.[table_view_name], a.column_name
/*

--+++++++++++++++++++++++++++
--Search all objects for text
--++++++++++++++++++++++++++
select
	a.id,
	b.name,
	b.type_desc
from
	syscomments a
inner join
	sys.objects b on a.id = b.object_id
where
	a.text like '%poid%'
order by
	b.name asc
--++++++++++++++++++++++++++++
--Search all columns for value
--++++++++++++++++++++++++++++
	declare @SearchStr nvarchar(max)
	set @SearchStr = 'Sent to Billing'

	CREATE TABLE #Results (ColumnName nvarchar(370), ColumnValue nvarchar(3630))

	SET NOCOUNT ON

	DECLARE @TableName nvarchar(256), @ColumnName nvarchar(128), @SearchStr2 nvarchar(110)
	SET  @TableName = ''
	SET @SearchStr2 = QUOTENAME('%' + @SearchStr + '%','''')
	

	WHILE @TableName IS NOT NULL
	BEGIN
		SET @ColumnName = ''
		SET @TableName = 
		(
			SELECT MIN(QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME))
			FROM 	INFORMATION_SCHEMA.TABLES
			WHERE 		TABLE_TYPE = 'BASE TABLE'
				AND	QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) > @TableName
				AND	OBJECTPROPERTY(
						OBJECT_ID(
							QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME)
							 ), 'IsMSShipped'
						       ) = 0
		)

		WHILE (@TableName IS NOT NULL) AND (@ColumnName IS NOT NULL)
		BEGIN
			SET @ColumnName =
			(
				SELECT MIN(QUOTENAME(COLUMN_NAME))
				FROM 	INFORMATION_SCHEMA.COLUMNS
				WHERE 		TABLE_SCHEMA	= PARSENAME(@TableName, 2)
					AND	TABLE_NAME	= PARSENAME(@TableName, 1)
					AND	DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar')
					AND	QUOTENAME(COLUMN_NAME) > @ColumnName
			)
	
			IF @ColumnName IS NOT NULL
			BEGIN
				INSERT INTO #Results
				EXEC
				(
					'SELECT ''' + @TableName + '.' + @ColumnName + ''', LEFT(' + @ColumnName + ', 3630) 
					FROM ' + @TableName + ' (NOLOCK) ' +
					' WHERE ' + @ColumnName + ' LIKE ' + @SearchStr2
				)
			END
		END	
	END

	SELECT ColumnName, ColumnValue FROM #Results
drop table #Results*/