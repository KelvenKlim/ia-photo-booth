import { Sparkles } from "lucide-react";

export function AppHeader() {
  return (
    <header className="gradient-hero px-4 pt-12 pb-10 text-center">
      {/* Logo circle */}
      <div className="mx-auto mb-5 flex h-20 w-20 items-center justify-center rounded-full bg-primary-foreground/20 backdrop-blur-sm border border-primary-foreground/30">
        <Sparkles className="h-9 w-9 text-primary-foreground" />
      </div>

      <h1 className="font-display text-2xl font-extrabold tracking-tight text-primary-foreground">
        ICBEU IA Photo Zone
      </h1>
      <p className="mt-2 text-sm font-medium text-primary-foreground/80">
        Transforme sua foto com o poder da Inteligência Artificial
      </p>
      <p className="mt-1 text-xs text-primary-foreground/60">
        Escolha um tema, envie sua foto e veja a mágica acontecer ✨
      </p>
    </header>
  );
}
