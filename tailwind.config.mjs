/** @type {import('tailwindcss').Config} */

import daisyui from "daisyui";
import typography from "@tailwindcss/typography";

export default {
  content: ["./src/*.sass", "./src/**/*.html", "./src/**/*.{js,jsx,ts,tsx}"],
  options: {
    safelist: ["size-5", "group-hover:opacity-100"],
  },
  plugins: [
    typography,
    daisyui,
    function ({ addBase, theme }) {
      const screens = theme("screens");
      addBase({
        ":root": {
          fontSize: "1.2rem",
          "--screen-sm": screens.sm,
          "--screen-md": screens.md,
          "--screen-lg": screens.lg,
        },
      });
    },
  ],
  daisyui: {
    themes: [
      {
        ad: {
          primary: "#b6b8e6",
          secondary: "#99c9bc",
          accent: "#ffc293",
          neutral: "#3b5d6e",
          "base-100": "#1b303b",
          info: "#18bdcf",
          success: "#40b78e",
          warning: "#b6b14d",
          error: "#f38fa1",
          "--tw-theme-ring": "#b6b8e6",
        },
        fl: {
          primary: "#134f62",
          secondary: "#583c5b",
          accent: "#00b3a9",
          neutral: "#1f1008",
          "base-100": "#e9e5e4",
          info: "#71bcfe",
          success: "#7fbb70",
          warning: "#daba00",
          error: "#f57592",
          "--tw-theme-ring": "#134f62",
        },
      },
    ],
    logs: false,
  },
  theme: {
    extend: {
      fontSize: {
        xs: ["0.75rem", "1.6"],
        sm: ["0.8333rem", "1.6"],
        base: ["1rem", "1.6"],
        lg: ["1.125rem", "1.6"],
        xl: ["1.25rem", "1.4"],
        "2xl": ["1.5rem", "1.4"],
        "3xl": ["1.875rem", "1.4"],
      },
      fontFamily: {
        cursive: ["Sacramento", "cursive"],
        serif: ["Zilla Slab", "serif"],
        heading: ["Bitter", "serif"],
        highlight: ["Zilla Slab Highlight", "serif"],
        mono: ["Fira Code", "monospace"],
      },
      colors: {
        "profile-ring": "var(--tw-theme-ring)",
      },
      maxWidth: {
        sm: "34rem",
        md: "40rem",
        lg: "52rem",
        xl: "66rem",
        "2xl": "78rem",
      },
      padding: {
        "safe-left": "env(safe-area-inset-left)",
        "safe-right": "env(safe-area-inset-right)",
      },
      margin: {
        "neg-safe-left": "calc(-1 * env(safe-area-inset-left))",
        "neg-safe-right": "calc(-1 * env(safe-area-inset-right))",
      },
    },
  },
  variants: {
    extend: {},
  },
};
