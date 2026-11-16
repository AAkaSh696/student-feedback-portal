
package com.internship;

public class FeedbackValidator {

    public static boolean isValid(String name, String email, String message) {

        return name != null && !name.isBlank()
                && email != null && !email.isBlank()
                && message != null && !message.isBlank();
    }
}
