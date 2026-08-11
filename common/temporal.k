temporalDataTypes = ["Date", "Time", "DateTime", "DateTimeTz"]

isTimeEffective = lambda datatype: str, isTime: bool -> bool {
    isTime if isTime != Undefined else datatype in temporalDataTypes
}
