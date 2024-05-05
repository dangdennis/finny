SELECT User {
    id,
    name,
    age
}
FILTER .age >= <int16>$age;
