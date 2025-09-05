# 🚀 React + Supabase Template

A modern, production-ready template for building full-stack web applications with React, TypeScript, Vite, and Supabase.

## ✨ Features

- **⚡ Vite** - Lightning fast build tool and dev server
- **⚛️ React 18** - Latest React with concurrent features
- **🔷 TypeScript** - Type-safe development experience
- **🎨 Tailwind CSS** - Utility-first CSS framework
- **🧩 shadcn/ui** - High-quality, customizable UI components
- **🗄️ Supabase** - Backend as a Service (PostgreSQL, Auth, Storage, Realtime)
- **📊 TanStack Query** - Powerful data synchronization for React
- **📝 React Hook Form** - Performant forms with easy validation
- **🛣️ React Router v6** - Client-side routing
- **🔐 Authentication** - Built-in auth with Supabase Auth
- **🎯 Type Safety** - End-to-end TypeScript support
- **📱 Responsive** - Mobile-first design approach
- **🌙 Dark Mode** - Theme support out of the box

## 📋 Prerequisites

Before you begin, ensure you have the following installed:
- **Node.js** (v18 or higher)
- **npm** (v9 or higher)
- **Git**
- **Supabase CLI** (optional, for local development)

## 🚀 Quick Start

### 1. Clone the Template

```bash
git clone https://github.com/yourusername/template_app.git my-new-app
cd my-new-app
```

### 2. Run the Setup Script

```bash
chmod +x setup_worktree_v2.sh
./setup_worktree_v2.sh
```

This script will:
- Check prerequisites
- Install dependencies
- Set up environment variables
- Initialize Supabase (optional)
- Create initial project structure
- Configure Git hooks

### 3. Manual Setup (Alternative)

If you prefer manual setup or the script doesn't work:

```bash
# Install dependencies
npm install

# Copy environment variables
cp .env.example .env.local

# Install Supabase CLI (if not installed)
npm install -g supabase

# Initialize Supabase (optional, for local development)
npx supabase init
npx supabase start
```

### 4. Configure Environment Variables

Edit `.env.local` with your Supabase credentials:

```env
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
```

#### Getting Supabase Credentials

**Option 1: Local Development (Recommended for start)**
```bash
npx supabase start
# Copy the API URL and anon key from the output
```

**Option 2: Supabase Cloud**
1. Go to [supabase.com](https://supabase.com)
2. Create a new project
3. Go to Settings → API
4. Copy the Project URL and anon key

### 5. Start Development Server

```bash
npm run dev
```

Open [http://localhost:5173](http://localhost:5173) to see your app!

## 📁 Project Structure

```
template_app/
├── .claude/            # Claude AI configuration
│   └── CLAUDE.md       # Project context for Claude
├── src/
│   ├── components/     # Reusable UI components
│   │   ├── ui/         # shadcn/ui components
│   │   └── ...         # Custom components
│   ├── hooks/          # Custom React hooks
│   ├── lib/            # Core libraries and utilities
│   │   ├── supabase.ts # Supabase client
│   │   └── utils.ts    # Utility functions
│   ├── pages/          # Page components (routes)
│   ├── types/          # TypeScript type definitions
│   ├── utils/          # Helper functions
│   ├── App.tsx         # Main App component
│   ├── main.tsx        # Application entry point
│   └── index.css       # Global styles
├── supabase/
│   ├── functions/      # Edge Functions (serverless)
│   ├── migrations/     # Database migrations
│   └── config.toml     # Supabase configuration
├── public/             # Static assets
├── .env.example        # Environment variables template
├── .env.local          # Local environment variables (not committed)
├── .mcp.json           # MCP configuration
├── package.json        # Dependencies and scripts
├── vite.config.ts      # Vite configuration
├── tailwind.config.ts  # Tailwind CSS configuration
└── tsconfig.json       # TypeScript configuration
```

## 🛠️ Available Scripts

```bash
# Development
npm run dev             # Start dev server
npm run build           # Build for production
npm run preview         # Preview production build
npm run lint            # Run ESLint

# Supabase
npx supabase start      # Start local Supabase
npx supabase stop       # Stop local Supabase
npx supabase status     # Check Supabase status
npx supabase db push    # Push migrations
npx supabase db reset   # Reset database

# Type Checking
npm run type-check      # Run TypeScript compiler check
```

## 🎨 Customization

### Adding New Components

1. **shadcn/ui Components**
```bash
npx shadcn-ui@latest add button
```

2. **Custom Components**
```tsx
// src/components/MyComponent.tsx
import { cn } from '@/lib/utils';

interface MyComponentProps {
  className?: string;
}

export function MyComponent({ className }: MyComponentProps) {
  return (
    <div className={cn('your-styles', className)}>
      {/* Component content */}
    </div>
  );
}
```

### Adding New Pages

```tsx
// src/pages/NewPage.tsx
import { useEffect } from 'react';
import { supabase } from '@/lib/supabase';

export default function NewPage() {
  useEffect(() => {
    // Fetch data from Supabase
  }, []);

  return (
    <div>
      {/* Page content */}
    </div>
  );
}
```

Don't forget to add the route in `App.tsx`:
```tsx
<Route path="/new-page" element={<NewPage />} />
```

### Database Schema

Create migrations in `supabase/migrations/`:
```sql
-- supabase/migrations/001_create_users_table.sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
```

Apply migrations:
```bash
npx supabase db push
```

### Authentication Setup

```tsx
// src/hooks/useAuth.ts
import { useEffect, useState } from 'react';
import { supabase } from '@/lib/supabase';
import type { User } from '@supabase/supabase-js';

export function useAuth() {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      setUser(session?.user ?? null);
      setLoading(false);
    });

    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      (_event, session) => {
        setUser(session?.user ?? null);
      }
    );

    return () => subscription.unsubscribe();
  }, []);

  return { user, loading };
}
```

## 🚢 Deployment

### Vercel

```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel
```

### Netlify

```bash
# Build command
npm run build

# Publish directory
dist
```

### Docker

```dockerfile
FROM node:18-alpine as builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

## 🧪 Testing

```bash
# Run tests (when configured)
npm test

# Run tests in watch mode
npm run test:watch

# Run E2E tests
npm run test:e2e
```

## 📚 Learn More

- [React Documentation](https://react.dev)
- [Vite Documentation](https://vitejs.dev)
- [Supabase Documentation](https://supabase.com/docs)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [shadcn/ui Documentation](https://ui.shadcn.com)
- [TypeScript Documentation](https://www.typescriptlang.org/docs)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with love using amazing open-source technologies
- Inspired by modern web development best practices
- Thanks to all contributors and the open-source community

---

**Happy Coding!** 🎉

Need help? Check the [Issues](https://github.com/yourusername/template_app/issues) section or create a new one.
