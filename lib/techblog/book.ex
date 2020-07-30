defmodule Techblog.Book do
  @default_path Application.get_env(:techblog, :books_path)

  def slugs(), do: slugs(@default_path)

  def slugs(path) do
    path
    |> File.ls!()
    |> Enum.filter(&File.exists?(readme_file(path, &1)))
    |> Enum.map(fn nme ->
      {
        nme,
        path |> readme_file(nme) |> book_attrs(nme)
      }
    end)
    |> Enum.into(%{})
  end

  defp readme_file(path, name), do: "#{path}/#{name}/readme.md"

  defp book_attrs(fullpath, nme) do
    Techblog.default_attrs(fullpath)
    |> Map.merge(local_attrs(fullpath, nme))
    |> Map.merge(Techblog.other_attrs(fullpath))
  end

  defp local_attrs(fullpath, nme) do
    stream =
      fullpath
      |> File.stream!()
      |> Enum.reject(fn line -> String.starts_with?(line, "#meta") end)

    %{
      author:
        stream
        |> Enum.filter(fn line -> String.starts_with?(line, "##") end)
        |> Enum.fetch!(0)
        |> String.replace("##", "")
        |> String.trim(),
      img: "/assets/books/#{nme}/#{nme}.png",
      body:
        stream
        |> Enum.drop_while(fn line -> !String.starts_with?(line, "![") end)
        |> Enum.drop(1)
        |> Enum.join("\n")
        |> String.trim()
    }
  end
end
