#!/bin/bash

# Setup Worktree V2 - Complete Project Bootstrap Script
# This script sets up a new React + Supabase project from this template

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    print_step "Checking prerequisites..."
    
    # Check Node.js
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed. Please install Node.js 18+ first."
        exit 1
    fi
    
    # Check npm
    if ! command -v npm &> /dev/null; then
        print_error "npm is not installed. Please install npm first."
        exit 1
    fi
    
    # Check Supabase CLI
    if ! command -v supabase &> /dev/null; then
        print_warning "Supabase CLI is not installed. Installing..."
        npm install -g supabase
    fi
    
    print_success "All prerequisites are installed!"
}

# Setup environment
setup_environment() {
    print_step "Setting up environment variables..."
    
    if [ ! -f .env.local ]; then
        cp .env.example .env.local
        print_success "Created .env.local from .env.example"
        print_warning "Please update .env.local with your actual Supabase credentials!"
    else
        print_warning ".env.local already exists, skipping..."
    fi
}

# Install dependencies
install_dependencies() {
    print_step "Installing dependencies..."
    
    if [ -f package-lock.json ]; then
        npm ci
    else
        npm install
    fi
    
    print_success "Dependencies installed successfully!"
}

# Setup Supabase
setup_supabase() {
    print_step "Setting up Supabase..."
    
    # Check if Supabase is already initialized
    if [ ! -f supabase/config.toml ]; then
        print_step "Initializing Supabase project..."
        npx supabase init
    fi
    
    # Start local Supabase
    print_step "Starting local Supabase instance..."
    npx supabase start
    
    # Get local credentials
    print_step "Getting local Supabase credentials..."
    npx supabase status
    
    print_success "Supabase setup complete!"
    print_warning "Remember to update .env.local with the local Supabase URL and anon key from the status output above!"
}

# Setup database
setup_database() {
    print_step "Setting up database..."
    
    # Check if there are migrations
    if [ -d "supabase/migrations" ] && [ "$(ls -A supabase/migrations)" ]; then
        print_step "Running database migrations..."
        npx supabase db push
        print_success "Database migrations applied!"
    else
        print_warning "No migrations found, skipping..."
    fi
    
    # Check if there's a seed file
    if [ -f "supabase/seed.sql" ]; then
        print_step "Seeding database..."
        npx supabase db seed
        print_success "Database seeded!"
    fi
}

# Setup Git hooks
setup_git_hooks() {
    print_step "Setting up Git hooks..."
    
    # Create pre-commit hook for linting
    if [ -d ".git" ]; then
        cat > .git/hooks/pre-commit << 'EOF'
#!/bin/sh
npm run lint
EOF
        chmod +x .git/hooks/pre-commit
        print_success "Git hooks configured!"
    else
        print_warning "Not a git repository, skipping git hooks..."
    fi
}

# Create initial components
create_initial_files() {
    print_step "Creating initial project files..."
    
    # Create main App component
    if [ ! -f "src/App.tsx" ]; then
        cat > src/App.tsx << 'EOF'
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { Toaster } from '@/components/ui/toaster';
import { ThemeProvider } from '@/components/theme-provider';
import HomePage from '@/pages/HomePage';
import './App.css';

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 60 * 1000,
      retry: 1,
    },
  },
});

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <ThemeProvider defaultTheme="light" storageKey="app-theme">
        <Router>
          <Routes>
            <Route path="/" element={<HomePage />} />
          </Routes>
        </Router>
        <Toaster />
      </ThemeProvider>
    </QueryClientProvider>
  );
}

export default App;
EOF
    fi
    
    # Create Supabase client
    if [ ! -f "src/lib/supabase.ts" ]; then
        cat > src/lib/supabase.ts << 'EOF'
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Missing Supabase environment variables');
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
EOF
    fi
    
    # Create main.tsx
    if [ ! -f "src/main.tsx" ]; then
        cat > src/main.tsx << 'EOF'
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import './index.css';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
);
EOF
    fi
    
    # Create index.html
    if [ ! -f "index.html" ]; then
        cat > index.html << 'EOF'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/vite.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Template App</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
EOF
    fi
    
    print_success "Initial files created!"
}

# Main setup flow
main() {
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║   Setup Worktree V2 - Project Setup   ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo ""
    
    check_prerequisites
    setup_environment
    install_dependencies
    
    # Ask if user wants to setup Supabase
    read -p "Do you want to setup local Supabase? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        setup_supabase
        setup_database
    fi
    
    setup_git_hooks
    create_initial_files
    
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║        Setup Complete! 🎉              ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Update .env.local with your Supabase credentials"
    echo "2. Run 'npm run dev' to start the development server"
    echo "3. Open http://localhost:5173 in your browser"
    echo ""
    echo -e "${BLUE}Useful commands:${NC}"
    echo "  npm run dev          - Start development server"
    echo "  npm run build        - Build for production"
    echo "  npm run lint         - Run ESLint"
    echo "  npx supabase start   - Start local Supabase"
    echo "  npx supabase stop    - Stop local Supabase"
    echo ""
}

# Run main function
main