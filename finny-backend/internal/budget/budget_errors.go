package budget

type NetworkError struct {
	Message string
}

func (e *NetworkError) Error() string {
	return e.Message
}

type NotFoundError struct {
	Message string
}

func (e *NotFoundError) Error() string {
	return e.Message
}
