schema AIContextObject:
    """
    Structured additional context for AI tools.

    Attributes
    ----------
    instructions: str, default is Undefined, optional.
        Instructions for AI on how to use this entity.
    synonyms: [str], default is Undefined, optional.
        Alternative names and terms.
    examples: [str], default is Undefined, optional.
        Sample questions or use cases.

    Any additional key is accepted; the standard's `AIContext` object form is
    intentionally open (`additionalProperties: true`) so tools can attach
    fields beyond the three recommended ones.
    """
    [str]: any
    instructions?: str
    synonyms?: [str]
    examples?: [str]

# The standard's `AIContext` is `oneOf [string, object]`. A plain `str |
# AIContextObject` union fails `kcl vet` YAML coercion for the object branch
# (KCL cannot route a dict literal through a schema member of a union that
# also contains `str`); adding the permissive `{str:any}` member fixes
# coercion while `AIContextObject`'s own field types still get checked first.
# See docs/schemas/common.md.
type AIContext = str | AIContextObject | {str:any}
