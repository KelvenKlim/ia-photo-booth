import { useEffect, useState } from "react";
import { Sparkles } from "lucide-react";

const messages = [
  "Analisando sua foto...",
  "Aplicando o tema escolhido...",
  "Preservando sua identidade...",
  "Gerando cenário histórico...",
  "Ajustando iluminação e detalhes...",
  "Quase lá, finalizando...",
];

export function ProcessingOverlay() {
  const [msgIndex, setMsgIndex] = useState(0);
  const [progress, setProgress] = useState(0);

  useEffect(() => {
    const msgTimer = setInterval(() => {
      setMsgIndex((prev) => (prev + 1) % messages.length);
    }, 3000);
    return () => clearInterval(msgTimer);
  }, []);

  useEffect(() => {
    const progTimer = setInterval(() => {
      setProgress((prev) => (prev >= 95 ? 95 : prev + Math.random() * 8));
    }, 800);
    return () => clearInterval(progTimer);
  }, []);

  return (
    <section className="card-elevated p-6 animate-fade-up">
      <div className="flex flex-col items-center gap-5 py-4">
        {/* Animated icon */}
        <div className="relative">
          <div className="absolute inset-0 rounded-full bg-primary/20 animate-ping" />
          <div className="relative flex h-16 w-16 items-center justify-center rounded-full bg-gradient-to-br from-primary to-accent shadow-lg">
            <Sparkles className="h-8 w-8 text-white animate-pulse" />
          </div>
        </div>

        {/* Message */}
        <p className="text-sm font-semibold text-foreground text-center animate-pulse">
          {messages[msgIndex]}
        </p>

        {/* Progress bar */}
        <div className="w-full max-w-xs">
          <div className="h-2 w-full rounded-full bg-muted overflow-hidden">
            <div
              className="h-full rounded-full bg-gradient-to-r from-primary to-accent transition-all duration-700 ease-out"
              style={{ width: `${progress}%` }}
            />
          </div>
          <p className="mt-1.5 text-center text-xs text-muted-foreground">
            {Math.round(progress)}%
          </p>
        </div>

        {/* Tip */}
        <p className="text-xs text-muted-foreground/70 text-center max-w-[250px]">
          Isso pode levar alguns segundos. Não feche a página.
        </p>
      </div>
    </section>
  );
}
