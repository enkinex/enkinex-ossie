import .enums

schema CustomExtension:
    """
    Vendor-specific attributes for extensibility, without breaking core compatibility.

    Attributes
    ----------
    vendor_name: enums.Vendor, default is Undefined, required.
        Free-form string identifying the vendor. Well-known values include
        "COMMON", "SNOWFLAKE", "SALESFORCE", "DBT", "DATABRICKS", "GOODDATA",
        "WISDOM"; any string value is accepted.
    data: str, default is Undefined, required.
        JSON string containing vendor-specific data.

    Examples
    --------
    snowflakeExtension = CustomExtension {
        vendor_name = "SNOWFLAKE"
        data = '{"warehouse": "ANALYTICS_WH"}'
    }
    """
    vendor_name: enums.Vendor
    data: str

