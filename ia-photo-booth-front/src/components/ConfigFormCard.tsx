import { THEMES, SIZES } from "@/types/api";
import { Settings2, Mail } from "lucide-react";

interface ConfigFormCardProps {
  email: string;
  theme: string;
  instructions: string;
  size: string;
  onEmailChange: (v: string) => void;
  onThemeChange: (v: string) => void;
  onInstructionsChange: (v: string) => void;
  onSizeChange: (v: string) => void;
}

function SelectField({
  label,
  value,
  onChange,
  options,
}: {
  label: string;
  value: string;
  onChange: (v: string) => void;
  options: readonly { value: string; label: string }[];
}) {
  return (
    <div>
      <label className="mb-1.5 block text-xs font-semibold text-muted-foreground uppercase tracking-wider">
        {label}
      </label>
      <select
        value={value}
        onChange={(e) => onChange(e.target.value)}
        className="w-full rounded-md border border-border bg-icbeu-surface px-3 py-2.5 text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-primary/40 transition-shadow"
      >
        {options.map((o) => (
          <option key={o.value} value={o.value}>{o.label}</option>
        ))}
      </select>
    </div>
  );
}

export function ConfigFormCard(props: ConfigFormCardProps) {
  return (
    <section className="card-glass p-5">
      <div className="mb-4 flex items-center gap-2">
        <Settings2 className="h-5 w-5 text-primary" />
        <h2 className="font-display text-lg font-bold text-foreground">Configurações</h2>
      </div>

      <div className="space-y-4">
        {/* Email */}
        <div>
          <label className="mb-1.5 flex items-center gap-1.5 text-xs font-semibold text-muted-foreground uppercase tracking-wider">
            <Mail className="h-3.5 w-3.5" /> E-mail <span className="text-muted-foreground/60 normal-case">(opcional)</span>
          </label>
          <input
            type="email"
            value={props.email}
            onChange={(e) => props.onEmailChange(e.target.value)}
            placeholder="seu@email.com"
            className="w-full rounded-md border border-border bg-icbeu-surface px-3 py-2.5 text-sm text-foreground placeholder:text-muted-foreground/50 focus:outline-none focus:ring-2 focus:ring-primary/40 transition-shadow"
          />
        </div>

        {/* Theme */}
        <SelectField label="Tema" value={props.theme} onChange={props.onThemeChange} options={THEMES} />

        {/* Extra instructions */}
        <div>
          <label className="mb-1.5 block text-xs font-semibold text-muted-foreground uppercase tracking-wider">
            Instruções extras
          </label>
          <textarea
            value={props.instructions}
            onChange={(e) => props.onInstructionsChange(e.target.value)}
            placeholder="Ex: Óculos escuros, fundo azul..."
            rows={3}
            className="w-full resize-none rounded-md border border-border bg-icbeu-surface px-3 py-2.5 text-sm text-foreground placeholder:text-muted-foreground/50 focus:outline-none focus:ring-2 focus:ring-primary/40 transition-shadow"
          />
        </div>

        {/* Size */}
        <div>
          <SelectField label="Tamanho" value={props.size} onChange={props.onSizeChange} options={SIZES} />
        </div>
      </div>
    </section>
  );
}
