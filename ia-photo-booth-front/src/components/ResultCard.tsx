import { useState } from "react";
import { ChevronDown, ChevronUp, ImageIcon, Sparkles } from "lucide-react";

interface ResultCardProps {
  originalPreview: string;
  resultUri: string;
  promptUsed: string;
}

export function ResultCard({ originalPreview, resultUri, promptUsed }: ResultCardProps) {
  const [showPrompt, setShowPrompt] = useState(false);
  const [fullscreen, setFullscreen] = useState<string | null>(null);

  return (
    <>
      <section className="card-elevated p-5 animate-fade-up">
        <div className="mb-4 flex items-center gap-2">
          <Sparkles className="h-5 w-5 text-accent" />
          <h2 className="font-display text-lg font-bold text-foreground">Resultado</h2>
        </div>

        <div className="space-y-4">
          {/* Original */}
          <div>
            <p className="mb-1.5 text-xs font-semibold text-muted-foreground uppercase tracking-wider flex items-center gap-1">
              <ImageIcon className="h-3 w-3" /> Original
            </p>
            <img
              src={originalPreview}
              alt="Foto original"
              className="w-full max-h-40 object-cover rounded-md opacity-70 cursor-pointer hover:opacity-100 transition-opacity"
              onClick={() => setFullscreen(originalPreview)}
            />
          </div>

          {/* Result */}
          <div>
            <p className="mb-1.5 text-xs font-semibold text-accent uppercase tracking-wider flex items-center gap-1">
              <Sparkles className="h-3 w-3" /> Versão IA
            </p>
            <img
              src={resultUri}
              alt="Resultado da IA"
              className="w-full rounded-md cursor-pointer hover:shadow-lg transition-shadow"
              onClick={() => setFullscreen(resultUri)}
            />
          </div>
        </div>

        {/* Prompt accordion */}
        <button
          onClick={() => setShowPrompt(!showPrompt)}
          className="mt-4 flex w-full items-center justify-between rounded-md bg-icbeu-surface px-3 py-2 text-xs font-semibold text-muted-foreground hover:text-foreground transition-colors"
        >
          <span>Prompt utilizado</span>
          {showPrompt ? <ChevronUp className="h-4 w-4" /> : <ChevronDown className="h-4 w-4" />}
        </button>
        {showPrompt && (
          <div className="mt-2 rounded-md border-l-4 border-accent bg-icbeu-surface px-3 py-2.5">
            <p className="text-xs italic text-muted-foreground leading-relaxed">{promptUsed}</p>
          </div>
        )}
      </section>

      {/* Fullscreen overlay */}
      {fullscreen && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center bg-foreground/80 backdrop-blur-sm p-4"
          onClick={() => setFullscreen(null)}
        >
          <img
            src={fullscreen}
            alt="Imagem ampliada"
            className="max-h-[90vh] max-w-full rounded-lg object-contain"
          />
        </div>
      )}
    </>
  );
}
