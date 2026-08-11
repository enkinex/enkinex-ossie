import ..common.ai_context
import ..common.extension

schema Relationship:
    """
    Foreign key relationship between two logical datasets, supporting simple
    and composite keys. The order of columns in `from_columns` must correspond
    to the order in `to_columns`; both arrays must have the same length.

    Attributes
    ----------
    name: str, default is Undefined, required.
        Unique identifier for the relationship.
    from: str, default is Undefined, required.
        The logical dataset on the many side of the relationship.
    to: str, default is Undefined, required.
        The logical dataset on the one side of the relationship.
    from_columns: [str], default is Undefined, required.
        Foreign key columns in the "from" dataset, at least one.
    to_columns: [str], default is Undefined, required.
        Primary or unique key columns in the "to" dataset, at least one, same
        length and order as `from_columns`.
    ai_context: ai_context.AIContext, default is Undefined, optional.
        Additional context for AI tools.
    custom_extensions: [extension.CustomExtension], default is Undefined, optional.
        Vendor-specific attributes.

    Examples
    --------
    simple = Relationship {
        name = "orders_to_customers"
        from = "orders"
        to = "customers"
        from_columns = ["customer_id"]
        to_columns = ["id"]
    }

    composite = Relationship {
        # order_lines.product_id = products.id AND order_lines.variant_id = products.variant_id
        name = "order_lines_to_products"
        from = "order_lines"
        to = "products"
        from_columns = ["product_id", "variant_id"]
        to_columns = ["id", "variant_id"]
    }
    """
    name: str
    from: str
    to: str
    from_columns: [str]
    to_columns: [str]
    ai_context?: ai_context.AIContext
    custom_extensions?: [extension.CustomExtension]

    check:
        len(from_columns) > 0, "from_columns must contain at least one entry"
        len(to_columns) > 0, "to_columns must contain at least one entry"
        len(from_columns) == len(to_columns), "from_columns and to_columns must have the same length"

