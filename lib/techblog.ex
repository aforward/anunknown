defmodule Techblog do
  @moduledoc false
  @version Mix.Project.config()[:version]

  @default_path Application.get_env(:techblog, :blog_path)

  def formatted_version, do: "v" <> @version

  def slugs(), do: slugs(@default_path)

  def slugs(path) do
    path
    |> File.ls!()
    |> Enum.filter(&File.exists?(summary_file(path, &1)))
    |> Enum.map(fn nme ->
      {
        nme,
        path |> summary_file(nme) |> article_attrs()
      }
    end)
    |> Enum.into(%{})
  end


  @doc """
  Sort the provided map of slugs based on the :sort details.  "Biggest"
  (aka newest if using a timestamp) first.

  To add a custom sort, add the following meta information into
  your summary.md filename

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

      ![My Image](a.png?raw=true)
      ![My Image](myawesomebloga.png?raw=true)
      <img src="a.png?raw=true" />
      <img src="myawesomebloga.png?raw=true" />

  But in your website, you want to strip out a few things

      ![My Image](/assets/a.png)
      ![My Image](/assets/a.png)
      <img src="/assets/a.png" />
      <img src="/assets/a.png" />

  We don't (yet) support optional titles like

      ![My Image](a.png?raw=true "Optional Title")

  This function will help do that transformation.

  ## Example

      iex> Techblog.format_images("![My Image](a.png?raw=true)", "my-blog")
      "![My Image](/assets/my-blog/a.png)"

      iex> Techblog.format_images("![My Image](myawesomebloga.png?raw=true)", "your-blog")
      "![My Image](/assets/your-blog/myawesomebloga.png)"

      iex> Techblog.format_images("<img src=\\\"a.png?raw=true\\\" alt=\\\"hello\\\"/>", "your-blog")
      "<img src=\\\"/assets/your-blog/a.png\\\" alt=\\\"hello\\\"/>"

      iex> Techblog.format_images("<img src=\\\"myawesomebloga.png?raw=true\\\" alt=\\\"hello\\\"/>", "my-blog")
      "<img src=\\\"/assets/my-blog/myawesomebloga.png\\\" alt=\\\"hello\\\"/>"

  """
  def format_images(line, blog_slug) do
    line
    |> regex(~r{!\[(.*)\]\(([^\)]*)\?raw=true\)}, fn _, alt, p ->
      "![#{alt}](/assets/#{blog_slug}/#{p})"
    end)
    |> regex(~r{!\[(.*)\]\([^/]*([^\)]*)\?raw=true\)}, fn _, alt, p ->
      "![#{alt}](/assets/#{blog_slug}/#{p})"
    end)
    |> regex(~r{<img\s+src=\"([^\?]*)\?raw=true\"}, fn _, p ->
      "<img src=\"/assets/#{blog_slug}/#{p}\""
    end)
    |> regex(~r{<img\s+src=\"[^/]*([^\?]*)\?raw=true\"}, fn _, p ->
      "<img src=\"/assets/#{blog_slug}/#{p}\""
    end)
  end

  def articles(), do: articles(@default_path)

  def articles(path), do: all_html!(path, "readme.md")

  def summaries(), do: summaries(@default_path)

  def summaries(path), do: all_html!(path, "summary.md")

  def tags(), do: tags(@default_path)

  def tags(path) do
    path
    |> articles()
    |> Enum.flat_map(fn {_, %{tags: tags}} -> tags end)
    |> Enum.reduce(%{}, fn t, tags ->
      Map.update(tags, t, 1, &(&1 + 1))
    end)
  end

  defp summary_file(path, name), do: "#{path}/#{name}/summary.md"

  defp all_html!(path, filename) do
    path
    |> slugs()
    |> Enum.map(fn slug -> append_html!(slug, path, filename) end)
    |> Enum.into(%{})
  end

  defp append_html!({blog_slug, details}, path, filename) do
    {
      blog_slug,
      Map.put(details, :html, as_html!(path, blog_slug, filename))
    }
  end

  defp as_html!(path, blog_slug, filename) do
    "#{path}/#{blog_slug}/#{filename}"
    |> article_content(blog_slug)
    |> Earmark.as_html!()
  end

  defp article_content(fullpath, blog_slug) do
    fullpath
    |> File.stream!()
    |> Enum.reject(fn line -> String.starts_with?(line, "#meta") end)
    |> Enum.map(fn line -> format_images(line, blog_slug) end)
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
