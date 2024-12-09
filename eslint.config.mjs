// @ts-check

import eslint from "@eslint/js";
import react from "eslint-plugin-react";
import tseslint from "typescript-eslint";
import tailwind from "eslint-plugin-tailwindcss";
import tsParser from "@typescript-eslint/parser";

export default tseslint.config(
  {
    ignores: [
      ".git/**",
      ".pytest_cache/**",
      ".ruff_cache/**",
      ".venv/**",
      "__pycache__/**",
      "dist/**",
      "build/**",
      "infra/**",
      "logs/**",
      "node_modules/**",
      "static/**",
    ],
  },
  {
    files: ["**/*.{js,mjs,cjs,jsx,mjsx,ts,tsx,mtsx}"],
    languageOptions: {
      ecmaVersion: "latest",
      parser: tsParser,
      sourceType: "module",
      globals: {
        process: "readonly",
        window: "readonly",
        document: "readonly",
        navigator: "readonly",
        console: "readonly",
      },
      parserOptions: {
        ecmaFeatures: {
          jsx: true,
        },
      },
    },
  },
  eslint.configs.recommended,
  tseslint.configs.recommended,
  tailwind.configs["flat/recommended"],
  {
    files: ["packages/website/**/*.{ts,tsx,mts,cts,js,jsx}"],
    // @ts-expect-error TypeScript doesn’t fully understand react.configs.flat compatibility with tseslint.config yet.
    extends: [react.configs.flat.recommended],
  },
);
