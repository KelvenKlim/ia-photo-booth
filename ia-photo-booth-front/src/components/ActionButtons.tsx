import { Button } from "@/components/ui/button";
import { Loader2, Wand2, Trash2 } from "lucide-react";
import type { AppState } from "@/types/api";

interface ActionButtonsProps {
  appState: AppState;
  canProcess: boolean;
  onProcess: () => void;
  onClear: () => void;
}

export function ActionButtons({ appState, canProcess, onProcess, onClear }: ActionButtonsProps) {
  const isProcessing = appState === "processing";

  return (
    <section className="space-y-3">
      <Button
        variant="hero"
        size="xl"
        className="w-full"
        disabled={!canProcess || isProcessing}
        onClick={onProcess}
      >
        {isProcessing ? (
          <>
            <Loader2 className="h-5 w-5 animate-spin-slow" />
            Criando sua versão com IA...
          </>
        ) : (
          <>
            <Wand2 className="h-5 w-5" />
            Processar com IA
          </>
        )}
      </Button>

      <Button
        variant="ghost"
        size="default"
        className="w-full text-muted-foreground"
        onClick={onClear}
        disabled={isProcessing}
      >
        <Trash2 className="h-4 w-4" />
        Limpar tudo
      </Button>
    </section>
  );
}
