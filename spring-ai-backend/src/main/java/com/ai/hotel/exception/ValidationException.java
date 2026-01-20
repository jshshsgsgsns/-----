package com.ai.hotel.exception;

public class ValidationException extends BusinessException {

    public ValidationException(String message) {
        super(400, message);
    }

}
