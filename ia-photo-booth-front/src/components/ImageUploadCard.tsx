import { Camera, ImagePlus, X } from "lucide-react";
import { Button } from "@/components/ui/button";
import { useRef } from "react";

interface ImageUploadCardProps {
  imagePreview: string | null;
  onImageSelect: (file: File) => void;
  onClear: () => void;
}

export function ImageUploadCard({ imagePreview, onImageSelect, onClear }: ImageUploadCardProps) {
  const fileInputRef = useRef<HTMLInputElement>(null);
  const cameraInputRef = useRef<HTMLInputElement>(null);

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) onImageSelect(file);
    e.target.value = "";
  };

  return (
    <section className="card-glass p-5">
      <div className="mb-4 flex items-center gap-2">
        <ImagePlus className="h-5 w-5 text-primary" />
        <h2 className="font-display text-lg font-bold text-foreground">Sua Foto</h2>
      </div>

      {imagePreview ? (
        <div className="relative overflow-hidden rounded-md">
          <img
            src={imagePreview}
            alt="Foto selecionada"
            className="w-full max-h-72 object-cover rounded-md"
          />
          <button
            onClick={onClear}
            className="absolute top-2 right-2 flex h-8 w-8 items-center justify-center rounded-full bg-foreground/60 text-primary-foreground backdrop-blur-sm hover:bg-foreground/80 transition-colors"
          >
            <X className="h-4 w-4" />
          </button>
        </div>
      ) : (
        <div className="flex h-48 flex-col items-center justify-center rounded-md border-2 border-dashed border-border bg-icbeu-surface">
          <ImagePlus className="mb-2 h-10 w-10 text-muted-foreground/40" />
          <p className="text-sm text-muted-foreground">Nenhuma foto selecionada</p>
        </div>
      )}

      <div className="mt-4 grid grid-cols-2 gap-3">
        <Button
          variant="outline-card"
          size="lg"
          onClick={() => cameraInputRef.current?.click()}
          className="gap-2"
        >
          <Camera className="h-4 w-4" />
          Câmera
        </Button>
        <Button
          variant="outline-card"
          size="lg"
          onClick={() => fileInputRef.current?.click()}
          className="gap-2"
        >
          <ImagePlus className="h-4 w-4" />
          Galeria
        </Button>
      </div>

      {/* Hidden file inputs */}
      <input
        ref={cameraInputRef}
        type="file"
        accept="image/png,image/jpeg,image/jpg,image/webp"
        capture="environment"
        onChange={handleFileChange}
        className="hidden"
      />
      <input
        ref={fileInputRef}
        type="file"
        accept="image/png,image/jpeg,image/jpg,image/webp"
        onChange={handleFileChange}
        className="hidden"
      />
    </section>
  );
}
