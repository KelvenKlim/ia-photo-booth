import { Button } from "@/components/ui/button";
import { Share2, Download, Mail, RefreshCw } from "lucide-react";
import { useState } from "react";

const API_URL = import.meta.env.VITE_API_URL || "http://localhost:8000";

interface ShareButtonsProps {
  resultUri: string;
  onRegenerate: () => void;
  email?: string;
}

export function ShareButtons({ resultUri, onRegenerate, email }: ShareButtonsProps) {
  const [sending, setSending] = useState(false);

  const handleShare = async () => {
    try {
      // Check if Web Share API is available
      if (!navigator.share) {
        alert("Compartilhamento não suportado neste navegador. Use o botão de baixar para salvar a imagem.");
        return;
      }

      // Convert data URI to blob
      const res = await fetch(resultUri);
      const blob = await res.blob();
      
      // Try to share as file (works on Android Chrome, some iOS apps)
      const file = new File([blob], "icbeu-ia-photo.png", { type: "image/png" });
      
      try {
        // Check if device supports file sharing
        if (navigator.canShare && navigator.canShare({ files: [file] })) {
          await navigator.share({
            title: "ICBEU IA Photo Zone",
            text: "Veja minha foto transformada com IA no ICBEU!",
            files: [file],
          });
          return;
        }
      } catch (fileShareError) {
        console.log('File sharing not fully supported, trying alternative...');
      }

      // Fallback: Create a blob URL and open share with that
      const blobUrl = URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = blobUrl;
      link.download = 'icbeu-ia-photo.png';
      
      // Try share with blob URL
      try {
        await navigator.share({
          title: "ICBEU IA Photo Zone",
          text: "Veja minha foto transformada com IA no ICBEU!",
          url: blobUrl,
        });
        URL.revokeObjectURL(blobUrl);
        return;
      } catch {
        URL.revokeObjectURL(blobUrl);
      }

      // Last fallback: just trigger download and inform user
      alert("Compartilhamento direto não está disponível. A imagem será baixada. Você pode compartilhá-la manualmente após o download.");
      link.click();
      
    } catch (error) {
      if (error instanceof Error && error.name === 'AbortError') {
        // User cancelled - silent
        return;
      }
      console.error('Share error:', error);
      alert("Erro ao compartilhar. Tente baixar a imagem em vez disso.");
    }
  };

  const handleDownload = async () => {
    try {
      const res = await fetch(resultUri);
      const blob = await res.blob();
      const url = URL.createObjectURL(blob);
      const a = document.createElement("a");
      a.href = url;
      a.download = "icbeu-ia-photo.png";
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);
    } catch {
      alert("Erro ao baixar a imagem.");
    }
  };

  const handleEmail = async () => {
    if (!email || !email.includes("@")) {
      // Scroll até o campo de e-mail e dar foco
      const emailInput = document.querySelector('input[type="email"]') as HTMLInputElement;
      if (emailInput) {
        emailInput.scrollIntoView({ behavior: "smooth", block: "center" });
        setTimeout(() => {
          emailInput.focus();
          emailInput.classList.add("ring-2", "ring-red-400");
          setTimeout(() => emailInput.classList.remove("ring-2", "ring-red-400"), 2000);
        }, 400);
      }
      alert("Digite um e-mail válido no campo acima.");
      return;
    }
    setSending(true);
    try {
      const base64 = resultUri.split(",")[1];
      const form = new FormData();
      form.append("to_email", email);
      form.append("image_base64", base64);
      const res = await fetch(`${API_URL}/api/send-email`, {
        method: "POST",
        body: form,
      });
      if (res.ok) {
        alert("E-mail enviado com sucesso!");
      } else {
        alert("Erro ao enviar e-mail.");
      }
    } catch (e) {
      alert("Erro ao enviar e-mail.");
    } finally {
      setSending(false);
    }
  };

  return (
    <section className="space-y-3 animate-fade-up" style={{ animationDelay: "0.15s" }}>
      <Button variant="whatsapp" size="xl" className="w-full" onClick={handleEmail} disabled={sending}>
        <Mail className="h-5 w-5" />
        {sending ? "Enviando..." : "Enviar por E-mail"}
      </Button>

      <Button variant="outline-card" size="lg" className="w-full" onClick={handleDownload}>
        <Download className="h-4 w-4" />
        Baixar Imagem
      </Button>

      <Button variant="ghost" size="default" className="w-full text-primary" onClick={onRegenerate}>
        <RefreshCw className="h-4 w-4" />
        Gerar novamente
      </Button>
    </section>
  );
}
