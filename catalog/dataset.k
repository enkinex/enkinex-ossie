import ..common.ai_context
import ..common.extension
import .field

schema Dataset:
    """
    Logical dataset representing a business entity or concept (a fact or
    dimension table). Contains fields and defines the structure of the data.

    Attributes
    ----------
    name: str, default is Undefined, required.
        Unique identifier for the dataset.
    source: str, default is Undefined, required.
        Reference to the underlying physical table/view (e.g.
        "database.schema.table") or query.
    primary_key: [str], default is Undefined, optional.
        Primary key columns that uniquely identify rows (single or composite).
        Examples: ["customer_id"], ["order_id", "line_number"].
    unique_keys: [[str]], default is Undefined, optional.
        Array of unique key definitions; each entry can be single or
        composite. Example: [["email"], ["first_name", "last_name"]].
    description: str, default is Undefined, optional.
        Human-readable description.
    ai_context: ai_context.AIContext, default is Undefined, optional.
        Additional context for AI tools (e.g. synonyms, common terms).
    fields: [field.Field], default is Undefined, optional.
        Row-level attributes for grouping, filtering, and metric expressions.
        Field names must be unique within the dataset.
    custom_extensions: [extension.CustomExtension], default is Undefined, optional.
        Vendor-specific attributes.

    Examples
    --------
    orders = Dataset {
        name = "orders"
        source = "sales.public.orders"
        primary_key = ["order_id"]
        unique_keys = [["order_id"], ["order_number"]]
        description = "Order transactions"
        ai_context = { synonyms = ["purchases", "sales"] }
        fields = []
    }
    """
    name: str
    source: str
    primary_key?: [str]
    unique_keys?: [[str]]
    description?: str
    ai_context?: ai_context.AIContext
    fields?: [field.Field]
    custom_extensions?: [extension.CustomExtension]

    check:
        fields == Undefined or len(fields) == len({f.name: True for f in fields}), "field names must be unique within the dataset"
