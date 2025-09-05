import { Button } from "@/components/ui/button";

export default function HomePage() {
  return (
    <div className="container mx-auto py-10">
      <h1 className="text-4xl font-bold mb-6">Welcome to Your App</h1>
      <p className="text-lg text-muted-foreground mb-8">
        This is a modern React + Supabase template with TypeScript, Tailwind CSS, and shadcn/ui.
      </p>
      <div className="flex gap-4">
        <Button>Get Started</Button>
        <Button variant="outline">Learn More</Button>
      </div>
    </div>
  );
}