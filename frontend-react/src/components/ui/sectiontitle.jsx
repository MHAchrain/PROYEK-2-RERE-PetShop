export default function SectionTitle({
  eyebrow,
  title,
  description,
  accentClassName = "bg-primary",
  titleClassName = "text-primary",
}) {
  return (
    <div className="space-y-3">
      <div className="flex items-center gap-4">
        <div className={`h-10 w-4 rounded-sm sm:w-5 ${accentClassName}`}></div>
        <div>
          {eyebrow ? (
            <p className="text-xs font-semibold uppercase tracking-[0.18em] text-gray-400">{eyebrow}</p>
          ) : null}
          <p className={`text-xl font-bold capitalize sm:text-2xl ${titleClassName}`}>{title}</p>
        </div>
      </div>

      {description ? (
        <p className="max-w-2xl text-sm leading-relaxed text-gray-500 sm:text-base">{description}</p>
      ) : null}
    </div>
  );
}
