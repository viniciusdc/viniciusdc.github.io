import { cn } from "@/lib/utils";

interface BadgeProps extends React.HTMLAttributes<HTMLSpanElement> {
  variant?: "default" | "outline" | "accent";
}

export function Badge({ className, variant = "outline", ...props }: BadgeProps) {
  return (
    <span
      className={cn(
        "inline-flex items-center rounded-full px-2.5 py-1 font-mono text-[11px] leading-none",
        variant === "outline" && "border border-border text-muted-foreground",
        variant === "accent" && "border border-[rgba(216,166,87,0.38)] bg-[var(--accent-soft)] text-[#f1d39b]",
        variant === "default" && "bg-primary text-primary-foreground",
        className
      )}
      {...props}
    />
  );
}
