declare namespace I18n {
  type TranslationData = Record<string, unknown>;

  interface RenderProps {
    text: string;
    index: number;
    href?: string;
  }

  interface ScrewOptions<T = unknown> {
    links: string[];
    render(props: RenderProps): T;
  }

  function screw(text: string, data?: TranslationData): string;

  function screw(
    text: string,
    data: TranslationData | undefined,
    options: Pick<ScrewOptions, "links">
  ): string;

  function screw<T>(
    text: string,
    data: TranslationData | undefined,
    options: ScrewOptions<T>
  ): T[] | string;
}
