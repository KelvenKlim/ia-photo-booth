import type { EditImageResponse, EditImageParams } from "@/types/api";

const BASE_URL = import.meta.env.VITE_API_URL || "http://localhost:8000";

export async function editImage(params: EditImageParams): Promise<EditImageResponse> {
  const formData = new FormData();
  formData.append("image", params.image);
  formData.append("theme", params.theme);
  formData.append("extra_instructions", params.extra_instructions);
  formData.append("size", params.size);

  const response = await fetch(`${BASE_URL}/api/edit-image`, {
    method: "POST",
    body: formData,
  });

  if (!response.ok) {
    throw new Error(`Erro ${response.status}: ${response.statusText}`);
  }

  return response.json();
}
