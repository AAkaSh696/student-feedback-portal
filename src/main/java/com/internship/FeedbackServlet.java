
package com.internship;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

@WebServlet("/feedback")
public class FeedbackServlet extends HttpServlet {

    private static final List<Feedback> feedbackList =
            new CopyOnWriteArrayList<>();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String message = request.getParameter("message");

        if (name == null || name.isBlank()
                || email == null || email.isBlank()
                || message == null || message.isBlank()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "All fields are required."
            );
            return;
        }

        Feedback feedback = new Feedback(name, email, message);

        feedbackList.add(feedback);

        response.setContentType("text/html;charset=UTF-8");

        response.getWriter().println(
                "<!DOCTYPE html><html><head>"
                + "<title>Feedback Submitted</title>"
                + "</head><body>"
                + "<h1>Thank You, " + escapeHtml(name) + "!</h1>"
                + "<p>Your feedback has been submitted successfully.</p>"
                + "<a href='index.jsp'>Submit another feedback</a>"
                + "</body></html>"
        );
    }

    private String escapeHtml(String value) {
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }

    public static List<Feedback> getFeedbackList() {
        return List.copyOf(feedbackList);
    }

    public static class Feedback {

        private final String name;
        private final String email;
        private final String message;

        public Feedback(String name, String email, String message) {
            this.name = name;
            this.email = email;
            this.message = message;
        }

        public String getName() {
            return name;
        }

        public String getEmail() {
            return email;
        }

        public String getMessage() {
            return message;
        }
    }
}
