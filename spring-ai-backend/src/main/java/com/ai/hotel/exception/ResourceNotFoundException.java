package com.ai.hotel.exception;

public class ResourceNotFoundException extends BusinessException {

    public ResourceNotFoundException(String message) {
        super(404, message);
    }

    public ResourceNotFoundException(String resource, Long id) {
        super(404, String.format("%s not found with id: %d", resource, id));
    }

}
