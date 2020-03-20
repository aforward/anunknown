defmodule Techblog do
  @moduledoc false
  @version Mix.Project.config()[:version]

  @default_path "assets/blog"

  def formatted_version, do: "v" <> @version

  def slugs(), do: slugs(@default_path)

  def slugs(path) do
    real = _slugs(path, ".summary.md")

    cond do
      map_size(real) == 0 -> _slugs(path, ".summary.md.example")
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

  @doc """
  Sort the provided map of slugs based on the :sort details.  "Biggest"
  (aka newest if using a timestamp) first.

  To add a custom sort, add the following meta information into
  your .summary.md filename

      # How To Deploy to Digital Ocean
      #meta sort 2019-09-21

  ## Example

      iex> Techblog.sort(%{"a" => %{sort: "m"}, "b" => %{sort: "a"}, "c" => %{sort: "z"}, "d" => %{}})
      [{"c", %{sort: "z"}}, {"a", %{sort: "m"}}, {"b", %{sort: "a"}}, {"d", %{}}]

  """
  def sort(map) do
    map
    |> Enum.sort_by(fn {_, details} -> details[:sort] end)
    |> Enum.reverse()
  end

  @doc """
  Let's filter the results based on one or more tags.
  We will do it on every request (for now) and then
  look at pre-calculating it as needed

  To add tags, just add tags

      #meta tags[] love cheese

  ## Example

      iex> Techblog.filter(%{"a" => %{tags: ["a", "z"]}, "b" => %{tags: ["a"]}, "c" => %{tags: ["z"]}, "d" => %{}}, ["a", "z"])
      [{"a", %{tags: ["a", "z"]}}, {"b", %{tags: ["a"]}}, {"c", %{tags: ["z"]}}]

      iex> Techblog.filter(%{"a" => %{tags: ["a", "z"]}, "b" => %{tags: ["a"]}, "c" => %{tags: ["z"]}, "d" => %{}}, ["z"])
      [{"a", %{tags: ["a", "z"]}}, {"c", %{tags: ["z"]}}]

      iex> Techblog.filter(%{"a" => %{tags: ["a", "z"]}, "b" => %{tags: ["a"]}, "c" => %{tags: ["z"]}, "d" => %{}}, [])
      %{"a" => %{tags: ["a", "z"]}, "b" => %{tags: ["a"]}, "c" => %{tags: ["z"]}, "d" => %{}}

  """
  def filter(map, []), do: map
  def filter(map, nil), do: map

  def filter(map, needle) do
    map
    |> Enum.filter(fn
      {_k, %{tags: haystack}} -> Enum.any?(haystack, &Enum.member?(needle, &1))
      {_k, _no_tags} -> false
    end)
  end

  @doc """
  The URL for displaying images within your GitHub repo is

      ![My Image](/assets/static/images/a.png?raw=true)
      ![My Image](/myawesomeblog/assets/static/images/a.png?raw=true)
      <img src="/assets/static/images/a.png?raw=true" />
      <img src="/myawesomeblog/assets/static/images/a.png?raw=true" />

  But in your website, you want to strip out a few things

      ![My Image](/images/a.png)
      ![My Image](/images/a.png)
      <img src="/images/a.png" />
      <img src="/images/a.png" />

  We don't (yet) support optional titles like

      ![My Image](/assets/static/images/a.png?raw=true "Optional Title")

  This function will help do that transformation.

  ## Example

      iex> Techblog.format_images("![My Image](/assets/static/images/a.png?raw=true)")
      "![My Image](/images/a.png)"

      iex> Techblog.format_images("![My Image](/myawesomeblog/assets/static/images/a.png?raw=true)")
      "![My Image](/images/a.png)"

      iex> Techblog.format_images("<img src=\\\"/assets/static/images/a.png?raw=true\\\" alt=\\\"hello\\\"/>")
      "<img src=\\\"/images/a.png\\\" alt=\\\"hello\\\"/>"

      iex> Techblog.format_images("<img src=\\\"/myawesomeblog/assets/static/images/a.png?raw=true\\\" alt=\\\"hello\\\"/>")
      "<img src=\\\"/images/a.png\\\" alt=\\\"hello\\\"/>"

  """
  def format_images(line) do
    line
    |> regex(~r{!\[(.*)\]\(/assets/static/([^\)]*)\?raw=true\)}, fn _, alt, p ->
      "![#{alt}](/#{p})"
    end)
    |> regex(~r{!\[(.*)\]\(/[^/]*/assets/static/([^\)]*)\?raw=true\)}, fn _, alt, p ->
      "![#{alt}](/#{p})"
    end)
    |> regex(~r{<img\s+src=\"/assets/static/([^\?]*)\?raw=true\"}, fn _, p ->
      "<img src=\"/#{p}\""
    end)
    |> regex(~r{<img\s+src=\"/[^/]*/assets/static/([^\?]*)\?raw=true\"}, fn _, p ->
      "<img src=\"/#{p}\""
    end)
  end

  def articles(), do: articles(@default_path)

  def articles(path), do: all_html!(path, ".md")

  def summaries(), do: summaries(@default_path)

  def summaries(path), do: all_html!(path, ".summary.md")

  def tags(), do: tags(@default_path)

  def tags(path) do
    path
    |> articles()
    |> Enum.flat_map(fn {_, %{tags: tags}} -> tags end)
    |> Enum.reduce(%{}, fn t, tags ->
      Map.update(tags, t, 1, &(&1 + 1))
    end)
  end

  defp all_html!(path, ext) do
    path
    |> slugs()
    |> Enum.map(fn slug -> append_html!(slug, path, ext) end)
    |> Enum.into(%{})
  end

  defp append_html!({name, details}, path, ext) do
    {
      name,
      Map.put(details, :html, as_html!("#{path}/#{name}#{ext}"))
    }
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
    |> Enum.map(&format_images/1)
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
    |> Enum.map(&parse_attribute/1)
    |> Enum.into(%{})
  end

  def parse_attribute([k, v]) do
    k
    |> String.split("[]")
    |> case do
      [k, ""] -> [k, String.split(v, " ") |> Enum.sort()]
      [k] -> [k, v]
    end
    |> (fn [k, v] -> {String.to_atom(k), v} end).()
  end

  defp regex(line, matcher, func) do
    Regex.replace(matcher, line, func)
  end
end
