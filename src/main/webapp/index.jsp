
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Feedback Portal</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            background: #f3f4f6;
            color: #1f2937;
        }

        header {
            background: #1e3a8a;
            color: white;
            padding: 22px;
            text-align: center;
        }

        header h1 {
            margin-bottom: 8px;
        }

        .container {
            max-width: 650px;
            margin: 45px auto;
            padding: 30px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }

        .container h2 {
            margin-bottom: 12px;
            color: #1e3a8a;
        }

        .container p {
            margin-bottom: 25px;
            color: #6b7280;
        }

        label {
            display: block;
            margin: 15px 0 7px;
            font-weight: bold;
        }

        input, textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 15px;
        }

        textarea {
            resize: vertical;
            min-height: 120px;
        }

        button {
            width: 100%;
            margin-top: 22px;
            padding: 13px;
            background: #2563eb;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background: #1e40af;
        }

        footer {
            text-align: center;
            padding: 20px;
            color: #6b7280;
        }
    </style>
</head>

<body>

<header>
    <h1>Student Feedback Portal</h1>
    <p>Share your experience and help us improve</p>
</header>

<div class="container">

    <h2>Submit Your Feedback</h2>

    <p>We value your opinion. Please fill out the form below.</p>

    <form action="feedback" method="post">

        <label for="name">Full Name</label>
        <input type="text" id="name" name="name"
               placeholder="Enter your full name" required>

        <label for="email">Email Address</label>
        <input type="email" id="email" name="email"
               placeholder="Enter your email" required>

        <label for="message">Your Feedback</label>
        <textarea id="message" name="message"
                  placeholder="Write your feedback here..."
                  required></textarea>

        <button type="submit">Submit Feedback</button>

    </form>

</div>

<footer>
    Student Feedback Portal | Internship DevOps Project
</footer>

</body>
</html>
