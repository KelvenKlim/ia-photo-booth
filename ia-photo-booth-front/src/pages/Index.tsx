import { useState, useRef, useCallback } from "react";
import { AppHeader } from "@/components/AppHeader";
import { ConfigFormCard } from "@/components/ConfigFormCard";
import { ImageUploadCard } from "@/components/ImageUploadCard";
import { ActionButtons } from "@/components/ActionButtons";
import { ResultCard } from "@/components/ResultCard";
import { ShareButtons } from "@/components/ShareButtons";
import { ProcessingOverlay } from "@/components/ProcessingOverlay";
import { editImage } from "@/services/api";
import type { AppState } from "@/types/api";
import { toast } from "sonner";

export default function Index() {
  const resultRef = useRef<HTMLDivElement>(null);

  // Form state
  const [email, setEmail] = useState("");
  const [theme, setTheme] = useState("Hamilton");
  const [instructions, setInstructions] = useState("");
  const [size, setSize] = useState("1024x1024");

  // Image state
  const [imageFile, setImageFile] = useState<File | null>(null);
  const [imagePreview, setImagePreview] = useState<string | null>(null);

  // Result state
  const [appState, setAppState] = useState<AppState>("idle");
  const [resultUri, setResultUri] = useState<string | null>(null);
  const [promptUsed, setPromptUsed] = useState("");

  const handleImageSelect = useCallback((file: File) => {
    setImageFile(file);
    setImagePreview(URL.createObjectURL(file));
    setResultUri(null);
    setAppState("photo-ready");
  }, []);

  const handleClear = useCallback(() => {
    setImageFile(null);
    setImagePreview(null);
    setResultUri(null);
    setPromptUsed("");
    setAppState("idle");
  }, []);

  const handleProcess = useCallback(async () => {
    if (!imageFile || !theme) return;

    setAppState("processing");
    try {
      const response = await editImage({
        image: imageFile,
        theme,
        extra_instructions: instructions,
        size,
      });

      const uri = `data:${response.mime_type};base64,${response.image_base64}`;
      setResultUri(uri);
      setPromptUsed(response.prompt_used);
      setAppState("success");

      // Scroll suave para o resultado
      setTimeout(() => {
        resultRef.current?.scrollIntoView({ behavior: "smooth", block: "start" });
      }, 300);
    } catch (err) {
      setAppState("error");
      toast.error("Não foi possível processar sua imagem. Tente novamente.", {
        duration: 5000,
      });
      // Allow retry
      setTimeout(() => setAppState("photo-ready"), 2000);
    }
  }, [imageFile, theme, instructions, size]);

  const canProcess = !!imageFile && !!theme && appState !== "processing";

  return (
    <div className="min-h-screen bg-background font-display">
      <AppHeader />

      <main className="mx-auto max-w-lg space-y-5 px-4 py-6 -mt-4">
        <ConfigFormCard
          email={email}
          theme={theme}
          instructions={instructions}
          size={size}
          onEmailChange={setEmail}
          onThemeChange={setTheme}
          onInstructionsChange={setInstructions}
          onSizeChange={setSize}
        />

        <ImageUploadCard
          imagePreview={imagePreview}
          onImageSelect={handleImageSelect}
          onClear={() => {
            setImageFile(null);
            setImagePreview(null);
            setResultUri(null);
            setAppState("idle");
          }}
        />

        <ActionButtons
          appState={appState}
          canProcess={canProcess}
          onProcess={handleProcess}
          onClear={handleClear}
        />

        {/* Processing overlay */}
        {appState === "processing" && <ProcessingOverlay />}

        {/* Result section */}
        <div ref={resultRef}>
          {appState === "success" && resultUri && imagePreview && (
            <>
              <ResultCard
                originalPreview={imagePreview}
                resultUri={resultUri}
                promptUsed={promptUsed}
              />
              <div className="mt-5">
                <ShareButtons resultUri={resultUri} onRegenerate={handleProcess} email={email} />
              </div>
            </>
          )}
        </div>

        {/* Footer */}
        <footer className="pb-8 pt-4 text-center">
          <p className="text-xs text-muted-foreground">
            ICBEU Manaus • IA Photo Zone
          </p>
        </footer>
      </main>
    </div>
  );
}
