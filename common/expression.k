import .enums

schema DialectExpression:
    """
    A scalar expression rendered in one specific dialect.

    Attributes
    ----------
    dialect: enums.Dialect, default is Undefined, required.
        The SQL or expression language dialect this expression is written in.
    expression: str, default is Undefined, required.
        Scalar expression in the given dialect (no aggregations). Can be a simple
        column reference (e.g. "customer_id") or a computed expression
        (e.g. "first_name || ' ' || last_name").

    Examples
    --------
    ansiSql = DialectExpression {
        dialect = "ANSI_SQL"
        expression = "customer_id"
    }
    """
    dialect: enums.Dialect
    expression: str

schema Expression:
    """
    Expression definition with multi-dialect support, attached to a field or metric.

    Attributes
    ----------
    dialects: [DialectExpression], default is Undefined, required.
        At least one dialect-specific rendering of the expression. Multiple
        dialect versions can be provided for the same field or metric, but each
        dialect may appear at most once.

    Examples
    --------
    multiDialect = Expression {
        dialects = [
            DialectExpression { dialect = "ANSI_SQL", expression = "LOWER(email)" }
            DialectExpression { dialect = "SNOWFLAKE", expression = "LOWER(email)::VARCHAR" }
        ]
    }
    """
    dialects: [DialectExpression]

    check:
        len(dialects) > 0, "dialects must contain at least one entry"
        len(dialects) == len({d.dialect: True for d in dialects}), "each dialect may appear at most once"

