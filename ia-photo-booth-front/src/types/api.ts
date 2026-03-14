export interface EditImageResponse {
  prompt_used: string;
  image_base64: string;
  mime_type: string;
}

export interface EditImageParams {
  image: File;
  theme: string;
  extra_instructions: string;
  size: string;
}

export type AppState = "idle" | "photo-ready" | "processing" | "success" | "error";

export const THEMES = [
  { value: "Hamilton", label: "Hamilton" },
  { value: "Colonial American", label: "Colonial American" },
  { value: "Historical Portrait", label: "Historical Portrait" },
  { value: "Vintage Studio", label: "Vintage Studio" },
] as const;

export const SIZES = [
  { value: "1024x1024", label: "1024×1024" },
  { value: "1536x1024", label: "1536×1024" },
  { value: "1024x1536", label: "1024×1536" },
] as const;
