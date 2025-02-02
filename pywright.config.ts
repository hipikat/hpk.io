import { defineConfig } from "@playwright/test";

export default defineConfig({
  use: {
    baseURL: "http://localhost:8075", // Test server now runs on 8075
    headless: false, // Run in a visible browser window
    video: "on-first-retry", // Record video only if a test fails once
    screenshot: "only-on-failure", // Take screenshots on failure
  },
  webServer: {
    command: ".venv/bin/python src/manage.py runserver 0.0.0.0:8075", // Run test server
    port: 8075, // Ensure Playwright waits for the test server
    reuseExistingServer: true,
  },
});
