type ApiVersionType = "0.2.0.dev0"

schema SemanticModel:
    """
    Collection of semantic model definitions.

    Attributes
    ----------
    version: ApiVersionType, default is "0.2.0.dev0", required.
        Apache Ossie specification version.
    """
    version: ApiVersionType = "0.2.0.dev0"

    check:
        len(version) > 0, "version must not be empty"

