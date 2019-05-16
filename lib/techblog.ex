defmodule Techblog do
  @moduledoc false
  @version Mix.Project.config()[:version]

  @default_path "assets/blog"

  def formatted_version, do: "v" <> @version

  def slugs(), do: slugs(@default_path)

  def slugs(path) do
    real = _slugs(path, ".summary.md")

    cond do
      Map.size(real) == 0 -> _slugs(path, ".summary.md.example")
      :else -> real
    end
  end

  defp _slugs(path, ext) do
    path
    |> File.ls!()
    |> Enum.filter(fn nme -> String.ends_with?(nme, ext) end)
    |> Enum.map(fn nme ->
      {
        nme |> String.split_at(String.length(ext) * -1) |> elem(0),
        article_attrs("#{path}/#{nme}")
      }
    end)
    |> Enum.into(%{})
  end

  def articles(), do: articles(@default_path)

  def articles(path), do: all_html!(path, ".md")

  def summaries(), do: summaries(@default_path)

  def summaries(path), do: all_html!(path, ".summary.md")

  defp all_html!(path, ext) do
    path
    |> slugs()
    |> Map.keys()
    |> Enum.map(fn name ->
      {name, as_html!("#{path}/#{name}#{ext}")}
    end)
    |> Enum.into(%{})
  end

  defp as_html!(filename), do: as_html!(filename, File.exists?(filename))

  defp as_html!(filename, true) do
    filename
    |> article_content()
    |> Earmark.as_html!()
  end

  defp as_html!(filename, false) do
    "#{filename}.example"
    |> article_content()
    |> Earmark.as_html!()
  end

  defp article_content(fullpath) do
    fullpath
    |> File.stream!()
    |> Enum.reject(fn line -> String.starts_with?(line, "#meta") end)
    |> Enum.join()
  end

  defp article_attrs(fullpath) do
    Map.merge(default_attrs(fullpath), other_attrs(fullpath))
  end

  defp default_attrs(fullpath) do
    %{
      title:
        fullpath
        |> File.stream!()
        |> Enum.reject(fn line -> String.starts_with?(line, "#meta") end)
        |> Enum.filter(fn line -> String.starts_with?(line, "#") end)
        |> Enum.fetch!(0)
        |> String.replace("#", "")
        |> String.trim()
    }
  end

  defp other_attrs(fullpath) do
    fullpath
    |> File.stream!()
    |> Enum.filter(fn line -> String.starts_with?(line, "#meta") end)
    |> Enum.map(&(String.slice(&1, 6..-1) |> String.trim() |> String.split(" ", parts: 2)))
    |> Enum.map(fn [k, v] -> {String.to_atom(k), v} end)
    |> Enum.into(%{})
  end
end
