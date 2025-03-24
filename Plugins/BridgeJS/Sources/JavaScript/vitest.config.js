// @ts-check
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    environment: 'node',
    include: ['**/?(*.)+(spec|test).js'],
    globals: true
  }
}); 
