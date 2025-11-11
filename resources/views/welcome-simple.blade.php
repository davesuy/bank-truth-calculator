<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bank Truth Calculator</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .container {
            background: white;
            border-radius: 20px;
            padding: 40px;
            max-width: 600px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        h1 {
            color: #667eea;
            margin-bottom: 20px;
            font-size: 32px;
        }
        p {
            color: #666;
            line-height: 1.6;
            margin-bottom: 15px;
        }
        .status {
            background: #f0fdf4;
            border-left: 4px solid #22c55e;
            padding: 15px;
            margin: 20px 0;
            border-radius: 4px;
        }
        .status h3 {
            color: #22c55e;
            margin-bottom: 10px;
        }
        .links {
            margin-top: 30px;
        }
        .links a {
            display: inline-block;
            background: #667eea;
            color: white;
            padding: 12px 24px;
            border-radius: 8px;
            text-decoration: none;
            margin: 5px;
            transition: all 0.3s;
        }
        .links a:hover {
            background: #764ba2;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }
        .api-test {
            background: #f9fafb;
            padding: 15px;
            border-radius: 8px;
            margin-top: 20px;
            font-family: 'Courier New', monospace;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>💰 Bank Truth Calculator</h1>

        <div class="status">
            <h3>✅ Application is Running!</h3>
            <p>The Laravel backend is working correctly. The build was successful.</p>
        </div>

        <p>
            Welcome to the Bank Truth Calculator! This application helps you understand
            the real cost of keeping money in low-interest savings accounts.
        </p>

        <p>
            <strong>Current Status:</strong> The application is deployed and the API is functional.
            We're working on loading the full calculator interface.
        </p>

        <div class="links">
            <a href="/test">System Test</a>
            <a href="/health">Health Check</a>
            <a href="/api/banks">View Banks API</a>
        </div>

        <div class="api-test">
            <strong>Quick API Test:</strong><br>
            Try: <code>GET /api/banks</code> to see all banks<br>
            Or: <code>GET /api/banks/sponsored</code> for high-yield options
        </div>

        <p style="margin-top: 30px; font-size: 14px; color: #999;">
            Environment: {{ config('app.env') }} |
            Debug: {{ config('app.debug') ? 'Enabled' : 'Disabled' }} |
            Version: Laravel {{ app()->version() }}
        </p>
    </div>
</body>
</html>

