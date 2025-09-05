# Project Context for Claude

## Project Overview
This is a full-stack web application built with React, TypeScript, Vite, and Supabase. The application follows a modern architecture with real-time capabilities, authentication, and a component-based UI using shadcn/ui and Tailwind CSS.

## Tech Stack
- **Frontend**: React 18 + TypeScript + Vite
- **Styling**: Tailwind CSS + shadcn/ui components
- **Backend**: Supabase (PostgreSQL + Auth + Storage + Edge Functions)
- **State Management**: TanStack Query (React Query)
- **Forms**: React Hook Form + Zod validation
- **Routing**: React Router v6
- **Build Tool**: Vite
- **Package Manager**: npm (or bun)

## Project Structure
```
├── src/
│   ├── components/     # Reusable UI components
│   ├── hooks/          # Custom React hooks
│   ├── lib/            # Core libraries and utilities
│   │   ├── supabase.ts # Supabase client configuration
│   │   └── utils.ts    # Utility functions
│   ├── pages/          # Page components (routes)
│   ├── types/          # TypeScript type definitions
│   └── utils/          # Helper functions
├── supabase/
│   ├── functions/      # Supabase Edge Functions
│   └── migrations/     # Database migrations
├── public/             # Static assets
└── .env.local          # Environment variables (not committed)
```

## Key Conventions

### Code Style
- Use TypeScript for all new files
- Follow React best practices with functional components and hooks
- Use shadcn/ui components for UI elements
- Apply Tailwind CSS for styling
- Implement proper error handling with try-catch blocks
- Use async/await for asynchronous operations

### Component Structure
```tsx
// Example component structure
import { useState } from 'react';
import { Button } from '@/components/ui/button';
import { useToast } from '@/hooks/use-toast';

interface ComponentProps {
  // Props definition
}

export function ComponentName({ ...props }: ComponentProps) {
  // Component logic
  return (
    // JSX
  );
}
```

### Supabase Integration
- All Supabase operations should go through the client in `src/lib/supabase.ts`
- Use Row Level Security (RLS) policies for data access control
- Handle authentication state globally
- Implement proper error handling for database operations

### State Management
- Use TanStack Query for server state management
- Local state with useState for component-specific state
- Context API for global app state when needed

### File Naming
- Components: PascalCase (e.g., `UserProfile.tsx`)
- Utilities/Hooks: camelCase (e.g., `useAuth.ts`, `formatDate.ts`)
- Types: PascalCase with `.types.ts` extension

## Common Commands
```bash
# Development
npm run dev           # Start development server
npm run build         # Build for production
npm run preview       # Preview production build
npm run lint          # Run ESLint

# Supabase
npx supabase start    # Start local Supabase
npx supabase stop     # Stop local Supabase
npx supabase db push  # Push migrations
npx supabase functions serve  # Serve Edge Functions locally
```

## Environment Variables
Required environment variables (see `.env.example`):
- `VITE_SUPABASE_URL`: Supabase project URL
- `VITE_SUPABASE_ANON_KEY`: Supabase anonymous key

## Important Notes
- Always check for existing components before creating new ones
- Follow the established patterns in the codebase
- Test locally with `npm run dev` before committing
- Use proper TypeScript types - avoid `any`
- Implement loading and error states for async operations
- Keep components small and focused (single responsibility)

## Testing Approach
- Manual testing during development
- Test critical user flows
- Verify Supabase operations work correctly
- Check responsive design on different screen sizes

## Performance Considerations
- Lazy load routes and heavy components
- Optimize images and assets
- Use React.memo for expensive components
- Implement proper caching with React Query
- Minimize bundle size

## Security Best Practices
- Never expose sensitive keys in frontend code
- Use environment variables for configuration
- Implement proper authentication checks
- Validate all user inputs
- Use Supabase RLS for data security