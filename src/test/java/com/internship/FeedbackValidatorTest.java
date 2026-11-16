package com.internship;

import org.junit.Test;
import static org.junit.Assert.*;

public class FeedbackValidatorTest {

    @Test
    public void shouldAcceptValidFeedback() {
        assertTrue(
            FeedbackValidator.isValid(
                "Aakash",
                "aakash@example.com",
                "Great application"
            )
        );
    }

    @Test
    public void shouldRejectEmptyName() {
        assertFalse(
            FeedbackValidator.isValid(
                "",
                "aakash@example.com",
                "Great application"
            )
        );
    }

    @Test
    public void shouldRejectEmptyEmail() {
        assertFalse(
            FeedbackValidator.isValid(
                "Aakash",
                "",
                "Great application"
            )
        );
    }

    @Test
    public void shouldRejectEmptyMessage() {
        assertFalse(
            FeedbackValidator.isValid(
                "Aakash",
                "aakash@example.com",
                ""
            )
        );
    }

    @Test
    public void shouldRejectNullValues() {
        assertFalse(
            FeedbackValidator.isValid(
                null,
                "aakash@example.com",
                "Great application"
            )
        );
    }
}
